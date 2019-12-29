MOD.Type = "implicit"
MOD.Name = "Dropletted"
MOD.Tags = {}

MOD.Color = Color(24, 125, 216)

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:CanRollOn(class)
	return false
end

function MOD:FormatModifier(index, roll)
	return ""
end

MOD.Description = "Droplets can roll max modifiers"

MOD.Tiers = {
	{ 1, 1 },
}

return MOD