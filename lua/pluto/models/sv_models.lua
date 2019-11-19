pluto.models = {}

AddCSLuaFile "sh_list.lua"

function pluto.model(name)
	return function(d)
		d.InternalName = name
		pluto.models[name] = d
		-- resource.AddFile(d.Model)
		player_manager.AddValidModel(d.Name, d.Model)
		if (d.Hands) then
			player_manager.AddValidHands(d.Name, d.Hands, 0, "00000000")
		end
	end
end

include "sh_list.lua"

hook.Add("PlayerSetModel", "pluto_model", function(ply)
	if (pluto.cancheat(ply)) then
		local m = pluto.models[ply:GetInfo "pluto_model"]
		if (m) then
			ply:SetModel(m.Model)
			return true
		end
	end

	if (not pluto.inv.invs[ply]) then
		return
	end

	local equip_tab

	for _, tab in pairs(pluto.inv.invs[ply]) do
		if (tab.Type == "equip") then
			equip_tab = tab
			break
		end
	end

	if (not equip_tab) then
		pwarnf("Player doesn't have equip tab!")
		return
	end

	local mdl = equip_tab.Items[3]

	if (mdl and mdl.Type == "Model") then
		ply:SetModel(mdl.Model.Model)
		return true
	end
end)
