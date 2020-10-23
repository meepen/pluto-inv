local function default(name)
	return "https://cdn.pluto.gg/" .. name .. ".gma"
end
local packs =  {
	pluto = {
		remote = "https://cdn.pluto.gg/content.gma",
		versions = {
			"20200223_222",
			"20191121",
			"20191119",
			"20191118",
			"20191115",
			"20191114",
			"20191113"
		}
	},
	shotguns = {
		remote = "https://cdn.pluto.gg/shotguns.gma",
		versions = {
			"20200223_222",
			"20191115",
		}
	},
	m21 = {
		remote = "https://cdn.pluto.gg/m21.gma",
		versions = {
			"20200223_222",
			"20191205",
		}
	},
	mp7 = {
		remote = "https://cdn.pluto.gg/mp7.gma",
		versions = {
			"20200331",
			"20200223_222",
			"20191117",
			"20191115",
		}
	},
	tec9 = {
		remote = "https://cdn.pluto.gg/tec9.gma",
		versions = {
			"20200223_222",
			"20191116",
			"20191115",
		}
	},
	ump45 = {
		remote = "https://cdn.pluto.gg/ump45.gma",
		versions = {
			"20200223_222",
			"20191116",
			"20191115",
		}
	},
	["2b"] = {
		remote = "https://cdn.pluto.gg/2b.gma",
		versions = {
			"20200223_222",
			"20191121",
		}
	},
	a2 = {
		remote = "https://cdn.pluto.gg/a2.gma",
		versions = {
			"20200223_222",
			"20191121",
		}
	},
	doom = {
		remote = "https://cdn.pluto.gg/doom.gma",
		versions = {
			"20200223_222",
			"20191121",
		}
	},
	wick = {
		remote = "https://cdn.pluto.gg/wick.gma",
		versions = {
			"20200223_222",
			"20191123_3",
			"20191123_2",
			"20191123",
			"20191122",
		}
	},
	lilith = {
		remote = "https://cdn.pluto.gg/lilith.gma",
		versions = {
			"20200223_222",
			"20191211",
			"20191122",
		}
	},
	odst = {
		remote = "https://cdn.pluto.gg/odst.gma",
		versions = {
			"20200223_222",
			"20191122",
		}
	},
	bigboss = {
		remote = "https://cdn.pluto.gg/bigboss.gma",
		versions = {
			"20200223_222",
			"20191122",
		}
	},
	hevsuit = {
		remote = "https://cdn.pluto.gg/hevsuit.gma",
		versions = {
			"20200223_222",
			"20191123",
			"20191122",
		}
	},
	jacket = {
		remote = "https://cdn.pluto.gg/jacket.gma",
		versions = {
			"20200223_222",
			"20191122",
		}
	},
	unique0 = {
		remote = "https://cdn.pluto.gg/unique0.gma",
		versions = {
			"20200329",
			"20200223_222",
			"20191123",
			"20191122",
		}
	},
	maya = {
		remote = "https://cdn.pluto.gg/maya.gma",
		versions = {
			"20200223_222",
			"20191122",
			"20191123",
		}
	},
	metro = {
		remote = "https://cdn.pluto.gg/metro.gma",
		versions = {
			"20200223_222",
			"20191225",
		}
	},
	tomb = {
		remote = "https://cdn.pluto.gg/tomb.gma",
		versions = {
			"20200223_222",
			"20191225",
		}
	},
	cayde6 = {
		remote = "https://cdn.pluto.gg/cayde6.gma",
		versions = {
			"20200223_222",
			"20191225",
		}
	},
	nigt = {
		remote = "https://cdn.pluto.gg/nigt.gma",
		versions = {
			"20200223_222",
			"20191225_1",
			"20191225",
		}
	},
	warmor = {
		remote = "https://cdn.pluto.gg/warmor.gma",
		versions = {
			"20200223_222",
			"20191225",
		}
	},
	osrsbob = {
		remote = "https://cdn.pluto.gg/osrsbob.gma",
		versions = {
			"20200223_222",
			"20191225",
		}
	},
	puggamaximus = {
		remote = "https://cdn.pluto.gg/puggamaximus.gma",
		versions = {
			"20200223_222",
			"20191225",
		}
	},
	santa = {
		remote = "https://cdn.pluto.gg/santa.gma",
		versions = {
			"20200223_222",
			"20191225",
		}
	},
	weebshit = {
		remote = "https://cdn.pluto.gg/weebshit.gma",
		versions = {
			"20200223_222",
			"20191225",
		}
	},
	lancer = {
		remote = "https://cdn.pluto.gg/lancer.gma",
		versions = {
			"20200223_222",
			"20191225",
		}
	},
	confetti = {
		remote = "https://cdn.pluto.gg/confetti.gma",
		versions = {
			"20200223_222",
			"20200215",
			"20200128_4",
		}
	},
	goldpan = {
		remote = "https://cdn.pluto.gg/goldpan.gma",
		versions = {
			"20200301_4",
			"20200301_3",
			"20200301_2",
			"20200301",
		}
	},
	cod4 = {
		remote = "https://cdn.pluto.gg/cod4.gma",
		versions = {
			"20200303"
		}
	},
	box2 = {
		remote = "https://cdn.pluto.gg/box2.gma",
		versions = {
			"20200323_2",
			"20200322",
		}
	},
	unique3 = {
		remote = "https://cdn.pluto.gg/unique3.gma",
		versions = {
			"20200323",
		}
	},
	spacesuit = {
		remote = "https://cdn.pluto.gg/spacesuit.gma",
		versions = {
			"20200326",
		}
	},
	tfa_cso2 = {
		remote = "https://cdn.pluto.gg/tfa_cso2.gma",
		versions = {
			"20200329",
			"20200328_5",
			"20200328_4",
			"20200328_3",
			"20200328_2",
			"20200328_1",
		}
	},--[[
	bo2 = {
		remote = "https://cdn.pluto.gg/bo2.gma",
		versions = {
			"20200323",
		}
	}]]
	tfa_cso_general = {
		remote = default "tfa_cso_general",
		versions = {
			"20200412_3",
			"20200412_2",
			"20200412",
			"20200411",
		}
	},
	starchaserar = {
		remote = default "starchaserar",
		versions = {
			"20200411",
		}
	},
	brick_piece_v2 = {
		remote = default "brick_piece_v2",
		versions = {
			"20200412",
		}
	},
	serpent_blade = {
		remote = default "serpent_blade",
		versions = {
			"20200412",
		}
	},
	tfa_mp7unicorn = {
		remote = default "tfa_mp7unicorn",
		versions = {
			"20200412",
		}
	},
	tfa_monkeywpset3 = {
		remote = default "tfa_monkeywpset3",
		versions = {
			"20200412",
		}
	},
	tfa_broad = {
		remote = default "broad",
		versions = {
			"20200412",
		}
	},
	tfa_laserfist = {
		remote = default "tfa_laserfist",
		versions = {
			"20200412",
		}
	},
	tfa_dreadnova = {
		remote = default "tfa_dreadnova",
		versions = {
			"20200412",
		}
	},
	p90lapin = {
		remote = default "p90lapin",
		versions = {
			"20200412",
		}
	},
	charger5 = {
		remote = default "charger5",
		versions = {
			"20200429",
		}
	},
	dark_knight_overlord = {
		remote = default "dark_knight_overlord",
		versions = {
			"20200429",
		}
	},
	darkknight_v8 = {
		remote = default "darkknight_v8",
		versions = {
			"20200430",
		}
	},
	ethereal = {
		remote = default "ethereal",
		versions = {
			"20200430",
		}
	},
	tfa_unknown = {
		remote = default "tfa_unknown",
		versions = {
			"20200412",
		}
	},
	posteaster = {
		remote = default "posteaster",
		versions = {
			"20200425_3",
			"20200425_2",
			"20200425",
			"20200424",
		}
	},
	m82_v6 = {
		remote = default "m82_v6",
		versions = {
			"20200501",
		}
	},
	m82_v8 = {
		remote = default "m82_v8",
		versions = {
			"20200501",
		}
	},
	m82 = {
		remote = default "m82",
		versions = {
			"20200501",
		}
	},
	m95 = {
		remote = default "m95",
		versions = {
			"20200501",
		}
	},
	m95_v6 = {
		remote = default "m95_v6",
		versions = {
			"20200501",
		}
	},
	m95_v8 = {
		remote = default "m95_v8",
		versions = {
			"20200501",
		}
	},
	sparklies = {
		remote = default "sparklies",
		versions = {
			"20200529_1",
			"20200529",
			"20200525_4",
			"20200525_3",
			"20200525_2",
			"20200525",
			"20200524_10",
			"20200524_9",
			"20200524_8",
			"20200524_7",
			"20200524_6",
			"20200524_5",
			"20200524_4",
			"20200524_3",
			"20200524_2",
			"20200524",
		}
	},
	thunderlord = {
		remote = default "thunderlord",
		versions = {
			"20200211"
		}
	},
	blink = {
		remote = default "blink",
		versions = {
			"20200211",
		}
	},
	destroyer = {
		remote = default "destroyer",
		versions = {
			"20200615",
		}
	},
	--[[bo2 = {
		remote = default "bo2",
		versions = {
			"20201006",
		}
	},]]
	tfa_xtracker = {
		remote = default "tfa_xtracker",
		versions = {
			"dev",
		}
	},
	pumpkin = {
		remote = default "pumpkin",
		versions = {
			"20201015"
		}
	},
	halloween2020 = {
		remote = default "halloween2020",
		versions = {
			"20201021_new2",
			"20201021_new",
			"20201021"
		}
	},
	tbarrel = {
		remote = default "tbarrel",
		versions = {
			"20201022",
		}
	},
	stinger = {
		remote = default "stinger",
		versions = {
			"20201022",
		}
	},
	qbarrel = {
		remote = default "qbarrel",
		versions = {
			"20201022",
		}
	},
}


local good_col = Color(0, 255, 0)
local error_col = Color(255, 0, 0)
local ok_col = Color(255, 255, 0)

local to_mount = {}
local status = {}
local font = "BudgetLabel"
local done = false
hook.Add("DrawOverlay", "pluto_workshop", function()
	if (done) then
		hook.Remove("DrawOverlay", "pluto_workshop")
		return
	end

	surface.SetFont "BudgetLabel"
	local _, h = surface.GetTextSize "A"
	h = h + 2
	surface.SetTextColor(255, 255, 255, 255)
	surface.SetTextPos(2, 3)
	surface.DrawText "Downloading textures!"

	local y = 3 + h
	for pack, status in SortedPairs(status) do
		surface.SetTextPos(2, y)
		y = y + h
		surface.SetTextColor(white_text)
		surface.DrawText(pack .. ": ")
		surface.SetTextColor(status[1])
		surface.DrawText(status[2])
	end
end)

local function check_mount()
	if (table.Count(to_mount) == table.Count(packs)) then
		local queue = {}
		for pack, fname in pairs(to_mount) do
			if (not fname) then
				continue
			end

			local succ, fs = game.MountGMA("data/" .. fname)

			if (not succ) then
				status[pack] = {error_col, "Couldn't mount"}
				return
			end

			for _, file in pairs(fs) do
				local match = file:match "materials/(.+)%.vtf"
				if (match) then
					queue[#queue + 1] = match
				end
			end

			status[pack] = {good_col, "Mounted."}
			to_mount[pack] = nil
		end
		RunConsoleCommand "snd_restart"
		done = true
		timer.Create("pluto_workshop", 1, 0, function()
			if (not IsValid(LocalPlayer())) then
				pwarnf("no localplayer yet")
				return
			end

			for _, match in pairs(queue) do
				LocalPlayer():ConCommand("mat_reloadtexture \"" .. match .. "\"")
			end

			timer.Remove "pluto_workshop"
			hook.Run "PlutoWorkshopFinish"
		end)
	end
end

for pack, data in SortedPairs(packs) do
	local fname = pack .. "_" .. data.versions[1] .. ".dat"

	for i = 2, #data.versions do
		file.Delete(pack .. "_" .. data.versions[i] .. ".dat")
	end

	local function fail(err)
		status[pack] = {error_col, "ERROR: " .. err}
		to_mount[pack] = false
		file.Delete("data/" .. fname)
	end

	local function update(msg)
		status[pack] = {ok_col, msg}
	end

	local function mount()
		to_mount[pack] = fname
		status[pack] = {good_col, "Ready to mount."}
		check_mount()
	end

	if (not file.Exists(fname, "DATA")) then
		update "Downloading..."
		http.Fetch(data.remote, function(b, size, headers, code)
			if (code == 200) then
				file.Write(fname, b)
				mount()
			else
				fail("HTTP CODE " .. code)
			end
		end)
	else
		mount()
	end
end

check_mount()