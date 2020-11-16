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
		"trades/cl.lua",
		"models/cl_models.lua",
		"mapvote/cl_mapvote.lua",
		"cl/workshop.lua",
		"tools/cl_tools.lua",
		"craft/cl.lua",
		"nitro/cl_nitro.lua",
		"quests/cl_quests.lua",
		"models/cl_showhitgroups.lua",

		"chat/cl_chat.lua",
		"chat/cl_filter.lua",

		"cosmetics/cl_test.lua",
		"cosmetics/cl_sparkle.lua",

		"events/pass/cl_passevent.lua",

		"inv/exp/cl_exp_scoreboard.lua",
		
		"hitreg/cl_hitreg.lua",

		"weapons/cl_hover.lua",
	},
	Shared = {
		"co_net.lua",
		"init.lua",
		"weapons/override.lua",

		"inv/sh_manager.lua",
		"inv/sh_tabs.lua",
		"inv/currency/sh_currency.lua",

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