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

hook.Remove("DrawOverlay", "cancer", function()
	local p = vgui.GetHoveredPanel()
	if (IsValid(p)) then
		local x0, y0 = p:LocalToScreen(0, 0)
		local x1, y1 = p:LocalToScreen(p:GetSize())

		surface.SetTextColor(white_text)
		surface.SetDrawColor(100, 50, 50, 50)
		surface.SetFont "BudgetLabel"

		surface.SetTextPos(x0, y1)
		surface.DrawText(tostring(p))

		surface.DrawRect(x0, y0, x1 - x0, y1 - y0)
	end

end)

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
		local children = s:GetChildren()
		table.sort(children, function(a, b)
			return a:GetZPos() < b:GetZPos()
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
		if (i <= 3) then
			parent = self.Lines[1]
		elseif (i <= 5) then
			parent = self.Lines[2]
		elseif (i <= 7) then
			parent = self.Lines[3]
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

			if (self.Item) then
				self.Used[self.Item.ID] = nil
			end

			if (other.Item and not self.Used[other.Item.ID] and self:Filter(other.Item)) then
				self:SetItem(other.Item)
				self.Tab.Items[i] = other.Item

				self.Used[self.Item.ID] = true
			end

			pluto.ui.ghost = nil
		end

		function p:RightClick()
			if (self.Item) then
				self.Used[self.Item.ID] = nil
			end
			self:SetItem()
			self.Tab.Items[i] = nil
		end

		function p.OnSetItem(s, item)
			self:OnSetItem(s.TabIndex, item)
		end

		if (i <= 3) then
			p:SetDefault "shard"
		end
		self.Items[i] = p
		p:SetZPos(i * 2)
	end

	self.Currency = self.Lines[3]:Add "pluto_trade_currency"
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

	self.Currency:SetZPos(6 * 2 + 1)
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

	self.CraftButton:SetZPos(9)
	self.CraftButton:Dock(LEFT)
	self.CraftButton:SetCurve(4)
	self.CraftButton:SetColor(Color(50,51,52))
	self.CraftButton:SetFont "pluto_craft_combine"
	self.CraftButton:SetText "Combine!"
	self.CraftButton:DockMargin(0, 10, 0, 10)

	function self.CraftButton.DoClick(s)
		pluto.inv.message()
			:write("craft", {
				Shards = {
					self.Items[1].Item,
					self.Items[2].Item,
					self.Items[3].Item,
				},
				Currency = self.Currency.Info,
			})
			:send()
		self.Items[1]:SetItem()
		self.Items[2]:SetItem()
		self.Items[3]:SetItem()
		self.Tab.Items[1] = nil
		self.Tab.Items[2] = nil
		self.Tab.Items[3] = nil
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

	hook.Add("PlutoCraftResults", self, self.PlutoCraftResults)
end

function PANEL:UpdateText(why)
	self.Text = self.Text or {}
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
	print(why, text)
	self.Text[why] = text
end

function PANEL:OnSetItem(id, item)
	local items = {}
	for i, panel in ipairs(self.Items) do
		items[i] = panel.Item
	end

	pluto.inv.message()
		:write("requestcraftresults", items)
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
	for _, child in pairs(self.Outcomes) do
		child:Remove()
	end

	for _, i in pairs(outcomes) do
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

vgui.Register("pluto_craft", PANEL, "pluto_inventory_base")


function pluto.inv.writerequestcraftresults(items)
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

function pluto.inv.readcraftresults(cl)
	local outcomes = {}
	for i = 1, net.ReadUInt(8) do
		local item = pluto.received.item[id] or setmetatable({
			ID = "fake",
		}, pluto.inv.item_mt)
		outcomes[i] = item
		pluto.inv.readbaseitem(item)
	end

	hook.Run("PlutoCraftResults", outcomes)
end

function pluto.inv.writecraft(info)
	local i1, i2, i3 = info.Shards[1], info.Shards[2], info.Shards[3]

	if (i1 and i2 and i3) then
		for _, tab in pairs(pluto.cl_inv) do
			for idx, item in pairs(tab.Items or {}) do
				if (i1 and item.ID == i1.ID or i2 and item.ID == i2.ID or i3 and item.ID == i3.ID) then
					tab.Items[idx] = nil

					hook.Run("PlutoTabUpdate", tab.ID, idx, nil)
				end
			end
		end
	end

	net.WriteUInt(i1 and i1.ID or 0, 32)
	net.WriteUInt(i2 and i2.ID or 0, 32)
	net.WriteUInt(i3 and i3.ID or 0, 32)

	if (info.Currency) then
		net.WriteBool(true)
		net.WriteString(info.Currency.Currency)
		net.WriteUInt(info.Currency.Amount, 32)
	else
		net.WriteBool(false)
	end
end