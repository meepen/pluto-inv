pluto.models = {}

AddCSLuaFile "sh_list.lua"

function pluto.model(name)
	return function(d)
		d.InternalName = d
		pluto.models[name] = d
		-- resource.AddFile(d.Model)
		player_manager.AddValidModel(d.Name, d.Model)
		if (d.Hands) then
			player_manager.AddValidHands(d.Name, d.Hands, 0, "00000000")
		end

		for _, fname in pairs(d.Downloads or {}) do
			for _, add in pairs((file.Find(fname .. "*", "GAME"))) do
				-- resource.AddFile(fname .. add)
			end
		end
	end
end

include "sh_list.lua"

hook.Add("PlayerSetModel", "pluto_model", function(ply)
	if (ply:SteamID() == "STEAM_0:0:44950009") then
		local m = pluto.models[ply:GetInfo "pluto_model"]
		if (not m) then
			return
		end

		PrintTable(m)

		ply:SetModel(m.Model)
		return true
	end
end)
