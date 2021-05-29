function pluto.isdevserver()
	return GetHostName():find "[DEV]" and true or false
end

pluto.files.load {
	Server = {
		"sv/config.lua",
		"sv/crash.lua",
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
		"mapvote/mapvote.lua",
		"models/sv_models.lua",
		"craft/sv.lua",


		"inv/exp/sv_exp_provider.lua",
		"inv/exp/sv_model_exp.lua",
		"inv/exp/sv_player_exp.lua",

		"discord/discord.lua",
		"nitro/sv_nitro.lua",

		"quests/_init.lua",
		"quests/sv_quest_commands.lua",
		"quests/sv_quest_object.lua",
		"quests/sv_quest_networking.lua",
		"quests/sv_quests.lua",
		"quests/sv_quest_rewards.lua",

		"inv/currency/sv_currency.lua",
		"inv/currency/sv_crossmap.lua",

		"inv/sv_emojis.lua",

		"inv/currency/object/sv_object.lua",

		"playercards/sv_cards.lua",

		"chat/sv_chat.lua",

		"cheaters/sv_nocheats.lua",

		"hitreg/sv_hitreg.lua",

		"sv/ammospawn.lua",

		"minigame/sv_snake.lua",

		"inv/nodes/sv_nodes.lua",
		"divine/sv_currency_exchange.lua",
		"divine/sv_stardust_shop.lua",
		"divine/sv_auction_house.lua",
		"divine/sv_blackmarket.lua",

		"trades/sv_trade_state.lua",
		"trades/sv_trade_networking.lua",

		"websocket/sv_websocket.lua",

		"donate/sv_donate.lua",
	},
	Client = {}, -- keep empty
	Shared = {}, -- keep empty
	Resources = {
		"resource/fonts/Niconne-Regular.ttf",
		"resource/fonts/Lateef-Regular.ttf",
		"resource/fonts/Aladin-Regular.ttf",
		"resource/fonts/PermanentMarker-Regular.ttf",

		"materials/pluto/seamless/galaxy.png",
		"materials/pluto/seamless/bullets.png",
		"materials/pluto/seamless/blackhole.png",

		"materials/pluto/currencies/plutonicvial.png",
	},
	Workshop = {
		"2275087857",
		"2277399930",
		"2277451436",

		"1516699044", -- slvbase 2
		"1516711672", -- skyrim snpcs

		-- TODO(meep): remove later
		"122274673", -- nes zapper
		"329057380", -- raygun
		"923947785", -- raygun 2
		"317267606", -- stealth box
	},
}

concommand.Add("pluto_reload", function(ply)
	if (IsValid(ply)) then
		return
	end

	include "autorun/pluto.lua"
	BroadcastLua [[include "autorun/pluto.lua"]]
end)