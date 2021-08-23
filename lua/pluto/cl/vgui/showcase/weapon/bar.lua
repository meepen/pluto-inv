--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
local PANEL = {}

local line_color = Color(161, 161, 161)

function PANEL:Init()
	self.Bars = {}
end

function PANEL:AddFilling(pct, txt, col)
	table.insert(self.Bars, {
		Color = col or Color(59, 255, 64),
		Text = txt,
		Percent = pct
	})
end

function PANEL:ScissorBar(bar, sx, w, h)
	local scrx, scry = self:LocalToScreen(sx, 0)
	local scrx2, scry2 = self:LocalToScreen(sx + w, h)
	render.SetScissorRect(scrx, scry, scrx2, scry2, true)
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(21, 21, 21)
	ttt.DrawCurvedRect(0, 1, w, h, 2)
	surface.SetDrawColor(85, 85, 85)
	ttt.DrawCurvedRect(0, 0, w, h - 1, 2)
	local x = 1
	for _, bar in ipairs(self.Bars) do
		local bw = math.Round((w - 2) * bar.Percent)

		self:ScissorBar(bar, x, bw, h)

		surface.SetDrawColor(bar.Color)
		ttt.DrawCurvedRect(0, 0, w, h - 1, 2)
		x = x + bw
		surface.SetDrawColor(255, 255, 255, 200)
		surface.DrawLine(x - 1, 0, x - 1, h - 2)
	end

	render.SetScissorRect(0, 0, 0, 0, false)
end

vgui.Register("pluto_showcase_bar", PANEL, "EditablePanel")