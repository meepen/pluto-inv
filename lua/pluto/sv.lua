pluto.files.load {
	Server = {
		"sv/config.lua",
		"weapons/weapons.lua",
		"weapons/random_spawns.lua",
		"mods.lua",
		"sv/hacks.lua",
		"db/init.lua",
		"inv/init.lua",
		"inv/sv_manager.lua",
		"inv/ttt.lua",
		"trades/sv.lua",
		"mapvote/mapvote.lua",
		"models/sv_models.lua",
	},
	Client = {}, -- keep empty
	Shared = {}, -- keep empty
	Resources = {
		"materials/pluto/item_bg_real.png",
		"materials/pluto/trashcan_128.png",
	},
	Workshop = {
		"1896665699",
	},
}

concommand.Add("pluto_reload", function(ply)
	if (IsValid(ply)) then
		return
	end

	include "autorun/pluto.lua"
	BroadcastLua [[include "autorun/pluto.lua"]]
end)