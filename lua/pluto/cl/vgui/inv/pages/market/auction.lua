local PANEL = {}

PANEL.ResultRow = 6
PANEL.ResultColumn = 6
PANEL.Padding = 3

function PANEL:Init()
	self.ResultArea = self:Add "EditablePanel"
	self.ResultArea:Dock(RIGHT)
	self.ResultArea:SetWide(self.ResultColumn * 56 + (self.ResultColumn + 1) * self.Padding)

	self.ItemArea = self.ResultArea:Add "EditablePanel"
	self.ItemArea:SetTall(self.ResultRow * 56 + (self.ResultRow + 1) * self.Padding)
	self.ItemArea:SetZPos(1)
	self.ItemArea:Dock(TOP)

	self.Results = {}

	for y = 1, self.ResultRow do
		local row = self.ItemArea:Add "EditablePanel"
		row:Dock(TOP)
		row:DockMargin(0, y == 1 and self.Padding or 0, 0, self.Padding)
		row:SetTall(56)

		for x = 1, self.ResultColumn do
			local itempnl = row:Add "pluto_inventory_item"
			itempnl:Dock(LEFT)
			itempnl:SetWide(56)
			itempnl:DockMargin(x == 1 and self.Padding or 0, 0, self.Padding, 0)
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

	function self.Pagination.PerformLayout()
		self.PaginationLabel:Center()
		self.SearchArea:DockMargin(0, self.Padding + 1, self.Padding * 2, self.Pagination:GetTall() + self.Padding + 1)
	end

	self.SearchArea = self:Add "pluto_inventory_auction_search"
	self.SearchArea:Dock(FILL)
	self.WeaponSearchArea = self.SearchArea:AddTab "Weapon"

	local type = self.WeaponSearchArea:Add "pluto_inventory_auction_search_dropdown"
	type:SetText "Choose weapon type: "
	type:AddOption "Any"
	type:AddOption "Primary"
	type:AddOption "Secondary"
	type:AddOption "Melee"
	type:AddOption "Grenade"
	type:Dock(TOP)
	
	local ammotype = self.WeaponSearchArea:Add "pluto_inventory_auction_search_dropdown"
	ammotype:SetText "Choose ammo type: "
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

	self:SetPageInfo(0, 0)
end

function PANEL:SetPageInfo(num, max)
	self.PaginationLabel:SetText(string.format("Page %i / %i", num, max))
	self.PaginationLabel:SizeToContents()
	self.PaginationLabel:Center()
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

	self.TabArea = self:Add "EditablePanel"
	self.TabArea:Dock(FILL)
	self.TabArea:DockPadding(self.Padding, self.Padding * 2, self.Padding, self.Padding)
	
	self.SortBy = self.TabArea:Add "pluto_inventory_auction_search_dropdown"
	self.SortBy:Dock(TOP)
	self.SortBy:SetText "Sort by:"
	self.SortBy:AddOption "Newest to Oldest"
	self.SortBy:AddOption "Oldest to Newest"
	self.SortBy:AddOption "ID Low to High"
	self.SortBy:AddOption "ID High to Low"
	self.SortBy:AddOption "Price Low to High"
	self.SortBy:AddOption "Price High to Low"

	self.ItemID = self.TabArea:Add "pluto_inventory_auction_search_input_two"
	self.ItemID:Dock(TOP)
	self.ItemID:SetText "Item ID:"

	self.ItemName = self.TabArea:Add "pluto_inventory_auction_search_input"
	self.ItemName:Dock(TOP)
	self.ItemName:SetText "Item name:"
end

function PANEL:AddTab(name)
	local btn = self.ButtonArea:Add "pluto_inventory_button"
	btn:Dock(LEFT)
	btn:SetCurve(4)
	btn:SetColor(self.InactiveColor)

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
		Label = btn
	}

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
		tab.Label:SetColor(self.InactiveColor)
	end
	local tab = self.Tabs[name]
	self.ActiveTab = name
	tab.Panel:SetParent(self.TabArea)
	tab.Panel:SetVisible(true)
	tab.Label:SetColor(self.ActiveColor)
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

function PANEL:OnChange()
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
		self:OnChange(what)
	end)
end

vgui.Register("pluto_inventory_auction_search_dropdown", PANEL, "pluto_inventory_auction_search_base")

local PANEL = {}

function PANEL:Init()
	self.TextEntry = self:Add "DTextEntry"
	self.TextEntry:Dock(RIGHT)
	self.TextEntry:SetWide(120)
end

vgui.Register("pluto_inventory_auction_search_input", PANEL, "pluto_inventory_auction_search_base")

local PANEL = {}

function PANEL:Init()
	self.TextEntry1 = self:Add "DTextEntry"
	self.TextEntry1:Dock(RIGHT)
	self.TextEntry1:SetWide(55)

	self.To = self:Add "pluto_label"
	self.To:SetContentAlignment(5)
	self.To:SetText "-"
	self.To:SetFont "pluto_inventory_font"
	self.To:SetTextColor(Color(255, 255, 255))
	self.To:SetRenderSystem(pluto.fonts.systems.shadow)
	self.To:SetWide(10)
	self.To:Dock(RIGHT)

	self.TextEntry2 = self:Add "DTextEntry"
	self.TextEntry2:Dock(RIGHT)
	self.TextEntry2:SetWide(55)
end

vgui.Register("pluto_inventory_auction_search_input_two", PANEL, "pluto_inventory_auction_search_base")