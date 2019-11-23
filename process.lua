local cur
local t = {}

local lookup = {
	generic = 0,
	head = 1,
	chest = 2,
	stomach = 3,
	leftarm = 4,
	rightarm = 5,
	lefthand = 4,
	righthand = 5,
	leftleg = 6,
	rightleg = 7,
	["rightleg"] = 7,
}

local max = -math.huge

for line in io.lines("hitgroups.txt") do
	if (tonumber(line)) then
		t[tonumber(line) + 1] = cur
		max = math.max(max, tonumber(line) + 1)
	else
		cur = lookup[line:match "^(%w+)"]
		print(line, cur)
	end
end

if (#t ~= max) then
	error(#t)
end

print(table.concat(t, ", "))