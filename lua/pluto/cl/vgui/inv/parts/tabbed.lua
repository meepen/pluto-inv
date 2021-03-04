local circles = include "pluto/thirdparty/circles.lua"

local inactive_color = Color(35, 36, 43)
local active_color   = Color(64, 66, 74)

local active_text = Color(255, 255, 255)
local inactive_text = Color(128, 128, 128)

local padding_x = 23
local padding_y = 5

local PANEL = {}

function PANEL:Init()
	self.Color = active_color
	self.TabArea = self:Add "EditablePanel"
	function self.TabArea:PerformLayout(w, h)
		local children = self:GetChildren()
		local cw = math.Round((w - 2 * #children - 2) / #children)
		for _, child in pairs(children) do
			child:SetWide(cw)
		end

		if (#children > 0) then
			children[#children]:SetWide(w - cw * (#children - 1) - 2 * (#children - 1))
		end
	end
	self.TabArea:Dock(TOP)
	self.TabArea:SetTall(22)

	self.Inner = self:Add "pluto_inventory_component"
	self.Inner:Dock(FILL)
	self.Inner:SetCurveTopLeft(false)
	self.Inner:SetCurveTopRight(false)

	function self.Inner.PaintOver(s, w, h)
		if (not IsValid(self.ActiveTab)) then
			return
		end

		local col = s:GetColor()

		local x, y = self.ActiveTab:GetPos()
		local tw, th = self.ActiveTab:GetSize()
		
		surface.SetDrawColor(s:GetColor())
		surface.DrawLine(x, 0, x + tw - 1, 0)
	end

	local old_layout = self.Inner.PerformLayout
	function self.Inner.PerformLayout(s, w, h)
		if (old_layout) then
			old_layout(s, w, h)
		end

		for _, tab in pairs(self.Tabs) do
			self:SizeTab(tab, w, h)
		end
	end

	self.Tabs = {}
	self.TabList = {}
end

function PANEL:SizeTab(tab, w, h)
	tab:SetSize(padding_x * 3 + 48 * 4, h - 24)
	tab:SetPos(w / 2 - tab:GetWide() / 2, 12)
end

function PANEL:GetTab(text)
	return self.Tabs[self.TabList[text]]
end

function PANEL:AddTab(text, onpress, col)
	col = col or active_text
	onpress = onpress or function() end
	local curve = self.TabArea:Add "pluto_inventory_component_noshadow"
	curve:Dock(LEFT)
	curve:DockPadding(0, 1, 0, 3)
	curve:SetCurveBottomRight(false)
	curve:SetCurveBottomLeft(false)
	curve:SetMouseInputEnabled(true)

	curve.Label = curve:Add "pluto_label"
	curve.Label:SetFont "pluto_inventory_font_lg"
	curve.Label:SetRenderSystem(pluto.fonts.systems.shadow)
	curve.Label:SetTextColor(Color(255, 255, 255))
	curve.Label:SetText(text)
	curve.Label:SetContentAlignment(5)
	curve.Label:SizeToContentsX()
	curve:SetWide(curve.Label:GetWide() + 24)
	curve.Label:Dock(FILL)

	curve:SetCursor "hand"
	curve:DockMargin(0, 0, 2, 0)

	self.Tabs[curve] = self.Inner:Add "EditablePanel"
	self.TabList[text] = curve
	if (not self.ActiveTab) then
		curve:SetColor(self.Color)
		curve.Label:SetTextColor(col)
		self.ActiveTab = curve
		self.Tabs[curve]:SetVisible(true)
		curve:ChangeDockInner(1, 1, 1, 0)
	else
		curve:SetColor(inactive_color)
		curve.Label:SetTextColor(inactive_text)
		self.Tabs[curve]:SetVisible(false)
		curve:ChangeDockInner(0, 0, 0, 0)
	end

	function curve.OnMousePressed(s, m)
		if (m == MOUSE_LEFT) then
			if (IsValid(self.ActiveTab)) then
				self.ActiveTab:SetColor(inactive_color)
				self.ActiveTab.Label:SetTextColor(inactive_text)
				self.ActiveTab:ChangeDockInner(0, 0, 0, 0)
				self.Tabs[self.ActiveTab]:SetVisible(false)
			end
			s:SetColor(self.Color)
			s:ChangeDockInner(1, 1, 1, 0)
			s.Label:SetTextColor(col)
			self.Tabs[s]:SetVisible(true)
			self.ActiveTab = s
			onpress()
		end
	end

	return self.Tabs[curve]
end

function PANEL:SelectTab(name)
	local tab = self.TabList[name]
	if (IsValid(tab)) then
		tab:OnMousePressed(MOUSE_LEFT)
	end
end

function PANEL:SetCurve(curve)
	self.Inner:SetCurve(curve)

	for tab in pairs(self.Tabs) do
		tab:SetCurve(curve)
	end
end

function PANEL:SetColor(col)
	self.Color = col
	if (IsValid(self.ActiveTab)) then
		self.ActiveTab:SetColor(self.Color)
	end
	self.Inner:SetColor(col)
end

vgui.Register("pluto_inventory_component_tabbed", PANEL, "EditablePanel")