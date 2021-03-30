local PANEL = {}

function PANEL:Init()
	self:DockPadding(3, 3, 3, pluto.ui.sizings "pluto_inventory_font")
	self.ShopScroll = self:Add "EditablePanel"
	self.ShopScroll:Dock(RIGHT)
	self.ShopScroll:SetWide(pluto.ui.sizings "ItemSize" * 4 + 5 * 3)
	self.ShopScroll:DockMargin(5 + 20, 0, 0, 0)

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
				price:SetText("111")
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

	for i = 1, 10 do
		self:AddShopItem {
			Price = math.random(1, 100),
			Item = nil
		}
	end
end

function PANEL:GetNextShopLayer()
	if (not IsValid(self.ShopLayer) or #self.ShopLayer:GetChildren() >= 4) then
		local t = self.ShopScroll:Add "EditablePanel"
		t:Dock(TOP)
		t:SetTall(pluto.ui.sizings "ItemSize")
		t:DockMargin(0, 0, 0, 5)
		self.ShopLayer = t
	end

	return self.ShopLayer
end

function PANEL:AddShopItem(data)
	local layer = self:GetNextShopLayer()
	local item = layer:Add "pluto_inventory_item"
	item:SetWide(pluto.ui.sizings "ItemSize")
	item:Dock(LEFT)
	item:DockMargin(0, 0, 5, 0)

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

vgui.Register("pluto_inventory_blackmarket", PANEL, "EditablePanel")