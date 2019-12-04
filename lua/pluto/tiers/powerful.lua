return {
	Name = "Powerful",
	affixes = 3,
	tags = {
		damage = 3,
	},
	SubDescription = {
		tags = "This gun seems to roll Damage modifiers 3x as often",
		rolltier = "This gun seems to roll better Damage modifiers",
	},
	rolltier = function(mod)
		if (mod.Tags and mod.Tags.damage) then
			local bias = 1.5
			return math.floor(math.random(1, (#mod.Tiers) ^ (1 / bias)) ^ bias)
		end
		return math.random(1, #mod.Tiers)
	end,
	Shares = 10000,
	Color = Color(204, 61, 5),
}