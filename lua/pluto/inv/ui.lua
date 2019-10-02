local pad = 0
local accent = Color(0, 173, 123)

local active_text = Color(205, 203, 203)
local inactive_text = Color(130, 130, 136)

local function curve(level)
	return 4 + level
end

local bg_color = Color(36, 36, 37)
local inactive_color = Color(47, 47, 48)

local count = 6

local PANEL = {}
function PANEL:Init()
	self:SetColor(Color(84, 89, 89, 255))
end

function PANEL:PerformLayout(w, h)
	self:SetCurve(curve(0))
end

vgui.Register("pluto_inventory_item", PANEL, "ttt_curved_panel")

local PANEL = {}
DEFINE_BASECLASS "pluto_inventory_base"
function PANEL:Init()
	BaseClass.Init(self)
	
	self.Layout = self:Add "DIconLayout"
	self.Layout:Dock(FILL)

	self.Items = {}

	for i = 1, count * count do
		local p = self.Layout:Add "pluto_inventory_item"
		self.Items[i] = p
	end
end

function PANEL:PerformLayout(w, h)
	local size = math.Round(w / (count + 2))
	local divide = (w - size * count) / (count + 2)

	for _, item in ipairs(self.Items) do
		item:SetSize(size, size)
	end

	self.Layout:SetSpaceX(divide)
	self.Layout:SetSpaceY(divide)

	self:DockPadding(divide * 1.5, divide * 1.5, divide * 1.5, divide * 1.5)
end

vgui.Register("pluto_inventory_items", PANEL, "pluto_inventory_base")

local PANEL = {}

function PANEL:Init()
	self:SetCurve(curve(2))
	self:SetColor(bg_color)
end

vgui.Register("pluto_inventory_base", PANEL, "ttt_curved_panel")

local PANEL = {}
DEFINE_BASECLASS "pluto_inventory_base"
function PANEL:Init()
	BaseClass.Init(self)
	self:SetCursor "hand"
	self:SetCurveBottomRight(false)
	self:SetCurveBottomLeft(false)

	self.Text = self:Add "DLabel"
	self.Text:Dock(FILL)
	self.Text:SetContentAlignment(5)
	self.Text:SetTextColor(inactive_text)
end
function PANEL:SetText(t)
	self.Text:SetText(t)
	surface.SetFont(self.Text:GetFont())
	local w = surface.GetTextSize(t)
	self.Text:SetWide(w + pad * 2)
end
function PANEL:OnMousePressed(key)
	if (key == MOUSE_LEFT) then
		self:DoClick()
	end
end

function PANEL:DoClick()
	self:GetParent():Select(self)
end

function PANEL:DoSelect()
	self.Text:SetTextColor(active_text)
end

function PANEL:Unselect()
	self.Text:SetTextColor(inactive_text)
end

local LastHeight = 0

function PANEL:PerformLayout(w, h)
	h = self:GetParent():GetTall()
	if (LastHeight ~= h) then
		LastHeight = h
		surface.CreateFont("pluto_inventory_tab", {
			font = "Lato",
			extended = true,
			size = h - pad / 2
		})
	end
	
	self.Text:SetFont "pluto_inventory_tab"

	surface.SetFont(self.Text:GetFont())
	local w = surface.GetTextSize(self.Text:GetText())
	self:SetWide(w + pad * 2)
	self:SetTall(h)
end

function PANEL:SetItems(items)
	PrintTable(items)
end
function PANEL:SetPanelColor(col)
	print(col)
end

vgui.Register("pluto_inventory_tab", PANEL, "pluto_inventory_base")

local PANEL = {}

function PANEL:Init()
	self.Tabs = {}
	self.CurPos = 0

	for _, tab in SortedPairsByMemberValue(pluto.cl_inv, "ID") do
		local pnl = self:AddTab "pluto_inventory_tab"
		pnl:SetText(tab.Name)
		pnl:SetPanelColor(tab.Color)
		pnl:SetItems(tab.Items)
	end
end

local function PerformLayoutHack(self, w, h)
	if (self.OldPerformLayout) then
		self:OldPerformLayout(w, h)
	end

	if (IsValid(self.Before)) then
		self.Position = self.Before.Position + self.Before:GetWide() + pad / 2
	else
		self.Position = 0
	end

	self:GetParent():Recalculate(self)
end

function PANEL:Recalculate(tab)
	tab:SetPos(tab.Position - self.CurPos, 0)
	if (IsValid(tab.Next)) then
		tab.Next.Position = tab.Position + tab:GetWide() + pad / 2
		return self:Recalculate(tab.Next)
	end
end

function PANEL:Select(tab)
	if (IsValid(self.Current)) then
		self.Current:SetColor(inactive_color)
		self.Current:Unselect()
	end

	self.Current = tab
	if (tab.Position < self.CurPos) then
		self.CurPos = tab.Position
		self:Recalculate(tab)
	end

	if (tab.Position + tab:GetWide() > self.CurPos + self:GetWide()) then
		self.CurPos = self.CurPos + tab.Position + tab:GetWide() - (self.CurPos + self:GetWide())
		self:Recalculate(self.Next)
	end

	tab:SetColor(bg_color)

	tab:DoSelect()
end

function PANEL:AddTab(class)
	local tab = self:Add(class)
	tab:SetWide(100)

	table.insert(self.Tabs, tab)
	tab:SetZPos(#self.Tabs)

	tab.Before = self.Last
	if (IsValid(self.Last)) then
		self.Last.Next = tab
	end
	if (not IsValid(self.Next)) then
		self.Next = tab
		self.Current = tab
	else
		tab:SetColor(inactive_color)
	end
	self.Last = tab

	tab.OldPerformLayout = tab.PerformLayout
	tab.PerformLayout = PerformLayoutHack

	tab:InvalidateLayout(true)

	if (not IsValid(self.Next)) then
		self:Select(self.Current)
	end

	return tab
end

function PANEL:OnMouseWheeled(delta)
	local totalwide = self.Last.Position + self.Last:GetWide() - self:GetWide()
	if (totalwide < 0) then
		return
	end

	self.CurPos = math.Clamp(self.CurPos - delta * 30, 0, totalwide)

	self:Recalculate(self.Next)
end

vgui.Register("pluto_inventory_tabs", PANEL, "EditablePanel")

local PANEL = {}

function PANEL:Init()
	self:SetCurveBottomLeft(false)
	self:SetCurveBottomRight(false)
	self:SetColor(inactive_color)
	self:SetWide(20)
end

vgui.Register("pluto_inventory_tab_selector", PANEL, "pluto_inventory_base")

local PANEL = {}

function PANEL:Init()
	self.Tabs = self:Add "pluto_inventory_tabs"
	self.Tabs:Dock(FILL)

	self.Controller = self:Add "pluto_inventory_tab_selector"
	self.Controller:Dock(RIGHT)
	self.Controller:DockMargin(pad / 2, 0, 0, 0)

	self:DockMargin(curve(2), 0, curve(2), 0)
end

vgui.Register("pluto_inventory_tab_controller", PANEL, "EditablePanel")

local PANEL = {}

function PANEL:Init()
	self:SetColor(Color(13, 12, 12, 220))
	self:SetCurve(curve(3))
	self:OnScreenSizeChanged()

	self.Tabs = self:Add "pluto_inventory_tab_controller"
	self.Tabs:Dock(TOP)
	self.Tabs:SetZPos(0)

	self.Items = self:Add "pluto_inventory_items"
	self.Items:Dock(TOP)
	self.Items:SetZPos(1)

	self:MakePopup()
end

function PANEL:OnScreenSizeChanged()
	local w = math.min(500, math.max(400, ScrW() / 3))
	self:SetSize(w, w * 1.2)
	pad = w * 0.05
	self:DockPadding(pad, pad, pad, pad)
	self:Center()
end

function PANEL:PerformLayout(w, h)
	w = w - w * 0.1
	h = h - w * 0.1

	self.Items:SetTall(w)

	h = h - w

	self.Tabs:SetTall(h * 1 / 3)
end

vgui.Register("pluto_inventory", PANEL, "ttt_curved_panel")


if (IsValid(pluto.ui)) then
	pluto.ui:Remove()
	pluto.ui = vgui.Create "pluto_inventory"
end

local function create()
	if (input.WasKeyPressed(KEY_I)) then
		if (IsValid(pluto.ui) and vgui.FocusedHasParent(pluto.ui)) then
			pluto.ui:Remove()
		elseif (not IsValid(pluto.ui)) then
			pluto.ui = vgui.Create "pluto_inventory"
		end
	end
end

hook.Add("InputMouseApply", "pluto_inventory_ui", function()
	if (input.WasKeyPressed(KEY_I) and not IsValid(pluto.ui)) then
		if (pluto.inv.status ~= "ready") then
			chat.AddText("wait for inventory!")
			return
		end
		pluto.ui = vgui.Create "pluto_inventory"
	end
end)
hook.Add("PlayerTick", "pluto_inventory_ui", function()
	if (input.WasKeyPressed(KEY_I) and IsValid(pluto.ui) and vgui.FocusedHasParent(pluto.ui)) then
		pluto.ui:Remove()
	end
end)