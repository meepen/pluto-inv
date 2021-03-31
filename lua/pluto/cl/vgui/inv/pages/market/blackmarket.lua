local PANEL = {}

local blackmarket_items_test = {
	{
		Price = math.random(1, 10000),
		Item = setmetatable({
			Type = "Weapon",
			Mods = {},
			ClassName = "weapon_ttt_m4a1",
			Tier = pluto.tiers.byname.otherworldly,
		}, pluto.inv.item_mt)
	}
}

function PANEL:Init()
	surface.CreateFont("headline_font", {
		font = "Permanent Marker",
		size = pluto.ui.sizings "pluto_inventory_font_xlg" * 1.4,
		antialias = true,
		weight = 500
	})

	self:DockPadding(3, 3, 3, pluto.ui.sizings "pluto_inventory_font")
	self.ShopScroll = self:Add "EditablePanel"
	self.ShopScroll:Dock(RIGHT)
	self.ShopScroll:SetWide(pluto.ui.sizings "ItemSize" * 5 + 5 * 4)
	self.ShopScroll:DockMargin(5 + 20, 0, 0, 0)

	self.Header = self.ShopScroll:Add "ttt_curved_panel"
	self.Header:Dock(TOP)
	self.Header:SetColor(pluto.ui.theme "InnerColorSeperator")
	self.Header:SetTall(pluto.ui.sizings "pluto_inventory_font_xlg" + 8)
	self.Header:DockMargin(0, 0, 0, 5)
	self.Header:SetCurve(6)

	self.TextHeader = self.Header:Add "pluto_label"
	self.TextHeader:SetRenderSystem(pluto.fonts.systems.shadow)
	self.TextHeader:SetText "SPECIALS XD"
	self.TextHeader:SetFont "headline_font"
	self.TextHeader:SetContentAlignment(5)
	self.TextHeader:Dock(FILL)
	self.TextHeader:SetTextColor(pluto.ui.theme "TextActive")

	self.Fill = self:Add "EditablePanel"
	self.Fill:Dock(FILL)

	self.StardustItems = self.Fill:Add "EditablePanel"
	self.StardustItems:Dock(TOP)
	self.StardustItems:SetTall(pluto.ui.sizings "ItemSize" * 3 + 5 * 2)

	self.Lines = {}
	self.StardustItemPanels = {}
	for i = 1, 3 do
		local line = self.StardustItems:Add "EditablePanel"
		line:SetSize(pluto.ui.sizings "ItemSize" * 5 + 5 * 4, pluto.ui.sizings "ItemSize")
		self.Lines[i] = line

		if (i ~= 1) then
			for x = 1, 5 do
				local item = line:Add "pluto_inventory_item"
				item:Dock(LEFT)
				item:SetWide(pluto.ui.sizings "ItemSize")
				item:DockMargin(0, 0, 5, 0)
				table.insert(self.StardustItemPanels, item)

				
				local container = item.ItemPanel:Add "ttt_curved_panel_outline"
				container:SetCurve(4)
				container:SetColor(pluto.ui.theme "InnerColorSeperator")
				container:Dock(BOTTOM)

				local container_fill = container:Add "ttt_curved_panel"
				container_fill:SetCurve(4)
				container_fill:Dock(FILL)
				container_fill:SetColor(Color(52, 51, 52))

				local img = container_fill:Add "DImage"
				img:Dock(RIGHT)
				img:DockMargin(1, 1, 1, 1)
				img:SetImage(pluto.currency.byname.stardust.Icon)

				function container_fill:PerformLayout(w, h)
					img:SetSize(h - 2, h - 2)
				end

				local price = container_fill:Add "pluto_label"
				price:Dock(FILL)
				price:SetText ""
				price:SetContentAlignment(6)
				price:SetFont "pluto_inventory_font"
				price:SetTextColor(pluto.ui.theme "TextActive")
				price:SetRenderSystem(pluto.fonts.systems.shadow)
				price:SizeToContentsY()
				container:SetTall(price:GetTall())
		
				item.PricePanel = price
			end
		else
			for i = 1, 4 do
				local pnl
				if (i == 1 or i == 3) then
					pnl = line:Add "EditablePanel"
					pnl:Dock(LEFT)
					pnl:SetWide(pluto.ui.sizings "ItemSize")
				else
					pnl = line:Add "pluto_inventory_currency_selector"
					pnl:Dock(LEFT)
					pnl:SetWide(pluto.ui.sizings "ItemSize")
					pnl:ShowAmount(true)
				end
				pnl:DockMargin(0, 0, 5, 0)
			end
		end
	end

	function self.StardustItems.PerformLayout(s, w, h)
		local sy = h / 2 - (#self.Lines * self.Lines[1]:GetTall()) / 2 - (#self.Lines - 1) * 5 / 2
		for i, line in ipairs(self.Lines) do
			line:SetPos(0, sy)
			line:CenterHorizontal()
			sy = sy + line:GetTall() + 5
		end
	end

	hook.Add("ReceiveStardustShop", self, self.ReceiveStardustShop)

	for _, data in ipairs(blackmarket_items_test) do
		self:AddBlackmarketItem(data)
	end
end

function PANEL:ReceiveStardustShop(stardusts)
	for i, item in ipairs(stardusts) do
		self.StardustItemPanels[i]:SetItem(item.Item)
		self.StardustItemPanels[i].PricePanel:SetText(item.Price)
	end
end

function PANEL:GetNextShopLayer()
	if (not IsValid(self.ShopLayer) or #self.ShopLayer:GetChildren() >= 5) then
		local t = self.ShopScroll:Add "EditablePanel"
		t:Dock(TOP)
		t:SetTall(pluto.ui.sizings "ItemSize")
		t:DockMargin(0, 0, 0, 5)
		self.ShopLayer = t
	end

	return self.ShopLayer
end

function PANEL:AddBlackmarketItem(data)
	local layer = self:GetNextShopLayer()
	local item = layer:Add "pluto_inventory_item"
	item:SetWide(pluto.ui.sizings "ItemSize")
	item:Dock(LEFT)
	item:DockMargin(0, 0, 5, 0)
	item:SetItem(data.Item)

	local container = item.ItemPanel:Add "ttt_curved_panel_outline"
	container:SetCurve(4)
	container:SetColor(pluto.ui.theme "InnerColorSeperator")
	container:Dock(BOTTOM)

	local container_fill = container:Add "ttt_curved_panel"
	container_fill:SetCurve(4)
	container_fill:Dock(FILL)
	container_fill:SetColor(Color(52, 51, 52))

	local img = container_fill:Add "DImage"
	img:Dock(RIGHT)
	img:DockMargin(1, 1, 1, 1)
	img:SetImage(pluto.currency.byname.tp.Icon)
	
	function container_fill:PerformLayout(w, h)
		img:SetSize(h - 2, h - 2)
	end

	local price = container_fill:Add "pluto_label"
	price:Dock(FILL)
	price:SetText(tonumber(data.Price))
	price:SetContentAlignment(6)
	price:SetFont "pluto_inventory_font"
	price:SetTextColor(pluto.ui.theme "TextActive")
	price:SetRenderSystem(pluto.fonts.systems.shadow)
	price:SizeToContentsY()

	container:SetTall(price:GetTall())
end

function PANEL:Paint()
	if (not self.HasPainted) then
		self.HasPainted = true
		RunConsoleCommand "pluto_send_stardust_shop"
	end
end

vgui.Register("pluto_inventory_blackmarket", PANEL, "EditablePanel")