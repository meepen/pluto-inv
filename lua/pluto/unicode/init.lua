-- Data files are retrieved from ftp://unicode.org/Public/UNIDATA

unicode = unicode or {}

function unicode.totable(str)
	local t = {n = 0}
	for _, code in utf8.codes(str) do
		t.n = t.n + 1
		t[t.n] = utf8.char(code)
	end

	return t
end

function unicode.fromtable(t)
	return table.concat(t)
end

local CaseFolding = include "casefolding.lua"

unicode.case = {
	tolower = {},
	toupper = {},
}

for line in CaseFolding:gmatch "([^\r\n]+)" do
	if (line[1] == "#") then -- comment
		continue
	end
	if (line:len() == 0) then
		continue
	end

	-- 0041; C; 0061; # LATIN CAPITAL LETTER A

	local upper, case, lower, comment = line:match "^([0-9A-Fa-f]+); ([CFST]); ([0-9A-Fa-f ]+);(.+)$"

	if (not upper) then
		print("Couldn't understand CaseFolding line: " .. line)
		continue
	end

	upper = utf8.char(tonumber(upper, 16))

	lower = string.Explode(" ", lower)

	for index, data in pairs(lower) do
		lower[index] = utf8.char(tonumber(data, 16))
	end

	lower = table.concat(lower)

	unicode.case.tolower[upper] = lower

	if (case == "C" or case == "S") then
		unicode.case.toupper[lower] = upper
	end
end

function unicode.lower(str)
	local tbl = unicode.totable(str)

	for ind, char in ipairs(tbl) do
		local lower = unicode.case.tolower[char]
		if (lower) then
			tbl[ind] = lower
		end
	end

	return unicode.fromtable(tbl)
end

function unicode.upper(str)
	local tbl = unicode.totable(str)

	for ind, char in ipairs(tbl) do
		local upper = unicode.case.toupper[char]
		if (lower) then
			tbl[ind] = upper
		end
	end

	return unicode.fromtable(tbl)
end

unicode.lookup = {}

local UnicodeData = include "unicodedata.lua"
-- 00C9;LATIN CAPITAL LETTER E WITH ACUTE;Lu;0;L;0045 0301;;;;N;LATIN CAPITAL LETTER E ACUTE;;;00E9;
for line in UnicodeData:gmatch "([^\r\n]+)" do
	if (line[1] == "#") then -- comment
		continue
	end
	if (line:len() == 0) then
		continue
	end

	local code, name, category, combining, bidirectional, decomp, decimal, digit, numeric_or_mirrored, _, old_name, comment, uppercase, lowercase, titlecase =
		line:match(
			"^([0-9A-Fa-f]+);" ..
			"([^;]*);" ..
			"([^;]*);" ..
			"([^;]*);" ..
			"([^;]*);" ..
			"([^;]*);" ..
			"([^;]*);" ..
			"([^;]*);" ..
			"([^;]*);" ..
			"([^;]*);" ..
			"([^;]*);" ..
			"([^;]*);" ..
			"([^;]*);" ..
			"([^;]*);" ..
			"(.*)$"
		)

	if (not code) then
		print(line)
		return
	end

	decomp = string.Explode(" ", decomp)

	for i = #decomp, 1, -1 do
		local chr = decomp[i]
		if (chr[1] == "<") then
			table.remove(decomp, i)
		end
	end

	unicode.lookup[code] = {
		Character = utf8.char(tonumber(code, 16)),
		Name = name,
		Category = category,
		Combining = combining,
		DecompisitionMapping = decomp,
		Decimal = decimal,
		Digit = digit,
		Numeric = numeric_or_mirrored,
		Mirrored = numeric_or_mirrored,
		OldName = old_name,
		Comment = comment,
		UpperCase = uppercase,
		LowerCase = lowercase,
		TitleCase = titlecase
	}
end

function unicode.nfd(str)
	local tbl = unicode.totable(str)

end

local Confusables = include "confusables.lua"

unicode.confusables = {}

for line in Confusables:gmatch "([^\r\n]+)" do
	if (line[1] == "#") then -- comment
		continue
	end
	if (line:len() == 0) then
		continue
	end

	-- 05AD ;	0596 ;	MA	# ( ֭ → ֖ ) HEBREW ACCENT DEHI → HEBREW ACCENT TIPEHA	# 

	local char, confusable = line:match "^([0-9a-fA-F]+) ;\t([0-9a-fA-F ]+);"

	print(char, confusable)
end