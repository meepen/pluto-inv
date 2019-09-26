pluto = pluto or {}

include "pluto/files.lua"
AddCSLuaFile "pluto/files.lua"

pluto.files.load {
	Client = {
		"cl/hacks.lua",
	},
	Shared = {
		"init.lua",
		"weapons/override.lua",
		"entities.lua",
	},
	Server = {
		"sv.lua",
	},
	Resources = {}, -- keep blank
}