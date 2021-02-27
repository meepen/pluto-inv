hook.Add("PlutoExperienceGain", "pluto_model_exp", function(ply, exp, damager, vic)
	local inv = pluto.inv.invs[ply]
	if (not inv) then
		return
	end

	local equip_tab = inv.tabs.equip

	if (not equip_tab) then
		pwarnf "Player doesn't have equip tab!"
		return
	end

	local mdl = equip_tab.Items[3]
	if (not mdl or mdl.Type ~= "Model") then
		pwarnf "Item not model!!!"
		return
	end

	pluto.inv.addexperience(mdl.RowID, exp)
end)