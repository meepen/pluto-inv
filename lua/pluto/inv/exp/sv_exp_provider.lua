

hook.Add("DoPlayerDeath", "pluto_provide_exp", function(vic, damager, dmg)
	local atk = dmg:GetAttacker()

	if (not IsValid(atk) or not atk:IsPlayer()) then
		return
	end

	if (atk:GetRoleTeam() == vic:GetRoleTeam()) then
		return
	end

	local exp_gotten = (atk:GetRole() == "Innocent" and 150 or 75) + math.random(0, 25)

	hook.Run("PlutoExperienceGain", atk, exp_gotten, damager, vic)
end)