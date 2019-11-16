local function starttime()
	return tostring(math.ceil((system.SteamTime() - system.AppTime()) / 4) * 4)
end

local packs =  {
	pluto = {
		remote = "https://pluto.gg/datastore/server/content.gma",
		versions = {
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
			"20191115",
		}
	},
}

for pack, data in pairs(packs) do
	data.cv = CreateConVar("pluto_pack_2" .. pack, 0, {FCVAR_ARCHIVE})
end

local function run()
	for pack, data in pairs(packs) do
		local cv = data.cv

		if (cv:GetString() == starttime()) then
			print("Already mounted: " .. pack)
			continue
		end

		local function success()
			print(pack .. " mounted")
			RunConsoleCommand "snd_restart"
			cv:SetString(starttime())
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
			local succ, fs = game.MountGMA("data/" .. fname)

			if (not succ) then
				fail "couldn't mount"
			else
				success()
			end
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