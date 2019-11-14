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
	},
	Shared = {
		"init.lua",
		"weapons/override.lua",
		"inv/sh_manager.lua",
		"inv/sh_tabs.lua",
		"inv/sh_currency.lua",
	},
	Server = {
		"sv.lua",
	},
	Resources = {}, -- keep blank
}