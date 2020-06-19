pluto = pluto or {}

local good_color = Color(0,255,0)
local bad_color = Color(255,0,0)
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

AccessorFunc(FindMetaTable "Player", "pluto_exp", "PlutoExperience", FORCE_NUMBER)
