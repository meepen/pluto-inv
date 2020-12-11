local PANEL = {}

function PANEL:SetTab(t)
	self.Tab = t
	if (IsValid(self.CurrentContents)) then
		self.CurrentContents:SetTab(self.Tab)
	end
end

function PANEL:Init()
	self.Left = self:Add "EditablePanel"
	self.Left:Dock(LEFT)
	self.Left:SetWide(40)

	self.ContentPanel = self:Add "EditablePanel"
	self.ContentPanel:Dock(FILL)
	self.ContentPanel:DockPadding(0, 4, 4, 4)

	self.LeftExpand = self:Add "pluto_divine_market_selector"
	self.LeftExpand:SetWide(40)
	self.LeftExpand:SetPos(0, 0)

	self:RecreateContents "pluto_craft"

	self.LeftExpand:AddSelection("Auction House", "pluto_trade")
	self.LeftExpand:AddSelection("Stardust Shop", "pluto_stardust_shop")
	self.LeftExpand:AddSelection("Currency Exchange", "pluto_stardust_exchange")
	self.LeftExpand:AddSelection("Shard Crafting", "pluto_craft")
end

function PANEL:RecreateContents(tabtype)
	if (IsValid(self.CurrentContents)) then
		self.CurrentContents:Remove()
	end

	self.CurrentContents = self.ContentPanel:Add(tabtype)
	self.CurrentContents:Dock(FILL)
	if (self.Tab) then
		self.CurrentContents:SetTab(self.Tab)
	end
end

function PANEL:PerformLayout(w, h)
	self.LeftExpand:SetTall(h)
end

vgui.Register("pluto_divine_market", PANEL, "pluto_inventory_base")

local PANEL = {}

function PANEL:AddSelection(what, tabtype)
	local p = self:Add "pluto_inventory_base"
	p:Dock(TOP)
	p:DockMargin(0, 4, 0, 0)
	p:SetCursor "hand"
	p:SetTall(26)
	p.Label = p:Add "DLabel"
	p.Label:SetFont "pluto_inventory_tab"
	p.Label:SetContentAlignment(4)
	p.Label:Dock(FILL)
	p.Label:DockMargin(10, 0, 4, 0)
	p.Label:SetText(what)
	function p.OnMousePressed()
		self:GetParent():RecreateContents(tabtype)
	end
	function p:OnCursorEntered()
		self:GetParent():OnCursorEntered()
	end
	function p:OnCursorExited()
		self:GetParent():OnCursorExited()
	end
end

function PANEL:OnCursorEntered()
	self:SetWide(160)
end

function PANEL:OnCursorExited()
	self:SetWide(40)
end

vgui.Register("pluto_divine_market_selector", PANEL, "pluto_inventory_base")
