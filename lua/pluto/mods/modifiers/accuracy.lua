MOD.Type = "prefix"
MOD.Name = "Spread"
MOD.StatModifier = "Spread"
MOD.Tags = {
	"accuracy"
}

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:FormatModifier(index, roll)
	return string.format("%.01f%%", roll)
end

MOD.Description = "Accuracy is increased by %s"

MOD.Tiers = {
	{ -15, -25 },
	{ -5, -15 },
	{ -2.5, -5 },
	{ -0.1, -2.5 },
}

return MOD