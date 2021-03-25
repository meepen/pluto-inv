local PANEL = {}

function PANEL:Init()
	hook.Add("PlutoCraftResults", self, self.PlutoCraftResults)

	self.UsedItems = {}

	self.Shards = {}
	self.ShardLine = self:Add "EditablePanel"
	self.ShardLine:SetTall(pluto.ui.sizings "ItemSize")
	self.ShardLine:Dock(TOP)

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
		local amt = #self.Shards + 1
		local offset = 0
		local x = math.Round(w / 2 - (pluto.ui.sizings "ItemSize" * amt + 5 * (amt - 1)) / 2 - offset)

		for i = 1, 3 do
			self.Shards[i]:SetPos(x, h / 2 - pluto.ui.sizings "ItemSize" / 2)
			x = x + pluto.ui.sizings "ItemSize" + 5
		end

		self.CurrencySelector:SetPos(x + offset, h - self.CurrencySelector:GetTall())
	end

	local selector = self.ShardLine:Add "pluto_inventory_currency_selector"
	selector:SetCurrencyFilter(function(cur)
		return cur.Crafted
	end)
	selector:AcceptInput(true)
	selector:AcceptAmount(true)
	self.CurrencySelector = selector

	function selector:OnCurrencyChanged(currency)
		if (currency and not currency.Crafted) then
			self:SetCurrency()
		end

		if (IsValid(pluto.ui.pnl)) then
			pluto.ui.pnl:ChangeToTab "Crafting"
		end
	end

	function selector.OnCurrencyUpdated(s)
		local cur, amt = s:GetCurrency()

		if (cur) then
			local crafted = cur.Crafted
			--self.CurrencyText:SetText(string.format("Chance to get %s modifier: %.2f%%", crafted.Mod, pluto.mods.chance(crafted, amt) * 100))
		else
			--self.CurrencyText:SetText ""
		end
	end

	self.LineConnectors = self:Add "EditablePanel"
	self.LineConnectors:Dock(TOP)
	self.LineConnectors:SetTall(42)

	function self.LineConnectors.Paint(s, w, h)
		local shardlocs = {}
		for i, shard in ipairs(self.Shards) do
			shardlocs[i] = Vector(s:ScreenToLocal(shard:LocalToScreen(shard:GetWide() / 2, shard:GetTall())))
		end

		local curpos = Vector(s:ScreenToLocal(self.CurrencySelector:LocalToScreen(self.CurrencySelector:GetWide() / 2, self.CurrencySelector:GetTall())))

		surface.SetDrawColor(95, 96, 102)
		surface.DrawLine(shardlocs[2].x, 0, shardlocs[2].x, h)
		surface.DrawLine(shardlocs[1].x, 0, shardlocs[1].x, 12)
		surface.DrawLine(shardlocs[3].x, 0, shardlocs[3].x, 12)
		surface.DrawLine(shardlocs[1].x, 12, shardlocs[3].x, 12)

		surface.DrawLine(curpos.x, 0, curpos.x, h)
	end

	self.Items = {}
	self.ItemLine = self:Add "ttt_curved_panel_outline"
	self.ItemLine:SetCurve(6)
	self.ItemLine:SetColor(Color(95, 96, 102))
	self.ItemLine:SetTall(pluto.ui.sizings "ItemSize" + 10)
	self.ItemLine:Dock(TOP)
	self.ItemLine:DockMargin(5, 0, 5, 10)
	self.ItemLine:DockPadding(7, 0, 7, 0)

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
		local x = math.Round(w / 2 - (pluto.ui.sizings "ItemSize" * amt + 5 * (amt - 1)) / 2)

		for i = 1, amt do
			self.Items[i]:SetPos(x, h / 2 - pluto.ui.sizings "ItemSize" / 2)
			x = x + pluto.ui.sizings "ItemSize" + 5
		end
	end


	self.GoButton = self:Add "pluto_inventory_button"
	self.GoButton:Dock(TOP)
	self.GoButton:SetMouseInputEnabled(false)
	self.GoButton:DockMargin(55, 12, 55, 7)
	self.GoButton:SetTall(18)
	self.GoButton:SetCurve(2)
	self.GoButton:SetColor(Color(95, 96, 102), Color(95, 96, 102))
	self.GoButton:SetMouseInputEnabled(true)

	function self.GoButton.DoClick()
		self:Go()
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
	self.ShardResultLine:Dock(BOTTOM)
	self.ShardResultLine:DockMargin(0, 5, 0, 5)

	self.ShardResults = {}

	function self.ShardResultLine:Relayout()
		local w, h = self:GetSize()
		local children = self:GetChildren()
		local amt = #children
		local x = 0

		for i = 1, amt do
			children[i]:SetPos(x, h / 2 - 28 / 2)
			x = x + 28 + 5
		end
	end

	function self.ShardResultLine:PerformLayout()
		self:Relayout()
	end

	self:RecreateResults()
	self:SetGoodToGo(true)
end

function PANEL:SetGoodToGo(good)
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
	self.UsedItems = {}
end

vgui.Register("pluto_inventory_crafting_shards", PANEL, "EditablePanel")
