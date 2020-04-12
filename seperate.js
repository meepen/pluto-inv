let output = Object.create(null);
output.tfa_unknown = [];

const addons = require("./addons");
let all = [];

for (let name in addons) {
	if (name == "tfa_split")
		continue;

	for (let file of addons[name]) {
		all.push(file);
	}
}


for (let item of addons.tfa_split) {
	if (all.indexOf(item) !== -1)
		continue;

	if (item.indexOf("materials/models/weapons/tfa_cso/") === 0) {
		let weapon = "tfa_" + item.match("materials/models/weapons/tfa_cso/([^/]+)")[1];

		if (!output[weapon] ) {
			output[weapon] = [];
			console.log(`${weapon} CREATED`);
		}

		output[weapon].push(item);
	}
	else {
		output.tfa_unknown.push(item);
	}
}

require("fs").writeFileSync("./garbage.json", JSON.stringify(output, null, "\t"));