MOD.Type = "implicit"
MOD.Name = "Hearted"
MOD.Tags = {}

MOD.Color = Color(204, 43, 75)

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:CanRollOn(class)
	return false
end

function MOD:FormatModifier(index, roll)
	return ""
end

MOD.Tomeable = true

MOD.Description = "Has an extra affix slot"

MOD.ExtraAffixes = 1

MOD.Tiers = {
	{ 1, 1 },
}

return MOD