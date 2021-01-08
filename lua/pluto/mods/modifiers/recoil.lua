MOD.Type = "prefix"
MOD.Name = "Recoil"
MOD.StatModifier = "ViewPunchAngles"
MOD.Tags = {
	"recoil"
}

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:FormatModifier(index, roll)
	return string.format("%.01f%%", -roll)
end

function MOD:GetDescription(rolls)
	return rolls[1] < 0 and "Recoil is decreased by %s" or "Recoil is increased by %s"
end

MOD.Tiers = {
	{ -20, -33 },
	{ -13, -20 },
	{ -7, -13 },
	{ -4, -7 },
	{ -4, -4 },
}

return MOD