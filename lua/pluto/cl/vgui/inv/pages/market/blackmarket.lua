local PANEL = {}

function PANEL:Init()
	self.RightSide = self:Add "ttt_curved_panel_outline"
	self.RightSide:Dock(RIGHT)
	self.RightSide:SetCurve(4)
	self.RightSide:DockMargin(5, 0, 0, 0)
	self.RightSide:DockPadding(5, 5, 5, 5)
	self.RightSide:SetColor(pluto.ui.theme "InnerColorSeperator")
	self.RightSide:SetWide(pluto.ui.sizings "ItemSize" * 4 + 5 * 5)

	self.ShopScroll = self.RightSide:Add "DScrollPanel"
	self.ShopScroll:Dock(FILL)
	

	self.Fill = self:Add "ttt_curved_panel_outline"
	self.Fill:Dock(FILL)
	self.Fill:SetColor(pluto.ui.theme "InnerColorSeperator")

	for i = 1, 10 do
		self:AddShopItem {
			Price = math.random(1, 100)
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
	img:DockMargin(2, 3, 3, 3)
	img:SetImage(pluto.currency.byname.tp.Icon)
	
	function container_fill:PerformLayout(w, h)
		img:SetSize(h - 6, h - 6)
	end

	local price = container_fill:Add "pluto_label"
	price:Dock(FILL)
	price:SetText(tonumber(data.Price))
	price:SetContentAlignment(6)
	price:SetFont "pluto_inventory_font"
	price:SetTextColor(pluto.ui.theme "TextActive")
	price:SetRenderSystem(pluto.fonts.systems.shadow)
	price:SizeToContentsY()

end

vgui.Register("pluto_inventory_blackmarket", PANEL, "EditablePanel")