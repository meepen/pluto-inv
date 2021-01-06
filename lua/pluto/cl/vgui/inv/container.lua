surface.CreateFont("pluto_inventory_font", {
	font = "Roboto Lt",
	size = 13,
	weight = 450,
})
surface.CreateFont("pluto_inventory_font_lg", {
	font = "Roboto Lt",
	size = 15,
	weight = 450,
})

surface.CreateFont("pluto_inventory_x", {
	font = "Arial",
	size = 15,
	weight = 1000,
})

surface.CreateFont("pluto_inventory_storage", {
	font = "Verdana",
	size = 15,
	weight = 100,
})

local text_color = Color(255, 255, 255)
local inner_color = Color(64, 66, 74)

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
	self.StorageTabs = {}

	self.SidePanelSize = 180
	self.TopSize = 22
	self.BottomSize = 11
	self:SetSize(700 + self.SidePanelSize, 450 + self.BottomSize)

	self.SidePanel = self:Add "ttt_curved_panel"
	self.SidePanel:SetWide(self.SidePanelSize + 10)
	self.SidePanel:SetVisible(false)

	self.SidePanelContainer = self.SidePanel:Add "ttt_curved_panel"
	self.SidePanelContainer:Dock(FILL)
	self.SidePanelContainer:SetCurve(4)

	self.StorageTabList = self.SidePanelContainer:Add "EditablePanel"
	self.StorageTabList:Dock(FILL)
	local w_spacing = 5
	self.StorageTabList:DockPadding(10 + w_spacing, 12, w_spacing, 4)

	function self.StorageTabList.PerformLayout(s, w, h)
		self:SelectTab(self.ActiveStorageTab)
	end

	self.ActiveStorageTabBackground = self.StorageTabList:Add "ttt_curved_panel"
	self.ActiveStorageTabBackground:SetCurve(4)
	self.ActiveStorageTabBackground:SetColor(Color(106, 107, 112))

	self.SidePanelBorderContainer = self.SidePanelContainer:Add "pluto_inv_border"
	self.SidePanelBorderContainer:Dock(TOP)

	self.Main = self:Add "ttt_curved_panel"
	self.Main:DockMargin(0, 0, self.SidePanelSize, 0)
	self.Main:Dock(FILL)

	self.TabContainer = self.Main:Add "EditablePanel"
	self.TabContainer:Dock(TOP)
	self.TabContainer:SetTall(self.TopSize)
	self.TabContainer:DockMargin(4, 0, 0, 0)

	self.StorageExpander = self.TabContainer:Add "pluto_label"
	self.StorageExpander:Dock(RIGHT)
	self.StorageExpander:SetFont "pluto_inventory_storage"
	self.StorageExpander:SetText ">>"
	self.StorageExpander:SetTextColor(Color(255, 255, 255))
	self.StorageExpander:SetContentAlignment(5)
	self.StorageExpander:SizeToContentsX()
	self.StorageExpander:DockMargin(0, 0, 4, 4)
	self.StorageExpander:SetCursor "hand"
	self.StorageExpander:SetMouseInputEnabled(true)
	self.StorageExpander.AllowClickThrough = true
	function self.StorageExpander.OnMousePressed(s, m)
		if (m == MOUSE_LEFT) then
			s.Toggled = not s.Toggled

			self.SidePanel:SetVisible(s.Toggled)
			self.StorageExpander:SetText(s.Toggled and "<<" or ">>")
		end
	end

	self.Divider = self.TabContainer:Add "EditablePanel"
	self.Divider:Dock(RIGHT)
	self.Divider:SetWide(1)
	self.Divider:DockMargin(4, 0, 4, 0)

	function self.Divider:Paint(w, h)
		surface.SetDrawColor(58, 58, 58)
		surface.DrawLine(w / 2, 2, w / 2, h - 2)
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
	self.CloseButton:SizeToContentsX()
	self.CloseButton.AllowClickThrough = true
	function self.CloseButton.OnMousePressed(s, m)
		if (m == MOUSE_LEFT) then
			self:Remove()
		end
	end

	self.BorderContainer = self.Main:Add "pluto_inv_border"
	self.BorderContainer:Dock(TOP)

	self.Container = self.Main:Add "ttt_curved_panel"
	self.Container:Dock(FILL)
	self.Container:SetTall(self:GetTall() - self.TopSize)
	self.Container:SetCurve(4)
	self.Container:DockPadding(15, 9, 15, 9)

	self.StorageContainer = self.Container:Add "EditablePanel"
	self.Storage = self.StorageContainer:Add "pluto_storage_area"
	self.Storage:SetStorageHandler(self)

	self.Storage:Dock(RIGHT)
	self.Storage:DockMargin(12, 0, 0, 0)
	self.Storage:SetColor(inner_color)
	self.Storage:SetCurve(4)

	self.RestOfStorage = self.StorageContainer:Add "EditablePanel"
	self.RestOfStorage:Dock(FILL)

	self.EmptyContainer = self.Container:Add "EditablePanel"

	function self.Container.PerformLayout(s, w, h)
		local x, y = 15, 9
		w = w - 30
		h = h - 18

		for _, child in pairs(s:GetChildren()) do
			child:SetPos(x, y)
			child:SetSize(w, h - self.BottomSize)
		end
	end

	self.StorageLabel = self.SidePanel:Add "pluto_label"
	self.StorageLabel:SetTall(self.TopSize)
	self.StorageLabel:Dock(TOP)
	self.StorageLabel:SetContentAlignment(5)
	self.StorageLabel:SetFont "pluto_inventory_font"

	self.StorageLabel:SetText "Storage"
	self.StorageLabel:SetRenderSystem(pluto.fonts.systems.shadow)
	self.StorageLabel:SetTextColor(text_color)

	-- THEME
	self.Main:SetColor(Color(38, 38, 38))
	self.SidePanel:SetColor(Color(57, 57, 57))
	self.Container:SetColor(Color(48, 50, 59))
	self.SidePanelContainer:SetColor(Color(64, 66, 74))

	self.Main:SetCurve(4)
	self.SidePanel:SetCurve(4)
	self.SidePanel:SetCurveTopLeft(false)
	self.SidePanel:SetCurveBottomLeft(false)
	self.Container:SetCurveTopLeft(false)
	self.Container:SetCurveTopRight(false)
	self.SidePanelContainer:SetCurveTopLeft(false)
	self.SidePanelContainer:SetCurveBottomLeft(false)
	self.SidePanelContainer:SetCurveTopRight(false)

	self.Tabs = {}
	self.ActiveTab = nil

	self:AddTab("Loadout", function(container)
		local other = container:Add "pluto_inventory_equip"
		other:SetCurve(4)
		other:Dock(FILL)
		other:SetColor(inner_color)
	end, true)

	self:AddTab("Crafting", function(container)
	end, true)

	self:AddTab("Currency", function(container)
	end, true)

	self:AddTab("Quests", function(container)
	end)

	self:AddTab("Divine Market", function(container)
	end)

	self.TabList = {}

	for id, tab in pairs(pluto.cl_inv) do
		if (tab.Type == "normal" or tab.Type == "equip") then
			table.insert(self.TabList, {
				Tab = tab
			})
		end
	end

	for _, item in ipairs(self.TabList) do
		self:AddStorageTab(item.Tab)
	end
end

function PANEL:GetOrderConvar()
	return CreateConVar("pluto_tab_order_" .. LocalPlayer():SteamID64() .. "_" .. self.ID, "[]", FCVAR_ARCHIVE)
end

function PANEL:Reorder()
	local json = util.JSONToTable(self:GetOrderConvar():GetString()) or {}

	local lookup = {}
	for i, v in ipairs(json) do
		lookup[tonumber(v)] = i
	end

	table.sort(self.TabList, function(a, b)
		local aid = a.Tab.FakeID and -a.Tab.FakeID or a.Tab.ID
		local bid = b.Tab.FakeID and -b.Tab.FakeID or b.Tab.ID

		local al = lookup[aid]
		local bl = lookup[bid]

		if (al and not bl) then
			return false
		elseif (bl and not al) then
			return true
		elseif (bl and al) then
			return al < bl
		end

		return aid < bid
	end)

	self:SaveOrder()
end

function PANEL:SaveOrder()
	local list = {}
	for _, tab in ipairs(self.TabList) do
		table.insert(list, tab.Tab.FakeID and -tab.Tab.FakeID or tab.Tab.ID)
	end
	self:GetOrderConvar():SetString(util.TableToJSON(list))
end

function PANEL:PerformLayout(w, h)
	self.SidePanel:SetPos(w - self.SidePanel:GetWide())
	self.SidePanel:SetTall(h)
end

function PANEL:ClearContainer()
	for _, pnl in pairs(self.Container:GetChildren()) do
		pnl:Remove()
	end
end

function PANEL:ChangeToTab(name)
	if (self.ActiveTab == name) then
		return
	end

	local old = self.Tabs[self.ActiveTab]
	if (old) then
		old.Label:SetTextColor(Color(255, 255, 255))
	end

	self.ActiveTab = name

	local tab = self.Tabs[name]
	if (not tab) then
		return
	end

	tab.Label:SetTextColor(Color(28, 198, 244))

	local pnl
	if (tab.HasStorage) then
		pnl = self.RestOfStorage
		self.StorageContainer:SetVisible(true)
		self.EmptyContainer:SetVisible(false)
	else
		pnl = self.EmptyContainer
		self.StorageContainer:SetVisible(false)
		self.EmptyContainer:SetVisible(true)
	end

	for _, child in pairs(pnl:GetChildren()) do
		child:Remove()
	end

	tab.Populate(pnl)
end

local gradient_up = Material "gui/gradient_up"

function PANEL:AddTab(name, func, has_storage)
	local lbl = self.TabContainer:Add "pluto_label"
	local old_paint = lbl.Paint
	function lbl.Paint(s, w, h)
		if (self.ActiveTab == name) then
			surface.SetMaterial(gradient_up)
			surface.SetDrawColor(255, 255, 255, 10)
			surface.DrawTexturedRect(0, 0, w, h)
		end

		if (old_paint) then
			old_paint(s, w, h)
		end
	end
	self.Tabs[name] = {
		Label = lbl,
		Populate = func,
		HasStorage = has_storage
	}

	lbl:Dock(LEFT)
	lbl:SetContentAlignment(5)
	lbl:SetText(name)
	lbl:SetFont "pluto_inventory_font"
	lbl:SetTextColor(white_text)
	lbl:SetRenderSystem(pluto.fonts.systems.shadow)
	lbl:SetCursor "hand"
	lbl:SetMouseInputEnabled(true)

	surface.SetFont(lbl:GetFont())
	lbl:SetWide(surface.GetTextSize(lbl:GetText()) + 24)

	function lbl.OnMousePressed(s, m)
		if (self.ActiveTab == name) then
			return
		end

		self:ChangeToTab(name)
	end

	if (not self.ActiveTab) then
		self:ChangeToTab(name)
	end
end

function PANEL:Center()
	local prnt = self:GetParent()
	local pw, ph
	if (not prnt) then
		pw, ph = prnt:GetSize()
	else
		pw, ph = ScrW(), ScrH()
	end

	self:SetPos(pw / 2 - (self:GetWide() - self.SidePanelSize) / 2, ph / 2 - self:GetTall() / 2)
end

function PANEL:HandleStorageScroll(wheeled)
	local current_position
	for i, tab in ipairs(self.TabList) do
		if (tab.Tab == self.ActiveStorageTab) then
			current_position = i
			break
		end
	end
	current_position = math.Clamp(current_position + (wheeled < 0 and 1 or -1), 1, #self.TabList)
	self:SelectTab(self.TabList[current_position].Tab)
end

function PANEL:AddStorageTab(tab)
	self.Storage:AddTab(tab)
	local pnl = self.StorageTabList:Add "EditablePanel"
	pnl.AllowClickThrough = true
	self.StorageTabs[tab] = pnl
	pnl:Dock(TOP)
	pnl:SetTall(20)

	local img = pnl:Add "pluto_inventory_shape"
	img:SetSize(pnl:GetTall(), pnl:GetTall())
	img:Dock(LEFT)
	img:SetMouseInputEnabled(false)

	local lbl = pnl:Add "pluto_label"
	pnl.Label = lbl
	lbl:Dock(FILL)
	lbl:SetContentAlignment(4)
	lbl:SetFont "pluto_inventory_font"
	lbl:SetTall(22)
	lbl:SetRenderSystem(pluto.fonts.systems.shadow)
	lbl:SetTextColor(Color(255, 255, 255))
	lbl:SetText(tab.Name)
	lbl:SetMouseInputEnabled(false)

	function pnl.OnMousePressed(s, m)
		if (m == MOUSE_RIGHT) then
			-- start rename
		end
		self:SelectTab(tab)
	end

	if (not self.ActiveStorageTab) then
		self:SelectTab(tab)
	end
end

function PANEL:SelectTab(tab)
	self.ActiveStorageTabBackground:SetTall(22)
	local fg = self.StorageTabs[tab]
	self.ActiveStorageTabBackground:SetWide(fg:GetWide())
	self.ActiveStorageTabBackground:SetPos(fg:GetPos())

	if (tab ~= self.ActiveStorageTab) then
		self.ActiveStorageTab = tab
		self.Storage:PopulateFromTab(tab)
	end
end

function PANEL:OnRemove()
	pluto.ui.pickupitem()
end

vgui.Register("pluto_inv", PANEL, "EditablePanel")


function pluto.ui.toggle()
	if (IsValid(pluto.ui.pnl)) then
		pluto.ui.pnl:Remove()
		return
	end

	pluto.ui.pnl = vgui.Create "pluto_inv"
	pluto.ui.pnl:Center()
	pluto.ui.pnl:MakePopup()
	pluto.ui.pnl:SetPopupStayAtBack(true)
	pluto.ui.pnl:SetKeyboardInputEnabled(false)
end

if (IsValid(pluto.ui.pnl)) then
	pluto.ui.pnl:Remove()
	pluto.ui.toggle()
end