MOD.Type = "suffix"
MOD.Name = "Zoomies"
MOD.Tags = { }
MOD.ModType = "special"

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:CanRollOn(class)
	return class.HasScope
end

function MOD:GetDescription(rolls)
	return string.format("You can zoom %i additional time%s", rolls[1], rolls[1] == 1 and "" or "s")
end

MOD.Tiers = {
	{ 2, 2 },
	{ 1, 1 },
}

return MOD