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


local mt = {
	__index = {
		SetPos = function(self, x, y)
			local dx, dy = x, y
			if (self.lastpos) then
				dx, dy = dx - self.lastpos.x, dy - self.lastpos.y
			end
			self.lastpos = {x = x, y = y}

			for _, vertex in ipairs(self) do
				vertex.x, vertex.y = vertex.x + dx, vertex.y + dy
			end
		end,
		GetPos = function(self)
			if (self.lastpos) then
				return self.lastpos.x, self.lastpos.y
			end
			return 0, 0
		end,
		Rotate = function(self, rot)
			local x, y = self:GetPos()

			local rad = math.rad(rot)
			local s, c = math.sin(rad), math.cos(rad)

			for _, vertex in ipairs(self) do
				local bx, by = vertex.x - x, vertex.y - y
				local bxr, byr = bx * c - by * s, bx * s + by * c

				vertex.x = bxr + x
				vertex.y = byr + y
			end
		end
	},
	__call = function(self)
		surface.DrawPoly(self)
	end
}

function pluto.ellipsis(w, h)
	local points = math.max(w, h) * 2
	local vertices = {}

	for ang = 0, points - 1 do
		local cur = math.rad(-ang / points * 360)

		local s, c = math.sin(cur) * w, math.cos(cur) * h

		table.insert(vertices, {
			x = s,
			y = c
		})
	end

	return setmetatable(vertices, mt)
end


function pluto.loading_polys(x, y, size, rot)
	rot = rot or 0
	local ellipsis_width = size / 16
	local ellipsis_height = size / 7

	local diameter = size - ellipsis_height * 2
	local circumference = math.pi * diameter


	local poly_count = math.floor(math.ceil(circumference / (ellipsis_width * 8)) / 2 + 1) * 2

	local polys = {}

	local r = diameter / 2
	for i = 0, poly_count - 1 do
		local ang = i / poly_count * 360 + rot
		local rang = math.rad(ang)
		local s, c = math.sin(rang), math.cos(rang)

		local poly = pluto.ellipsis(ellipsis_width, ellipsis_height)
		poly:SetPos(x + size / 2 + s * r, y + size / 2 + c * r)
		poly:Rotate(-ang)

		table.insert(polys, poly)
	end

	return polys
end
