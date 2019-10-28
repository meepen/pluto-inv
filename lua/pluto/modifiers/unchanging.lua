MOD.Type = "suffix"
MOD.Name = "The Tome"
MOD.Tags = {}
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

MOD.Description = "This gun has been corrupted. It cannot be changed."

MOD.Tiers = {
	{ 1, 1 },
}

return MOD