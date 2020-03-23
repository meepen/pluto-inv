var VMTFile = module.exports.VMTFile = class VMTFile {

	static skipWhitespace(contents, offset) {
		for (let i = offset; i++; i < contents.length) {

			let char = contents.charAt(i);

			if (char === ' ' || char === '\n' || char === '\t' || char === '\f' || char === '\v' || char === '\r')
				continue;

			return i;
		}

		return contents.length;
	}

	static readToken(contents, offset) {
		let start = VMTFile.skipWhitespace(contents, offset);

	}

	constructor(contents) {
		this.keyValues = Object.create(null);

		let wasQuoted;

		for (let i = 0; i < contents.length; i++) {

			

		}
	}

	toString() {

	}
}