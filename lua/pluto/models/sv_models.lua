pluto.models = pluto.models or {}
pluto.models.gendered = {}
pluto.models.list = {}

AddCSLuaFile "sh_list.lua"

function pluto.model(name)
	return function(d)
		d.InternalName = name
		local old = pluto.models[name]
		if (old) then
			table.Merge(old, d)
			d = old
		else
			pluto.models[name] = d
		end
		-- resource.AddFile(d.Model)
		player_manager.AddValidModel(d.Name, d.Model)
		if (d.Hands) then
			player_manager.AddValidHands(d.Name, d.Hands, 0, "00000000")
		end

		pluto.models.gendered[d.Model] = d.Gender or "Male"

		if (not d.Fake) then
			table.insert(pluto.models.list, d)
		end
	end
end

include "sh_list.lua"

hook.Add("PlayerSetModel", "pluto_model", function(ply)
	local r = pluto.rounds.run("PlayerSetModel", ply)

	if (r ~= nil) then
		return r
	end

	if (ply:IsBot()) then
		ply:SetModel(table.Random(pluto.models.list).Model)
		return true
	end

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
		pluto.updatemodel(ply, mdl)
		for _, other in pairs(player.GetHumans()) do
			pluto.inv.message(other)
				:write("playermodel", ply, mdl)
				:send()
		end
		return true
	end
end)

function pluto.inv.writeplayermodel(to, ply, mdl)
	net.WriteEntity(ply)
	pluto.inv.writeitem(to, mdl)
end