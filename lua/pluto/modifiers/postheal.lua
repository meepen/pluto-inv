MOD.Type = "suffix"
MOD.Name = "Rejuvenation"
MOD.Tags = {
	"healing",
}

function MOD:IsNegative(roll)
	return false
end

function MOD:FormatModifier(index, roll)
	if (index == 1) then
		return string.format("%i", roll)
	else
		return string.format("%.01f", roll)
	end
end

MOD.Description = "After a righteous kill, heal %s of your health over %s seconds"

MOD.Tiers = {
	{ 15,  15, 1, 5 },
	{ 10, 10, 1, 5 },
	{ 5, 5, 1, 5 },
}

function MOD:OnKill(wep, rolls, atk, vic)
	if (atk:GetRoleTeam() ~= vic:GetRoleTeam()) then
		pluto.statuses.heal(atk, atk:GetMaxHealth() * rolls[1] / 100, rolls[2])
	end
end

return MOD