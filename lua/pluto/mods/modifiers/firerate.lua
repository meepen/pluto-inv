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
	{ 9, 13 },
	{ 6, 9 },
	{ 5, 6 },
	{ 3, 5 },
	{ 0, 3 },
}

return MOD