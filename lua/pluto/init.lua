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