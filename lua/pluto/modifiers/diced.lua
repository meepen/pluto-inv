MOD.Type = "implicit"
MOD.Name = "Diced"
MOD.Tags = {}

MOD.Color = Color(235, 193, 40)

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:CanRollOn(class)
	return false
end

function MOD:FormatModifier(index, roll)
	return ""
end

MOD.Description = "Rolls better numbers on modifiers"

MOD.Tiers = {
	{ 1, 1 },
}

function MOD:OnRollMod(item, mod)
	for i = 1, #mod.Roll do
		mod.Roll[i] = math.min(1, mod.Roll[i] + 0.15)
	end
end

return MOD