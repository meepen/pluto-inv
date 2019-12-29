MOD.Type = "implicit"
MOD.Name = "Coined"
MOD.Tags = {}

MOD.Color = Color(254, 233, 105)

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:CanRollOn(class)
	return false
end

function MOD:FormatModifier(index, roll)
	return ""
end

MOD.Description = "Doubles currency rewards"

MOD.Tiers = {
	{ 1, 1 },
}

function MOD:OnKill(wep, rolls, atk, vic)
	if (IsValid(atk)) then
		pluto.currency.givespawns(atk, 0.3)
	end
end

return MOD