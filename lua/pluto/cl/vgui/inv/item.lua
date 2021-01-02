local PANEL = {}

function PANEL:Init()
	self:SetSize(56, 56)

	self.OuterBorder = self:Add "ttt_curved_panel"
	self.OuterBorder:Dock(FILL)
	self.OuterBorder:SetColor(Color(95, 96, 102))
	self.OuterBorder:DockPadding(1, 1, 1, 1)

	self.InnerBorder = self.OuterBorder:Add "ttt_curved_panel"
	self.InnerBorder:Dock(FILL)
	self.InnerBorder:SetColor(Color(41, 43, 54))
	self.InnerBorder:DockPadding(1, 1, 1, 1)

	self.Inner = self.InnerBorder:Add "ttt_curved_panel"
	self.Inner:Dock(FILL)
	self.Inner:SetColor(Color(53, 53, 60))

	self:SetCurve(4)
end

function PANEL:SetCurve(curve)
	self.InnerBorder:SetCurve(curve)
	self.OuterBorder:SetCurve(curve)
	self.Inner:SetCurve(curve)
end

vgui.Register("pluto_inventory_item", PANEL, "EditablePanel")