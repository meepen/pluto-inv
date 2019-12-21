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

	self.MainElements = self:Add "EditablePanel"

	function self.MainElements.PerformLayout(s, w, h)
		local padleftright = 30
		s:DockPadding(padleftright, 10, padleftright, 10)

		w = w - padleftright * 2

		for i = 1, 3 do
			self.Items[i]:SetWide(h - 20)
		end

		w = w - (h - 20) * 3 - 24 * 2 -- pluses

		self.Items[1]:DockMargin(0, 0, w / 4, 0)
		self.Items[2]:DockMargin(w / 4, 0, w / 4, 0)
		self.Items[3]:DockMargin(w / 4, 0, 0, 0)
	end

	self.Plus = self:Add "EditablePanel"
	function self.Plus:PerformLayout(w, h)
		self.Plus:SetSize(h, h)
		self.Plus:Center()
	end
	self.Plus.Plus = self.Plus:Add "DImage"
	self.Plus.Plus:SetImage "pluto/plus.png"

	self.CurrencyElements = self:Add "EditablePanel"

	function self.CurrencyElements.PerformLayout(s, w, h)
		self.Currency:SetSize(h, h)
		self.Currency:Center()
	end

	self.MainElements:Dock(TOP)
	self.Plus:Dock(TOP)
	self.Plus:SetTall(24)
	self.CurrencyElements:Dock(TOP)

	self.Items = {}

	self.Used = {}

	for i = 1, 3 do
		local p = self.MainElements:Add "pluto_inventory_item"
		p:Dock(LEFT)
		p.Used = self.Used
		p.NoGhost = true
		p.TabIndex = i
		function p:SwitchWith(other)
			if (other.Tab.ID == 0) then
				return
			end

			if (self.Item) then
				self.Used[self.Item.ID] = nil
			end

			if (other.Item and not self.Used[other.Item.ID] and other.Item.Type == "Shard") then
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

		self.Items[i] = p
	end

	self.Plus1 = self.MainElements:Add "EditablePanel"
	self.Plus1.Plus = self.Plus1:Add "DImage"
	self.Plus1.Plus:SetImage "pluto/plus.png"
	self.Plus1:SetWide(24)
	self.Plus1:Dock(LEFT)

	self.Plus2 = self.MainElements:Add "EditablePanel"
	self.Plus2.Plus = self.Plus2:Add "DImage"
	self.Plus2.Plus:SetImage "pluto/plus.png"
	self.Plus2:SetWide(24)
	self.Plus2:Dock(LEFT)

	function self.Plus1:PerformLayout(w, h)
		self.Plus:SetSize(w, w)
		self.Plus:Center()
	end
	function self.Plus2:PerformLayout(w, h)
		self.Plus:SetSize(w, w)
		self.Plus:Center()
	end

	self.Items[1]:SetZPos(0)
	self.Plus1:SetZPos(1)
	self.Items[2]:SetZPos(2)
	self.Plus2:SetZPos(3)
	self.Items[3]:SetZPos(4)
	
	self.Currency = self.CurrencyElements:Add "pluto_trade_currency"
	self.Currency:SetModifiable()
	function self.Currency:OnUpdate() end

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

	self.CraftButton = self:Add "ttt_curved_button"
	self.CraftButton:Dock(FILL)
	self.CraftButton:SetCurve(4)
	self.CraftButton:SetColor(Color(50,51,52))
	self.CraftButton:SetFont "pluto_craft_combine"
	self.CraftButton:SetText "Combine Shards!"
	self.CraftButton:DockMargin(50, 20, 50, 20)

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

function PANEL:OnSetItem(id, item)
	local i1 = self.Items[1].Item
	local i2 = self.Items[2].Item
	local i3 = self.Items[3].Item

	if (i1 and i2 and i3) then
		pluto.inv.message()
			:write("requestcraftresults", i1, i2, i3)
			:send()
	else
		for _, child in pairs(self.Outcomes) do
			child:Remove()
		end
		self.Outcomes = {}
	end
end

function PANEL:PerformLayout(w, h)
	self.MainElements:SetTall(w / 4)

	self.CurrencyElements:SetTall(w / 6)
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

		self.Outcomes[n] = p
	end

	self.Outcomes[#self.Outcomes]:DockMargin(0, 0, 0, 0)

	self.OutcomeLayer:InvalidateLayout(true)
end

vgui.Register("pluto_craft", PANEL, "pluto_inventory_base")


function pluto.inv.writerequestcraftresults(i1, i2, i3)
	net.WriteUInt(i1.ID, 32)
	net.WriteUInt(i2.ID, 32)
	net.WriteUInt(i3.ID, 32)
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

	for _, tab in pairs(pluto.cl_inv) do
		for idx, item in pairs(tab.Items or {}) do
			print(item.ID)
			if (item.ID == i1.ID or item.ID == i2.ID or item.ID == i3.ID) then
				tab.Items[idx] = nil

				print "del"
				hook.Run("PlutoTabUpdate", tab.ID, idx, nil)
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