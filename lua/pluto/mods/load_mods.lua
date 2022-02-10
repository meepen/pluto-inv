--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
pluto.mods = pluto.mods or {}

pluto.mods.byname = pluto.mods.byname or {}
pluto.mods.byitem = pluto.mods.byitem or {
	--[[
	[type] = {
		suffix = {},
		prefix = {},
		implcit = {}
	}
	]]
}

for _, filename in pairs {
	"prefix/accuracy",
	"prefix/damage",
	"prefix/firerate",
	"prefix/mag",
	"prefix/max_range",
	"prefix/min_range",
	"prefix/recoil",
	"prefix/reload",
	
	"suffix/bleeding",
	"suffix/eagle",
	"suffix/fire",
	"suffix/greed",
	"suffix/leech",
	"suffix/limp",
	"suffix/poison",
	"suffix/postheal",
	"suffix/protec",
	"suffix/recycle",
	"suffix/shock",
	"suffix/snipexp",
	"suffix/zoomies",

	"implicit/arcane",
	"implicit/coined",
	"implicit/diced",
	"implicit/dropletted",
	"implicit/handed",
	"implicit/hearted",
	"implicit/mirror",
	"implicit/new_coined",
	"implicit/starseeker",
	"implicit/tomed",
	"implicit/unchanging",

	"grenades/grendelay",
	"grenades/elasticity",
	"grenades/smokeclr",
	"grenades/throwspeed",
	"grenades/thunderous",
	"grenades/denseexplosives",
	"grenades/wideexplosives",
} do
	local modname = filename:match "[_%w]+$"
	MOD = pluto.mods.byname[modname] or {}
	setmetatable(MOD, pluto.mods.mt)
	AddCSLuaFile("modifiers/" .. filename .. ".lua")
	include("modifiers/" .. filename .. ".lua")
	local mod = MOD
	MOD = nil

	if (not mod) then
		pwarnf("Modifier %s didn't return value.", modname)
		continue
	end

	mod.Name = mod.Name or modname
	mod.InternalName = modname

	-- faster indexing in rolls
	if (mod.Tags) then
		for k, v in pairs(mod.Tags) do
			mod.Tags[v] = k
		end
	end

	local itemtype = mod.ItemType or "Weapon"

	if (not pluto.mods.byitem[itemtype]) then
		pluto.mods.byitem[itemtype] = {
			byname = {},
			suffix = {},
			prefix = {},
		}
	end

	local typeinfo = pluto.mods.byitem[itemtype]

	if (not typeinfo[mod.Type]) then
		typeinfo[mod.Type] = {}
	end

	typeinfo[mod.Type][modname] = mod

	pluto.mods.byname[modname] = mod
	pluto.mods.byitem[itemtype].byname[modname] = mod
end