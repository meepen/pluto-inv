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

unicode.CaseFolding = {
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

	unicode.CaseFolding.tolower[upper] = lower

	if (case == "C" or case == "S") then
		if (select(2, utf8.codes(lower)()) == 0x21d) then
			print(lower, upper)
		end
		unicode.CaseFolding.toupper[lower] = upper
	end
end

function unicode.lower(str)
	local tbl = unicode.totable(str)

	for ind, char in ipairs(tbl) do
		local lower = unicode.CaseFolding.tolower[char]
		if (lower) then
			tbl[ind] = lower
		end
	end

	return unicode.fromtable(tbl)
end

function unicode.upper(str)
	local tbl = unicode.totable(str)

	for ind, char in ipairs(tbl) do
		local upper = unicode.CaseFolding.toupper[char]
		if (lower) then
			tbl[ind] = upper
		end
	end

	return unicode.fromtable(tbl)
end

--[[
local UnicodeData = include "unicodedata.lua"
-- 00C9;LATIN CAPITAL LETTER E WITH ACUTE;Lu;0;L;0045 0301;;;;N;LATIN CAPITAL LETTER E ACUTE;;;00E9;
local Decompisitions = {}
local Combining = {}
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

	if (#decomp > 0 and decomp[1] ~= "") then
		for i = #decomp, 1, -1 do
			local data = decomp[i]
			if (tonumber(data, 16)) then
				decomp[i] = utf8.char(tonumber(data, 16))
			else
				table.remove(decomp, i)
			end
		end

		Decompisitions[utf8.char(tonumber(code, 16))] = table.concat(decomp)
	end

	if (combining ~= "0") then
		table.insert(Combining, (utf8.char(tonumber(code, 16))))
	end
end
file.Write("unicodedata.json", util.TableToJSON{Decompisitions = Decompisitions, Combining = Combining})
]]

unicode.Maps = util.JSONToTable(include "unicodedata_json.lua" or "{}")
for k,v in pairs(unicode.Maps.Combining) do
	unicode.Maps.Combining[v] = true
end

function unicode.removecombining(str)
	local t = {n = 0}
	for _, code in utf8.codes(str) do
		local chr = utf8.char(code)

		if (unicode.Maps.Combining[chr]) then
			continue
		end

		t.n = t.n + 1
		t[t.n] = chr
	end

	return table.concat(t)
end

function unicode.nfd(str)
	local t = {n = 0}
	for _, code in utf8.codes(str) do
		local chr = utf8.char(code)

		t.n = t.n + 1
		t[t.n] = unicode.Maps.Decompisitions[chr] or chr
	end

	return table.concat(t)
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

	confusable = string.Explode(" ", confusable)

	for i = #confusable, 1, -1 do
		local data = confusable[i]
		if (string.Trim(data):len() == 0) then
			table.remove(confusable, i)
			continue
		end
		data = utf8.char(tonumber(data, 16))
		if (unicode.CaseFolding.toupper[data]) then
			table.insert(confusable, unicode.CaseFolding.toupper[data])
		end
		if (unicode.CaseFolding.tolower[data]) then
			table.insert(confusable, unicode.CaseFolding.tolower[data])
		end
		confusable[i] = data
	end

	char = utf8.char(tonumber(char, 16))

	unicode.confusables[char] = confusable
end

function unicode.addconfusable(char, confusables)
	local main = unicode.confusables[char]
	if (not main) then
		main = {}
		unicode.confusables[char] = main
	end
	for _, confusable in pairs(confusables) do
		if (not table.HasValue(main, confusable)) then
			table.insert(main, confusable)
		end
	end
end
unicode.addconfusable("3", {"e"})

local function next_confusable(current, from)
	local confused_idx, results = false

	for idx = (from or 0) + 1, #current do
		local chr = current[idx]
		local confused = unicode.confusables[chr]
		if (confused) then
			results = results or {}
			confused_idx = idx
			for _, chr in pairs(confused) do
				table.insert(results, chr)
			end
		end

		local lower = unicode.CaseFolding.tolower[chr]
		if (lower) then
			results = results or {}
			confused_idx = idx
			table.insert(results, lower)
		end

		local upper = unicode.CaseFolding.toupper[chr]
		if (upper) then
			results = results or {}
			confused_idx = idx
			table.insert(results, upper)
		end

		if (results) then
			break
		end
	end

	return confused_idx, results
end

function unicode.unconfuse(str)
	str = unicode.nfd(unicode.upper(str))
	local list = {str}
	local idx = 0

	local done = {}

	repeat
		idx = idx + 1
		local current_str = list[idx]
		local tbl = unicode.totable(current_str)
		
		local finished = false
		local confused_idx, confused_values
		repeat
			confused_idx, confused_values = next_confusable(tbl, confused_idx)

			if (confused_idx) then -- add the confused pairs into the list
				local insert = unicode.totable(current_str)

				for _, item in pairs(confused_values) do
					insert[confused_idx] = item
					local str = unicode.fromtable(insert)
					if (not done[str]) then
						done[str] = true
						table.insert(list, str)
						finished = true
					end
				end
			end
		until not confused_idx or finished

	until idx == #list

	return list
end
