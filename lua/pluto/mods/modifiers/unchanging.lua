MOD.Type = "implicit"
MOD.Name = "The Tome"
MOD.Tags = {}

MOD.Color = Color(255, 0, 0)
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

MOD.Description = "Corrupted"

MOD.Tiers = {
	{ 1, 1 },
}

return MOD