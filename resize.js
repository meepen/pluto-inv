const sharp = require("sharp");
const {VTFFile, VTFImageData} = require("vtflib");

const { resolve } = require('path');
const { readdir } = require('fs').promises;
const { statSync, writeSync, openSync, readFileSync } = require("fs");

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

const resize_to = 512;
(async () => {
	for await (const f of getFiles('materials')) {
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

				let buf = await (sharp(rgba, {
					raw: {
						width: cvt.Width,
						height: cvt.Height,
						channels: 4
					}
				}).resize(width, height).toBuffer());
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
})()