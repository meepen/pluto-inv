CreateConVar("pluto_model", "", FCVAR_USERINFO)

pluto.models = pluto.models or {}

function pluto.model(name)
	return function(d)
		d.InternalName = name
		local old = pluto.models[name]
		if (old) then
			table.Merge(old, d)
		else
			pluto.models[name] = d
			pluto.models[d.Model] = d
		end

		player_manager.AddValidModel(d.Name, d.Model)
		if (d.Hands) then
			player_manager.AddValidHands(d.Name, d.Hands, 0, "00000000")
		end
	end
end

include "sh_list.lua"

matproxy.Add {
	name = "B3ZeroEmotes",
	init = function(self, mat, values)
		self.EmoteColor = values.resultvar
	end,
	bind = function(self, mat)
		mat:SetVector(self.EmoteColor, Vector(3, 0, 0))
	end
}

function pluto.inv.readplayermodel()
	local ply = net.ReadEntity()
	local item = pluto.inv.readitem()

	PrintTable(item)

	pluto.sparkle(ply, "pluto_sparklies", false)
	local id = IsValid(ply) and ply:IsPlayer() and ply:SteamID64()
	if (item and (id == "76561198083846494" or id == "76561198050165746")) then
		pluto.sparkle(ply, "pluto_hearts", true)
	elseif (item and item.SpecialName and item.SpecialName:StartWith "Prototype ") then
		pluto.sparkle(ply, "pluto_sparklies", true)
	end

end