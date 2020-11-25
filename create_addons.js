const { buf } = require("crc-32"); // npm install this
const { readdir, readFile, stat } = require("fs").promises;
const { createWriteStream } = require("fs");

const too_big_size = 1024 * 1024 * 1024;
async function* getFiles(dir) {
	const dirents = await readdir(dir, { withFileTypes: true });
	for (const dirent of dirents) {
		const res = dir + "/" + dirent.name
		if (dirent.isDirectory()) {
			yield* getFiles(res);
		} else {
			yield res;
		}
	}
}

const addon_data = JSON.stringify(require("./addon.json"));
/*
{
	"title":"pluto.gg content",
	"type":"servercontent",
	"tags":[]
}
*/

class GMAFile {
	constructor(fname) {
		this.stream = createWriteStream(fname);
		this.current_length = 8; // crc32 + 0 (uint)
		this.length = this.current_length;

		this.write(Buffer.from("GMAD"));
		this.write(Buffer.from("\x03"));
		this.write(Buffer.alloc(8));
		this.write(Buffer.alloc(8));
		this.write(Buffer.alloc(1));
		this.write(Buffer.from("pluto.gg content")); // change this
		this.write(Buffer.alloc(1));
		this.write(Buffer.from(addon_data));
		this.write(Buffer.alloc(1));
		this.write(Buffer.from("Meepen")); // and this
		this.write(Buffer.alloc(1));
		this.write(Buffer.from("\x01\x00\x00\x00"));
		this.filenames = [];
	}

	write(data) {
		this.current_length += data.length;
		this.length += data.length;
		this.crc32 = buf(data, this.crc32);
		this.stream.write(data);
	}

	async addFile(fname) {
		this.filenames.push(fname);

		let size = (await stat(fname)).size;
		this.length += size;

		let num = Buffer.alloc(4);
		num.writeUInt32LE(this.filenames.length);
		this.write(num);

		let name = Buffer.from(fname.toLowerCase())
		this.write(name);

		let size_buffer = Buffer.alloc(13);
		size_buffer.writeUInt32LE(size, 1);
		size_buffer.writeInt32LE(buf(await readFile(fname)), 9);
		this.write(size_buffer);
	}

	async finalize() {
		this.write(Buffer.alloc(4));

		for (let fname of this.filenames) {
			let data = await readFile(fname);
			this.write(data);
		}

		let last_crc = Buffer.alloc(4);
		last_crc.writeInt32LE(this.crc32);
		this.write(last_crc);

		this.stream.end();
	}
}

(async () => {
	let list = [];

	for await (const f of getFiles("materials")) {
		list.push(f);
	}
	for await (const f of getFiles("models")) {
		list.push(f);
	}
	for await (const f of getFiles("sound")) {
		list.push(f);
	}
	for await (const f of getFiles("particles")) {
		list.push(f);
	}

	let size = 0;
	let gma = new GMAFile(`content/pack${size++}.gma`);
	for (let file of list) {
		await gma.addFile(file);
		if (gma.length > too_big_size) {
			await gma.finalize();

			gma = new GMAFile(`content/pack${size++}.gma`);
		}
	}
	await gma.finalize();
})();
