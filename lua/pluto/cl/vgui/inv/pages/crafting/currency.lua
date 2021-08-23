--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
local PANEL = {}

function PANEL:Init()
	self.ContainerArea = self:Add "EditablePanel"
	self.ContainerArea:Dock(TOP)
	self.ContainerArea:SetTall(pluto.ui.sizings "ItemSize")

	self.ItemContainer = self.ContainerArea:Add "pluto_inventory_item"

	self.Selector = self.ContainerArea:Add "pluto_inventory_currency_selector"

	self.Selector:SetCurrencyFilter(function(cur)
		return cur.AllowMass
	end)

	self.Selector:AcceptAmount(true)
	self.Selector:AcceptInput(true)
	self.Selector:SetTall(pluto.ui.sizings "ItemSize")
	self.Selector:InvalidateLayout(true)

	function self.Selector:OnCurrencyUpdated()
		if (IsValid(pluto.ui.pnl)) then
			pluto.ui.pnl:ChangeToTab "Crafting"
		end
	end

	local pad = 34
	function self.ContainerArea.PerformLayout(s, w, h)
		self.ItemContainer:SetPos(w / 2 - self.ItemContainer:GetWide() - pad / 2, 0)
		self.Selector:SetPos(w / 2 + pad / 2, 0)
	end

	function self.ContainerArea.Paint(s, w, h)
		surface.SetDrawColor(pluto.ui.theme "InnerColorSeperator")
		surface.DrawLine(w / 2 - pad, h - 8, self.Selector:GetPos(), h - 8)
	end

	function self.ItemContainer.CanClickWith(s, other)
		local item = other.Item
		return item
	end
	function self.ItemContainer.ClickedWith(s, other)
		s:SetItem(other.Item)
	end
	function self.ItemContainer.OnRightClick(s)
		s:SetItem(nil)
	end
	function self.ItemContainer.OnLeftClick(s)
		if (not s.Item) then
			return
		end

		pluto.ui.highlight(s.Item)
	end

	function self.ItemContainer.OnSetItem(s, item)
		self:PlutoItemUpdate(item)
	end

	hook.Add("PlutoItemUpdate", self, self.PlutoItemUpdate)
	self.ContainerArea:DockMargin(0, 20, 0, 7)

	self.LoadingArea = self:Add "EditablePanel"
	self.LoadingArea:Dock(TOP)
	self.LoadingArea:SetTall(19)
	self.LoadingArea:DockMargin(0, 0, 0, 5)
	self.Loading = self.LoadingArea:Add "pluto_inventory_loading"
	self.Loading:SetVisible(false)
	function self.LoadingArea.PerformLayout(s, w, h)
		self.Loading:SetSize(h, h)
		self.Loading:Center()
	end

	self.SearchPanels = {}

	self.BetweenSearch = self:Add "EditablePanel"
	self.BetweenSearch:Dock(TOP)
	self.BetweenSearch:DockMargin(0, 0, 0, 5)
	self.BetweenSearch:SetTall(19)
	self.BetweenSearch:SetZPos(0x7ffe)

	self.BetweenStatus = self.BetweenSearch:Add "ttt_curved_panel_outline"
	self.BetweenStatus:SetCurve(4)
	self.BetweenStatus:SetColor(pluto.ui.theme "InnerColorSeperator")
	self.BetweenStatus:Dock(LEFT)
	self.BetweenStatus:DockMargin(0, 0, 5, 0)

	self.BetweenStatus.Image = self.BetweenStatus:Add "DImage"
	self.BetweenStatus.Image:Dock(FILL)
	self.BetweenStatus.Image:DockMargin(2, 2, 2, 2)
	self.BetweenStatus.Image:SetImage "icon16/cross.png"

	function self.BetweenSearch.PerformLayout(s, w, h)
		self.BetweenStatus:SetWide(h)
	end

	local betweentext = self.BetweenSearch:Add "pluto_label"
	betweentext:SetContentAlignment(4)
	betweentext:SetFont "pluto_inventory_font"
	betweentext:SetText "Stop when have at least "
	betweentext:Dock(LEFT)
	betweentext:SizeToContents()
	betweentext:SetTextColor(pluto.ui.theme "TextActive")
	betweentext:SetRenderSystem(pluto.fonts.systems.shadow)
	betweentext:DockMargin(0, 1, 0, 2)

	self.LowerBounds = self.BetweenSearch:Add "pluto_inventory_textentry"
	self.LowerBounds:DockMargin(0, 0, 3, 0)
	self.LowerBounds:SetText "1"
	self.LowerBounds:Dock(FILL)
	self.LowerBounds:SetWide(50)

	function self.LowerBounds.OnChange()
		self:PlutoItemUpdate(self.ItemContainer.Item)
	end

	self:AddSearchPanel()

	self.AddSearchButton = self:Add "EditablePanel"
	self.AddSearchButton:SetTall(19)
	self.AddSearchButton:Dock(TOP)
	self.AddSearchButton:DockMargin(0, 0, 0, 12)
	local outline = self.AddSearchButton:Add "ttt_curved_panel_outline"
	outline:SetColor(pluto.ui.theme "InnerColorSeperator")
	outline:Dock(LEFT)

	function self.AddSearchButton.PerformLayout(s, w, h)
		outline:SetWide(h)
	end

	local plus = outline:Add "pluto_label"
	plus:SetContentAlignment(5)
	plus:SetFont "pluto_inventory_font"
	plus:SetText "+"
	plus:Dock(FILL)
	plus:SetTextColor(pluto.ui.theme "TextActive")
	plus:DockMargin(0, 0, 2, 1)
	plus:SetCursor "hand"
	plus:SetMouseInputEnabled(true)
	function plus.OnMousePressed(s, m)
		if (m == MOUSE_LEFT) then
			self:AddSearchPanel()
		end
	end
	self.AddSearchButton:SetZPos(0x7ffd)

	
	self.GoButton = self:Add "pluto_inventory_button"
	self.GoButton:Dock(TOP)
	self.GoButton:SetMouseInputEnabled(true)
	self.GoButton:DockMargin(55, 12, 55, 7)
	self.GoButton:SetTall(19)
	self.GoButton:SetCurve(2)
	self.GoButton:SetColor(pluto.ui.theme "InnerColorSeperator", pluto.ui.theme "InnerColorSeperator")
	self.GoButton:SetCursor "hand"
	

	function self.GoButton.DoClick()
		self:Go()
	end

	self.GoLabel = self.GoButton:Add "pluto_label"
	self.GoLabel:Dock(FILL)
	self.GoLabel:SetRenderSystem(pluto.fonts.systems.shadow)
	self.GoLabel:SetTextColor(pluto.ui.theme "TextActive")
	self.GoLabel:SetFont "pluto_inventory_font"
	self.GoLabel:SetContentAlignment(5)
	self.GoLabel:SetText "Use currency"

	self.GoButton:SetZPos(0x7fff)
end

function PANEL:AddSearchPanel()
	local container = self:Add "EditablePanel"
	container:Dock(TOP)
	container:DockMargin(0, 0, 0, 5)

	container.Status = container:Add "ttt_curved_panel_outline"
	container.Status:SetCurve(4)
	container.Status:SetColor(pluto.ui.theme "InnerColorSeperator")
	container.Status:Dock(LEFT)
	container.Status:DockMargin(0, 0, 5, 0)
	container.Status:SetMouseInputEnabled(true)
	container.Status:SetCursor "hand"

	function container.Status.OnMousePressed()
		container:Remove()

		for i, c in pairs(self.SearchPanels) do
			if (c == container) then
				table.remove(self.SearchPanels, i)
			end
		end
	end

	container.StatusImage = container.Status:Add "DImage"
	container.StatusImage:Dock(FILL)
	container.StatusImage:DockMargin(2, 2, 2, 2)
	container.StatusImage:SetImage "icon16/cross.png"

	function container.PerformLayout(s, w, h)
		container.Status:SetWide(h)
	end


	container.Label = container:Add "pluto_inventory_textentry"
	container.Label:SetText("")
	container.Label:Dock(FILL)

	function container.Label:OnMousePressed(m)
		if (m == MOUSE_LEFT) then
			pluto.ui.pnl:SetKeyboardFocus(self, true)
			self:OpenAutoComplete(self:GetAutoComplete "")
		end
	end

	function container.Label:GetAutoComplete(text)
		local modlist = {}
	
		for _, MOD in pairs(pluto.mods.byname) do
			if (MOD.Type == "suffix" or MOD.Type == "prefix") then
				table.insert(modlist, MOD:GetPrintName())
			end
		end

		table.sort(modlist)

		for i = #modlist, 1, -1 do
			if (not modlist[i]:lower():find(text:lower(), 1, true)) then
				table.remove(modlist, i)
			end
		end
	
		return modlist
	end

	function container.Label.OnChange()
		self:PlutoItemUpdate(self.ItemContainer.Item)
	end

	container:SetTall(19)

	container.Tier = container:Add "pluto_inventory_textentry"
	container.Tier:SetText("")
	container.Tier:Dock(RIGHT)

	local text = container:Add "pluto_label"
	text:SetContentAlignment(5)
	text:SetFont "pluto_inventory_font"
	text:SetTextColor(pluto.ui.theme "TextActive")
	text:SetText " with tier <= "
	text:SetRenderSystem(pluto.fonts.systems.shadow)
	text:Dock(RIGHT)
	text:SizeToContentsX()
	function container.Tier:OnMousePressed(m)
		if (m == MOUSE_LEFT) then
			pluto.ui.pnl:SetKeyboardFocus(self, true)
			self:OpenAutoComplete(self:GetAutoComplete "")
		end
	end

	function container.Label.OnFocusChanged(s, gained)
		if (not gained) then
			pluto.ui.pnl:SetKeyboardFocus(s, false)
		end
	end

	function container.Label.OnChange()
		self:PlutoItemUpdate(self.ItemContainer.Item)
	end

	container:SetZPos(#self.SearchPanels)

	table.insert(self.SearchPanels, container)

	self:PlutoItemUpdate(self.ItemContainer.Item)
end

function PANEL:GetWants(justtext)
	local wants = {}
	for _, search in ipairs(self.SearchPanels) do
		local tier = ""
		if (search.Tier:GetText() ~= "") then
			tier = " " .. search.Tier:GetText()
		end
		table.insert(wants, justtext and search.Label:GetText() .. tier or {search, search.Label:GetText() .. tier})
	end

	return wants
end

function PANEL:PlutoItemUpdate(item)
	if (not self.ItemContainer.Item or self.ItemContainer.Item ~= item) then
		return
	end

	local has = {}

	for type, modlist in pairs(item.Mods) do
		for _, mod in ipairs(modlist) do
			local MOD = pluto.mods.byname[mod.Mod]
			table.insert(has, {lazy = true, MOD:GetPrintName()})
			table.insert(has, MOD:GetPrintName() .. " " .. mod.Tier)
			table.insert(has, MOD:GetTierName(mod.Tier))
		end
	end

	local gotten = 0

	for _, data in ipairs(self:GetWants()) do
		local container = data[1]
		local text = data[2]:lower()
		local found = false

		for _, what in ipairs(has) do
			local lazy = false
			if (istable(what)) then
				lazy = what.lazy
				what = what[1]
			end

			what = what:lower()

			if (not lazy) then
				if (what == text) then
					found = true
					break
				end
			else
				if (what:find(text, 1, true)) then
					found = true
					break
				end
			end
		end

		gotten = gotten + (found and 1 or 0)

		container.StatusImage:SetImage(found and "icon16/tick.png" or "icon16/cross.png")
	end

	local mins, maxs = tonumber(self.LowerBounds:GetText()) or -math.huge, math.huge

	self.BetweenStatus.Image:SetImage(gotten >= mins and gotten <= maxs and "icon16/tick.png" or "icon16/cross.png")

	self.Status = gotten >= mins and gotten <= maxs

	self:TryContinue()
end

function PANEL:TryContinue()
	if (not self.Going) then
		return
	end

	if (self.Status) then
		self:Go(false)
		return
	end

	local item = self.ItemContainer.Item

	if (not item) then
		self:Go(false)
		return
	end

	local currency, amount = self.Selector:GetCurrency()
	if (not amount or not currency or amount <= 0) then
		self:Go(false)
		return
	end

	local mins, maxs = tonumber(self.LowerBounds:GetText()) or 0, 0xff
	self.Selector:SetAmount(math.max(0, amount - 50))
	pluto.inv.message()
		:write("masscurrencyuse", currency.InternalName, item, amount, self:GetWants(true), mins, maxs)
		:send()
end

function PANEL:Go(b)
	if (b ~= nil) then
		self.Going = b
	else
		self.Going = not self.Going
	end
	self.Loading:SetVisible(self.Going)

	self:TryContinue()
end

vgui.Register("pluto_inventory_crafting_currency", PANEL, "DScrollPanel")

function pluto.inv.writemasscurrencyuse(cur, item, amount, searches, mins, maxs)
	net.WriteString(cur)
	net.WriteUInt(item.ID, 32)
	net.WriteUInt(amount, 32)

	net.WriteUInt(math.min(256, #searches), 8)
	for i = 1, math.min(256, #searches) do
		net.WriteString(searches[i])
	end

	net.WriteUInt(mins, 8)
	net.WriteUInt(maxs, 8)
end