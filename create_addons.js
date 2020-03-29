const { buf } = require("crc-32");
const addons = require("./addons")
const { readdir, readFile, writeFile } = require('fs').promises;

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

async function add_file(file_datas, gma_header, filenum, f) {
	let content = await readFile(f);

	let num = Buffer.alloc(4);
	num.writeUInt32LE(filenum);

	gma_header.push(num);
	gma_header.push(Buffer.from(f.toLowerCase()));
	let size = Buffer.alloc(13);
	size.writeUInt32LE(content.length, 1);
	size.writeInt32LE(buf(content), 9);
	gma_header.push(size);

	file_datas.push(content);
}

async function make_gma(all_files, list) {
	let gma_header = [
		Buffer.from("GMAD"),
		Buffer.from("\x03"),
		Buffer.alloc(8),
		Buffer.alloc(8),
		Buffer.alloc(1),
		Buffer.from("pluto.gg content"),
		Buffer.alloc(1),
		await readFile("./addon.json"),
		Buffer.alloc(1),
		Buffer.from("Meepen"),
		Buffer.alloc(1),
		Buffer.from("\x01\x00\x00\x00"),
	];

	let file_datas = [];
	let filenum = 0;

	for (const f of list) {
		const idx = all_files.indexOf(f);
		if (idx === -1) {
			throw new Error(`couldn't find ${f}`);
		}
		all_files[idx] = null;

		await add_file(file_datas, gma_header, ++filenum, f);
	}

	gma_header.push(Buffer.alloc(4));

	let header = Buffer.concat(gma_header);
	let files = Buffer.concat(file_datas);

	let full_data = Buffer.concat([header, files]);
	let last_crc = Buffer.alloc(4);
	last_crc.writeInt32LE(buf(full_data))

	full_data = Buffer.concat([full_data, last_crc]);

	return full_data;
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
	for (let pack in addons) {
		if (pack !== "workshop") {
			for (let i = addons[pack].length - 1; i >= 0; i--) {
				let file = addons[pack][i];
				if (file.indexOf("models/") === 0 || file.indexOf(".vmt") !== -1) {
					console.log(`${file} being sent to workshop`);
					addons.workshop.push(addons[pack].splice(i, 1)[0]);
				}
			}
		}
	}
	
	for (const pack in addons) {
		writeFile(`content/${pack}.gma`, await make_gma(list, addons[pack]));
	}

	writeFile(`content/content.gma`, await make_gma(list, list.filter(x => x)));

	console.log(list.filter(x => x));
})();
