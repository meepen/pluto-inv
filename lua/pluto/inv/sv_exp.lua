

hook.Add("DoPlayerDeath", "pluto_model_exp", function(vic, damager, dmg)
	local atk = dmg:GetAttacker()

	if (not IsValid(atk) or not atk:IsPlayer() or not pluto.inv.invs[atk]) then
		return
	end

	local equip_tab = pluto.inv.invs[atk].equip

	if (not equip_tab) then
		pwarnf("Player doesn't have equip tab!")
		return
	end


	local mdl = equip_tab.Items[3]
	if (not mdl or mdl.Type ~= "Model") then
		return
	end

	if (atk:GetRoleTeam() == vic:GetRoleTeam()) then
		return
	end

	pprintf("MODEL EXP!!!")

	pluto.inv.addexperience(mdl.RowID, (atk:GetRole() == "Innocent" and 150 or 75) + math.random(0, 25))
end)