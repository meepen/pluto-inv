
pluto.tiers = pluto.tiers or {
	crafted = {},
	bytype = {},
	byname = {},
}

local TIER = {}
pluto.tier_mt = pluto.tier_mt or {}
pluto.tier_mt.__index = TIER

function TIER:GetSubDescription()
	local desc = self.SubDescription

	if (type(desc) == "table") then
		local r = {}

		for k, v in SortedPairs(desc) do
			r[#r + 1] = v
		end

		return table.concat(r, "\n")
	end

	return desc or ""
end

function pluto.tiers.random(gun)
	local type = pluto.weapons.type(gun)

	if (not type) then
		return
	end

	local typelist = pluto.tiers.bytype[type]

	if (not typelist) then
		return
	end

	local rand = math.random() * typelist.shares

	for _, tier in pairs(typelist.list) do
		rand = rand - tier.Shares
		if (rand < 0) then
			return tier
		end
	end

	error "Reached end of loop in pluto.tiers.random!" 
end

local function CombineColors(...)
	local cols = {
		s = 0,
		v = 0,
		a = 255
	}
	local hues = {}

	local num = select("#", ...)
	for i = 1, num do
		local h, s, v = ColorToHSV((select(i, ...)))

		hues[i] = h / 360
		cols.s = cols.s + s / num
		cols.v = cols.v + v / num
	end

	local c = HSVToColor(math.circularmean(unpack(hues)) * 360, cols.s, cols.v, cols.a)
	return Color(c.r, c.g, c.b, c.a)
end

function pluto.tiers.craft(tiers)
	for i, t in pairs(tiers) do
		tiers[i] = pluto.tiers.byname[tiers[i]]
	end

	local t1, t2, t3 = tiers[1], tiers[2], tiers[3]

	if (t1 == t2 and t2 == t3) then
		return t1
	end

	local name = t1.InternalName .. "-" .. t2.InternalName .. "-" .. t3.InternalName

	if (pluto.tiers.crafted[name]) then
		return pluto.tiers.crafted[name]
	end

	local tier = setmetatable({
		Name = "Crafted",
		InternalName = "crafted",
		Tiers = {
			t1.InternalName,
			t2.InternalName,
			t3.InternalName,
		},
	}, pluto.tier_mt)

	pluto.tiers.crafted[name] = tier

	tier.SubDescription = {
		string.format("Crafted from %s, %s and %s shards", t1.Name, t2.Name, t3.Name)
	}

	if (t2.tags) then
		table.insert(tier.SubDescription, t2.SubDescription.tags)
		tier.tags = t2.tags
	end

	if (t3.rolltier) then
		table.insert(tier.SubDescription, t3.SubDescription.rolltier)
		tier.rolltier = t3.rolltier
	end

	tier.affixes = t1.affixes or 0
	tier.Color = CombineColors(t1.Color, t1.Color, t1.Color, t2.Color, t2.Color, t3.Color)

	return tier
end

for _, name in pairs {
	"common",
	"confused",
	"junk",
	"mystical",
	"otherworldly",
	"powerful",
	"shadowy",
	"stable",
	"uncommon",
	"unique",
	"vintage",

	"unstable",
} do
	local item = include("pluto/tiers/" .. name .. ".lua")
	if (not item) then
		pwarnf("Tier %s didn't return a value", name)
		continue
	end

	setmetatable(item, pluto.tier_mt)

	if (not item.Shares) then
		pwarnf("Tier %s doesn't have shares", name)
		continue
	end

	local prev = pluto.tiers[name]
	if (prev) then
		table.Merge(prev, item)
		item = prev
	end

	item.InternalName = name


	pluto.tiers.byname[name] = item

	local type = item.Type or "Weapon"

	if (not pluto.tiers.bytype[type]) then
		pluto.tiers.bytype[type] = {
			list = {},
			shares = 0,
		}
	end

	local typelist = pluto.tiers.bytype[type]

	table.insert(typelist.list, item)
	typelist.shares = typelist.shares + item.Shares
end