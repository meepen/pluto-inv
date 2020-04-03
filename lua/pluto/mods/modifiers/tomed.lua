MOD.Type = "implicit"
MOD.Name = "Tomed"
MOD.Tags = {}

MOD.Color = Color(153, 6, 87)

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:CanRollOn(class)
	return false
end

function MOD:FormatModifier(index, roll)
	return ""
end

MOD.Description = "This item awaits the tome..."

MOD.Tiers = {
	{ 1, 1 },
}

return MOD