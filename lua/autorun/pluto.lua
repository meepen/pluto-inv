pluto = pluto or {}

include "pluto/files.lua"
AddCSLuaFile "pluto/files.lua"

pluto.files.load {
	Client = {
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
	},
	Shared = {
		"co_net.lua",
		"init.lua",
		"weapons/override.lua",
		"inv/sh_manager.lua",
		"inv/sh_tabs.lua",
		"inv/sh_currency.lua",

		"roles/ttc.lua",
	},
	Server = {
		"sv.lua",
	},
	Resources = {}, -- keep blank
}