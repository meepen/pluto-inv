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

MOD.Description = "Gives 50% more currency rewards"

MOD.Tiers = {
	{ 1, 1 },
}

function MOD:OnUpdateSpawnPoints(wep, rolls, atk, vic, state)
	if (IsValid(atk) and state.Points > 0) then
		state.Points = state.Points * 1.5
	end
end

return MOD