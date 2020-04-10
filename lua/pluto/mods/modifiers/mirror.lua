MOD.Type = "implicit"
MOD.Name = "The Mirror"
MOD.Tags = {}

MOD.Color = Color(180, 180, 180)
MOD.PreventChange = true

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:CanRollOn(class)
	return false
end

function MOD:FormatModifier(index, roll)
	return ""
end

MOD.NoCoined = true

MOD.Description = "Mirrored"

MOD.Tiers = {
	{ 1, 1 },
}

return MOD