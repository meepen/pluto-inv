local PANEL = {}

function PANEL:Init()
	self.Entry = self:Add "DTextEntry"
	self.Entry:SetPaintBackground(false)
	self.Entry:SetFont "pluto_inventory_font"
	self.Entry:Dock(FILL)
	self.Entry:SetPaintBackground(false)
	self.Entry:SetMouseInputEnabled(true)
	self.Entry:SetTextColor(Color(255, 255, 255))

	function self.Entry.OnChange()
		self:OnChange()
	end

	local oldpress = self.Entry.OnMousePressed

	function self.Entry.OnMousePressed(s, m)
		if (oldpress) then
			oldpress(s, m)
		end

		if (self:IsChildOfInventory()) then
			pluto.ui.pnl:SetKeyboardFocus(s, true)
		end
	end

	function self.Entry.OnRemove(s)
		pluto.ui.pnl:SetKeyboardFocus(s, false)
	end

	self.Entry.GetAutoComplete = function(s, t)
		return self.GetAutoComplete(s, t)
	end

	hook.Add("OnTextEntryLoseFocus", self.Entry, function(s, p)
		if (s == p) then
			pluto.ui.pnl:SetKeyboardFocus(s, false)
		end
	end)

	hook.Add("VGUIMousePressed", self.Entry, function(s, p)
		if (not self:IsParentOf(s)) then
			self:FocusNext()
		end
	end)

	self:SetColor(Color(95, 96, 102))
	self:SetCurve(2)
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

function PANEL:GetAutoComplete(t)
end

function PANEL:OpenAutoComplete(...)
	self.Entry:OpenAutoComplete(...)
end

function PANEL:IsChildOfInventory()
	local p = self
	while (IsValid(p)) do
		if (p == pluto.ui.pnl) then
			break
		end

		p = p:GetParent()
	end

	return p == pluto.ui.pnl and p
end

function PANEL:SetText(t)
	self.Entry:SetText(t)
end

function PANEL:OnChange()
end

function PANEL:GetText()
	return self.Entry:GetText()
end

vgui.Register("pluto_inventory_textentry", PANEL, "ttt_curved_panel_outline")