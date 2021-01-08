MOD.Type = "prefix"
MOD.Name = "Reload Speed"
MOD.StatModifier = "ReloadAnimationSpeed"
MOD.Tags = {
	"reload", "speed"
}

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:FormatModifier(index, roll)
	return string.format("%.01f%%", roll)
end

MOD.Description = "Reloads %s faster"

MOD.Tiers = {
	{ 25, 45 },
	{ 20, 25 },
	{ 5, 10 },
	{ 0.1, 5 },
}

return MOD