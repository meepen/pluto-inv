local PANEL = {}

local inactive_color = Color(35, 36, 43)
local active_color   = Color(64, 66, 74)

local active_text = Color(255, 255, 255)
local inactive_text = Color(128, 128, 128)

local item_size = 56
local inner_area = 5
local outer_area = 10

function PANEL:Init()
	self:SetWide(item_size * 6 + inner_area * 5 + outer_area * 2)
	self.UpperArea = self:Add "EditablePanel"
	self.UpperArea:Dock(TOP)
	self.UpperArea:SetTall(22)

	self.SearchyBoiText = self.UpperArea:Add "DTextEntry"
	self.SearchyBoiText:Dock(RIGHT)
	self.SearchyBoiText:SetWide(100)
	self.SearchyBoiText:SetFont "pluto_inventory_font"
	self.SearchyBoiText:SetKeyboardInputEnabled(true)

	function self.SearchyBoiText:OnMousePressed(m)
		if (m == MOUSE_LEFT) then
			pluto.ui.pnl:AddKeyboardFocus(1)
		end
	end

	function self.SearchyBoiText.OnFocusChanged(s, gained)
		if (not gained) then
			pluto.ui.pnl:AddKeyboardFocus(-1)
		end
	end

	function self.SearchyBoiText.OnChange(s)
		self:SearchItems(s:GetValue())
	end

	function self.SearchyBoiText:Think()
		if (input.IsKeyDown(KEY_LCONTROL) and input.IsKeyDown(KEY_F)) then
			self:OnMousePressed(MOUSE_LEFT)
			self:RequestFocus()
		end
	end

	self.SearchyBoiText:DockMargin(0, 4, 0, 3)

	self.SearchyBoi = self.UpperArea:Add "pluto_label"
	self.SearchyBoi:Dock(RIGHT)
	self.SearchyBoi:SetTextColor(Color(255, 255, 255))
	self.SearchyBoi:SetRenderSystem(pluto.fonts.systems.shadow)
	self.SearchyBoi:SetFont "pluto_inventory_font"
	self.SearchyBoi:SetText "Search:"
	self.SearchyBoi:DockMargin(0, 4, 5, 3)
	self.SearchyBoi:SizeToContentsX()


	self.InventoryContainer = self.UpperArea:Add "pluto_inventory_component_noshadow"
	self.InventoryContainer:Dock(LEFT)
	self.InventoryContainer:SetWide(100)
	self.InventoryContainer:DockPadding(0, 4, 0, 3)
	self.InventoryContainer:DockMargin(0, 0, 2, 0)
	self.InventoryContainer:ChangeDockInner(1, 1, 1, 0)

	self.InventoryLabel = self.InventoryContainer:Add "pluto_label"
	self.InventoryLabel:SetContentAlignment(8)
	self.InventoryLabel:SetFont "pluto_inventory_font_lg"
	self.InventoryLabel:SetTextColor(Color(255, 255, 255))
	self.InventoryLabel:SetRenderSystem(pluto.fonts.systems.shadow)
	self.InventoryLabel:Dock(FILL)
	self.InventoryLabel:SetText "Inventory"
	self.InventoryLabel:SizeToContentsX()
	self.InventoryLabel:SetMouseInputEnabled(false)
	self.InventoryContainer:SetWide(self.InventoryLabel:GetWide() + 25)
	self.InventoryContainer:SetCursor "hand"

	self.BufferContainer = self.UpperArea:Add "pluto_inventory_component_noshadow"
	self.BufferContainer:Dock(LEFT)
	self.BufferContainer:SetWide(100)
	self.BufferContainer:DockPadding(0, 4, 0, 3)
	self.BufferContainer:ChangeDockInner(1, 1, 1, 0)

	self.BufferLabel = self.BufferContainer:Add "pluto_label"
	self.BufferLabel:SetContentAlignment(8)
	self.BufferLabel:SetFont "pluto_inventory_font_lg"
	self.BufferLabel:SetTextColor(Color(255, 255, 255))
	self.BufferLabel:SetRenderSystem(pluto.fonts.systems.shadow)
	self.BufferLabel:Dock(FILL)
	self.BufferLabel:SetText "Buffer"
	self.BufferLabel:SizeToContentsX()
	self.BufferLabel:SetMouseInputEnabled(false)
	self.BufferContainer:SetWide(self.BufferLabel:GetWide() + 25)
	self.BufferContainer:SetColor(inactive_color)
	self.BufferContainer:SetCursor "hand"

	function self.BufferContainer.OnMousePressed(s, m)
		if (m == MOUSE_LEFT) then
			self:SwapToBuffer(true)
			self:OnBufferPressed()
		end
	end

	function self.InventoryContainer.OnMousePressed(s, m)
		if (m == MOUSE_LEFT) then
			self:SwapToBuffer(false)
		end
	end

	self.Container = self:Add "pluto_inventory_component"
	DEFINE_BASECLASS "pluto_inventory_component"
	self.Container:Dock(FILL)

	function self.Container.PaintOver(s, w, h)
		if (not IsValid(self.SelectedTab)) then
			return
		end

		local col = s:GetColor()

		local x, y = self.SelectedTab:GetPos()
		local tw, th = self.SelectedTab:GetSize()
		
		surface.SetDrawColor(s:GetColor())
		surface.DrawLine(x, 0, x + tw - 1, 0)
	end

	self.ItemContainer = self.Container:Add "EditablePanel"
	self.ItemContainer:SetSize(item_size * 6 + inner_area * 5, item_size * 6 + inner_area * 5)

	function self.Container.PerformLayout(s, w, h)
		BaseClass.PerformLayout(s, w, h)
		self.ItemContainer:Center()
	end

	self.ItemRows = {}
	self.Items = {}
	self.ItemHighlights = {}

	for i = 1, 6 do
		local row = self.ItemContainer:Add "EditablePanel"
		self.ItemRows[i] = row

		for j = 1, 6 do
			local item = row:Add "pluto_inventory_item"
			item:SetCanPickup(true)
			table.insert(self.Items, item)
			item:Dock(LEFT)
			if (j ~= 6) then
				item:DockMargin(0, 0, inner_area, 0)
			end

			local tabindex = #self.Items

			function item.OnLeftClick(s)
				-- this is claiming a buffer item (for now)
				local p = pluto.ui.pickupitem(s)
				if (not IsValid(p)) then
					return
				end

				function p.ClickedOn(_, other)
					self:SwapToBuffer(true)
					for i = _.TabIndex, 36 do
						pluto.buffer[i] = pluto.buffer[i + 1]
						if (pluto.buffer[i]) then
							pluto.buffer[i].TabIndex = i
						end
					end
					hook.Run "PlutoBufferChanged"
				end

				self:SwapToBuffer(false)
			end
		end

		row:Dock(TOP)
		row:SetTall(56)
		if (i ~= 6) then
			row:DockMargin(0, 0, 0, inner_area)
		end
	end

	self.Container:SetCurveTopLeft(false)
	self.InventoryContainer:SetCurveBottomLeft(false)
	self.InventoryContainer:SetCurveBottomRight(false)
	self.BufferContainer:SetCurveBottomLeft(false)
	self.BufferContainer:SetCurveBottomRight(false)

	self:SelectWhich(self.InventoryContainer)
end

function PANEL:OnBufferPressed()
	print "TODO: override"
end

function PANEL:SelectWhich(t)
	self.SelectedTab = t
	t:SetColor(active_color)
	t:ChangeDockInner(1, 1, 1, 0)

	local lbl = self.InventoryContainer == t and self.InventoryLabel or self.BufferLabel
	lbl:SetTextColor(active_text)

	local other = t == self.InventoryContainer and self.BufferContainer or self.InventoryContainer
	other:SetColor(inactive_color)
	other:ChangeDockInner(0, 0, 0, 0)

	local otherlbl = other == self.InventoryContainer and self.InventoryLabel or self.BufferLabel
	otherlbl:SetTextColor(inactive_text)
end

function PANEL:AddTab(tab)
	if (not self.ActiveTab) then
		self:PopulateFromTab(tab)
		self.ActiveTab = tab
	end
end

function PANEL:PopulateFromTab(tab)
	if (self.BufferActive and tab.Type ~= "buffer") then
		return
	elseif (tab.Type ~= "buffer") then
		self.ActiveTab = tab
	end

	self.ItemHighlights = {}
	local tabtype = pluto.tabs[tab.Type]
	if (not tabtype) then
		ErrorNoHalt("unknown how to handle tab type " .. tab.Type)
		return
	end

	for i = 1, 36 do
		local item = tab.Items[i]
		self.Items[i]:SetUpdateFrom(tab.ID, i)
		self.Items[i]:SetItem(item)

		self.Items[i].CanClickWith = function(s, other)
			return tabtype.canaccept(i, other.Item)
		end
	end
	pluto.ui.realpickedupitem = nil
	if (IsValid(pluto.ui.pickedupitem)) then
		local p = pluto.ui.pickedupitem
		if (p.TabID  == tab.ID) then
			pluto.ui.realpickedupitem = self.Items[p.TabIndex]
		end
	end

	if (self.SearchText) then
		self:SearchItems(self.SearchText)
	end
end

function PANEL:SetCurve(curve)
	self.Container:SetCurve(curve)
	self.InventoryContainer:SetCurve(curve)
	self.BufferContainer:SetCurve(curve)
end

function PANEL:SetColor(col)
	self.Container:SetColor(col)
end

function PANEL:SetStorageHandler(pnl)
	self.Handler = pnl
end

function PANEL:OnMouseWheeled(wheel)
	if (IsValid(self.Handler)) then
		self.Handler:HandleStorageScroll(wheel)
	end
end

function PANEL:HighlightItem(item, lifetime)
	table.insert(self.ItemHighlights, {
		StartTime = CurTime(),
		TabIndex = item,
		Lifetime = lifetime or 2,
	})
end

function PANEL:PaintOver()
	for i = #self.ItemHighlights, 1, -1 do
		local item = self.ItemHighlights[i]
		if (item.StartTime + item.Lifetime < CurTime()) then
			table.remove(self.ItemHighlights, i)
			continue
		end
		
		local pnl = self.Items[item.TabIndex]
		local frac = (CurTime() - item.StartTime) / item.Lifetime

		local x, y = self:ScreenToLocal(pnl:LocalToScreen(0, 0))
		local w, h = pnl:GetSize()
		surface.SetDrawColor(255, 255, 255, (1 - frac) * 255)
		surface.DrawOutlinedRect(x, y, w, h, 4)
	end
end

PANEL.FilterTypes = {
	type = function(item, text)
		text = text:sub(1, 1):upper() .. text:sub(2):lower()
		return item.Type == text
	end,
	name = function(item, text)
		return item:GetPrintName():lower():find(text, nil, true)
	end,
	slot = function(item, text)
		text = (tonumber(text) or -1) - 1
		if (item.Type ~= "Weapon") then
			return false
		end

		local class = baseclass.Get(item.ClassName)
		return class and class.Slot == text
	end,
	class = function(item, text)
		if (item.Type ~= "Weapon") then
			return false
		end

		if (item.ClassName == text) then
			return
		end

		local class = baseclass.Get(item.ClassName)
		return class and class.PrintName:lower():find(text, nil, true)
	end
}

function PANEL:SearchItems(text)
	self.ItemHighlights = {}
	self.SearchText = text
	if (text == "") then
		return
	end

	local removals = {}

	local filters = {}

	for pos1, typ, txt, pos2 in text:gmatch "%s*()([^%s:]+):(%S*)%s*()" do
		filters[typ] = txt
		table.insert(removals, {pos1, pos2})
	end

	for i = #removals, 1, -1 do
		local positions = removals[i]

		text = text:sub(1, positions[1] - 1) .. text:sub(positions[2])
	end

	text = text:Trim()
	if (text ~= "") then
		filters.name = text
	end

	for i, pnl in pairs(self.Items) do
		local item = pnl.Item
		if (not item) then
			continue
		end

		local good = true

		for filtername, filterdata in pairs(filters) do
			local filter = self.FilterTypes[filtername]
			if (not filter) then
				continue
			end

			if (not filter(item, filterdata)) then
				good = false
				break
			end
		end

		if (good) then
			self:HighlightItem(i, math.huge)
		end
	end
end

function PANEL:SwapToBuffer(enable)
	if (not not self.BufferActive == enable) then
		return
	end

	self.BufferActive = not self.BufferActive
	if (self.BufferActive) then
		for _, tab in pairs(pluto.cl_inv) do
			if (tab.Type == "buffer") then
				self:PopulateFromTab(tab, true)
			end
		end

		hook.Add("PlutoBufferChanged", self, self.PlutoBufferChanged)

		self:SelectWhich(self.BufferContainer)

		for _, item in pairs(self.Items) do
			item:SetCanPickup(false)
		end
	else
		self:SelectWhich(self.InventoryContainer)
		self:PopulateFromTab(self.ActiveTab)
		for _, item in pairs(self.Items) do
			item:SetCanPickup(true)
		end
	end
end

function PANEL:PlutoBufferChanged()
	if (self.BufferActive) then
		for _, tab in pairs(pluto.cl_inv) do
			if (tab.Type == "buffer") then
				self:PopulateFromTab(tab)
			end
		end
	end
end

vgui.Register("pluto_storage_area", PANEL, "EditablePanel")
