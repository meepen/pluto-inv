--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
surface.CreateFont("pluto_showcase_name", {
	font = "Roboto",
	size = 20,
	weight = 450,
})

surface.CreateFont("pluto_showcase_name_real", {
	font = "Roboto",
	size = 14,
	weight = 450,
})

surface.CreateFont("pluto_showcase_small", {
	font = "Roboto",
	size = 16,
	weight = 450
})

surface.CreateFont("pluto_showcase_xsmall", {
	font = "Roboto",
	size = 12,
	weight = 450,
	italic = true
})

surface.CreateFont("pluto_showcase_suffix_text", {
	font = "Roboto",
	size = 14,
	weight = 450,
})

function pluto.ui.showcase(item)
	if (item.Type == "Weapon") then
		local container = vgui.Create "pluto_showcase_weapon"
		container:SetItem(item)

		return container
	elseif (item.Type == "Model") then
		local container = vgui.Create "pluto_showcase_model"
		container:SetItem(item)

		return container
	elseif (item.Type == "Currency") then
		local container = vgui.Create "pluto_showcase_currency"
		container:SetItem(item)

		return container
	else
		return pluto.ui.oldshowcase(item)
	end
end

local PANEL = {}

function PANEL:Init()
	self:SetColor(Color(83, 85, 90))

	self.Inner = self:Add "ttt_curved_panel"
	self.Inner:SetColor(Color(33, 33, 33))
	self.Inner:Dock(FILL)
	self.Inner:SetCurveTopRight(false)
	self.Inner:SetCurveTopLeft(false)

	local oldpaint = self.Inner.Paint
	function self.Inner:Paint(w, h)
		oldpaint(self, w, h)
		
		surface.SetDrawColor(38, 38, 38)
		ttt.DrawCurvedRect(1, 1, w - 2, h - 2, self:GetCurve() / 2)
		
		surface.SetDrawColor(36, 36, 36)
		local scrx, scry = self:LocalToScreen(1, 1)
		local scrx2, scry2 = self:LocalToScreen(w - 1, h - 1)
		render.SetScissorRect(scrx, scry, scrx2, scry2, true)
		local step = 11
		for y = 0, h + w + step, step do
			surface.DrawLine(1, y, w - 2, y - w - 2)
		end
		render.SetScissorRect(scrx, scry, scrx2, scry2, false)
	end

	self.NameContainer = self:Add "ttt_curved_panel"
	self.NameContainer:Dock(TOP)
	self.NameContainer:SetCurveBottomRight(false)
	self.NameContainer:SetCurveBottomLeft(false)
	self.NameContainer:SetTall(30)

	self.NameShadow = self:Add "ttt_curved_panel"
	self.NameShadow:SetTall(1)
	self.NameShadow:Dock(TOP)
	self.NameShadow:SetColor(Color(21, 21, 21))

	self:SetCurve(4)
	self.Inner:SetCurve(4)
	self.NameContainer:SetCurve(4)

	self.Name = self.NameContainer:Add "pluto_label"
	self.Name:Dock(FILL)
	self.Name:SetText "name"
	self.Name:SetFont "pluto_showcase_name"
	self.Name:SetRenderSystem(pluto.fonts.systems.shadow)
	self.Name:SetContentAlignment(5)
	self.Name:SetTextColor(pluto.ui.theme "TextActive")
end

function PANEL:SetItem()
end

function PANEL:GetCanvas()
	return self.Inner
end

vgui.Register("pluto_showcase_base", PANEL, "ttt_curved_panel_outline")