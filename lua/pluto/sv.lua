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
		"inv/sv_buffer.lua",
		"trades/sv.lua",
		"mapvote/mapvote.lua",
		"models/sv_models.lua",
		"inv/sv_craft.lua",
	},
	Client = {}, -- keep empty
	Shared = {}, -- keep empty
	Resources = {
		"materials/pluto/item_bg_real.png",
		"materials/pluto/trashcan_128.png",
		"materials/pluto/shard128.png",
		"materials/pluto/shard128add.png",
	},
	Workshop = {},
}

concommand.Add("pluto_reload", function(ply)
	if (IsValid(ply)) then
		return
	end

	include "autorun/pluto.lua"
	BroadcastLua [[include "autorun/pluto.lua"]]
end)