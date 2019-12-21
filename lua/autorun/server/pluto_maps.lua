local map_lookup = {
	ttt_innocentmotel_v1 = "285372790",
	--["ttt_pluto_test.*"] = "1851705099",
	ttt_penitentiary = "1335770232",
	ttt_chaser_v2 = "109410344",
	ttt_magma_v2a  = "208061322",
	de_dolls = "821268438",
	ttt_island_2013 = "183797802",
	ttt_bb_teenroom_b2 = "141103402",
	ttt_richland_fix = "572477267",
	ttt_community_bowling_v5a = "131667838",
	ttt_pluto_icebox_v2 = "1897157110",
	ttt_casino_b2 = "169342118",
	ttt_mcdonalds = "264839450",
	ttt_skyscraper = "253328815",
	ttt_stadium = "104506140",
	ttt_whitehouse_v9 = "296631816",
	ttt_forest_final = "147635981",
	ttt_clue_se_2017 = "971786142",
	ttt_skyscraper_2015_v1p_f4 = "376339464",
}

function pluto.GetValidMaps()
	local r = {}
	for map, id in pairs(map_lookup) do
		if (not file.Exists("maps/" .. map .. ".bsp", "GAME") or not file.Exists("maps/" .. map .. ".nav", "GAME")) then
			continue
		end

		r[#r + 1] = map
	end

	return r
end

for map, wsid in pairs(map_lookup) do
	if (game.GetMap() == map) then
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
			if (IsValid(e)) then
				e:Remove()
			end
		end
	end
end)