return {
	Name = "Confused",
	affixes = 6,
	rolltier = function(mod)
		return #mod.Tiers
	end,
	tags = {
		damage = 3,
		speed = 3,
		rpm = 3,
	},
	SubDescription = {
		tags = "This gun seems to roll Damage, Speed and RPM modifiers 3x as often",
		rolltier = "This gun seems to always roll the lowest tier possible"
	},
	Shares = 1000,
	Color = Color(180, 170, 70),
}