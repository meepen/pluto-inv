pluto = pluto or {}

include "pluto/files.lua"
AddCSLuaFile "pluto/files.lua"

pluto.files.load {
	Client = {
		"cl/hacks.lua",
		"inv/ui.lua",
	},
	Shared = {
		"init.lua",
		"weapons/override.lua",
	},
	Server = {
		"sv.lua",
	},
	Resources = {}, -- keep blank
}