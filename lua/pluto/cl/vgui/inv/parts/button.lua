--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
local PANEL = {}

function PANEL:Init()
	self.Color = Color(51, 53, 59)

	self.ButtonOutline = self:Add "ttt_curved_panel_outline"
	self.ButtonOutline:Dock(FILL)

	self.ButtonFill = self.ButtonOutline:Add "ttt_curved_panel"
	self.ButtonFill:Dock(FILL)

	self:SetCursor "hand"
	self.ButtonOutline:SetMouseInputEnabled(false)

	self:DockPadding(0, 0, 0, 1)

	self:SetTall(18)
end

function PANEL:GetLabel()
	if (not IsValid(self.Label)) then
		self.Label = self:Add "pluto_label"
		self.Label:SetRenderSystem(pluto.fonts.systems.shadow)
		self.Label:SetFont "pluto_inventory_font" -- better font maybe? idk
		self.Label:SetTextColor(pluto.ui.theme "TextActive")
		self.Label:SetText ""
		self.Label:Dock(FILL)
		self.Label:SetContentAlignment(5)
		self.Label:DockMargin(0, 0, 0, 1)
	end

	return self.Label
end

function PANEL:SetText(text)
	self:GetLabel():SetText(text)
end

function PANEL:SetColor(main, outline)
	self.ButtonFill:SetColor(main)
	self.ButtonOutline:SetColor(outline)
end

function PANEL:SetCurve(curve)
	self.Curve = curve
	self.ButtonFill:SetCurve(curve)
	self.ButtonOutline:SetCurve(curve)
end

function PANEL:OnChildAdded(x)
	x:SetParent(self.ButtonFill)
end

function PANEL:OnMousePressed(m)
	if (m == MOUSE_LEFT) then
		self:DoClick()
	end
end

function PANEL:DoClick()
end

vgui.Register("pluto_inventory_button", PANEL, "ttt_curved_panel_outline")