pluto.craft = pluto.craft or {}

local function CombineColors(...)
	local cols = {
		r = 0,
		g = 0,
		b = 0,
		a = 255
	}

	local num = select("#", ...)
	for i = 1, num do
		local c = select(i, ...)

		cols.r = cols.r + c.r / num
		cols.g = cols.g + c.g / num
		cols.b = cols.b + c.b / num
	end

	return Color(cols.r, cols.g, cols.b, cols.a)
end

function pluto.craft.tier(tiers)
	local tier = setmetatable({
		Name = "Crafted",
		InternalName = "crafted",
	}, pluto.tier_mt)

	for i, t in pairs(tiers) do
		tiers[i] = pluto.tiers[tiers[i]]
	end

	local t1, t2, t3 = tiers[1], tiers[2], tiers[3]

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