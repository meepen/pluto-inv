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
		surface.DrawRect(w / 3 + 1, h / 3 + 1, w / 3, h / 3)
		surface.SetDrawColor(self:GetColor())
		surface.DrawRect(w / 3, h / 3, w / 3, h / 3)
	end
}

function PANEL:Paint(w, h)
	(self.DrawingTypes[self:GetShape()] or self.DrawingTypes.square)(self, w, h)
end

vgui.Register("pluto_inventory_shape", PANEL, "EditablePanel")