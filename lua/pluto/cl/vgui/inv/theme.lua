
local function gettheme()
	return "default"
end

pluto.ui = pluto.ui or {}
pluto.ui.theme = setmetatable({
	default = {
		XButton = Color(0xd7, 0x2c, 0x2d),
		["?Button"] = Color(0x2c, 0xd7, 0x2d),
		InnerColor = Color(64, 66, 74),
		InnerColorInactive = Color(35, 36, 43),
		TextActive = Color(255, 255, 255),
		InnerColorSeperator = Color(95, 96, 102),
	}
}, {
	__call = function(self, k)
		return rawget(self, gettheme())[k]
	end
})

local function getsizeindex()
	local w, h = ScrW(), ScrH()
	local index = 1
	while (rawget(pluto.ui.sizings, index + 1)) do
		if (pluto.ui.sizings[index + 1].w > w or pluto.ui.sizings[index + 1].h > h) then
			break
		end
		index = index + 1
	end

	return index
end

pluto.ui.sizings = setmetatable({
	{
		w = 1366, h = 768,
		SidePanelSize = 140,
		pluto_inventory_font = 13,
		pluto_inventory_font_s = 13,
		pluto_inventory_font_lg = 15,
		pluto_inventory_font_xlg = 18,
		MainWidth = 700,
		MainHeight = 450,
		ItemSize = 56
	},
	{
		w = 1920, h = 1080,
		pluto_inventory_font = 17,
		pluto_inventory_font_s = 15,
		pluto_inventory_font_lg = 19,
		pluto_inventory_font_xlg = 23,
		SidePanelSize = 200,
		MainWidth = 950,
		MainHeight = 570,
		ItemSize = 76
	}
}, {
	__call = function(self, key)
		local index = getsizeindex()
		for i = index, 1, -1 do
			local val = self[i][key]
			if (val ~= nil) then
				return val
			end
		end
	end
})

local function init_fonts()
	surface.CreateFont("pluto_inventory_font", {
		font = "Roboto Lt",
		size = pluto.ui.sizings "pluto_inventory_font",
		weight = 450,
	})

	surface.CreateFont("pluto_inventory_font_s", {
		font = "Roboto Lt",
		size = pluto.ui.sizings "pluto_inventory_font_s",
		weight = 450,
	})

	surface.CreateFont("pluto_inventory_font_lg", {
		font = "Roboto Lt",
		size = pluto.ui.sizings "pluto_inventory_font_lg",
		weight = 450,
	})

	surface.CreateFont("pluto_trade_buttons", {
		font = "Roboto Lt",
		size = 13,
		weight = 450,
	})

	surface.CreateFont("pluto_inventory_font_xlg", {
		font = "Roboto Lt",
		size = pluto.ui.sizings "pluto_inventory_font_xlg",
		weight = 450,
	})

	surface.CreateFont("pluto_inventory_x", {
		font = "Arial",
		size = 15,
		weight = 1000,
	})

	surface.CreateFont("pluto_inventory_storage", {
		font = "Verdana",
		size = 15,
		weight = 100,
	})
end

hook.Add("DrawOverlay", "pluto_init_fonts", function()
	init_fonts()
	hook.Remove("DrawOverlay", "pluto_init_fonts")
end)

hook.Add("OnScreenSizeChanged", "pluto_init_fonts", init_fonts)