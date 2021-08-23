--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
local PANEL = {}

function PANEL:Init()
	self.Entry = self:Add "DTextEntry"
	self.Entry:SetPaintBackground(false)
	self.Entry:SetFont "pluto_inventory_font"
	self.Entry:Dock(FILL)
	self.Entry:SetPaintBackground(false)
	self.Entry:SetMouseInputEnabled(true)
	self.Entry:SetTextColor(pluto.ui.theme "TextActive")

	self.Entry.OnEnter = function(s, val)
		self:OnEnter(val)
	end

	function self.Entry.OnChange()
		self:OnChange()
	end

	local oldpress = self.Entry.OnMousePressed

	function self.Entry.OnMousePressed(s, m)
		if (oldpress) then
			oldpress(s, m)
		end

		pluto.ui.SetKeyboardFocus(s, true)
	end

	local old = self.Entry.OnKeyCodeTyped
	function self.Entry.OnKeyCodeTyped(s, key)
		local r = self:OnKeyCode(key)
		if (r ~= nil) then
			return r
		end
		if (old) then
			return old(s, key)
		end
	end

	function self.Entry.OnRemove(s)
		pluto.ui.SetKeyboardFocus(s, false)
	end

	self.Entry.GetAutoComplete = function(s, t)
		return self.GetAutoComplete(s, t)
	end

	hook.Add("OnTextEntryLoseFocus", self.Entry, function(s, p)
		if (s == p) then
			pluto.ui.SetKeyboardFocus(s, false)
		end
	end)

	hook.Add("VGUIMousePressed", self.Entry, function(s, p)
		if (not self:IsParentOf(s)) then
			self:FocusNext()
		end
	end)

	self:SetColor(pluto.ui.theme "InnerColorSeperator")
	self:SetCurve(2)
end

function PANEL:GetCaretPos()
	return self.Entry:GetCaretPos()
end
function PANEL:SetCaretPos(c)
	return self.Entry:SetCaretPos(c)
end

function PANEL:OnKeyCode(key)
end

function PANEL:IsParentOf(p)
	while (IsValid(p)) do
		if (p == self) then
			break
		end

		p = p:GetParent()
	end

	return p and p == self
end

function PANEL:Focus()
	self.Entry:RequestFocus()
end

function PANEL:GetAutoComplete(t)
end

function PANEL:OpenAutoComplete(...)
	self.Entry:OpenAutoComplete(...)
end

function PANEL:SetText(t)
	self.Entry:SetText(t)
end

function PANEL:OnChange()
end

function PANEL:GetText()
	return self.Entry:GetText()
end

function PANEL:OnEnter(text)
end

function PANEL:SetFont(font)
	self.Entry:SetFont(font)
end

vgui.Register("pluto_inventory_textentry", PANEL, "ttt_curved_panel_outline")