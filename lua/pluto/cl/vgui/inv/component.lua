local PANEL = {}

function PANEL:Init()
	self.ComponentShadow = self:Add "ttt_curved_panel"
	self.ComponentShadow:SetColor(Color(0, 0, 0, 128))
	self.ComponentInner = self:Add "ttt_curved_panel"
end

function PANEL:PerformLayout(w, h)
	self.ComponentShadow:SetSize(w, h)
	self.ComponentInner:SetSize(w, h - 1)
end

function PANEL:SetColor(col)
	self.ComponentInner:SetColor(col)
end

function PANEL:SetCurve(curve)
	self.ComponentShadow:SetCurve(curve)
	self.ComponentInner:SetCurve(curve)
end

function PANEL:SetCurveTopRight(right)
	self.ComponentInner:SetCurveTopRight(right)
	self.ComponentShadow:SetCurveTopRight(right)
end

function PANEL:SetCurveTopLeft(right)
	self.ComponentInner:SetCurveTopLeft(right)
	self.ComponentShadow:SetCurveTopLeft(right)
end

function PANEL:SetCurveBottomRight(right)
	self.ComponentInner:SetCurveBottomRight(right)
	self.ComponentShadow:SetCurveBottomRight(right)
end

function PANEL:SetCurveBottomLeft(right)
	self.ComponentInner:SetCurveBottomLeft(right)
	self.ComponentShadow:SetCurveBottomLeft(right)
end


vgui.Register("pluto_inventory_component", PANEL, "EditablePanel")