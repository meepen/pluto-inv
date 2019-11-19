CreateConVar("pluto_model", "", FCVAR_USERINFO)

pluto.models = {}

function pluto.model(name)
	return function(d)
		d.InternalName = name
		pluto.models[name] = d

		player_manager.AddValidModel(d.Name, d.Model)
		if (d.Hands) then
			player_manager.AddValidHands(d.Name, d.Hands, 0, "00000000")
		end
	end
end

include "sh_list.lua"