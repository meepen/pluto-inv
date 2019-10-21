pluto = pluto or {}

include "pluto/files.lua"
AddCSLuaFile "pluto/files.lua"

pluto.files.load {
	Client = {
		"cl/hacks.lua",
		"inv/ui.lua",
		"inv/cl_manager.lua",
		"trades/cl.lua",
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