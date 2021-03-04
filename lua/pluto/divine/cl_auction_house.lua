local PANEL = {}
function PANEL:SetTab()
	self.Tab = {
		Active = true,
		Items = {},
		ID = 0,
	}

	for _, item in ipairs(self.Items) do
		item:SetItem(nil, self.Tab)
	end
end

function PANEL:Init()
	self.Rows = {}
	self.Items = {}
	self.Prices = {}
	self.Images = {}
	for i = 1, 3 do
		self.Rows[i] = self:Add "EditablePanel"
		local row = self.Rows[i]
		row:Dock(TOP)
		row:SetTall(90)
		self.Rows[i].OnChildAdded = function(self, c)
			timer.Simple(0, function()
				local children = self:GetChildren()
				local w, h = self:GetSize()
				local totalw = #children * 10
	
				for _, child in ipairs(children) do
					totalw = totalw + child:GetWide()
				end
	
				local cw = 0
				for _, child in ipairs(children) do
					child:SetPos(w / 2 - totalw / 2 + cw, h / 2 - child:GetTall() / 2)
					cw = cw + 10 + child:GetWide()
				end
			end)
		end

		for j = 1, 5 do
			local container = row:Add "EditablePanel"
			container:SetSize(64, 64 + 20)

			local item = container:Add "pluto_inventory_item"
			item:Dock(TOP)
			item:SetTall(64)
			item:SetNoMove()
			function item:OverrideClick()
				if (not self.Item) then
					return
				end

				pluto.divine.confirm("Buy", function()
					RunConsoleCommand("pluto_auction_buy", self.Item.ID)
				end)
			end

			local label = container:Add "DLabel"
			label:Dock(FILL)
			label:SetFont "stardust_shop_price"
			label:SetText ""
			label:SetContentAlignment(6)
	
			local img = container:Add "DImage"
			img:Dock(RIGHT)
			img:SetImage(pluto.currency.byname.stardust.Icon)
			img:DockMargin(2, 2, 2, 2)
			function img:PerformLayout(w, h)
				self:SetWide(h)
			end
			img:SetVisible(false)

			table.insert(self.Images, img)
			table.insert(self.Prices, label)
			table.insert(self.Items, item)
		end
	end

	self.Pages = self:Add "EditablePanel"
	self.Pages:Dock(TOP)
	self.Pages:DockMargin(10, 10, 10, 10)
	self.Pages:SetTall(32)
	
	self.PageLabel = self.Pages:Add "DLabel"
	self.PageLabel:SetContentAlignment(5)
	self.PageLabel:SetFont "stardust_shop_price"
	self.PageLabel:SetText "Page 1 / ?"
	self.PageLabel:Dock(FILL)

	self.Search = self:Add "EditablePanel"
	self.Search:Dock(FILL)
	self.Search:DockMargin(8, 4, 8, 4)

	self.GoRight = self.Pages:Add "DButton"
	self.GoRight:Dock(RIGHT)
	self.GoRight:SetWide(64)
	self.GoRight:SetText ">"
	self.GoRight:SetTextColor(white_text)
	function self.GoRight:Paint(w, h)
	end

	self.GoLeft = self.Pages:Add "DButton"
	self.GoLeft:Dock(LEFT)
	self.GoLeft:SetWide(64)
	self.GoLeft:SetText "<"
	self.GoLeft:SetTextColor(white_text)
	function self.GoLeft:Paint(w, h)
	end

	function self.GoRight.DoClick()
		self:SetPage(self:GetPage() + 1)
	end
	function self.GoLeft.DoClick()
		self:SetPage(self:GetPage() - 1)
	end

	self.SortBy = self.Search:Add "DComboBox"
	self.SortBy:SetSortItems(false)
	self.SortBy:AddChoice("Most Expensive", "highest_price", false)
	self.SortBy:AddChoice("Least Expensive", "lowest_price", false)
	self.SortBy:AddChoice("Newest First", "newest", true)
	self.SortBy:AddChoice("Oldest First", "oldest", false)
	self.SortBy:Dock(TOP)
	self.SortBy.OnSelect = function()
		self:RunSearch()
	end


	self.FilterType = self.Search:Add "DComboBox"
	self.FilterType:SetSortItems(false)
	self.FilterType:AddChoice("Any Items", "all", true)
	self.FilterType:AddChoice("Primaries Only", "primary", false)
	self.FilterType:AddChoice("Secondaries Only", "secondary", false)
	self.FilterType:AddChoice("Melee Only", "melee", false)
	self.FilterType:AddChoice("Shards Only", "shard", false)
	self.FilterType:AddChoice("Models Only", "model", false)
	self.FilterType:Dock(TOP)
	self.FilterType.OnSelect = function()
		self:RunSearch()
	end


	self.RefreshArea = self.Search:Add "EditablePanel"
	self.RefreshArea:Dock(RIGHT)
	self.RefreshArea:SetWide(32)
	self.Refresh = self.RefreshArea:Add "DImageButton"
	self.Refresh:Dock(BOTTOM)
	self.Refresh:SetTall(32)
	self.Refresh:SetImage "icon16/tux.png"
	function self.Refresh.DoClick()
		self:RunSearch()
	end

	hook.Add("PlutoReceiveAuctionData", self, self.PlutoReceiveAuctionData)

	self:RunSearch()

	self.Page = 1
end

function PANEL:SetPage(page)
	self.Page = math.max(1, page)
	self.PageLabel:SetText("Page " .. self.Page .. " / ?")
	self:RunSearch()
end

function PANEL:GetPage()
	return self.Page
end

function PANEL:RunSearch()
	pluto.inv.message()
		:write("auctionsearch", {
			Page = self.Page,
			Sort = self.SortBy:GetOptionData(self.SortBy:GetSelectedID()),
			Filter = self.FilterType:GetOptionData(self.FilterType:GetSelectedID()),
		})
		:send()
end

function PANEL:PlutoReceiveAuctionData(items, pages)
	self.PageLabel:SetText("Page " .. self.Page .. " / " .. pages)
	for i, item in ipairs(self.Items) do
		item:SetItem(items[i] or nil)
		self.Prices[i]:SetText(items[i] and items[i].Price or "")
		self.Images[i]:SetVisible(items[i])
	end
end

vgui.Register("pluto_auction_house", PANEL, "EditablePanel")

function pluto.inv.readauctiondata()
	local items = {}

	local pages = net.ReadUInt(32)
	for i = 1, net.ReadUInt(8) do
		items[i] = pluto.inv.readitem()
		items[i].Price = net.ReadUInt(32)
	end

	hook.Run("PlutoReceiveAuctionData", items, pages)
end

function pluto.inv.writeauctionsearch(page, params)
	net.WriteUInt(page, 32)

	for what, param in pairs(params) do
		net.WriteBool(true)
		net.WriteString(what)
		net.WriteUInt(param.n, 2)
		for i = 1, math.min(param.n, 3) do
			net.WriteString(param[i])
		end
	end

	net.WriteBool(false)
end

local PANEL = {}

function PANEL:Init()
	self:SetTall(310)
	self:Dock(TOP)
	self.ItemContainer = self:Add "EditablePanel"
	self.ItemContainer:Dock(TOP)
	self.ItemContainer:SetTall(150)
	function self.ItemContainer.PerformLayout()
		self.Item:Center()
	end
	self.Item = self.ItemContainer:Add "pluto_inventory_item"
	self.Item:SetNoMove()
	self.Item:SetSize(64, 64)
	self.Item:Center()
	self.Item:SetItem(nil, {Active = true, Items = {}, ID = 0})

	self.PriceLabel = self:Add "DLabel"
	self.PriceLabel:Dock(TOP)
	self.PriceLabel:SetTall(20)
	self.PriceLabel:DockMargin(8, 10, 8, 10)
	self.PriceLabel:SetContentAlignment(5)
	self.PriceLabel:SetText "Price"
	self.PriceLabel:SetFont "stardust_shop_price"

	self.PriceContainer = self:Add "EditablePanel"
	self.PriceContainer:DockMargin(8, 10, 8, 10)
	self.PriceContainer:Dock(TOP)
	self.PriceContainer:SetTall(20)
	self.Price = self.PriceContainer:Add "DTextEntry"
	self.Price:Dock(FILL)
	self.Price:SetFont "stardust_shop_price"
	function self.Price:OnFocusChanged(b)
		if (not b) then
			local num = tonumber(self:GetText()) or 100
			num = math.Clamp(num, 100, 90000)
			self:SetText(num)
			self.Tax:SetText("Tax: " .. math.ceil(num * 0.04) .. " (4%)")
		end
	end

	self.Stardust = self.PriceContainer:Add "DImage"
	self.Stardust:Dock(RIGHT)
	self.Stardust:SetWide(20)
	self.Stardust:SetImage(pluto.currency.byname.stardust.Icon)

	self.Price.Tax = self.PriceContainer:Add "DLabel"
	self.Price.Tax:Dock(RIGHT)
	self.Price.Tax:SetFont "stardust_shop_price"
	self.Price.Tax:SetWide(100)
	self.Price.Tax:SetContentAlignment(6)
	self.Price.Tax:SetText("Tax: 0 (4%)")

	self.Rest = self:Add "EditablePanel"
	self.Rest:Dock(FILL)

	function self.Rest:PerformLayout(w, h)
		self.Inner:Center()
	end

	self.Rest.Inner = self.Rest:Add "ttt_curved_button"
	self.Rest.Inner:SetCurve(4)
	self.Rest.Inner:SetFont "pluto_trade_buttons"
	self.Rest.Inner:SetColor(ttt.teams.innocent.Color)
	self.Rest.Inner:SetTextColor(white_text) -- pluto_trade_buttons

	self.Rest.Inner:SetSkin "tttrw"
	self.Rest.Inner:SetText "List on BIN"
	self.Rest.Inner:SetSize(120, 24)
	function self.Rest.Inner.DoClick()
		RunConsoleCommand("pluto_send_to_auction", self.Item.Item.ID, self.Price:GetText())
		PLUTO_LIST_TEST:Remove()
	end
	self.Rest.Inner:Center()
end

function PANEL:SetItem(item)
	self.Item:SetItem(item)
end

vgui.Register("pluto_list_auction_item", PANEL, "EditablePanel")
