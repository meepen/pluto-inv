local PANEL = {}

function PANEL:Init()
	self.ComponentOutline = self:Add "ttt_curved_panel"
	self.ComponentOutline:SetColor(Color(95, 96, 102))
	self.ComponentInner = self.ComponentOutline:Add "ttt_curved_panel"
	self.ComponentInner:Dock(FILL)
	self.ComponentInner:DockMargin(1, 1, 1, 1)

	for _, child in pairs(self:GetChildren()) do
		child:SetMouseInputEnabled(false)
	end
end

function PANEL:PerformLayout(w, h)
	self.ComponentOutline:SetSize(w, h)
end

function PANEL:ChangeDockInner(l, t, r, b)
	self.ComponentInner:DockMargin(l, t, r, b)
end

function PANEL:SetColor(col)
	self.ComponentInner:SetColor(col)
end

function PANEL:GetColor()
	return self.ComponentInner:GetColor()
end

function PANEL:SetCurve(curve)
	self.ComponentInner:SetCurve(curve)
	self.ComponentOutline:SetCurve(curve)
end

function PANEL:SetCurveTopRight(right)
	self.ComponentInner:SetCurveTopRight(right)
	self.ComponentOutline:SetCurveTopRight(right)
end

function PANEL:SetCurveTopLeft(right)
	self.ComponentInner:SetCurveTopLeft(right)
	self.ComponentOutline:SetCurveTopLeft(right)
end

function PANEL:SetCurveBottomRight(right)
	self.ComponentInner:SetCurveBottomRight(right)
	self.ComponentOutline:SetCurveBottomRight(right)
end

function PANEL:SetCurveBottomLeft(right)
	self.ComponentInner:SetCurveBottomLeft(right)
	self.ComponentOutline:SetCurveBottomLeft(right)
end

vgui.Register("pluto_inventory_component_noshadow", PANEL, "EditablePanel")


local PANEL = {}

function PANEL:Init()
	self.ComponentShadow = self:Add "ttt_curved_panel"
	self.ComponentShadow:SetColor(Color(0, 0, 0, 128))
	self.ComponentOutline = self:Add "ttt_curved_panel"
	self.ComponentOutline:SetColor(Color(95, 96, 102))
	self.ComponentInner = self.ComponentOutline:Add "ttt_curved_panel"
	self.ComponentInner:Dock(FILL)
	self.ComponentInner:DockMargin(1, 1, 1, 1)

	for _, child in pairs(self:GetChildren()) do
		child:SetMouseInputEnabled(false)
	end
end

function PANEL:ChangeDockInner(l, t, r, b)
	self.ComponentInner:DockMargin(l, t, r, b)
end

function PANEL:PerformLayout(w, h)
	self.ComponentShadow:SetSize(w, h)
	self.ComponentOutline:SetSize(w, h - 1)
end

function PANEL:SetColor(col)
	self.ComponentInner:SetColor(col)
end

function PANEL:GetColor(col)
	return self.ComponentInner:GetColor()
end

function PANEL:SetCurve(curve)
	self.ComponentShadow:SetCurve(curve)
	self.ComponentInner:SetCurve(curve)
	self.ComponentOutline:SetCurve(curve)
end

function PANEL:SetCurveTopRight(right)
	self.ComponentInner:SetCurveTopRight(right)
	self.ComponentShadow:SetCurveTopRight(right)
	self.ComponentOutline:SetCurveTopRight(right)
end

function PANEL:SetCurveTopLeft(right)
	self.ComponentInner:SetCurveTopLeft(right)
	self.ComponentShadow:SetCurveTopLeft(right)
	self.ComponentOutline:SetCurveTopLeft(right)
end

function PANEL:SetCurveBottomRight(right)
	self.ComponentInner:SetCurveBottomRight(right)
	self.ComponentShadow:SetCurveBottomRight(right)
	self.ComponentOutline:SetCurveBottomRight(right)
end

function PANEL:SetCurveBottomLeft(right)
	self.ComponentInner:SetCurveBottomLeft(right)
	self.ComponentShadow:SetCurveBottomLeft(right)
	self.ComponentOutline:SetCurveBottomLeft(right)
end


vgui.Register("pluto_inventory_component", PANEL, "EditablePanel")