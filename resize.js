const sharp = require("sharp");
const {VTFFile, VTFImageData} = require("./vtflib");
const ffmpeg = require("fluent-ffmpeg");

const { resolve } = require('path');
const { readdir } = require('fs').promises;
const { statSync, writeSync, openSync, readFileSync, unlinkSync } = require("fs");

async function* getFiles(dir) {
	const dirents = await readdir(dir, { withFileTypes: true });
	for (const dirent of dirents) {
		const res = resolve(dir, dirent.name);
		if (dirent.isDirectory()) {
			yield* getFiles(res);
		} else {
			yield res;
		}
	}
}


const pix_location = function pix_location(x, y, width) {
	return (x + y * width) * 4;
}

const hack_resize = function hack_resize(rgba, width, height, div) {
	let n = Buffer.alloc((width / div) * (height / div) * 4);

	for (let x = 0; x < width; x += div) {
		for (let y = 0; y < height; y += div) {

			let r = 0, g = 0, b = 0, a = 0;

			for (let x_add = 0; x_add < div; x_add++) {
				for (let y_add = 0; y_add < div; y_add++) {
					let loc = pix_location(x + x_add, y + y_add, width);

					r += rgba.readUInt8(loc);
					g += rgba.readUInt8(loc + 1);
					b += rgba.readUInt8(loc + 2);
					a += rgba.readUInt8(loc + 3);
				}
			}

			let divisor = div * div;

			let loc = pix_location(x / div, y / div, width / div);
			try {
				n.writeUInt8(r / divisor, loc);
				n.writeUInt8(g / divisor, loc + 1);
				n.writeUInt8(b / divisor, loc + 2);
				n.writeUInt8(a / divisor, loc + 3);
			}
			catch(e) {
				console.log(loc, x / div, y / div, width / div, width, height)
				throw e;
			}
		}
	}

	return n;
}

// TEXTURES
const resize_to = 512;
(async () => {
	for await (const f of getFiles("materials")) {
		if (f.substr(-4) === ".vtf" && statSync(f).size > 1000000) {

			let img = new VTFFile(readFileSync(f));
			img.Flags |= 0x100 | 0x200; // NOMIP | NOLOD
			let cvt = img.getImages().reverse()[0];

			if (cvt.Format === "DXT1") {
				continue;
			}

			let rgba = cvt.toRGBA8888()
			if (cvt.Width > resize_to && cvt.Height > resize_to) {
				let width = cvt.Width, height = cvt.Height;
				if (cvt.Width < cvt.Height) {
					height = (resize_to / width) * height;
					width = resize_to;
				}
				else {
					width = (resize_to / height) * width;
					height = resize_to;
				}

				let buf = hack_resize(rgba, cvt.Width, cvt.Height, cvt.Width / width);
				let newdata = (new VTFImageData(width, height, 1, "RGBA8888", buf)).convert("DXT5");
				img.setImage(newdata);
				writeSync(openSync(f, "w"), img.toBuffer());
			}
			else if (cvt.Format !== "DXT5") {
				img.setImage(cvt.convert("DXT5"));
				writeSync(openSync(f, "w"), img.toBuffer());
			}
		}
	}
})();

(async () => {
	for await (const f of getFiles("sound")) {
		if (f.substr(-4) !== ".ogg") {
			ffmpeg(f)
				.audioCodec("libvorbis")
				.output(f.split('.').slice(0, -1).join('.') + ".ogg")
				.on("end", () => {
					unlinkSync(f);
				})
				.run();
		}
	}
})();