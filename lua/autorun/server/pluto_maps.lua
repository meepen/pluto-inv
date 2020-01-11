local map_lookup = {
	de_dolls = "630780616",
	ttt_67thway_v14 = "298470515",
	ttt_aircraft_v1b = "154177743",
	ttt_atlantis = "301247622",
	--ttt_avalon = "284613511",
	ttt_bb_teenroom_b2 = "141103402",
	ttt_black_mesa_east_v1_fix2 = "716959993",
	ttt_canyon_a4 = "224282233",
	ttt_casino_b2 = "169342118",
	ttt_chaser_v2 = "109410344",
	ttt_christmastown = "779886575",
	ttt_cluedo_b5_improved1 = "253292930",
	ttt_community_bowling_v5a = "131667838",
	ttt_community_pool_revamped = "144575800",
	ttt_complex_fix4_ws = "512506068",
	ttt_crummycradle_a4 = "264864627",
	ttt_desperados_2 = "816252821",
	ttt_forest_final = "147635981",
	ttt_innocentmotel_v1 = "285372790",
	ttt_island_2013 = "183797802",
	ttt_kakariko_v4a = "238575181",
	ttt_pluto_stacks = "1935601426",
	ttt_lego = "295897079",
	ttt_lifetheroof = "487551759",
	ttt_lost_temple_v2 = "106527577",
	ttt_magma_v2a = "208061322",
	ttt_mcdonalds = "264839450",
	ttt_metropolis = "153600777",
	ttt_minecraft_b5 = "159321088",
	ttt_minecraft_haven = "389346280",
	ttt_minecraftcity_v3 = "212055526",
	ttt_mw2_terminal = "176887855" ,
	ttt_mw2_highrise = "290247692",
	ttt_olivegarden = "271298077",
	ttt_penitentiary = "1335770232",
	ttt_pluto_icebox_v2 = "1897157110",
	ttt_pluto_testing_grounds = "1851705099",
	ttt_richland_fix = "572477267" ,
	ttt_roy_the_ship = "108040571",
	ttt_skybreak_v1 = "1419089916",
	ttt_skyscraper_2015_v1p_f4 = "376339464",
	ttt_slender = "165026364",
	ttt_space_street_67_b2 = "544977614",
	ttt_stadium = "104506140",
	--ttt_terrorception = "110656185",
	ttt_terrortown = "204621664",
	ttt_the_room_v2 = "612880973",
	ttt_theship_v1 = "133911194",
	ttt_waterworld_remastered = "1293781407",
	ttt_westwood_v4 = "104520719",
	ttt_whitehouse_v9 = "1376497306",
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

local dat = changes[game.GetMap():lower()]


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