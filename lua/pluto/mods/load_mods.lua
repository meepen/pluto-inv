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
	"accuracy",
	"arcane",
	"bleeding",
	"coined",
	"damage",
	"diced",
	"dropletted",
	"eagle",
	"fire",
	"firerate",
	"greed",
	"handed",
	"hearted",
	"leech",
	"limp",
	"mag",
	"max_range",
	"min_range",
	"mirror",
	"poison",
	"postheal",
	"protec",
	"recoil",
	"reload",
	"recycle",
	"shock",
	-- "snipexp",
	"starseeker",
	"tomed",
	"unchanging",
	"zoomies",

	"new_coined",

	"grenades/grendelay",
	"grenades/elasticity",
	"grenades/smokeclr",
	"grenades/throwspeed",
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