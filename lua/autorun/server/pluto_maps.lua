local map_lookup = {
	de_dolls = "630780616",
	ttt_67thway_v14 = "298470515",
	--ttt_aircraft_v1b = "154177743",
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
	--ttt_olivegarden = "271298077",
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
	--ttt_waterworld_remastered = "1293781407",
	ttt_westwood_v4 = "104520719",
	ttt_whitehouse_v9 = "296631816",
	ttt_pluto_winterfactory = "2026893461",

	ttt_orange_v7 = "201250938",
	ttt_vegas_casino = "2013589768",
	ttt_vault = "422801063",
	ttt_kokiri = "2006894659",

	ttt_abandonedsubway = "1831532238",
	ttt_biocube = "1276409718",
	ttt_citadel = "2085978169",
	ttt_csgoofficesummer = "1124885861",
	--ttt_cyberpunk = "572218391",
	ttt_forsaken_chambers_v2 = "1766150425",
	ttt_glacier = "228041314",
	--ttt_hazard = "1528231628",
	ttt_simple_otat1 = "1812199726",
	ttt_vacuity = "728570439",

	ttt_pluto_station = "2236114156",

	ttt_pluto_bloodbath = "2220658788",

	ttt_ascend = "570270318",
	ttt_clue_2018_b7 = "1490186898",
	ttt_concentration_b2 = "228509308",
	ttt_freddy_the_ship_v3 = "119889220",
	ttt_harbor = "362988826",
	ttt_lttp_kakariko_a4 = "118937144",
	ttt_pcworld95_final = "624717817",
	ttt_vault = "422801063",
	ttt_vessel = "121935805",

	-- lime 2020
	ttt_skeld = "2244147954",
	ttt_mcdonalds_mds_v2 = "832254031",
	ttt_de_dolls_2008_v3 = "662146255",
	ttt_tf2_kongking = "583102116",
	ttt_tf2_harvest = "578705850",
	ttt_magma_v2b = "580870055",
	ttt_offblast_v2 = "1768579522",
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


local max_range = 12800

local changes = {
	ttt_innocentmotel_v1 = {
		Remove = {
			1593,
			1594,
			1551,
			1550,
		}
	},
	ttt_atlantis = {
		Entities = {
			pluto_block = {
				{
					Mins = Vector(558.402344, 2395.761475, -127.968750),
					Maxs = Vector(16.495560, 2320.931885, 124.112534),
				},
				{
					Mins = Vector(1789.020630, 1531.800293, -15.968746),
					Maxs = Vector(1605.661987, 1422.622803, 223.968750),
				},

				-- skybox
				{
					Mins = Vector(-max_range, -max_range, 165),
					Maxs = Vector(max_range, max_range, 1000),
				},
			},
		},
	},
	ttt_christmastown = {
		Remove = {
			2103,
			2104,
			1726,
			1727,
			2065,
			2066,
			2063,
			2064,
			1923,
			1924,
			1852,
			1853,
			2152,
			2153
		},
		Entities = {
			pluto_block = {
				{
					Mins = Vector(-max_range, -max_range, 490),
					Maxs = Vector(max_range, max_range, 1000)
				},
				{
					Mins = Vector(1013.454834, -3043.968750, 150),
					Maxs = Vector(1004.709229, -3236.638428, 1000.031250)
				},
				{
					Mins = Vector(1004.709229, -3236.638428, 150),
					Maxs = Vector(345.383881, -3223.166016, 1000)
				},
				{
					Mins = Vector(345.383881, -3223.166016, 150),
					Maxs = Vector(359.019379, -3708.840820, 1000.031250)
				},
				{
					Mins = Vector(359.019379, -3708.840820, 150),
					Maxs = Vector(-991.782410, -3702.208252, 1000)
				},
				{
					Mins = Vector(-991.782410, -3702.208252, 150.031250),
					Maxs = Vector(-985.727112, -3322.137207, 1000),
				},
				{
					Mins = Vector(-992.906738, -3328.938965, 150),
					Maxs = Vector(-1414.464844, -3308.904785, 1000),
				},
				{
					Mins = Vector(-1414.464844, -3308.904785, 150),
					Maxs = Vector(-1430.178955, -2228.209961, 1000),
				},
				{
					Mins = Vector(-1430.178955, -2228.209961, 150),
					Maxs = Vector(-1505.913696, -2252.130371, 1000),
				},
				{
					Mins = Vector(-1505.913696, -2252.130371, 150),
					Maxs = Vector(-1540.422241, -1265.033691, 1000),
				},
				{
					Mins = Vector(-1500.453491, -1265.239990, 150),
					Maxs = Vector(-1717.870239, -1260.839478, 1000),
				},
				{
					Mins = Vector(-1717.870239, -1260.839478, 150),
					Maxs = Vector(-1711.526123, -857.152527, 1000),
				},
				{
					Mins = Vector(-1711.526123, -857.152527, 150),
					Maxs = Vector(-1537.296387, -860.255737, 1000)
				},
				{
					Mins = Vector(-1585.542725, -862.631226, 150),
					Maxs = Vector(-1597.149048, -306.000732, 1000)
				},
				{
					Mins = Vector(-1474.383057, -350.031250, 150),
					Maxs = Vector(-1639.399048, -349.765869, 1000),
				},
				{
					Mins = Vector(1080.938354, -2155.510742, 150),
					Maxs = Vector(1080, -2155.510742, 1000)
				},
				{
					Mins = Vector(-89.336761, 263.998657, 280),
					Maxs = Vector(-546.473816, 414.031250, 1000)
				},
				{
					Mins = Vector(1080.968750, -2156.350830, 150),
					Maxs = Vector(1201.968750, -2169.014648, 1000),
				},
				{
					Mins = Vector(-1499.004272, -1420.951416, 1.169525),
					Maxs = Vector(-1430.341187, -1354.294189, -125.968750)
				}
			},
		},
	},
	ttt_casino_b2 = {
		Entities = {
			pluto_block = {
				{
					Mins = Vector(-max_range, -max_range, 0),
					Maxs = Vector(max_range, max_range, 1000),
				},
			},
		},
	},
	ttt_mw2_highrise = {
		Entities = {
			pluto_kill = {
				{
					Mins = Vector(-max_range, -max_range, -810),
					Maxs = Vector(max_range, max_range, -1010),
				}
			}
		}
	},
	ttt_metropolis = {
		Entities = {
			pluto_kill = {
				{
					Mins = Vector(-max_range, -max_range, 200.590088),
					Maxs = Vector(max_range, max_range, 290.590088),
				}
			}
		}
	},
	ttt_richland_fix = {
		Entities = {
			pluto_block = {
				{
					Mins = Vector(1353.164429, -1590.968750, 120.697266),
					Maxs = Vector(1635.450073, -1604.332764, 1204.968750)
				}
			}
		}
	},
	ttt_mw2_terminal = {
		Entities = {
			pluto_block = {
				{
					Mins = Vector(-1891.632324, 345.634949, 323.542053),
					Maxs = Vector(-1770.460571, 1069.968750, 720.980286),
				},
				{
					Mins = Vector(-max_range, -max_range, 395),
					Maxs = Vector(max_range, max_range, max_range),
				},
				{
					Mins = Vector(1411.918579, -1151.968750, 241.407318),
					Maxs = Vector(1536.441772, 815.766235, 370.079773),
				},
				{
					Mins = Vector(-1166.165405, -1532.051270, 81.909622),
					Maxs = Vector(-940.611450, -1532, 284.352112),
				},
				{
					Mins = Vector(1204.968750, 1815.791748, 303.903412),
					Maxs = Vector(523.714478, 2168.610840, 370.079773),
				},
				{
					Mins = Vector(-2036.941528, 360.031250, 274.532471),
					Maxs = Vector(-1560.594360, 1200.593506, 394.968750),
				},
				{
					Mins = Vector(1329.889160, 827.968628, 363.187958),
					Maxs = Vector(1401.968750, -1148.102417, 182.187347),
				}
			}
		}
	},
	ttt_desperados_2 = {
		Entities = {
			pluto_block = {
				{
					Mins = Vector(3048.625000, -5199.309570, 240.031250),
					Maxs = Vector(3071.722900, -5353.932617, 2303.968750),
				},
				{
					Mins = Vector(3999.968750, -5329.841309, 1133.74414),
					Maxs = Vector(3071.722900, -5353.932617, 2303.968750),
				},
				{
					Mins = Vector(-max_range, -max_range, 1453.591675),
					Maxs = Vector(max_range, max_range, max_range),
				},
			}
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

	if (dat.Entities) then
		for enttype, datas in pairs(dat.Entities) do
			for _, data in pairs(datas) do
				local e = ents.Create(enttype)
				local mn, mx = data.Mins, data.Maxs
				local real_mins = Vector(math.min(mn.x, mx.x), math.min(mn.y, mx.y), math.min(mn.z, mx.z))
				local real_maxs = Vector(math.max(mn.x, mx.x), math.max(mn.y, mx.y), math.max(mn.z, mx.z))
				e:SetMins(real_mins)
				e:SetMaxs(real_maxs)
				e:Spawn()
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
