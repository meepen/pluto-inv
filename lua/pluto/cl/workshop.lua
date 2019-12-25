local packs =  {
	pluto = {
		remote = "https://pluto.gg/datastore/server/content.gma",
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
		remote = "https://pluto.gg/datastore/server/shotguns.gma",
		versions = {
			"20191115",
		}
	},
	m21 = {
		remote = "https://pluto.gg/datastore/server/m21.gma",
		versions = {
			"20191205",
		}
	},
	mp7 = {
		remote = "https://pluto.gg/datastore/server/mp7.gma",
		versions = {
			"20191117",
			"20191115",
		}
	},
	tec9 = {
		remote = "https://pluto.gg/datastore/server/tec9.gma",
		versions = {
			"20191116",
			"20191115",
		}
	},
	ump45 = {
		remote = "https://pluto.gg/datastore/server/ump45.gma",
		versions = {
			"20191116",
			"20191115",
		}
	},
	["2b"] = {
		remote = "https://pluto.gg/datastore/server/2b.gma",
		versions = {
			"20191121",
		}
	},
	a2 = {
		remote = "https://pluto.gg/datastore/server/a2.gma",
		versions = {
			"20191121",
		}
	},
	doom = {
		remote = "https://pluto.gg/datastore/server/doom.gma",
		versions = {
			"20191121",
		}
	},
	wick = {
		remote = "https://pluto.gg/datastore/server/wick.gma",
		versions = {
			"20191123_3",
			"20191123_2",
			"20191123",
			"20191122",
		}
	},
	lilith = {
		remote = "https://pluto.gg/datastore/server/lilith.gma",
		versions = {
			"20191211",
			"20191122",
		}
	},
	odst = {
		remote = "https://pluto.gg/datastore/server/odst.gma",
		versions = {
			"20191122",
		}
	},
	bigboss = {
		remote = "https://pluto.gg/datastore/server/bigboss.gma",
		versions = {
			"20191122",
		}
	},
	hevsuit = {
		remote = "https://pluto.gg/datastore/server/hevsuit.gma",
		versions = {
			"20191123",
			"20191122",
		}
	},
	jacket = {
		remote = "https://pluto.gg/datastore/server/jacket.gma",
		versions = {
			"20191122",
		}
	},
	unique0 = {
		remote = "https://pluto.gg/datastore/server/unique0.gma",
		versions = {
			"20191123",
			"20191122",
		}
	},
	maya = {
		remote = "https://pluto.gg/datastore/server/maya.gma",
		versions = {
			"20191122",
			"20191123",
		}
	},
	metro = {
		remote = "https://pluto.gg/datastore/server/metro.gma",
		versions = {
			"20191225",
		}
	},
	tomb = {
		remote = "https://pluto.gg/datastore/server/tomb.gma",
		versions = {
			"20191225",
		}
	},
	cayde6 = {
		remote = "https://pluto.gg/datastore/server/cayde6.gma",
		versions = {
			"20191225",
		}
	},
	nigt = {
		remote = "https://pluto.gg/datastore/server/nigt.gma",
		versions = {
			"20191225_1",
			"20191225",
		}
	},
	warmor = {
		remote = "https://pluto.gg/datastore/server/warmor.gma",
		versions = {
			"20191225",
		}
	},
	osrsbob = {
		remote = "https://pluto.gg/datastore/server/osrsbob.gma",
		versions = {
			"20191225",
		}
	},
	puggamaximus = {
		remote = "https://pluto.gg/datastore/server/puggamaximus.gma",
		versions = {
			"20191225",
		}
	},
	santa = {
		remote = "https://pluto.gg/datastore/server/santa.gma",
		versions = {
			"20191225",
		}
	},
	weebshit = {
		remote = "https://pluto.gg/datastore/server/weebshit.gma",
		versions = {
			"20191225",
		}
	},
	--[[
	moxxi = {
		remote = "https://pluto.gg/datastore/server/moxxi.gma",
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