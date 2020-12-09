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

MOD.Description = "Gives 15% more currency rewards per max modifier"

MOD.Tiers = {
	{ 1, 1 },
}

function MOD:OnUpdateSpawnPoints(wep, rolls, atk, vic, state)
	if (IsValid(atk) and state.Points > 0) then
		local gun = wep.PlutoGun

		state.Points = state.Points * (1 + 0.15 * gun:GetMaxAffixes())
	end
end

return MOD