local packs =  {
	pluto = {
		remote = "https://cdn.pluto.gg/content.gma",
		versions = {
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
			"20191115",
		}
	},
	m21 = {
		remote = "https://cdn.pluto.gg/m21.gma",
		versions = {
			"20191205",
		}
	},
	mp7 = {
		remote = "https://cdn.pluto.gg/mp7.gma",
		versions = {
			"20191117",
			"20191115",
		}
	},
	tec9 = {
		remote = "https://cdn.pluto.gg/tec9.gma",
		versions = {
			"20191116",
			"20191115",
		}
	},
	ump45 = {
		remote = "https://cdn.pluto.gg/ump45.gma",
		versions = {
			"20191116",
			"20191115",
		}
	},
	["2b"] = {
		remote = "https://cdn.pluto.gg/2b.gma",
		versions = {
			"20191121",
		}
	},
	a2 = {
		remote = "https://cdn.pluto.gg/a2.gma",
		versions = {
			"20191121",
		}
	},
	doom = {
		remote = "https://cdn.pluto.gg/doom.gma",
		versions = {
			"20191121",
		}
	},
	wick = {
		remote = "https://cdn.pluto.gg/wick.gma",
		versions = {
			"20191123_3",
			"20191123_2",
			"20191123",
			"20191122",
		}
	},
	lilith = {
		remote = "https://cdn.pluto.gg/lilith.gma",
		versions = {
			"20191211",
			"20191122",
		}
	},
	odst = {
		remote = "https://cdn.pluto.gg/odst.gma",
		versions = {
			"20191122",
		}
	},
	bigboss = {
		remote = "https://cdn.pluto.gg/bigboss.gma",
		versions = {
			"20191122",
		}
	},
	hevsuit = {
		remote = "https://cdn.pluto.gg/hevsuit.gma",
		versions = {
			"20191123",
			"20191122",
		}
	},
	jacket = {
		remote = "https://cdn.pluto.gg/jacket.gma",
		versions = {
			"20191122",
		}
	},
	unique0 = {
		remote = "https://cdn.pluto.gg/unique0.gma",
		versions = {
			"20191123",
			"20191122",
		}
	},
	maya = {
		remote = "https://cdn.pluto.gg/maya.gma",
		versions = {
			"20191122",
			"20191123",
		}
	},
	metro = {
		remote = "https://cdn.pluto.gg/metro.gma",
		versions = {
			"20191225",
		}
	},
	tomb = {
		remote = "https://cdn.pluto.gg/tomb.gma",
		versions = {
			"20191225",
		}
	},
	cayde6 = {
		remote = "https://cdn.pluto.gg/cayde6.gma",
		versions = {
			"20191225",
		}
	},
	nigt = {
		remote = "https://cdn.pluto.gg/nigt.gma",
		versions = {
			"20191225_1",
			"20191225",
		}
	},
	warmor = {
		remote = "https://cdn.pluto.gg/warmor.gma",
		versions = {
			"20191225",
		}
	},
	osrsbob = {
		remote = "https://cdn.pluto.gg/osrsbob.gma",
		versions = {
			"20191225",
		}
	},
	puggamaximus = {
		remote = "https://cdn.pluto.gg/puggamaximus.gma",
		versions = {
			"20191225",
		}
	},
	santa = {
		remote = "https://cdn.pluto.gg/santa.gma",
		versions = {
			"20191225",
		}
	},
	weebshit = {
		remote = "https://cdn.pluto.gg/weebshit.gma",
		versions = {
			"20191225",
		}
	},
	lancer = {
		remote = "https://cdn.pluto.gg/lancer.gma",
		versions = {
			"20191225",
		}
	},
	--[[
	moxxi = {
		remote = "https://cdn.pluto.gg/moxxi.gma",
		versions = {
			"20191121",
		}
	},]]
}

pluto.mount_cache = pluto.mount_cache or {
	vmt = {},
	vtf = {},
}

function pluto.cache_mat(name)
	local tmp = pluto.mount_cache.vmt[name]

	if (not tmp) then
		tmp = {}
		pluto.mount_cache.vmt[name] = tmp
	end

	table.insert(tmp, (Material(name)))
end

function pluto.cache_tex(name)
	table.insert(pluto.mount_cache.vtf, name)
end

pluto.cache_mat "models/weapons/v_models/hands/v_hands"

local function run()
	for pack, data in pairs(packs) do

		local function success()
			print(pack .. " mounted")
			RunConsoleCommand "snd_restart"
		end

		local fname = pack .. "_" .. data.versions[1] .. ".dat"

		for i = 2, #data.versions do
			file.Delete(pack .. "_" .. data.versions[i] .. ".dat")
		end

		local function fail(err)
			print(pack .. " failed: " .. err)
			file.Delete("data/" .. fname)
		end

		local function update(msg)
			print(pack .. " update: " .. msg)
		end

		local function mount()
			local to_fix = {
				vtf = {}
			}

			local succ, fs = game.MountGMA("data/" .. fname)

			if (not succ) then
				fail "couldn't mount"
				return
			end

			for _, item in pairs(fs) do
				local match = item:match "materials/(.+)%.vmt"
				if (match) then
					pluto.cache_mat(match)
				end

				match = item:match "materials/(.+)%.vtf"
				if (match) then
					pluto.cache_tex(match)
					table.insert(to_fix.vtf, match)
				end
			end

			hook.Add("Think", "pluto_" .. pack, function()
				if (not IsValid(LocalPlayer())) then
					return
				end

				for _, item in pairs(to_fix.vtf) do
					LocalPlayer():ConCommand("mat_reloadtexture \"" .. item .. "\"")
				end

				hook.Remove("Think", "pluto_" .. pack)
			end)

			success()
		end

		if (not file.Exists(fname, "DATA")) then
			http.Fetch(data.remote, function(b, size, headers, code)
				if (code == 200) then
					file.Write(fname, b)
					mount()
				else
					fail(code)
				end
			end)
		else
			mount()
		end
	end
end

run()