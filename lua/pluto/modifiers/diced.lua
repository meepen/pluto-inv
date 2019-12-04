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

MOD.Description = "Doubles currency rewards"

MOD.Tiers = {
	{ 1, 1 },
}

function MOD:OnKill(wep, atk, vic, rolls)
	if (IsValid(atk)) then
		pluto.currency.givespawns(atk, 1)
	end
end

return MOD