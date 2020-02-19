function math.fact(x)
	return math.Round(math.sqrt(2 * math.pi / x) * ((x + 1 / ((12 * x) - 1 / (10 * x))) / math.exp(1)) ^ x)
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
