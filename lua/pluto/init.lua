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
}

function pluto.cancheat(ply)
	return IsValid(ply) and allowed[ply:SteamID64()]
end
