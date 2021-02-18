local PANEL = {}

function PANEL:Init()
	hook.Add("PlutoCraftResults", self, self.PlutoCraftResults)

	self.UsedItems = {}

	self.Shards = {}
	self.ShardLine = self:Add "EditablePanel"
	self.ShardLine:SetTall(56)
	self.ShardLine:Dock(TOP)
	self.ShardLine:DockMargin(0, 5, 0, 10)

	for i = 1, 3 do
		local shard = self.ShardLine:Add "pluto_inventory_item"
		self.Shards[i] = shard

		function shard.CanClickWith(s, other)
			local item = other.Item
			return item and item.Type == "Shard" and not self.UsedItems[other.Item.ID]
		end
		function shard.ClickedWith(s, other)
			if (s.Item) then
				self.UsedItems[other.Item.ID] = nil
			end
			s:SetItem(other.Item)
			if (other.Item) then
				self.UsedItems[other.Item.ID] = other.Item
			end
			self:UpdateItems()
		end
		function shard.OnRightClick(s)
			if (s.Item) then
				self.UsedItems[s.Item.ID] = nil
			end
			s:SetItem(nil)
			self:UpdateItems()
		end
		function shard.OnLeftClick(s)
			if (not s.Item) then
				return
			end

			pluto.ui.highlight(s.Item)
		end
	end

	function self.ShardLine.PerformLayout(s, w, h)
		local amt = #self.Shards
		local x = math.Round(w / 2 - (56 * amt + 5 * (amt - 1)) / 2)

		for i = 1, amt do
			self.Shards[i]:SetPos(x, h / 2 - 56 / 2)
			x = x + 56 + 5
		end
	end

	local selectorarea = self:Add "EditablePanel"
	selectorarea:Dock(TOP)
	selectorarea:SetTall(64)
	local selector = selectorarea:Add "pluto_inventory_currency_selector"
	selector:AcceptInput(true)
	self.CurrencySelector = selector

	function selector:OnCurrencyChanged(currency)
		if (currency and not currency.Crafted) then
			self:SetCurrency()
		end

		if (IsValid(pluto.ui.pnl)) then
			pluto.ui.pnl:ChangeToTab "Crafting"
		end
	end

	function selectorarea:PerformLayout()
		selector:Center()
	end

	function selector.OnCurrencyUpdated(s)
		local cur, amt = s:GetCurrency()

		if (cur) then
			local crafted = cur.Crafted
			self.CurrencyText:SetText(string.format("Chance to get %s modifier: %.2f%%", crafted.Mod, pluto.mods.chance(crafted, amt) * 100))
		else
			self.CurrencyText:SetText ""
		end
	end

	self.CurrencyText = self:Add "pluto_label"
	self.CurrencyText:Dock(TOP)
	self.CurrencyText:SetContentAlignment(5)
	self.CurrencyText:SetRenderSystem(pluto.fonts.systems.shadow)
	self.CurrencyText:SetFont "pluto_inventory_font"
	self.CurrencyText:SetTextColor(Color(255, 255, 255))
	self.CurrencyText:SetText ""

	self.Items = {}
	self.ItemLine = self:Add "EditablePanel"
	self.ItemLine:SetTall(56)
	self.ItemLine:Dock(TOP)
	self.ItemLine:DockMargin(0, 5, 0, 10)

	for i = 1, 4 do
		local itempnl = self.ItemLine:Add "pluto_inventory_item"
		self.Items[i] = itempnl

		function itempnl.CanClickWith(s, other)
			local item = other.Item
			return item and item.Type == "Weapon" and not self.UsedItems[other.Item.ID]
		end
		function itempnl.ClickedWith(s, other)
			if (s.Item) then
				self.UsedItems[other.Item.ID] = nil
			end
			s:SetItem(other.Item)
			if (other.Item) then
				self.UsedItems[other.Item.ID] = other.Item
			end
			self:UpdateItems()
		end
		function itempnl.OnRightClick(s)
			if (s.Item) then
				self.UsedItems[s.Item.ID] = nil
			end
			s:SetItem(nil)
			self:UpdateItems()
		end
		function itempnl.OnLeftClick(s)
			if (not s.Item) then
				return
			end

			pluto.ui.highlight(s.Item)
		end
	end

	function self.ItemLine.PerformLayout(s, w, h)
		local amt = #self.Items
		local x = math.Round(w / 2 - (56 * amt + 5 * (amt - 1)) / 2)

		for i = 1, amt do
			self.Items[i]:SetPos(x, h / 2 - 56 / 2)
			x = x + 56 + 5
		end
	end
	
	self.GoButton = self:Add "ttt_curved_panel"
	self.GoButton:Dock(TOP)
	self.GoButton:SetMouseInputEnabled(true)
	self.GoButton:SetCursor "hand"
	self.GoButton:DockMargin(20, 7, 20, 7)
	self.GoButton:SetTall(18)
	self.GoButton:SetCurve(2)
	self.GoButton:SetColor(Color(134, 191, 34))

	function self.GoButton.OnMousePressed(s, m)
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
	self.GoLabel:SetText "Create an item"

	self.ShardResultLine = self:Add "EditablePanel"
	self.ShardResultLine:SetTall(28)
	self.ShardResultLine:Dock(TOP)
	self.ShardResultLine:DockMargin(0, 5, 0, 5)

	self.ShardResults = {}

	function self.ShardResultLine:Relayout()
		local w, h = self:GetSize()
		local children = self:GetChildren()
		local amt = #children
		local x = math.Round(w / 2 - (28 * amt + 5 * (amt - 1)) / 2)

		for i = 1, amt do
			children[i]:SetPos(x, h / 2 - 28 / 2)
			x = x + 28 + 5
		end
	end

	function self.ShardResultLine:PerformLayout()
		self:Relayout()
	end

	self:RecreateResults()
end

function PANEL:RecreateResults()
	if (IsValid(self.ItemResults)) then
		self.ItemResults:Remove()
	end

	self.ItemResults = self:Add "pluto_text_inner"
	self.ItemResults:Dock(FILL)
	self.ItemResults:SetDefaultTextColor(Color(255, 255, 255))
	self.ItemResults:SetDefaultRenderSystem(pluto.fonts.systems.shadow)
	self.ItemResults:SetDefaultFont "pluto_inventory_font"
	self.ItemResults:SetMouseInputEnabled(false)
	self.ItemResults:SetWide(self:GetWide())
end

function PANEL:GetItems()
	local items = {}
	for _, item in pairs(self.UsedItems) do
		table.insert(items, item)
	end
	table.sort(items, function(a, b)
		if (a.Type == "Shard" and b.Type ~= "Shard") then
			return true
		elseif (a.Type ~= "Shard" and b.Type == "Shard") then
			return false
		else
			return b.ID > a.ID
		end
	end)

	return items
end

function PANEL:UpdateItems()
	pluto.inv.message()
		:write("requestcraftresults", self:GetItems())
		:send()

	for _, child in pairs(self.ShardResultLine:GetChildren()) do
		child:Remove()
	end
	self.ShardResultLine:Relayout()
	self:RecreateResults()
end

function PANEL:PlutoCraftResults(outcomes)
	for _, child in pairs(self.ShardResultLine:GetChildren()) do
		child:Remove()
	end

	for _, shard in ipairs(outcomes) do
		local shard_item = self.ShardResultLine:Add "pluto_inventory_item"
		table.insert(self.ShardResults, shard_item)
		shard_item:SetSize(28, 28)
		shard_item:SetItem(shard)
		function shard_item:OnLeftClick() end
		function shard_item:OnRightClick() end
	end
	self.ShardResultLine:Relayout()
	self:RecreateResults()

	for _, data in SortedPairs(outcomes.Info) do
		self.ItemResults:AppendText(data .. "\n")
	end
end

function PANEL:Go()
	local items = self:GetItems()
	local currency, amount = self.CurrencySelector:GetCurrency()

	pluto.inv.message()
		:write("craft", items, currency and {Currency = currency, Amount = amount} or nil)
		:send()

	for _, item in pairs(items) do
		item:Delete()
	end

	for _, item in pairs(self.Items) do
		item:SetItem()
	end

	for _, shard in pairs(self.Shards) do
		shard:SetItem()
	end
end

vgui.Register("pluto_inventory_crafting_shards", PANEL, "EditablePanel")

local PANEL = {}

vgui.Register("pluto_inventory_crafting_currency", PANEL, "EditablePanel")


local PANEL = {}

function PANEL:Init()
	self:AddTab "Shards":Add "pluto_inventory_crafting_shards":Dock(FILL)
	self:AddTab "Currency":Add "pluto_inventory_crafting_currency":Dock(FILL)
end

vgui.Register("pluto_inventory_crafting", PANEL, "pluto_inventory_component_tabbed")