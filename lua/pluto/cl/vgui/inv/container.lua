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
	self.SidePanelSize = 100
	self.TopSize = 22
	self:SetSize(700 + self.SidePanelSize, 450)

	self.SidePanel = self:Add "ttt_curved_panel"
	self.SidePanel:SetWide(self.SidePanelSize + 10)
	self.SidePanel:SetVisible(false)

	self.SidePanelContainer = self.SidePanel:Add "ttt_curved_panel"
	self.SidePanelContainer:Dock(FILL)
	self.SidePanelContainer:SetCurve(4)

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
	function self.StorageExpander.OnMousePressed(s, m)
		if (m == MOUSE_LEFT) then
			s.Toggled = not s.Toggled

			self.SidePanel:SetVisible(s.Toggled)
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
			child:SetSize(w, h)
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
	self.ActiveTab = name

	local tab = self.Tabs[name]
	if (not tab) then
		return
	end

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

function PANEL:AddTab(name, func, has_storage)
	local lbl = self.TabContainer:Add "pluto_label"
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

vgui.Register("pluto_inv", PANEL, "EditablePanel")

if (IsValid(pluto.ui.pnl)) then
	pluto.ui.pnl:Remove()
end

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

pluto.ui.toggle()