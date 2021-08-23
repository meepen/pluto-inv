--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
local circles = include "pluto/thirdparty/circles.lua"

local PANEL = {}

AccessorFunc(PANEL, "Shape", "Shape")
AccessorFunc(PANEL, "Color", "Color")

function PANEL:Init()
	self:SetShape "square"
	self:SetColor(Color(255, 0, 0))
end

local shape_font = setmetatable({},{
	__index = function(self, k)
		if (k ~= math.Round(k)) then
			return self[math.Round(k)]
		end

		local fontname = "pluto_shape_font_" .. k

		surface.CreateFont(fontname, {
			font = "Arial",
			size = k,
			extended = true
		})

		self[k] = fontname

		return fontname
	end
})

local shadow_color = Color(0, 0, 0, 128)
local DrawingTypes = {
	square = function(self, w, h)
		surface.SetDrawColor(shadow_color)
		surface.DrawRect(w / 4 + 1, h / 4 + 1, w / 2, h / 2)
		surface.SetDrawColor(self:GetColor())
		surface.DrawRect(w / 4, h / 4, w / 2, h / 2)
	end,
	circle = function(self, w, h)
		if (not self.CircleShape) then
			self.CircleShape = circles.New(CIRCLE_FILLED, w / 4, w / 2, w / 2)
			self.CircleShape:SetColor(self:GetColor())
			self.CircleShape:SetDistance(3)
			self.CircleShapeShadow = circles.New(CIRCLE_FILLED, w / 4, w / 2 + 1, w / 2 + 1)
			self.CircleShapeShadow:SetColor(shadow_color)
			self.CircleShapeShadow:SetDistance(3)
		end

		draw.NoTexture()
		self.CircleShapeShadow()
		self.CircleShape()
	end,
	triangle = function(self, w, h)
		draw.NoTexture()
		surface.SetDrawColor(shadow_color)
		surface.DrawPoly {
			{ x = 1 + w / 2, y = h / 3 + 1},
			{ x = 1 + w * 3 / 4, y = h * 2 / 3 + 1 },
			{ x = 1 + w / 4, y = h * 2 / 3 + 1 },
		}

		surface.SetDrawColor(self:GetColor())
		surface.DrawPoly {
			{ x = w / 2, y = h / 4 },
			{ x = w * 3 / 4, y = h * 3 / 4 },
			{ x = w / 4, y = h * 3 / 4 },
		}
	end,
	diamond = function(self, w, h)
		draw.NoTexture()
		surface.SetDrawColor(self:GetColor())
		surface.DrawPoly {
			{ x = w / 2,     y = h / 5 },
			{ x = w * 3 / 4, y = h / 2 },
			{ x = w / 2,     y = h * 4 / 5 },
			{ x = w / 4,     y = h / 2 },
		}
	end,
	plus = function(self, w, h)
		local cx, cy = math.Round(w / 2), math.Round(h / 2)
		local sw = math.Round(w / 2 / 2) * 2
		surface.SetDrawColor(shadow_color)
		surface.DrawLine(cx - sw / 2, cy + 1, cx + sw / 2, cy + 1)
		surface.DrawLine(cx, cy - sw / 2 + 1, cx, cy + sw / 2 + 1)
		surface.SetDrawColor(self:GetColor())
		surface.DrawLine(cx - sw / 2, cy, cx + sw / 2, cy)
		surface.DrawLine(cx, cy - sw / 2, cx, cy + sw / 2)
	end,
	heart = function(self, w, h)
		local surface = pluto.fonts.systems.shadow
		local font = shape_font[w]
		local c = "♥"
		surface.SetTextColor(self:GetColor())
		surface.SetFont(font)
		local tw, th = surface.GetTextSize(c)
		surface.SetTextPos(w / 2 - tw / 2 - 1, h / 2 - th / 2 - 1)
		surface.DrawText(c)
	end,
	music = function(self, w, h)
		local surface = pluto.fonts.systems.shadow
		local font = shape_font[w]
		local c = "♪"
		surface.SetTextColor(self:GetColor())
		surface.SetFont(font)
		local tw, th = surface.GetTextSize(c)
		surface.SetTextPos(w / 2 - tw / 2 - 1, h / 2 - th / 2 - 1)
		surface.DrawText(c)
	end,
	club = function(self, w, h)
		local surface = pluto.fonts.systems.shadow
		local font = shape_font[w]
		local c = "♣"
		surface.SetTextColor(self:GetColor())
		surface.SetFont(font)
		local tw, th = surface.GetTextSize(c)
		surface.SetTextPos(w / 2 - tw / 2 - 1, h / 2 - th / 2 - 1)
		surface.DrawText(c)
	end,
	spade = function(self, w, h)
		local surface = pluto.fonts.systems.shadow
		local font = shape_font[w]
		local c = "♠"
		surface.SetTextColor(self:GetColor())
		surface.SetFont(font)
		local tw, th = surface.GetTextSize(c)
		surface.SetTextPos(w / 2 - tw / 2 - 1, h / 2 - th / 2 - 1)
		surface.DrawText(c)
	end,
}

PANEL.DrawingTypes = DrawingTypes

function PANEL:Paint(w, h)
	(self.DrawingTypes[self:GetShape()] or self.DrawingTypes.square)(self, w, h)
end

vgui.Register("pluto_inventory_shape", PANEL, "EditablePanel")

local PANEL = {}

function PANEL:Init()
	self:SetCurve(2)
	self:SetColor(Color(146, 146, 149))
	self:DockPadding(1, 1, 1, 1)
	self:SetSize(190, 79 + 2 + 8 + 20 + 2 + 20 + 2)


	self.Inner = self:Add "ttt_curved_panel"
	self.Inner:Dock(FILL)
	self.Inner:SetCurve(2)
	self.Inner:SetColor(Color(38, 38, 38))
	self.Inner:SetSize(190 - 2, 79 + 2 + 8 + 20 + 2 + 20 + 2 - 2)

	self.MixerBackground = self.Inner:Add "ttt_curved_panel"
	self.MixerBackground:SetColor(Color(54, 54, 54))
	self.MixerBackground:SetPos(8, 8)
	self.MixerBackground:SetSize(136, 63)
	self.MixerBackground:DockPadding(1, 1, 1, 1)


	self.Mixer = self.MixerBackground:Add "DColorCube"
	self.Mixer:Dock(FILL)

	self.PickerBackground = self.Inner:Add "ttt_curved_panel"
	self.PickerBackground:SetColor(Color(54, 54, 54))
	self.PickerBackground:SetPos(8 + 136 + 8, 8)
	self.PickerBackground:SetSize(16, 63)
	self.PickerBackground:DockPadding(1, 1, 1, 1)
	self.Picker = self.PickerBackground:Add "DRGBPicker"
	self.Picker:Dock(FILL)

	function self.Picker.OnChange(s, col)
		self.Mixer:SetBaseRGB(col)
		self.Mixer:OnUserChanged(self.Mixer:GetRGB())
	end

	function self.Mixer.OnUserChanged(s, col)
		self:DoColorChanged(Color(col.r, col.g, col.b))
		self:OnColorChanged(Color(col.r, col.g, col.b))
		for _, shape in pairs(self.Shapes) do
			shape:SetColor(col)
		end
		if (self.Shapes.circle.CircleShape) then
			self.Shapes.circle.CircleShape:SetColor(Color(col.r, col.g, col.b))
		end
	end


	self.TextEntry = self.Inner:Add "pluto_inventory_textentry"
	self.TextEntry:SetPos(8, 77)
	self.TextEntry:SetSize(60, 20)
	self.TextEntry:CenterHorizontal()

	function self.TextEntry.OnEnter(s)
		local r, g, b = s:GetText():match "([a-fA-F0-9][a-fA-F0-9])([a-fA-F0-9][a-fA-F0-9])([a-fA-F0-9][a-fA-F0-9])"
		if (r) then
			print(tonumber(r, 16))
			self:SetRGB(Color(tonumber(r, 16), tonumber(g, 16), tonumber(b, 16)))
		else

			s:SetText "invalid"
		end
			
	end

	self.ShapeContainer = self.Inner:Add "EditablePanel"

	self.ShapeContainer:SetPos(8, 79 + 22)
	self.ShapeContainer:SetWide(self:GetWide() - 16)
	self.ShapeContainer:SetTall(20)
	self.ShapeContainer:DockPadding(1, 1, 1, 1)

	self.Shapes = {}

	for shape in pairs(DrawingTypes) do
		local cur_shape = self.ShapeContainer:Add "pluto_inventory_shape"
		cur_shape:Dock(LEFT)
		cur_shape:SetWide(18)
		cur_shape:SetShape(shape)
		cur_shape:SetCursor "hand"
		function cur_shape.OnMousePressed(s, m)
			self:OnShapeChanged(shape)
		end
		self.Shapes[shape] = cur_shape
		local seperator = self.ShapeContainer:Add "EditablePanel"
		seperator:SetWide(1)
		seperator:Dock(LEFT)
	end
end

function PANEL:OnColorChanged(col)
end

function PANEL:DoColorChanged(col)
	local hex = string.format("%02x%02x%02x", col.r, col.g, col.b)
	self.TextEntry:SetText(hex)
end

function PANEL:OnShapeChanged(shape)
end

function PANEL:SetRGB(col)
	self:DoColorChanged(col)
	self:OnColorChanged(col)
	self.Mixer:SetBaseRGB(col)
	self.Mixer:SetRGB(col)
	self.Picker:SetRGB(col)
	self.Mixer:OnUserChanged(self.Mixer:GetRGB())
	for _, shape in pairs(self.Shapes) do
		shape:SetColor(col)
	end
end

function PANEL:SetShape(shape)
end

vgui.Register("pluto_inventory_shape_change", PANEL, "ttt_curved_panel")