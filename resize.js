const {VTFFile, VTFImageData, GetImageTypeData} = require("./vtflib");
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


const pix_location = function pix_location(channels, x, y, width) {
	return (x + y * width) * channels;
}

const hack_resize = function hack_resize(channels, data, width, height, div) {
	let n = Buffer.alloc((width / div) * (height / div) * channels);
	let channel_data = [];
	const divisor = div * div;

	for (let x = 0; x < width; x += div) {
		for (let y = 0; y < height; y += div) {
			for (let chan = 0; chan < channels; chan++) {
				channel_data[chan] = 0;
			}

			for (let x_add = 0; x_add < div; x_add++) {
				for (let y_add = 0; y_add < div; y_add++) {
					let loc = pix_location(channels, x + x_add, y + y_add, width);

					for (let chan = 0; chan < channels; chan++) {
						channel_data[chan] += data[loc + chan];
					}
				}
			}

			let loc = pix_location(channels, x / div, y / div, width / div);
			for (let chan = 0; chan < channels; chan++) {
				n[loc + chan] = channel_data[chan] / divisor;
			}
		}
	}

	return n;
}

// TEXTURES
const resize_to = 512;
(async () => {
	for await (const f of getFiles("materials")) {
		if (f.substr(-4) === ".vmt") {
			// another time lol
		}
		else if (f.substr(-4) === ".vtf" && statSync(f).size > 1000000) {

			let img = new VTFFile(readFileSync(f));
			img.Flags |= 0x100 | 0x200; // NOMIP | NOLOD

			let frames = img.getImageFrames().map(x => x.reverse()[0]);

			for (let i = 0; i < frames.length; i++) {
				let cvt = frames[i];

				let fmt = GetImageTypeData(cvt.Format);
				let raw_data = cvt.Data;

				if (fmt.Channels === 3 || fmt.Channels === 4 || fmt.Name === "DXT5" || fmt.Name === "DXT3" || fmt.Name === "DXT1") {
					raw_data = cvt.toRGBA8888();
					fmt = GetImageTypeData("RGBA8888");
				}
				else if (fmt.Channels <= 2) {
					console.log(`Format ${cvt.Format} for ${f}`);
					// raw_data = cvt.Data;
				}
				else {
					console.log(`Skipping ${f}`);
					continue;
				}

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

					let buf = hack_resize(fmt.Channels, raw_data, cvt.Width, cvt.Height, cvt.Width / width);
					let newdata = new VTFImageData(width, height, 1, fmt.Name, buf);
					if (fmt.Name === "RGBA8888")
						newdata = newdata.convert("DXT5");
					
					frames[i] = newdata;
				}
			}

			img.setImageFrames(frames);
			writeSync(openSync(f, "w"), img.toBuffer());
		}
	}
})();

// SOUNDS
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