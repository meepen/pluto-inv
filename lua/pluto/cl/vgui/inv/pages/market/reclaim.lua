local PANEL = {}

PANEL.ResultRow = 6
PANEL.ResultColumn = 6
PANEL.Padding = 3

function PANEL:Init()
	self.ResultArea = self:Add "EditablePanel"
	self.ResultArea:Dock(RIGHT)
	self.ResultArea:SetWide(self.ResultColumn * pluto.ui.sizings "ItemSize" + (self.ResultColumn - 1) * self.Padding)

	self.ItemArea = self.ResultArea:Add "EditablePanel"
	self.ItemArea:SetTall(self.ResultRow * pluto.ui.sizings "ItemSize" + (self.ResultRow + 1) * self.Padding)
	self.ItemArea:SetZPos(1)
	self.ItemArea:Dock(TOP)

	self.Results = {}
	self.ResultPrices = {}

	for y = 1, self.ResultRow do
		local row = self.ItemArea:Add "EditablePanel"
		row:Dock(TOP)
		row:DockMargin(0, y == 1 and self.Padding or 0, 0, self.Padding)
		row:SetTall(pluto.ui.sizings "ItemSize")

		for x = 1, self.ResultColumn do
			local itempnl = row:Add "pluto_inventory_item"
			itempnl:Dock(LEFT)
			itempnl:SetWide(pluto.ui.sizings "ItemSize")
			itempnl:DockMargin(x == 1 and 0 or self.Padding, 0, 0, 0)
			table.insert(self.Results, itempnl)

			function itempnl:OnRightClick()
				if (not self.Item) then
					return
				end

				pluto.ui.rightclickmenu(self.Item, function(menu, item)
					menu:AddOption("Reclaim from auction house", function()
						RunConsoleCommand("pluto_auction_reclaim", self.Item.ID)
					end):SetIcon "icon16/money_add.png"
				end)
			end
			itempnl.OnLeftClick = itempnl.OnRightClick

			local container = itempnl.ItemPanel:Add "ttt_curved_panel_outline"
			container:SetCurve(4)
			container:SetColor(Color(95, 96, 102))
			container:Dock(BOTTOM)

			local container_fill = container:Add "ttt_curved_panel"
			container_fill:SetCurve(4)
			container_fill:Dock(FILL)
			container_fill:SetColor(Color(52, 51, 52))

			local price = container_fill:Add "pluto_label"
			price:Dock(FILL)
			price:SetText "0"
			price:SetContentAlignment(6)
			price:SetFont "pluto_inventory_font"
			price:SetTextColor(pluto.ui.theme "TextActive")
			price:SetRenderSystem(pluto.fonts.systems.shadow)
			price:SizeToContentsY()
			price:SetVisible(false)

			container:SetTall(price:GetTall())

			local img = container_fill:Add "DImage"
			img:SetImage(pluto.currency.byname.stardust.Icon)
			img:Dock(RIGHT)
			function img.PerformLayout(s, w, h)
				img:SetWide(h)
			end

			table.insert(self.ResultPrices, price)
		end
	end

	self.Pagination = self.ResultArea:Add "EditablePanel"
	self.Pagination:Dock(FILL)
	self.Pagination:DockMargin(0, 0, 0, self.Padding)

	self.PaginationLabel = self.Pagination:Add "pluto_label"
	self.PaginationLabel:SetFont "pluto_inventory_font_s"
	self.PaginationLabel:SetRenderSystem(pluto.fonts.systems.shadow)
	self.PaginationLabel:SetText "hi"
	self.PaginationLabel:SetTextColor(pluto.ui.theme "TextActive")
	self.PaginationLabel:SetContentAlignment(5)

	self.PageDown = self.Pagination:Add "pluto_label"
	self.PageDown:SetCursor "hand"
	self.PageDown:SetMouseInputEnabled(true)
	self.PageDown:SetFont "pluto_inventory_font_s"
	self.PageDown:SetRenderSystem(pluto.fonts.systems.shadow)
	self.PageDown:SetText "<<"
	self.PageDown:SetTextColor(pluto.ui.theme "TextActive")
	self.PageDown:SetContentAlignment(5)
	function self.PageDown.OnMousePressed()
		local page = self:GetPage() - 1
		if (page < 1) then
			return
		end
		self:SearchPage(page)
	end


	self.PageUp = self.Pagination:Add "pluto_label"
	self.PageUp:SetCursor "hand"
	self.PageUp:SetMouseInputEnabled(true)
	self.PageUp:SetFont "pluto_inventory_font_s"
	self.PageUp:SetRenderSystem(pluto.fonts.systems.shadow)
	self.PageUp:SetText ">>"
	self.PageUp:SetTextColor(pluto.ui.theme "TextActive")
	self.PageUp:SetContentAlignment(5)

	function self.PageUp.OnMousePressed()
		local page = self:GetPage() + 1
		if (page > self:GetPageMax()) then
			return
		end
		self:SearchPage(page)
	end

	function self.Pagination.PerformLayout()
		self.PaginationLabel:Center()
		self.PageDown:SetTall(self.PaginationLabel:GetTall())
		self.PageUp:SetTall(self.PaginationLabel:GetTall())
		local x, y = self.PaginationLabel:GetPos()
		self.PageDown:SetPos(x - self.PageDown:GetWide() - self.Padding, y)
		self.PageUp:SetPos(x + self.PaginationLabel:GetWide() + self.Padding, y)
		self.ListAreaContainer:DockMargin(self.Padding * 1, self.Padding, self.Padding * 2, self.Pagination:GetTall() + self.Padding * 2)
	end

	self.ListAreaContainer = self:Add "EditablePanel"
	self.ListAreaContainer:Dock(FILL)
	self.ListAreaContainer:DockPadding(self.Padding + 1, self.Padding + 1, self.Padding + 1, self.Padding + 1)

	self.ListDataContainer = self.ListAreaContainer:Add "ttt_curved_panel_outline"
	self.ListDataContainer:SetCurve(4)
	self.ListDataContainer:SetColor(Color(95, 96, 102))
	self.ListDataContainer:SetSize(132, 132)

	self.ListItem = self.ListDataContainer:Add "pluto_inventory_item"
	self.ListItem:SetItem(pluto.ui.listeditem)
	pluto.ui.listeditem = nil

	function self.ListItem.CanClickWith(s, other)
		local item = other.Item
		return item
	end
	function self.ListItem.ClickedWith(s, other)
		s:SetItem(other.Item)
	end
	function self.ListItem.OnRightClick(s)
		s:SetItem(nil)
	end
	function self.ListItem.OnLeftClick(s)
		if (not s.Item) then
			return -- 
		end

		pluto.ui.highlight(s.Item)
	end

	function self.ListItem.OnSetItem(s, item)
	end

	self.ListAmount = self.ListDataContainer:Add "pluto_inventory_textentry"
	self.ListAmount:SetContentAlignment(6)
	self.ListAmount:Dock(BOTTOM)
	self.ListAmount:DockMargin(4, 4, 4, 4)

	self.TaxLabel = self.ListDataContainer:Add "pluto_label"
	self.TaxLabel:SetRenderSystem(pluto.fonts.systems.shadow)
	self.TaxLabel:SetText "10 + 7.5% up to 200 tax"
	self.TaxLabel:SetTextColor(pluto.ui.theme "TextActive")
	self.TaxLabel:SetContentAlignment(2)
	self.TaxLabel:SetFont "pluto_inventory_font_s"
	self.TaxLabel:Dock(BOTTOM)


	function self.ListAmount.OnChange(s)
		self:OnUpdated()
	end

	function self.ListAreaContainer.PerformLayout(s, w, h)
		self.ListDataContainer:Center()
		self.ListButton:MoveBelow(self.ListDataContainer, 12)
		self.ListButton:CenterHorizontal()
	end

	function self.ListDataContainer.PerformLayout(s, w, h)
		self.ListButton:SetWide(w * 3 / 4)
		self.ListItem:CenterHorizontal()
		self.ListItem:SetPos(self.ListItem:GetPos(), (h - self.ListAmount:GetTall()) / 2 - self.ListItem:GetTall() / 2)
	end


	self.ListButton = self.ListAreaContainer:Add "pluto_inventory_button"
	self.ListButton:SetColor(Color(95, 96, 102), Color(95, 96, 102))
	self.ListButton:SetCurve(4)
	self.ListButton:SetWide(120)
	self.ListLabel = self.ListButton:Add "pluto_label"
	self.ListLabel:SetRenderSystem(pluto.fonts.systems.shadow)
	self.ListLabel:SetText "List item"
	self.ListLabel:SetTextColor(pluto.ui.theme "TextActive")
	self.ListLabel:SetContentAlignment(5)
	self.ListLabel:SetFont "pluto_inventory_font"
	self.ListLabel:Dock(FILL)
	function self.ListButton.DoClick()
		self:DoList()
	end

	self:SetPage(0)
	self:SetPageMax(1)

	self:SearchPage(1)

	hook.Add("PlutoYourAuctionsUpdated", self, self.PlutoYourAuctionsUpdated)
end

function PANEL:PlutoYourAuctionsUpdated(pagemax, items)
	self:SetPageMax(pagemax)
	for i = 1, 36 do
		local item = items[i]
		self.Results[i]:SetItem(item)
		self.ResultPrices[i]:SetVisible(item)
		if (item) then
			self.ResultPrices[i]:SetText(item.Price or "unk")
		end
	end
end

function PANEL:UpdatePages()
	if (not self.Page or not self.PageMax) then
		return
	end

	self.PaginationLabel:SetText(string.format("Page %i / %i", self.Page, self.PageMax))
	self.PaginationLabel:SizeToContents()
	self.PaginationLabel:Center()

	self.PageDown:SetVisible(self.Page > 1)
	self.PageUp:SetVisible(self.Page < self.PageMax)
end

function PANEL:SetPageMax(max)
	self.PageMax = max
	self:UpdatePages()
end

function PANEL:GetPageMax()
	return self.PageMax
end

function PANEL:SearchPage(page)
	self:SetPage(page)
	self:SendSearch()
end

function PANEL:SetPage(num)
	self.Page = num
	self:UpdatePages()
end

function PANEL:GetPage()
	return self.Page
end

function PANEL:SendSearch()
	pluto.inv.message()
		:write("getmyitems", self.Page)
		:send()
end

function PANEL:DoList()
	if (not self.ListItem.Item.ID) then
		return
	end

	RunConsoleCommand("pluto_auction_list", self.ListItem.Item.ID, self.ListAmount:GetText())
end

function PANEL:OnUpdated()
	local amount = tonumber(self.ListAmount:GetText()) or 0
	self.TaxLabel:SetText(math.ceil(math.min(200, 10 + 0.075 * amount)) .. " tax")
end

vgui.Register("pluto_inventory_auction_reclaim", PANEL, "EditablePanel")

function pluto.inv.writegetmyitems(page)
	net.WriteUInt(page, 32)
end

function pluto.inv.readgotyouritems()
	local pagemax = net.ReadUInt(32)

	local items = {}
	for i = 1, net.ReadUInt(8) do
		items[i] = pluto.inv.readitem()
		items[i].Price = net.ReadUInt(32)
	end

	hook.Run("PlutoYourAuctionsUpdated", pagemax, items)
end

function pluto.ui.listitem(item)
	if (not IsValid(pluto.ui.pnl)) then
		return
	end

	pluto.ui.listeditem = item

	pluto.ui.pnl:ChangeToTab "Divine Market":SelectTab "Your Items"
end