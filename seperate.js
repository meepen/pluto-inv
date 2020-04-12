let output = Object.create(null);
output.tfa_unknown = [];

for (let item of require("./addons").tfa_SEPERATEPLEASE) {
	if (item.indexOf("materials/models/weapons/tfa_cso/") === 0) {
		let weapon = item.match("materials/models/weapons/tfa_cso/([^/]+)")[1];

		if (!output[weapon]) {
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