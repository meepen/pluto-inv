include "files.lua" {
	Server = {
		"sv/config.lua",
		"weapons/random_spawns.lua",
	},
	Client = {}, -- keep empty
	Shared = {}, -- keep empty
	Resources = {
	}
}

concommand.Add("pluto_reload", function()
	include "autorun/pluto.lua"
	BroadcastLua [[include "autorun/pluto.lua"]]
end)