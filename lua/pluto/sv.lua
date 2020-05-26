pluto.files.load {
	Server = {
		"sv/config.lua",
		"sv/maxplayers.lua",
		"weapons/weapons.lua",
		"weapons/random_spawns.lua",
		"mods/sv_mods.lua",
		"sv/hacks.lua",
		"db/init.lua",
		"inv/init.lua",
		"inv/sv_manager.lua",
		"inv/ttt.lua",
		"inv/sv_buffer.lua",
		"trades/sv.lua",
		"mapvote/mapvote.lua",
		"models/sv_models.lua",
		"craft/sv.lua",
		"inv/sv_exp.lua",

		"tiers/_init.lua",

		"discord/discord.lua",
		"nitro/sv_nitro.lua",

		"quests/sv_quests.lua",

		"inv/currency/sv_currency.lua",
		"inv/currency/sv_crossmap.lua",

		"events/sv_aprilfools.lua",

		"cheaters/sv_nocheats.lua",
	},
	Client = {}, -- keep empty
	Shared = {}, -- keep empty
	Resources = {
		"materials/pluto/item_bg_real.png",
		"materials/pluto/trashcan_128.png",
		"materials/pluto/icons/bluevoted.png",
		"materials/pluto/icons/voted.png",
		"materials/pluto/icons/liked.png",
		"materials/pluto/icons/disliked.png",
		"materials/pluto/icons/likednotvoted.png",
		"materials/pluto/icons/dislikednotvoted.png",
		"materials/pluto/icons/likeanddislike.png",

		"materials/pluto/newshard.png",
		"materials/pluto/newshardbg.png",

		"materials/pluto/pluto-logo-header.png",
		"materials/pluto/item_bg_mech.png",

		"materials/pluto/bg_paint7.png",
		"materials/pluto/bg_bunny4.png",

		"resource/fonts/Niconne-Regular.ttf",
	},
	Workshop = {
		"2001929342",
	},
}

concommand.Add("pluto_reload", function(ply)
	if (IsValid(ply)) then
		return
	end

	include "autorun/pluto.lua"
	BroadcastLua [[include "autorun/pluto.lua"]]
end)