MOD.Type = "suffix"
MOD.Name = "Shocking"
MOD.Tags = {
	"shock"
}

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:FormatModifier(index, roll)
	return string.format("%.01f%%", roll)
end

MOD.Description = "Hits have a %s chance to shock"

MOD.Tiers = {
	{ 5,   7.5  },
	{ 2.5, 5   },
	{ 1,   2.5 },
}

return MOD