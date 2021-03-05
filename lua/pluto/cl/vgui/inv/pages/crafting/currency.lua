local PANEL = {}

function PANEL:Init()
	self.ContainerArea = self:Add "EditablePanel"
	self.ContainerArea:Dock(TOP)
	self.ContainerArea:SetTall(56)

	self.ItemContainer = self.ContainerArea:Add "pluto_inventory_item"

	self.Selector = self.ContainerArea:Add "pluto_inventory_currency_selector"

	self.Selector:SetCurrencyFilter(function(cur)
		return cur.AllowMass
	end)

	self.Selector:AcceptAmount(true)
	self.Selector:AcceptInput(true)
	self.Selector:SetTall(56)
	self.Selector:InvalidateLayout(true)

	function self.Selector:OnCurrencyUpdated()
		if (IsValid(pluto.ui.pnl)) then
			pluto.ui.pnl:ChangeToTab "Crafting"
		end
	end

	local pad = 14
	function self.ContainerArea.PerformLayout(s, w, h)
		self.ItemContainer:SetPos(w / 2 - self.ItemContainer:GetWide() - pad / 2, 0)
		self.Selector:SetPos(w / 2 + pad / 2, 0)
	end

	function self.ContainerArea.Paint(s, w, h)
		surface.SetDrawColor(95, 96, 102)
		surface.DrawLine(w / 2 - pad, h / 2, w / 2, h / 2)
		surface.DrawLine(w / 2, h / 2, w / 2, h - 8)
		surface.DrawLine(w / 2, h - 8, self.Selector:GetPos(), h - 8)
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
	self.ContainerArea:DockMargin(0, 0, 0, 7)

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
	self.BetweenStatus:SetColor(Color(95, 96, 102))
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
	betweentext:SetText "Stop when between "
	betweentext:Dock(LEFT)
	betweentext:SizeToContents()
	betweentext:SetTextColor(Color(255, 255, 255))
	betweentext:SetRenderSystem(pluto.fonts.systems.shadow)
	betweentext:DockMargin(0, 1, 0, 2)

	self.LowerBounds = self.BetweenSearch:Add "ttt_curved_panel_outline"
	self.LowerBounds:SetCurve(4)
	self.LowerBounds:SetColor(Color(95, 96, 102))
	self.LowerBounds:Dock(LEFT)
	self.LowerBounds:SetWide(50)

	self.LowerBounds.Label = self.LowerBounds:Add "DTextEntry"
	self.LowerBounds.Label:DockMargin(0, 0, 3, 0)
	self.LowerBounds.Label:SetFont "pluto_inventory_font"
	self.LowerBounds.Label:SetText "1"
	self.LowerBounds.Label:Dock(FILL)
	self.LowerBounds.Label:SetTextColor(Color(255, 255, 255))
	self.LowerBounds.Label:SetPaintBackground(false)
	self.LowerBounds.Label:SetMouseInputEnabled(true)

	function self.LowerBounds.Label.OnChange()
		self:PlutoItemUpdate(self.ItemContainer.Item)
	end

	function self.LowerBounds.Label:OnMousePressed(m)
		if (m == MOUSE_LEFT) then
			pluto.ui.pnl:SetKeyboardFocus(self, true)
		end
	end

	function self.LowerBounds.Label.OnFocusChanged(s, gained)
		if (not gained) then
			pluto.ui.pnl:SetKeyboardFocus(s, false)
		end
	end

	local andtext = self.BetweenSearch:Add "pluto_label"
	andtext:SetContentAlignment(4)
	andtext:SetFont "pluto_inventory_font"
	andtext:SetText " and "
	andtext:Dock(LEFT)
	andtext:SizeToContents()
	andtext:SetTextColor(Color(255, 255, 255))
	andtext:SetRenderSystem(pluto.fonts.systems.shadow)
	andtext:DockMargin(0, 1, 0, 2)

	self.UpperBounds = self.BetweenSearch:Add "ttt_curved_panel_outline"
	self.UpperBounds:SetCurve(4)
	self.UpperBounds:SetColor(Color(95, 96, 102))
	self.UpperBounds:Dock(LEFT)
	self.UpperBounds:SetWide(50)

	self.UpperBounds.Label = self.UpperBounds:Add "DTextEntry"
	self.UpperBounds.Label:DockMargin(0, 0, 3, 0)
	self.UpperBounds.Label:SetFont "pluto_inventory_font"
	self.UpperBounds.Label:SetText "1"
	self.UpperBounds.Label:Dock(FILL)
	self.UpperBounds.Label:SetTextColor(Color(255, 255, 255))
	self.UpperBounds.Label:SetPaintBackground(false)
	self.UpperBounds.Label:SetMouseInputEnabled(true)

	function self.UpperBounds.Label:OnMousePressed(m)
		if (m == MOUSE_LEFT) then
			pluto.ui.pnl:SetKeyboardFocus(self, true)
		end
	end

	function self.UpperBounds.Label.OnFocusChanged(s, gained)
		if (not gained) then
			pluto.ui.pnl:SetKeyboardFocus(s, false)
		end
	end

	function self.UpperBounds.Label.OnChange()
		self:PlutoItemUpdate(self.ItemContainer.Item)
	end

	self:AddSearchPanel "Damage"

	self.AddSearchButton = self:Add "EditablePanel"
	self.AddSearchButton:SetTall(19)
	self.AddSearchButton:Dock(TOP)
	self.AddSearchButton:DockMargin(0, 0, 0, 12)
	local outline = self.AddSearchButton:Add "ttt_curved_panel_outline"
	outline:SetColor(Color(95, 96, 102))
	outline:Dock(LEFT)

	function self.AddSearchButton.PerformLayout(s, w, h)
		outline:SetWide(h)
	end

	local plus = outline:Add "pluto_label"
	plus:SetContentAlignment(5)
	plus:SetFont "pluto_inventory_font"
	plus:SetText "+"
	plus:Dock(FILL)
	plus:SetTextColor(Color(255, 255, 255))
	plus:DockMargin(0, 0, 2, 1)
	plus:SetCursor "hand"
	plus:SetMouseInputEnabled(true)
	function plus.OnMousePressed(s, m)
		if (m == MOUSE_LEFT) then
			self:AddSearchPanel "Damage 1"
		end
	end
	self.AddSearchButton:SetZPos(0x7ffd)

	
	self.GoButtonShadow = self:Add "ttt_curved_panel"
	self.GoButtonShadow:Dock(TOP)
	self.GoButtonShadow:SetMouseInputEnabled(true)
	self.GoButtonShadow:DockMargin(55, 7, 55, 7)
	self.GoButtonShadow:SetTall(19)
	self.GoButtonShadow:SetCurve(2)
	self.GoButtonShadow:SetColor(Color(50, 51, 58))
	self.GoButtonShadow:SetCursor "hand"
	
	self.GoButton = self.GoButtonShadow:Add "ttt_curved_panel_outline"
	self.GoButton:Dock(FILL)
	self.GoButton:SetMouseInputEnabled(false)
	self.GoButton:DockMargin(0, 0, 0, 1)
	self.GoButton:SetTall(18)
	self.GoButton:SetCurve(2)
	self.GoButton:SetColor(Color(121, 121, 121))

	self.GoButtonInner = self.GoButton:Add "ttt_curved_panel"
	self.GoButtonInner:Dock(FILL)
	self.GoButtonInner:SetCurve(2)
	self.GoButtonInner:DockMargin(1, 1, 1, 1)
	self.GoButtonInner:SetColor(Color(95, 96, 102))

	function self.GoButtonShadow.OnMousePressed(s, m)
		if (m == MOUSE_LEFT) then
			self:Go()
		end
	end

	self.GoLabel = self.GoButton:Add "pluto_label"
	self.GoLabel:Dock(FILL)
	self.GoLabel:SetRenderSystem(pluto.fonts.systems.shadow)
	self.GoLabel:SetTextColor(Color(255, 255, 255))
	self.GoLabel:SetFont "pluto_inventory_font"
	self.GoLabel:SetContentAlignment(5)
	self.GoLabel:SetText "Use currency"

	self.GoButtonShadow:SetZPos(0x7fff)
end

function PANEL:AddSearchPanel(text)
	local container = self:Add "EditablePanel"
	container:Dock(TOP)
	container:DockMargin(0, 0, 0, 5)

	container.Status = container:Add "ttt_curved_panel_outline"
	container.Status:SetCurve(4)
	container.Status:SetColor(Color(95, 96, 102))
	container.Status:Dock(LEFT)
	container.Status:DockMargin(0, 0, 5, 0)

	container.StatusImage = container.Status:Add "DImage"
	container.StatusImage:Dock(FILL)
	container.StatusImage:DockMargin(2, 2, 2, 2)
	container.StatusImage:SetImage "icon16/cross.png"

	function container.PerformLayout(s, w, h)
		container.Status:SetWide(h)
	end

	local labelcontainer = container:Add "ttt_curved_panel_outline"
	labelcontainer:SetCurve(4)
	labelcontainer:SetColor(Color(95, 96, 102))
	labelcontainer:Dock(FILL)

	container.Label = labelcontainer:Add "DTextEntry"
	container.Label:SetFont "pluto_inventory_font"
	container.Label:SetText(text)
	container.Label:SetTextColor(Color(255, 255, 255))
	container.Label:SetPaintBackground(false)

	function container.Label:OnMousePressed(m)
		if (m == MOUSE_LEFT) then
			pluto.ui.pnl:SetKeyboardFocus(self, true)
			self:OpenAutoComplete(self:GetAutoComplete "")
		end
	end

	function container.Label:GetAutoComplete(text)
		return pluto.mods.networkednames
	end

	function container.Label.OnFocusChanged(s, gained)
		if (not gained) then
			pluto.ui.pnl:SetKeyboardFocus(s, false)
		end
	end

	function container.Label.OnChange()
		self:PlutoItemUpdate(self.ItemContainer.Item)
	end

	container.Label:SizeToContentsY()
	container:SetTall(19)
	container.Label:DockMargin(5, 1, 0, 2)
	container.Label:Dock(FILL)
	container.Label:SetMouseInputEnabled(true)

	container:SetZPos(#self.SearchPanels)

	table.insert(self.SearchPanels, container)

	self:PlutoItemUpdate(self.ItemContainer.Item)
end

function PANEL:GetWants(justtext)
	local wants = {}
	for _, search in ipairs(self.SearchPanels) do
		table.insert(wants, justtext and search.Label:GetText() or {search, search.Label:GetText()})
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

	local mins, maxs = tonumber(self.LowerBounds.Label:GetText()) or -math.huge, tonumber(self.UpperBounds.Label:GetText()) or math.huge

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

	local mins, maxs = tonumber(self.LowerBounds.Label:GetText()) or 0, tonumber(self.UpperBounds.Label:GetText()) or 0xff
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