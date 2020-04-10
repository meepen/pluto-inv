function math.fact(x)
	return math.Round(math.sqrt(2 * math.pi / x) * ((x + 1 / ((12 * x) - 1 / (10 * x))) / math.exp(1)) ^ x)
end

function math.circularmean(...)
	local x, y = 0, 0
	for i = 1, select("#", ...) do
		local num = select(i, ...)

		x = x + math.cos(num * math.pi * 2 - math.pi)
		y = y + math.sin(num * math.pi * 2 - math.pi)
	end

	return (math.atan2(y, x) + math.pi) / (math.pi * 2)
end

local function replace(replacer, str)
	if (isfunction(replacer)) then
		return replacer(str:sub(2, -2)) or str
	elseif (istable(replacer)) then
		return replacer[str:sub(2, -2)] or str
	elseif (replacer == nil) then
		return str
	else
		return replacer
	end
end

function table.formatsplit(str, replacer)
	local retn = {}

	local i = 1
	local last_cut = 1

	while (i <= str:len()) do
		local c = str:sub(i, i)

		if (c == "%") then
			retn[#retn + 1] = str:sub(last_cut, i - 1)
			local match, next = str:match("(%%[%w_]+%%)()", i)
			if (match) then
				retn[#retn + 1] = replace(replacer, match)
				i, last_cut = next, next
			end
		end

		i = i + 1
	end

	if (last_cut <= str:len()) then
		retn[#retn + 1] = str:sub(last_cut)
	end

	return retn
end

function string.formatsafe_table(str, ...)
	local cur_arg = 1
	local retn = {}

	local i = 1
	local last_cut = 1

	while (i <= str:len()) do
		local c = str:sub(i, i)

		if (c == "%") then
			local next = str:sub(i + 1, i + 1)
			if (next == "s") then
				retn[#retn + 1] = str:sub(last_cut, i - 1)
				retn[#retn + 1] = tostring((select(cur_arg, ...)))

				cur_arg = cur_arg + 1
				i = i + 1
				last_cut = i + 1
			end
		end

		i = i + 1
	end

	if (last_cut <= str:len()) then
		retn[#retn + 1] = str:sub(last_cut)
	end

	return retn
end

function string.formatsafe(str, ...)
	return table.concat(string.formatsafe_table(str, ...))
end

local function shuffler(a, b)
	return a.rand < b.rand
end

function table.shuffle(tbl)
	for i, dat in ipairs(tbl) do
		tbl[i] = {
			dat = dat,
			rand = math.random()
		}
	end

	table.sort(tbl, shuffler)

	for i, dat in ipairs(tbl) do
		tbl[i] = dat.dat
	end

	return tbl
end

-- https://gist.github.com/efrederickson/4080372
local numbers = { 1, 5, 10, 50, 100, 500, 1000 }
local chars = { "I", "V", "X", "L", "C", "D", "M" }

function pluto.toroman(s)
	s = tonumber(s)

	if (not s or s ~= s) then
		error "Unable to convert to number"
	end

	if (s == math.huge) then
		error "Unable to convert infinity"
	end

	s = math.floor(s)
	if (s <= 0) then
		return s
	end

	local ret = ""

	for i = #numbers, 1, -1 do
		local num = numbers[i]
		while (s - num >= 0 and s > 0) do
			ret = ret .. chars[i]
			s = s - num
		end

		for j = 1, i - 1 do
			local n2 = numbers[j]
			if (s - (num - n2) >= 0 and s < num and s > 0 and num - n2 ~= n2) then
				ret = ret .. chars[j] .. chars[i]
				s = s - (num - n2)
				break
			end
		end
	end
	return ret
end
