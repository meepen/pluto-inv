local PANEL = {}

PANEL.ResultRow = 6
PANEL.ResultColumn = 6
PANEL.Padding = 3

function PANEL:Init()
	self.ResultArea = self:Add "EditablePanel"
	self.ResultArea:Dock(RIGHT)
	self.ResultArea:SetWide(self.ResultColumn * 56 + (self.ResultColumn - 1) * self.Padding)

	self.ItemArea = self.ResultArea:Add "EditablePanel"
	self.ItemArea:SetTall(self.ResultRow * 56 + (self.ResultRow + 1) * self.Padding)
	self.ItemArea:SetZPos(1)
	self.ItemArea:Dock(TOP)

	self.Results = {}
	self.ResultPrices = {}

	for y = 1, self.ResultRow do
		local row = self.ItemArea:Add "EditablePanel"
		row:Dock(TOP)
		row:DockMargin(0, y == 1 and self.Padding or 0, 0, self.Padding)
		row:SetTall(56)

		for x = 1, self.ResultColumn do
			local itempnl = row:Add "pluto_inventory_item"
			itempnl:Dock(LEFT)
			itempnl:SetWide(56)
			itempnl:DockMargin(x == 1 and 0 or self.Padding, 0, 0, 0)
			table.insert(self.Results, itempnl)

			local container = itempnl.ItemPanel:Add "ttt_curved_panel_outline"
			container:SetCurve(4)
			container:SetColor(Color(95, 96, 102))
			container:Dock(BOTTOM)

			local container_fill = container:Add "ttt_curved_panel"
			container_fill:SetCurve(4)
			container_fill:Dock(FILL)
			container_fill:SetColor(Color(52, 51, 52))

			local price = container_fill:Add "pluto_label"
			price:Dock(FILL)
			price:SetText "0"
			price:SetContentAlignment(6)
			price:SetFont "pluto_inventory_font"
			price:SetTextColor(Color(255, 255, 255))
			price:SetRenderSystem(pluto.fonts.systems.shadow)
			price:SizeToContentsY()
			price:SetVisible(false)

			container:SetTall(price:GetTall())

			local img = container_fill:Add "DImage"
			img:SetImage(pluto.currency.byname.stardust.Icon)
			img:Dock(RIGHT)
			function img.PerformLayout(s, w, h)
				img:SetWide(h)
			end

			table.insert(self.ResultPrices, price)
		end
	end

	self.Pagination = self.ResultArea:Add "EditablePanel"
	self.Pagination:Dock(FILL)
	self.Pagination:DockMargin(0, 0, 0, self.Padding)

	self.PaginationLabel = self.Pagination:Add "pluto_label"
	self.PaginationLabel:SetFont "pluto_inventory_font"
	self.PaginationLabel:SetRenderSystem(pluto.fonts.systems.shadow)
	self.PaginationLabel:SetText "hi"
	self.PaginationLabel:SetTextColor(Color(255, 255, 255))
	self.PaginationLabel:SetContentAlignment(5)

	self.PageDown = self.Pagination:Add "pluto_label"
	self.PageDown:SetCursor "hand"
	self.PageDown:SetMouseInputEnabled(true)
	self.PageDown:SetFont "pluto_inventory_font"
	self.PageDown:SetRenderSystem(pluto.fonts.systems.shadow)
	self.PageDown:SetText "<<"
	self.PageDown:SetTextColor(Color(255, 255, 255))
	self.PageDown:SetContentAlignment(5)
	function self.PageDown.OnMousePressed()
		local page = self:GetPage() - 1
		if (page < 1) then
			return
		end
		self:SearchPage(page)
	end


	self.PageUp = self.Pagination:Add "pluto_label"
	self.PageUp:SetCursor "hand"
	self.PageUp:SetMouseInputEnabled(true)
	self.PageUp:SetFont "pluto_inventory_font"
	self.PageUp:SetRenderSystem(pluto.fonts.systems.shadow)
	self.PageUp:SetText ">>"
	self.PageUp:SetTextColor(Color(255, 255, 255))
	self.PageUp:SetContentAlignment(5)

	function self.PageUp.OnMousePressed()
		local page = self:GetPage() + 1
		if (page > self:GetPageMax()) then
			return
		end
		self:SearchPage(page)
	end

	function self.Pagination.PerformLayout()
		self.PaginationLabel:Center()
		self.PageDown:SetTall(self.PaginationLabel:GetTall())
		self.PageUp:SetTall(self.PaginationLabel:GetTall())
		local x, y = self.PaginationLabel:GetPos()
		self.PageDown:SetPos(x - self.PageDown:GetWide() - self.Padding, y)
		self.PageUp:SetPos(x + self.PaginationLabel:GetWide() + self.Padding, y)
		self.SearchAreaContainer:DockMargin(0, self.Padding, self.Padding * 4, self.Pagination:GetTall() + self.Padding * 2)
	end

	self.SearchAreaContainer = self:Add "ttt_curved_panel_outline"
	self.SearchAreaContainer:Dock(FILL)
	self.SearchAreaContainer:SetColor(Color(95, 96, 102))
	self.SearchAreaContainer:SetCurve(4)
	self.SearchAreaContainer:DockPadding(self.Padding + 1, self.Padding + 1, self.Padding + 1, self.Padding + 1)

	self.SearchArea = self.SearchAreaContainer:Add "pluto_inventory_auction_search"
	self.SearchArea:Dock(FILL)
	function self.SearchArea.StartNewSearch()
		self:StartNewSearch()
	end
	self.WeaponSearchArea = self.SearchArea:AddTab "Weapon"

	local type = self.WeaponSearchArea:Add "pluto_inventory_auction_search_dropdown"
	type:SetText "Choose weapon type:"
	type:AddOption "Any"
	type:AddOption "Primary"
	type:AddOption "Secondary"
	type:AddOption "Melee"
	type:AddOption "Grenade"
	type:Dock(TOP)
	
	local ammotype = self.WeaponSearchArea:Add "pluto_inventory_auction_search_dropdown"
	ammotype:SetText "Choose ammo type:"
	ammotype:AddOption "Any"
	ammotype:AddOption "Sniper"
	ammotype:AddOption "Pistol"
	ammotype:AddOption "SMG"
	ammotype:AddOption "None"
	ammotype:Dock(TOP)

	local mod_count = self.WeaponSearchArea:Add "pluto_inventory_auction_search_input_two"
	mod_count:Dock(TOP)
	mod_count:SetText "Maximum mods:"

	local current_mods = self.WeaponSearchArea:Add "pluto_inventory_auction_search_input_two"
	current_mods:Dock(TOP)
	current_mods:SetText "Current mods:"

	local current_suffixes = self.WeaponSearchArea:Add "pluto_inventory_auction_search_input_two"
	current_suffixes:Dock(TOP)
	current_suffixes:SetText "Current suffixes:"

	local current_prefixes = self.WeaponSearchArea:Add "pluto_inventory_auction_search_input_two"
	current_prefixes:Dock(TOP)
	current_prefixes:SetText "Current prefixes:"

	self.WeaponSearchArea:InvalidateChildren(true)
	self.WeaponSearchArea:SizeToChildren(false, true)

	self.SearchArea:AddTab "Model"

	self.ShardSearch = self.SearchArea:AddTab "Shard"

	local mod_count = self.ShardSearch:Add "pluto_inventory_auction_search_input_two"
	mod_count:Dock(TOP)
	mod_count:SetText "Maximum mods:"
	self.ShardSearch:InvalidateChildren(true)
	self.ShardSearch:SizeToChildren(false, true)

	self:SetPageMax(0)
	self:SetPage(0)

	hook.Add("PlutoReceiveAuctionData", self, self.PlutoReceiveAuctionData)
end

function PANEL:PlutoReceiveAuctionData(items, pages)
	self:SetPageMax(pages)

	for i = 1, 36 do
		local item = items[i]
		self.Results[i]:SetItem(item)
		local price = self.ResultPrices[i]

		price:SetVisible(item)
		if (item) then
			price:SetText(item.Price)
		end
	end
end

function PANEL:UpdatePages()
	if (not self.Page or not self.PageMax) then
		return
	end

	self.PaginationLabel:SetText(string.format("Page %i / %i", self.Page, self.PageMax))
	self.PaginationLabel:SizeToContents()
	self.PaginationLabel:Center()

	self.PageDown:SetVisible(self.Page > 1)
	self.PageUp:SetVisible(self.Page < self.PageMax)
end

function PANEL:SetPageMax(max)
	self.PageMax = max
	self:UpdatePages()
end

function PANEL:GetPageMax()
	return self.PageMax
end

function PANEL:SearchPage(page)
	self:SetPage(page)
	self:SendSearch()
end

function PANEL:SetPage(num)
	self.Page = num
	self:UpdatePages()
end

function PANEL:GetPage()
	return self.Page
end

function PANEL:StartNewSearch()
	self.Parameters = self.SearchArea:GetCurrentSearchParameters()

	self:SearchPage(1)
end

function PANEL:SendSearch()
	pluto.inv.message()
		:write("auctionsearch", self:GetPage(), self.Parameters)
		:send()
end

vgui.Register("pluto_inventory_auction", PANEL, "EditablePanel")

local PANEL = {}

PANEL.Padding = 3
PANEL.InactiveColor = Color(55, 54, 55)
PANEL.ActiveColor = Color(50, 168, 82)

function PANEL:Init()
	self.Tabs = {}
	self.Labels = {}
	self.Cache = vgui.Create "EditablePanel"
	self.Cache:SetVisible(false)

	self.ButtonArea = self:Add "EditablePanel"
	self.ButtonArea:Dock(TOP)
	self.ButtonArea:DockMargin(0, 0, 0, self.Padding)

	self.TabArea = self:Add "DScrollPanel"
	self.TabArea:Dock(FILL)
	self.TabArea:DockMargin(self.Padding, self.Padding * 2, self.Padding, self.Padding)

	self.SearchButtonContainer = self:Add "EditablePanel"
	self.SearchButtonContainer:Dock(BOTTOM)
	self.SearchButtonContainer:SetTall(22)

	self.SearchButton = self.SearchButtonContainer:Add "pluto_inventory_button"
	self.SearchButton:SetColor(Color(95, 96, 102), Color(95, 96, 102))
	self.SearchButton:SetCurve(4)
	self.SearchButton:SetWide(120)
	self.SearchLabel = self.SearchButton:Add "pluto_label"
	self.SearchLabel:SetRenderSystem(pluto.fonts.systems.shadow)
	self.SearchLabel:SetText "Update search"
	self.SearchLabel:SetTextColor(Color(255, 255, 255))
	self.SearchLabel:SetContentAlignment(5)
	self.SearchLabel:SetFont "pluto_inventory_font"
	self.SearchLabel:Dock(FILL)
	function self.SearchButtonContainer.PerformLayout(s, w, h)
		self.SearchButton:SetTall(h)
		self.SearchButton:Center()
	end
	function self.SearchButton.DoClick()
		self:StartNewSearch()
	end
	
	self.SortBy = self.TabArea:Add "pluto_inventory_auction_search_dropdown"
	self.SortBy:Dock(TOP)
	self.SortBy:SetText "Sort by:"
	self.SortBy:AddOption "Newest to Oldest"
	self.SortBy:AddOption "Oldest to Newest"
	self.SortBy:AddOption "ID Low to High"
	self.SortBy:AddOption "ID High to Low"
	self.SortBy:AddOption "Price Low to High"
	self.SortBy:AddOption "Price High to Low"

	self.Price = self.TabArea:Add "pluto_inventory_auction_search_input_two"
	self.Price:Dock(TOP)
	self.Price:SetText "Price:"

	self.ItemID = self.TabArea:Add "pluto_inventory_auction_search_input_two"
	self.ItemID:Dock(TOP)
	self.ItemID:SetText "Item ID:"

	self.ItemName = self.TabArea:Add "pluto_inventory_auction_search_input"
	self.ItemName:Dock(TOP)
	self.ItemName:SetText "Item name:"

	self.Parameters = {}

	local function update(s, what, ...)
		self.Parameters[what] = {n = select("#", ...), ...}
		self:OnSearchUpdated()
	end
	
	hook.Add("PlutoSearchChanged", self.SortBy, update)
	hook.Add("PlutoSearchChanged", self.ItemID, update)
	hook.Add("PlutoSearchChanged", self.Price, update)
	hook.Add("PlutoSearchChanged", self.ItemName, update)
end

function PANEL:AddTab(name)
	local btn = self.ButtonArea:Add "pluto_inventory_button"
	btn:Dock(LEFT)
	btn:SetCurve(4)
	btn:SetColor(self.InactiveColor, Color(95, 96, 102))

	function btn.DoClick()
		self:SelectTab(name)
	end

	local lbl = btn:Add "pluto_label"
	lbl:SetFont "pluto_inventory_font_lg"
	lbl:SetRenderSystem(pluto.fonts.systems.shadow)
	lbl:SetText(name)
	lbl:Dock(FILL)
	lbl:SetTextColor(Color(255, 255, 255))
	lbl:SetContentAlignment(5)

	table.insert(self.Labels, btn)

	local tab = self.Cache:Add "EditablePanel"
	tab:Dock(TOP)
	tab:SetVisible(false)
	tab:SetTall(0)
	self.Tabs[name] = {
		Panel = tab,
		Label = btn,
		Parameters = {},
	}

	function tab.OnChildAdded(child)
		hook.Add("PlutoSearchChanged", child, function(s, what, ...)
			self:OnSearchChanged(what, ...)
		end)
	end

	if (not self.ActiveTab) then
		self:SelectTab(name)
	end

	return tab
end

function PANEL:SelectTab(name)
	if (self.ActiveTab) then
		local tab = self.Tabs[self.ActiveTab]
		tab.Panel:SetParent(self.Cache)
		tab.Panel:SetVisible(false)
		tab.Label:SetColor(self.InactiveColor, Color(95, 96, 102))
	end
	local tab = self.Tabs[name]
	self.ActiveTab = name
	tab.Panel:SetParent(self.TabArea)
	tab.Panel:SetVisible(true)
	tab.Label:SetColor(self.ActiveColor, Color(95, 96, 102))
end

function PANEL:PerformLayout(w, h)
	local labelcount = #self.Labels
	local btnw = w - self.Padding * (labelcount + 1)
	self.Labels[labelcount]:Dock(FILL)

	for i = 1, labelcount - 1 do
		local label = self.Labels[i]
		label:SetWide(btnw / labelcount)
		label:DockMargin(0, 0, self.Padding, 0)
	end
end

function PANEL:OnSearchChanged(what, ...)
	local tab = self.Tabs[self.ActiveTab].Parameters
	tab[what] = {n = select("#", ...), ...}

	self:OnSearchUpdated()
end

function PANEL:GetCurrentSearchParameters()
	local params = {}
	for what, param in pairs(self.Tabs[self.ActiveTab].Parameters) do
		params[what] = param
	end

	for what, param in pairs(self.Parameters) do
		params[what] = param
	end

	params.what = {n = 1, self.ActiveTab}

	return params
end

function PANEL:StartNewSearch()
end

function PANEL:OnSearchUpdated()
	-- something?
end

function PANEL:OnRemove()
	self.Cache:Remove()
end

vgui.Register("pluto_inventory_auction_search", PANEL, "EditablePanel")

local PANEL = {}

function PANEL:Init()
	self.Label = self:Add "pluto_label"
	self.Label:SetText "text"
	self.Label:Dock(FILL)
	self.Label:SetFont "pluto_inventory_font"
	self.Label:SetRenderSystem(pluto.fonts.systems.shadow)
	self.Label:SetTextColor(Color(255, 255, 255))
	self.Label:SetContentAlignment(4)

	self:DockMargin(0, 0, 0, 3)

	self.Label:SizeToContentsY()
	self:SetTall(self.Label:GetTall() + 4)
end

function PANEL:SetText(text)
	self.Label:SetText(text)
end

function PANEL:GetText()
	return self.Label:GetText()
end

function PANEL:OnChanged(...)
	hook.Run("PlutoSearchChanged", self:GetText(), ...)
end

vgui.Register("pluto_inventory_auction_search_base", PANEL, "EditablePanel")

local PANEL = {}

function PANEL:Init()
	self.Dropdown = self:Add "pluto_dropdown"
	self.Dropdown:Dock(RIGHT)
	self.Dropdown:SetWide(120)
end

function PANEL:AddOption(what)
	self.Dropdown:AddOption(what, function()
		self:OnChanged(what)
	end)
end

vgui.Register("pluto_inventory_auction_search_dropdown", PANEL, "pluto_inventory_auction_search_base")

local PANEL = {}

function PANEL:Init()
	self.TextEntry = self:Add "DTextEntry"
	self.TextEntry:Dock(RIGHT)
	self.TextEntry:SetWide(120)
	self.TextEntry:SetFont "pluto_inventory_font"

	function self.TextEntry.OnMousePressed(s, m)
		if (m == MOUSE_LEFT) then
			pluto.ui.pnl:SetKeyboardFocus(s, true)
		elseif (m == MOUSE_RIGHT) then
			s:SetText ""
			self:OnUpdated()
		end
	end

	function self.TextEntry.OnEnter(s)
		self:OnUpdated()
		pluto.ui.pnl:SetKeyboardFocus(s, false)
	end

	function self.TextEntry.OnFocusChanged(s, gained)
		if (not gained) then
			self:OnUpdated()
			pluto.ui.pnl:SetKeyboardFocus(s, false)
		end
	end
end

function PANEL:OnUpdated()
	self:OnChanged(self.TextEntry:GetText())
end

vgui.Register("pluto_inventory_auction_search_input", PANEL, "pluto_inventory_auction_search_base")

local PANEL = {}

function PANEL:Init()
	self.TextEntry2 = self:Add "DTextEntry"
	self.TextEntry2:Dock(RIGHT)
	self.TextEntry2:SetWide(55)
	self.TextEntry2:SetUpdateOnType(true)
	self.TextEntry2:SetFont "pluto_inventory_font"
	
	function self.TextEntry2.OnMousePressed(s, m)
		if (m == MOUSE_LEFT) then
			pluto.ui.pnl:SetKeyboardFocus(s, true)
		elseif (m == MOUSE_RIGHT) then
			s:SetText ""
			self:OnUpdated()
		end
	end

	function self.TextEntry2.OnEnter(s)
		self:OnUpdated()
		pluto.ui.pnl:SetKeyboardFocus(s, false)
	end

	function self.TextEntry2.OnFocusChanged(s, gained)
		if (not gained) then
			self:OnUpdated()
			pluto.ui.pnl:SetKeyboardFocus(s, false)
		end
	end

	self.To = self:Add "pluto_label"
	self.To:SetContentAlignment(5)
	self.To:SetText "-"
	self.To:SetFont "pluto_inventory_font"
	self.To:SetTextColor(Color(255, 255, 255))
	self.To:SetRenderSystem(pluto.fonts.systems.shadow)
	self.To:SetWide(10)
	self.To:Dock(RIGHT)

	self.TextEntry1 = self:Add "DTextEntry"
	self.TextEntry1:Dock(RIGHT)
	self.TextEntry1:SetWide(55)
	self.TextEntry1:SetFont "pluto_inventory_font"

	function self.TextEntry1.OnMousePressed(s, m)
		if (m == MOUSE_LEFT) then
			pluto.ui.pnl:SetKeyboardFocus(s, true)
		elseif (m == MOUSE_RIGHT) then
			s:SetText ""
			self:OnUpdated()
		end
	end

	function self.TextEntry1.OnEnter(s)
		self:OnUpdated()
		pluto.ui.pnl:SetKeyboardFocus(s, false)
	end

	function self.TextEntry1.OnFocusChanged(s, gained)
		if (not gained) then
			self:OnUpdated()
			pluto.ui.pnl:SetKeyboardFocus(s, false)
		end
	end
end

function PANEL:OnUpdated()
	self:OnChanged(self.TextEntry1:GetText(), self.TextEntry2:GetText())
end

vgui.Register("pluto_inventory_auction_search_input_two", PANEL, "pluto_inventory_auction_search_base")