pluto = pluto or {}

include "pluto/files.lua"
AddCSLuaFile "pluto/files.lua"

pluto.files.load {
	Client = {
		"cl/richtextformat.lua",
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
		"tfa/external/tfa_cso2_snd_heavy.lua",
	},
	Shared = {
		"co_net.lua",
		"init.lua",
		"weapons/override.lua",

		"inv/sh_manager.lua",
		"inv/sh_tabs.lua",
		"inv/currency/sh_currency.lua",
	
		"mods/sh_mods.lua",

		"craft/sh.lua",

		"roles/ttc.lua",

		"util.lua",

		"mods/shared/limp.lua",
	},
	Server = {
		"sv.lua",
	},
	Resources = {}, -- keep blank
}