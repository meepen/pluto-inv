const del = require("./addons")[process.argv[2]];
const {unlinkSync} = require("fs");

for (let file of del) {
	unlinkSync(file);
}