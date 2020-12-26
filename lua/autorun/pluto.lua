pluto = pluto or {}

include "pluto/files.lua"
AddCSLuaFile "pluto/files.lua"

pluto.files.load {
	Client = {
		--"cl/richtextformat.lua",
		"cl/hacks.lua",
		"cl/settings.lua",
		"inv/ui.lua",
		"inv/cl_manager.lua",
		"inv/currency/object/cl_object.lua",
		"trades/cl.lua",
		"models/cl_models.lua",
		"mapvote/cl_mapvote.lua",
		"cl/workshop.lua",
		"tools/cl_tools.lua",
		"craft/cl.lua",
		"nitro/cl_nitro.lua",
		"quests/cl_quests.lua",
		"models/cl_showhitgroups.lua",

		"divine/cl.lua",
		"divine/cl_stardust_shop.lua",
		"divine/cl_currency_exchange.lua",
		"divine/cl_crafting_bench.lua",
		"divine/cl_auction_house.lua",

		"chat/cl_chat.lua",
		"chat/cl_settings.lua",
		"chat/cl_filter.lua",

		"cosmetics/cl_test.lua",
		"cosmetics/cl_sparkle.lua",

		"events/pass/cl_passevent.lua",

		"inv/exp/cl_exp_scoreboard.lua",
		
		"hitreg/cl_hitreg.lua",

		"weapons/cl_hover.lua",

		"minigame/cl.lua",

		"inv/nodes/cl_nodes.lua",

		"treelib/cl.lua",

		"cl/fontstuff.lua",

		"cl/vgui/plutotext.lua",
		"cl/vgui/plutolabel.lua",
		"cl/vgui/plutoimage.lua",
	},
	Shared = {
		"co_net.lua",
		"init.lua",
		"weapons/override.lua",

		"inv/sh_manager.lua",
		"inv/sh_tabs.lua",
		"inv/currency/sh_currency.lua",
		"inv/currency/object/sh_object.lua",

		"quests/sh_quests.lua",
	
		"mods/sh_mods.lua",

		"craft/sh.lua",

		"roles/ttc.lua",
		"roles/pluto.lua",

		"util.lua",

		"chat/sh_chat.lua",

		"mods/shared/limp.lua",

		"tfa/tfa_compat.lua",
		"tfa/external/tfa_cso2_snd_heavy.lua",

		"tfa/external/weaponsoundguarantee_part1.lua",
		"tfa/external/weaponsoundguarantee_part2.lua",
		"tfa/external/tfa_cso_part2_sounds_pt1.lua",
		"tfa/external/tfa_cso_new_guns_sound_pack3.lua",
		"tfa/external/tfa_cso_new_guns_sound_pack4.lua",
		"tfa/external/tfa_cso_part1_sounds_pt1.lua",

		"events/sh_init.lua",

		"thirdparty/sh_animations_api.lua",
		"thirdparty/circles.lua",

		"imgur/sh_imgur.lua",

		"sv/promise.lua",

		"treelib/sh.lua",

		"inv/nodes/sh_nodes.lua",

		-- "unicode/init.lua",
		-- "unicode/casefolding.lua",
		-- -- "unicode/unicodedata.lua",
		-- "unicode/confusables.lua",
		-- "unicode/unicodedata_json.lua"
	},
	Server = {
		"sv.lua",
	},
	Resources = {}, -- keep blank
}