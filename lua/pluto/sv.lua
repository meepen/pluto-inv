include "files.lua" {
	Server = {
		"sv/config.lua",
		"weapons/weapons.lua",
		"weapons/random_spawns.lua",
		"mods.lua",
	},
	Client = {}, -- keep empty
	Shared = {}, -- keep empty
	Resources = {
	}
}

concommand.Add("pluto_reload", function(ply)
	if (IsValid(ply)) then
		return
	end

	include "autorun/pluto.lua"
	BroadcastLua [[include "autorun/pluto.lua"]]
end)