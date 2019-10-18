MOD.Type = "suffix"
MOD.Name = "Zoomies"
MOD.Tags = { }

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:CanRollOn(class)
	return false and class.HasScope
end

function MOD:FormatModifier(index, roll)
	return string.format("%i", roll)
end

MOD.Description = "You can zoom %s additional times"

MOD.Tiers = {
	{ 2, 2 },
	{ 1, 1 },
}

return MOD