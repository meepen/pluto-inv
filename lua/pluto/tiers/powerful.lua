return {
	Name = "Powerful",
	affixes = 3,
	tags = {
		texture = "bullets",
		damage = 3,
	},
	SubDescription = {
		tags = "This gun seems to roll Damage modifiers 3x as often",
		rolltier = "This gun seems to roll better Damage modifiers",
	},
	rolltier = function(mod)
		if (mod.Tags and mod.Tags.damage) then
			local bias = 1.5

			return math.ceil(math.random() ^ (1 / bias) * #mod.Tiers)
		end
		return math.random(1, #mod.Tiers)
	end,
	Color = Color(204, 61, 5),
}