MOD.Type = "implicit"
MOD.Name = "Arcane"
MOD.Tags = {}

MOD.Color = Color(24, 50, 217)

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:CanRollOn(class)
	return false
end

function MOD:FormatModifier(index, roll)
	return ""
end

MOD.Description = "Touch of the Arcane"

MOD.Tiers = {
	{ 1, 1 },
}

return MOD