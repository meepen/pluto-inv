MOD.Type = "suffix"
MOD.Name = "Cannibalism"
MOD.Tags = {
	"healing",
}

function MOD:IsNegative(roll)
	return false
end

function MOD:GetDescription(rolls)
	return string.format("After a righteous kill, heal %i%% of your health over %.02f seconds", rolls[1], rolls[2])
end

MOD.Tiers = {
	{ 15,  15, 1, 5 },
	{ 10, 10, 1, 5 },
	{ 5, 5, 1, 5 },
}

function MOD:OnKill(wep, atk, vic, rolls)
	if (atk:GetRoleTeam() ~= vic:GetRoleTeam()) then
		pluto.statuses.heal(atk, atk:GetMaxHealth() * rolls[1] / 100, rolls[2])
	end
end

return MOD