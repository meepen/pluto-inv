local circles = include "pluto/thirdparty/circles.lua"

local PANEL = {}

AccessorFunc(PANEL, "Shape", "Shape")
AccessorFunc(PANEL, "Color", "Color")

function PANEL:Init()
	self:SetShape "square"
	self:SetColor(Color(255, 0, 0))
end

local shadow_color = Color(0, 0, 0, 128)
PANEL.DrawingTypes = {
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
		surface.SetDrawColor(self:GetColor())

		surface.DrawPoly {
			{ x = w / 2, y = h / 4 },
			{ x = w * 3 / 4, y = h * 3 / 4 },
			{ x = w / 4, y = h * 3 / 4 },
		}

		surface.SetDrawColor(shadow_color)

		surface.DrawPoly {
			{ x = 1 + w / 2, y = h / 3 + 1},
			{ x = 1 + w * 3 / 4, y = h * 2 / 3 + 1 },
			{ x = 1 + w / 4, y = h * 2 / 3 + 1 },
		}
	end,
	diamond = function(self, w, h)
		draw.NoTexture()
		surface.SetDrawColor(self:GetColor())
		surface.DrawPoly {
			{ x = w / 2, y = h / 4 },
			{ x = w * 3 / 4, y = h / 2 },
			{ x = w / 2, y = h * 3 / 4 },
			{ x = w / 4, y = h / 2 },
		}
	end,
}

function PANEL:Paint(w, h)
	(self.DrawingTypes[self:GetShape()] or self.DrawingTypes.square)(self, w, h)
end

vgui.Register("pluto_inventory_shape", PANEL, "EditablePanel")