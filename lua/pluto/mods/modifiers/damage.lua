MOD.Type = "prefix"
MOD.Name = "Damage"
MOD.StatModifier = "Damage"
MOD.Tags = {
	"damage"
}

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:GetDamageMult(rolls)
	return rolls[1] / 100
end

function MOD:FormatModifier(index, roll)
	return string.format("%.01f%%", roll)
end

function MOD:GetDescription(rolls)
	return rolls[1] >= 0 and "Damage is increased by %s" or "Damage is decreased by %s"
end

MOD.Tiers = {
	{ 11, 15 },
	{ 6, 11 },
	{ 3, 6 },
	{ -3, 3 },
}

return MOD