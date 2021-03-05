surface.CreateFont("pluto_craft_combine", {
	font = "Lato",
	size = 22,
	weight = 300,
})
surface.CreateFont("pluto_craft_outcome", {
	font = "Lato",
	size = 18,
	weight = 300,
})
local PANEL = {}

function PANEL:SetTab(tab)
	for i, item in ipairs(self.Items) do
		local it = tab.Items[i]
		if (it and it.ID) then
			self.Used[it.ID] = true
		end
		item:SetItem(it, tab)
	end
	for i, item in ipairs(self.Outcomes) do
		item:SetItem(item.Item, tab)
	end

	self.Tab = tab
end

function PANEL:Init()
	self:DockPadding(20, 16, 20, 10)

	self.Lines = {}

	for i = 1, 3 do
		self.Lines[i] = self:Add "EditablePanel"
		self.Lines[i]:Dock(TOP)
	end

	self.MainElements = self.Lines[1]
	self.MainElements:DockMargin(0, 10, 0, 10)
	self.Lines[2]:DockMargin(0, 0, 0, 10)

	for _, line in ipairs(self.Lines) do
		line:DockMargin(0, 0, 0, 10)
		function line.PerformLayout(s, w, h)
			if (s.LastWidth == w and s.LastHeight == h) then
				return
			end
			s.LastWidth, s.LastHeight = w, h
			local children = s:GetChildren()
			table.sort(children, function(a, b)
				return a:GetZPos() < b:GetZPos()
			end)

			local count = #children

			w = w - h * count

			local w_div = 10

			for _, item in ipairs(children) do
				item:SetWide(h)
			end

			children[1]:DockMargin((w - w_div * (count - 1)) / 2, 0, w_div, 0)
			for i = 2, count - 1 do
				children[i]:DockMargin(0, 0, w_div, 0)
			end
		end
	end

	self.Lines[2].PerformLayout = function(s, w, h)
		if (s.LastWidth == w and s.LastHeight == h) then
			return
		end
		s.LastWidth, s.LastHeight = w, h
		local children = s:GetChildren()
		table.sort(children, function(a, b)
			return a:GetZPos() <= b:GetZPos()
		end)

		local count = #children
		local w_div = 10

		w = w - h * (count + 1)

		for _, item in ipairs(children) do
			item:SetWide(h)
		end
		children[2]:SetWide(h * 2)

		children[1]:DockMargin((w - w_div * (count - 1)) / 2, 0, w_div, 0)
		for i = 2, count - 1 do
			children[i]:DockMargin(0, 0, w_div, 0)
		end
	end

	self.MainElements:Dock(TOP)

	self.Items = {}

	self.Used = {}

	for i = 1, 7 do
		local parent
		local zpos
		if (i <= 3) then
			parent = self.Lines[1]
			zpos = i - 1
		elseif (i <= 5) then
			parent = self.Lines[2]
			zpos = i - 4
		elseif (i <= 7) then
			parent = self.Lines[3]
			zpos = i - 6
		end
		local p = parent:Add "pluto_inventory_item"
		p:Dock(LEFT)
		p.Used = self.Used
		p.TabIndex = i

		if (i <= 3) then
			function p:Filter(x)
				return x.Type == "Shard"
			end
		else
			function p:Filter(x)
				return x.Type == "Weapon"
			end
		end

		function p:SwitchWith(other)
			if (other.Tab.ID == 0) then
				return
			end


			if (other.Item and not self.Used[other.Item.ID] and self:Filter(other.Item)) then
				if (self.Item) then
					self.Used[self.Item.ID] = nil
				end

				self:SetItem(other.Item)
				self.Tab.Items[i] = other.Item

				self.Used[self.Item.ID] = true
			end

			pluto.ui.unsetghost()
		end

		function p:RightClick()
			if (self.Item) then
				self.Used[self.Item.ID] = nil
			end
			self:SetItem()
			self.Tab.Items[i] = nil
		end

		function p.OnSetItem(s, item)
			if (self.Tab) then
				self:OnSetItem(s.TabIndex, item)
			end
		end

		if (i <= 3) then
			p:SetDefault "shard"
		end
		self.Items[i] = p
		p:SetZPos(zpos * 2)
	end

	self.Currency = self.Lines[3]:Add "pluto_trade_currency"
	self.Currency.Filter = function(data)
		return data.Crafted
	end
	self.Currency:SetModifiable()
	function self.Currency:OnUpdate()
		if (self.Info) then
			self.Info.Amount = math.min(self.Info.Amount or 0, 10, pluto.cl_currency[self.Info.Currency or ""] or 0)

			local crafted = pluto.currency.byname[self.Info.Currency].Crafted

			if (not crafted) then
				self.Info = nil
			end
		end
		self:UpdateText()
	end

	function self.Currency.UpdateText()
		self:UpdateText "currency"
	end

	self.Currency:SetZPos(1)
	self.Currency:Dock(LEFT)

	self.Outcomes = {}

	self.OutcomeLayer = self:Add "EditablePanel"
	self.OutcomeLayer:Dock(BOTTOM)
	self.OutcomeLayer:SetTall(64)

	self.OutcomeLayerText = self:Add "DLabel"
	self.OutcomeLayerText:Dock(BOTTOM)
	self.OutcomeLayerText:SetTall(64)
	self.OutcomeLayerText:SetContentAlignment(5)
	self.OutcomeLayerText:SetText "Possible Tier Outcomes"
	self.OutcomeLayerText:SetFont "pluto_craft_outcome"

	self.CraftButton = self.Lines[2]:Add "ttt_curved_button"

	self.CraftButton:SetZPos(1)
	self.CraftButton:Dock(LEFT)
	self.CraftButton:SetCurve(4)
	self.CraftButton:SetColor(Color(50,51,52))
	self.CraftButton:SetFont "pluto_craft_combine"
	self.CraftButton:SetText "Combine!"
	self.CraftButton:DockMargin(0, 10, 0, 10)

	function self.CraftButton.DoClick(s)
		local items = self:GetItems()
		if (pluto.craft.valid(items)) then
			return
		end

		pluto.inv.message()
			:write("craft", items, self.Currency.Info)
			:send()

		for i, panel in pairs(self.Items) do
			panel:SetItem()
			self.Tab.Items[i] = nil
		end

		self.Currency:SetInfo()

		for _, item in pairs(items) do
			if (item) then
				hook.Run("PlutoItemDelete", item.ID)
			end
		end
	end

	function self.OutcomeLayer.PerformLayout(s, w, h)
		local outcomes = self.Outcomes
		local size = #outcomes * h + (#outcomes - 1) * 5
		local x = (w - size) / 2

		for _, p in pairs(self.Outcomes) do
			if (not IsValid(p)) then
				continue
			end
			p:SetSize(h, h)
			p:SetPos(x, 0)
			x = x + p:GetParent():GetTall() + 5
		end
	end

	self.Text = self:Add "DLabel"
	self.Text:SetFont "pluto_craft_outcome"
	self.Text:SetContentAlignment(8)
	self.Text:SetText ""
	self.Text:Dock(FILL)

	hook.Add("PlutoCraftResults", self, self.PlutoCraftResults)
	hook.Add("PlutoItemDelete", self, self.PlutoItemDelete)
end

function PANEL:GetItems()
	local items = {}
	for i, panel in ipairs(self.Items) do
		items[i] = panel.Item
	end

	return items
end

function PANEL:PlutoItemDelete(item)
	for _, panel in pairs(self.Items) do
		if (panel.Item and panel.Item.ID == item) then
			panel:SetItem()
			panel.Tab.Items[panel.TabIndex] = nil
		end
	end
end

function PANEL:UpdateText(why)
	self.TextData = self.TextData or {}
	local text
	if (why == "currency") then
		local info = self.Currency.Info
		if (info) then
			local crafted = pluto.currency.byname[info.Currency].Crafted
			if (crafted) then
				text = string.format("Chance to get %s modifier: %.2f%%", crafted.Mod, pluto.mods.chance(crafted, info.Amount) * 100)
			end
		end
	end

	self.TextData[why] = text

	local text = {}
	for k, v in SortedPairs(self.TextData) do
		text[#text + 1] = v
	end

	self.Text:SetText(table.concat(text, "\n"))
end

function PANEL:OnSetItem(id, item)
	pluto.inv.message()
		:write("requestcraftresults", self:GetItems())
		:send()

	for _, child in pairs(self.Outcomes) do
		child:Remove()
	end
	self.Outcomes = {}
end

function PANEL:PerformLayout(w, h)
	for _, line in ipairs(self.Lines) do
		line:SetTall(w / 8)
	end
end

function PANEL:PlutoCraftResults(outcomes)
	self.TextData = outcomes.Info

	self:UpdateText "currency"

	for _, child in pairs(self.Outcomes) do
		child:Remove()
	end

	for _, i in ipairs(outcomes) do
		i.rand = math.random()
	end

	table.sort(outcomes, function(a, b)
		return a.rand < b.rand
	end)

	for n, i in ipairs(outcomes) do
		i.rand = nil

		local p = self.OutcomeLayer:Add "pluto_inventory_item"
		p:SetItem(i, self.Tab)
		p:SetNoMove()

		self.Outcomes[n] = p
	end

	self.Outcomes[#self.Outcomes]:DockMargin(0, 0, 0, 0)

	self.OutcomeLayer:InvalidateLayout(true)
end

vgui.Register("pluto_craft", PANEL, "EditablePanel")

function pluto.inv.writecraftheader(items)
	for i = 1, 7 do
		local item = items[i]
		if (item) then
			net.WriteBool(true)
			net.WriteUInt(item.ID, 32)
		else
			net.WriteBool(false)
		end
	end
end

function pluto.inv.writerequestcraftresults(items)
	pluto.inv.writecraftheader(items)
end

function pluto.inv.readcraftresults(cl)
	local outcomes = {
		Info = {}
	}

	for i = 1, net.ReadUInt(8) do
		local item = pluto.received.item[id] or setmetatable({
			ID = "fake",
		}, pluto.inv.item_mt)
		outcomes[i] = item
		pluto.inv.readbaseitem(item)
	end

	while (net.ReadBool()) do
		outcomes.Info[net.ReadString()] = net.ReadString()
	end

	hook.Run("PlutoCraftResults", outcomes)
end

function pluto.inv.writecraft(items, currency)
	pluto.inv.writecraftheader(items)
	if (currency) then
		net.WriteBool(true)
		net.WriteString(currency.Currency.InternalName)
		net.WriteUInt(currency.Amount, 32)
	else
		net.WriteBool(false)
	end
end