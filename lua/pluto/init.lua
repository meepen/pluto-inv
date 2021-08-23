--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
pluto = pluto or {}
pluto.modules = pluto.modules or {}
reset_color = reset_color or {}

local good_color = Color(0,255,0)
local bad_color = Color(255,0,0)

-- TODO(meep): deprecate
function pprintf(...)
	MsgC(good_color, string.format(...))

	MsgN ""
end
function pwarnf(...)
	MsgC(bad_color, string.format(...))
	MsgN""
end



local allowed = {
	["76561198050165746"] = true, -- Meepen
	["76561198055769267"] = true, -- Jared
	["76561198083846494"] = true, -- KAT
	["76561198188070674"] = true, -- CROSSMAN
	["76561198110055555"] = true, -- add___123
}

function HexColor(h)
	if (h[1] == "#") then
		h = h:sub(2)
	end

	local a, r, g, b = 255

	if (h:len() <= 4) then
		h = h:gsub(".", "%1%1")
	end

	local col = {}

	
	for num in h:gmatch "(..)" do
		col[#col + 1] = tonumber(num, 16)
	end

	return Color(unpack(col))
end

function pluto.cancheat(ply)
	return IsValid(ply) and allowed[ply:SteamID64()]
end

local PLAYER = FindMetaTable "Player"

pluto.experience = pluto.experience or {}

function PLAYER:SetPlutoExperience(exp)
	pluto.experience[self:SteamID64()] = exp
end

function PLAYER:GetPlutoExperience()
	return pluto.experience[self:SteamID64()] or 0
end

local base = 15
local linear = 22
local expo = 0.2

local function level_to_exp(lvl)
	lvl = lvl - 1
	return (base + linear * lvl + expo * lvl ^ 2) * 125
end

local function exp_to_level(exp)
	local exp = (exp or 0) / 125 + 1
	return (-linear + math.sqrt(linear ^ 2 - 4 * expo * (base - exp))) / (2 * expo) + 1
end

local function HSLToColor(h, s, l)
	local c = (1 - math.abs(2 * l - 1)) * s
	local hp = h / 60.0
	local x = c * (1 - math.abs((hp % 2) - 1))
	local rgb1;
	if (h ~= h) then
		rgb1 = {[0] = 0, 0, 0}
	elseif (hp <= 1) then
		rgb1 = {[0] = c, x, 0}
	elseif (hp <= 2) then
		rgb1 = {[0] = x, c, 0}
	elseif (hp <= 3) then
		rgb1 = {[0] = 0, c, x}
	elseif (hp <= 4) then
		rgb1 = {[0] = 0, x, c}
	elseif (hp <= 5) then
		rgb1 = {[0] = x, 0, c}
	elseif (hp <= 6) then
		rgb1 = {[0] = c, 0, x}
	end
	local m = l - c * 0.5;
	return Color(
		math.Round(255 * (rgb1[0] + m)),
		math.Round(255 * (rgb1[1] + m)),
		math.Round(255 * (rgb1[2] + m))
	)
end

local colors = {
	{
		Level = 100,
		Color = function()
			local rand = math.random()
			return function()
				return HSLToColor((((CurTime() % 5 / 5) + rand) % 1) * 360, 0.8, 0.3)
			end
		end,
	},
	{
		Level = 90,
		Color = HSLToColor(293, 0.8, 0.3),
	},
	{
		Level = 80,
		Color = HSLToColor(263, 0.8, 0.3),
	},
	{
		Level = 70,
		Color = HSLToColor(223, 0.8, 0.3),
	},
	{
		Level = 69,
		Color = HSLToColor(333, 0.8, 0.3),
	},
	{
		Level = 60,
		Color = HSLToColor(193, 0.8, 0.3),
	},
	{
		Level = 50,
		Color = HSLToColor(173, 0.8, 0.3),
	},
	{
		Level = 40,
		Color = HSLToColor(143, 0.8, 0.3),
	},
	{
		Level = 30,
		Color = HSLToColor(93, 0.8, 0.3),
	},
	{
		Level = 20,
		Color = HSLToColor(73, 0.8, 0.3),
	},
	{
		Level = 10,
		Color = HSLToColor(53, 0.8, 0.3),
	},
	{
		Level = 0,
		Color = HSLToColor(33, 0.8, 0.3),
	},
}

local cl_force = {
	["76561198050165746"] = {
		Level = 69,
		Color = 2000
	},
	["76561198083846494"] = {
		Level = 69,
		Color = 2000
	},
	["76561198055769267"] = {
		Level = 1337,
	}
}

function PLAYER:GetPlutoLevelColor()
	local level = self:GetPlutoLevel()
	if (CLIENT) then
		local force = cl_force[self:SteamID64()]
		if (force and force.Color) then
			if (isnumber(force.Color)) then
				level = force.Color
			elseif (isfunction(force.Color)) then
				return force.Color()
			else
				return force.Color
			end
		end
	end

	for _, cinfo in ipairs(colors) do
		if (cinfo.Level <= level) then
			local col = cinfo.Color
			if (isfunction(col)) then
				return col()
			else
				return col
			end
		end
	end
end

function PLAYER:GetPlutoLevel()
	if (CLIENT) then
		local force = cl_force[self:SteamID64()]
		if (force and force.Level) then
			return force.Level
		end
	end

	return math.floor(exp_to_level(self:GetPlutoExperience()))
end

function PLAYER:GetExperienceToNextLevel()
	local cur_level = self:GetPlutoLevel()
	return level_to_exp(cur_level + 1) - self:GetPlutoExperience()
end


-- pluto.message("STATUS", "error: ", col, "im ", reset_color, "gay")

function pluto.addmodule(what, color)
	pluto.modules[what] = color
end
pluto.addmodule("BASE", Color(233, 39, 80))


-- can return multiple values, with colors
local type_lookups = {
	table = function(t)
		if (t.r and t.g and t.b and t.a or t == reset_color) then
			return t
		end

		return tostring(t)
	end,
	number = function(num)
		return tostring(num)
	end,
	["nil"] = function()
		return "nil"
	end,
	Player = function(ply)
		return Color(255, 0, 0), ply:Nick(), " [", ply:SteamID64(), "]", reset_color
	end,
}

local function toprintable(what)
	local typ = type(what)
	
	if (type_lookups[typ]) then
		return type_lookups[typ](what)
	end

	return tostring(what)
end

local current_color
local default_color
-- called with toprintable(what)
local function MsgC_state(...)
	for i = 1, select("#", ...) do
		local what = select(i, ...)
		if (what == reset_color) then
			current_color = default_color
		elseif (istable(what)) then -- sometimes colors aren't colors idk
			current_color = what
		else
			MsgC(current_color, what)
		end
	end
end

local function print_message(col, what, ...)
	local status_color = pluto.modules[what] or pluto.modules.BASE
	default_color = Color(255, 255, 255)
	current_color = default_color

	MsgC(current_color, "[", status_color, what, current_color, "] ")

	for i = 1, select("#", ...) do
		local what = select(i, ...)
		MsgC_state(toprintable(what))
	end

	MsgN ""
end

function pluto.message(what, ...)
	MsgC(Color(128, 128, 255), "+++ ")
	print_message(Color(103, 206, 154), what, ...)
end

function pluto.warn(what, ...)
	MsgC(Color(255, 255, 128), "--- ")
	print_message(Color(206, 103, 154), what, ...)
end

function pluto.error(what, ...)
	MsgC(Color(255, 128, 128), "!!! ")
	print_message(Color(206, 103, 154), what, ...)
end

pluto.message("BASE", "Main pluto file ", Color(0, 255, 0), "loaded", reset_color, ".")
pluto.warn("BASE", "This is a warning")
pluto.error("BASE", "This is an error")