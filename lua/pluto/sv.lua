function pluto.isdevserver()
	return GetHostName():find "[DEV]" and true or false
end

pluto.files.load {
	Server = {
		"sv/config.lua",
		"sv/maxplayers.lua",

		"weapons/weapons.lua",
		"weapons/random_spawns.lua",
		"weapons/tracker/sv_tracker.lua",

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

		"inv/exp/sv_exp_provider.lua",
		"inv/exp/sv_model_exp.lua",
		"inv/exp/sv_player_exp.lua",

		"tiers/_init.lua",

		"discord/discord.lua",
		"nitro/sv_nitro.lua",

		"quests/sv_quests.lua",

		"inv/currency/sv_currency.lua",
		"inv/currency/sv_crossmap.lua",

		"inv/currency/object/sv_object.lua",
	
		"events/minis/sv_raining.lua",
		"events/minis/sv_dice.lua",
		"events/minis/sv_stars.lua",
		"events/sv_aprilfools.lua",

		"chat/sv_chat.lua",

		"cheaters/sv_nocheats.lua",

		"hitreg/sv_hitreg.lua",

		"sv/ammospawn.lua",

		"minigame/sv.lua",

		"divine/sv_currency_exchange.lua",
		"divine/sv_stardust_shop.lua",
		"divine/sv_auction_house.lua",
	},
	Client = {}, -- keep empty
	Shared = {}, -- keep empty
	Resources = {
		"resource/fonts/Niconne-Regular.ttf",
		"resource/fonts/Lateef-Regular.ttf",
		"resource/fonts/Aladin-Regular.ttf",
		"resource/fonts/PermanentMarker-Regular.ttf",
	},
	Workshop = {
		"2275087857",
		"2277399930",
		"2277451436",

		"1516699044", -- slvbase 2
		"1516711672", -- skyrim snpcs
	},
}

concommand.Add("pluto_reload", function(ply)
	if (IsValid(ply)) then
		return
	end

	include "autorun/pluto.lua"
	BroadcastLua [[include "autorun/pluto.lua"]]
end)