MOD.Type = "prefix"
MOD.Name = "RPM"
MOD.StatModifier = "Delay"
MOD.Tags = {
	"rpm", "speed"
}

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:FormatModifier(index, roll)
	return string.format("%.01f%%", roll)
end

function MOD:GetDescription(rolls)
	return rolls[1] >= 0 and "This gun shoots %s faster" or "This gun shoots %s slower"
end

MOD.Tiers = {
	{ 10, 15 },
	{ 5, 10 },
	{ 2.5, 5 },
	{ -1, 2.5 },
	{ -4, -1 },
}

return MOD