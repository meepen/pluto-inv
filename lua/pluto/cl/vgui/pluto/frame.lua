--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
local PANEL = {}

function PANEL:Init()
	self:SetTall(2)
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(Color(26, 27, 32))
	surface.DrawLine(0, 0, w, 0)
	surface.SetDrawColor(Color(111, 112, 118))
	surface.DrawLine(0, 1, w, 1)
end

vgui.Register("pluto_inv_border", PANEL, "EditablePanel")

local PANEL = {}

function PANEL:Init()
	self.KeyboardFocus = {}

	self.TopSize = 22
	self.BottomSize = 11

	self.Main = self:Add "ttt_curved_panel"
	self.Main:Dock(FILL)

	self.TabContainer = self.Main:Add "EditablePanel"
	self.TabContainer:Dock(TOP)
	self.TabContainer:SetTall(self.TopSize)
	function self.TabContainer.OnMousePressed(s, m)
		if (m == MOUSE_LEFT) then
			self.MovingFrom = {self:ScreenToLocal(gui.MousePos())}
		end
	end

	self.CloseButton = self.TabContainer:Add "pluto_label"
	self.CloseButton:Dock(RIGHT)
	self.CloseButton:SetSize(self.TopSize, self.TopSize)
	self.CloseButton:SetFont "pluto_inventory_x"
	self.CloseButton:SetText "X"
	self.CloseButton:SetTextColor(Color(0xd7, 0x2c, 0x2d))
	self.CloseButton:SetContentAlignment(5)
	self.CloseButton:SetRenderSystem(pluto.fonts.systems.shadow)
	self.CloseButton:SetCursor "hand"
	self.CloseButton:SetMouseInputEnabled(true)
	self.CloseButton:SizeToContentsX(20)
	self.CloseButton.AllowClickThrough = true
	self.CloseButton.PaintUnder = function(s, w, h)
		if (s:IsHovered()) then
			surface.SetDrawColor(0, 0, 0, 64)
			surface.DrawRect(0, 0, w, h)
		end
	end
	function self.CloseButton.OnMousePressed(s, m)
		if (m == MOUSE_LEFT) then
			self:DoClose()
		end
	end

	self.BorderContainer = self.Main:Add "pluto_inv_border"
	self.BorderContainer:Dock(TOP)

	self.Container = self.Main:Add "ttt_curved_panel"
	self.Container:Dock(FILL)
	self.Container:SetTall(self:GetTall() - self.TopSize)
	self.Container:SetCurve(4)
	self.Container:DockPadding(15, 9, 15, 9)

	self.EmptyContainerContainer = self.Container:Add "EditablePanel"

	self.EmptyContainer = self.EmptyContainerContainer:Add "EditablePanel"
	self.EmptyContainer:SetName "pluto_empty_container"
	self.EmptyContainer:Dock(FILL)

	function self.Container.PerformLayout(s, w, h)
		local x, y = 15, 9
		w = w - 30
		h = h - 18

		for _, child in pairs(s:GetChildren()) do
			child:SetPos(x, y)
			child:SetSize(w, h - self.BottomSize)
			child:InvalidateLayout(true)
		end
	end

	-- THEME
	self.Main:SetColor(Color(38, 38, 38))
	self.Container:SetColor(Color(48, 50, 59))

	self.Main:SetCurve(4)
	self.Container:SetCurveTopLeft(false)
	self.Container:SetCurveTopRight(false)

	self.Tabs = {}
	self.CachedTabs = {}
	self.ActiveTab = nil
end

function PANEL:DoClose()
	self:Remove()
	return true
end

function PANEL:Think()
	if (input.IsKeyDown(KEY_ESCAPE) and gui.IsGameUIVisible()) then
		if (self:DoClose(true)) then
			gui.HideGameUI()
		end
	end

	if (self.MovingFrom) then
		if (input.IsMouseDown(MOUSE_LEFT)) then
			local offsetx, offsety = self:ScreenToLocal(gui.MousePos())
			offsetx = offsetx - self.MovingFrom[1]
			offsety = offsety - self.MovingFrom[2]
			if (offsetx ~= 0 or offsety ~= 0) then
				local x, y = self:GetPos()
				self:SetPos(x + offsetx, y + offsety)
				self:OnPositionUpdated()
			end
		else
			self.MovingFrom = nil
		end
	end
end

function PANEL:OnPositionUpdated()
end

function PANEL:ClearContainer()
	for _, pnl in pairs(self.Container:GetChildren()) do
		pnl:Remove()
	end
end

function PANEL:ChangeToTab(name, noupdate)
	local tab = self.Tabs[name]
	if (not tab) then
		return
	end

	if (self.ActiveTab == name) then
		return tab.ActiveTabData
	end

	local old = self.Tabs[self.ActiveTab]
	if (old) then
		old.Label:SetTextColor(old.LabelColor)
	end

	self.ActiveTab = name

	tab.Label:SetTextColor(Color(28, 198, 244))

	local oldpnl = self.EmptyContainer
	local newpnl = self.EmptyContainer

	if (old and old.Cache) then
		if (not IsValid(self.CachedTabs[old.Name])) then
			local cache = vgui.Create "EditablePanel"
			cache:SetVisible(false)
			self.CachedTabs[old.Name] = cache
		end

		for _, child in pairs(oldpnl:GetChildren()) do
			child:SetParent(self.CachedTabs[old.Name])
		end
	else
		for _, child in pairs(oldpnl:GetChildren()) do
			child:Remove()
		end
	end

	if (tab and tab.Cache and IsValid(self.CachedTabs[name])) then
		for _, child in pairs(self.CachedTabs[name]:GetChildren()) do
			child:SetParent(newpnl)
			child:SetVisible(true)
		end
	else
		tab.ActiveTabData = tab.Populate(newpnl)
	end

	return tab.ActiveTabData
end

local gradient_up = Material "gui/gradient_up"

function PANEL:AddTab(name, func, cache, col)
	local lbl = self.TabContainer:Add "pluto_label"
	local old_paint = lbl.Paint
	function lbl.PaintUnder(s, w, h)
		if (self.ActiveTab == name) then
			surface.SetMaterial(gradient_up)
			surface.SetDrawColor(255, 255, 255, 10)
			surface.DrawTexturedRect(0, 0, w, h)
		elseif (s:IsHovered()) then
			surface.SetDrawColor(0, 0, 0, 64)
			surface.DrawRect(0, 0, w, h)
		end
	end
	self.Tabs[name] = {
		Label = lbl,
		LabelColor = col or white_text,
		Populate = func,
		Cache = cache,
		Name = name,
	}

	lbl:Dock(LEFT)
	lbl:SetContentAlignment(5)
	lbl:SetText(name)
	lbl:SetFont "pluto_inventory_font"
	lbl:SetTextColor(self.Tabs[name].LabelColor)
	lbl:SetRenderSystem(pluto.fonts.systems.shadow)
	lbl:SetCursor "hand"
	lbl:SetMouseInputEnabled(true)
	lbl.AllowClickThrough = true

	surface.SetFont(lbl:GetFont())
	lbl:SetWide(surface.GetTextSize(lbl:GetText()) + 24)

	function lbl.OnMousePressed(s, m)
		if (self.ActiveTab == name) then
			return
		end

		self:ChangeToTab(name)
	end

	if (not self.ActiveTab) then
		self:ChangeToTab(name, true)
	end
end

function PANEL:OnRemove()
	for _, pnl in pairs(self.CachedTabs or {}) do
		if (IsValid(pnl)) then
			pnl:Remove()
		end
	end
end

function PANEL:SetKeyboardFocus(what, b)
	self.KeyboardFocus[what] = b and true or nil

	self:SetKeyboardInputEnabled(table.Count(self.KeyboardFocus) > 0)
end

vgui.Register("pluto_window", PANEL, "EditablePanel")

if (IsValid(pluto.testingpnl)) then
	pluto.testingpnl:Remove()
end
