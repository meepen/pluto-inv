local map_lookup = {
	ttt_innocentmotel_v1 = "285372790",
	["ttt_pluto_test.*"] = "1851705099",
	ttt_penitentiary = "1335770232",
	ttt_chaser_v2 = "109410344",
	ttt_magma_v2a  = "208061322",
	de_dolls = "821268438",
	["ttt_rooftops_2016.*"] = "534491717",
	["ttt_island.*"] = "183797802",
	["ttt_bb_teenroom_b.*"] = "141103402",
	ttt_richland_fix = "572477267",
	["ttt_community_bowling.*"] = "131667838",
}

for k, wsid in pairs(map_lookup) do
	if (game.GetMap():match("^" .. k .. "$")) then
		resource.AddWorkshop(wsid)
		break
	end
end


local changes = {
	ttt_innocentmotel_v1 = {
		Remove = {
			1593,
			1594,
			1551,
			1550,
		}
	}
}

local dat = changes[game.GetMap()]


if (not dat) then
	return
end

hook.Add("InitPostEntity", "pluto_maps", function()
	if (dat.Remove) then
		for _, id in pairs(dat.Remove) do
			local e = ents.GetMapCreatedEntity(id)
			print(id, e)
			if (IsValid(e)) then
				e:Remove()
			end
		end
	end
end)

hook.Add("PostCleanupMap", "pluto_maps", function()
	if (dat.Remove) then
		for _, id in pairs(dat.Remove) do
			local e = ents.GetMapCreatedEntity(id)
			print(id, e)
			if (IsValid(e)) then
				e:Remove()
			end
		end
	end
end)