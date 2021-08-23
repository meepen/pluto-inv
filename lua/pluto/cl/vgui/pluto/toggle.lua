--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
local PANEL = {}

local circles = include "pluto/thirdparty/circles.lua"
AccessorFunc(PANEL, "Toggled", "Toggled")

function PANEL:Init()
	self:SetSize(23, 12)
	self.Background = self:Add "ttt_curved_panel"
	self.Background:SetSize(19, 6)
	self.Background:SetColor(Color(48, 49, 55))
	self.Background:SetCurve(4)

	self.Circle = self:Add "EditablePanel"
	self.Circle:SetSize(12, 12)

	function self.Circle:PerformLayout(w, h)
		self.Circle = circles.New(CIRCLE_FILLED, w / 2, w / 2, w / 2)
		self.Circle:SetColor(Color(255, 255, 255))
		self.Circle:SetDistance(3)
	end

	function self.Circle:Paint(w, h)
		draw.NoTexture()
		self.Circle()
	end

	self.Circle:SetMouseInputEnabled(false)
	self.Background:SetMouseInputEnabled(false)

	self:SetCursor "hand"
end

function PANEL:OnMousePressed(m)
	if (m == MOUSE_LEFT) then
		self:Toggle()
	end
end

function PANEL:PerformLayout()
	self.Background:Center()
end

function PANEL:Toggle()
	self:SetToggled(not self:GetToggled())
	self:OnToggled(self:GetToggled())

	if (self:GetToggled()) then
		self.Circle:SetPos(self:GetWide() - self.Circle:GetWide(), 0)
	else
		self.Circle:SetPos(0, 0)
	end
end

function PANEL:OnToggled(on)
end

vgui.Register("pluto_toggle", PANEL, "EditablePanel")