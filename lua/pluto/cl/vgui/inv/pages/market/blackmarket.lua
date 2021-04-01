local PANEL = {}

local function install(panel, cur)
	function panel:AddItem(data, buyfn)
		self.Items = self.Items or {}

		local pnl = self:Add "pluto_inventory_item"
		pnl:SetSize(pluto.ui.sizings "ItemSize", pluto.ui.sizings "ItemSize")
		pnl:SetItem(data.Item)

		function pnl:OnLeftClick()
			self:OnRightClick()
		end
		function pnl:OnRightClick()
			local mn = DermaMenu()
			mn:AddOption("Buy for " .. pnl.PricePanel:GetText() .. " " .. cur.Name,function()
				buyfn(self)
			end):SetIcon "icon16/money_delete.png"
			mn:Open()
		end

		local container = pnl.ItemPanel:Add "ttt_curved_panel_outline"
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
		img:SetImage(cur.Icon)

		function container_fill:PerformLayout(w, h)
			img:SetSize(h - 2, h - 2)
		end

		local price = container_fill:Add "pluto_label"
		price:Dock(FILL)
		price:SetText(tostring(data.Price))
		price:SetContentAlignment(6)
		price:SetFont "pluto_inventory_font"
		price:SetTextColor(pluto.ui.theme "TextActive")
		price:SetRenderSystem(pluto.fonts.systems.shadow)
		price:SizeToContentsY()
		container:SetTall(price:GetTall())

		pnl.PricePanel = price
		table.insert(self.Items, pnl)
		self:InvalidateLayout(true)
	end

	function panel:AddCurrency(data, buyfn)
		self.Items = self.Items or {}

		local pnl = self:Add "pluto_inventory_currency_selector"
		function pnl:OnLeftClick()
			local mn = DermaMenu()
			mn:AddOption("Buy for " .. pnl.PricePanel:GetText() .. " " .. cur.Name,function()
				buyfn(self.Currency)
			end):SetIcon "icon16/money_delete.png"
			mn:Open()
		end
		pnl:ShowAmount(true)
		pnl:SetCurrency(data.Currency)
		pnl:SetAmount(data.Amount)

		local container = pnl:Add "ttt_curved_panel_outline"
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
		img:SetImage(cur.Icon)

		function container_fill:PerformLayout(w, h)
			img:SetSize(h - 2, h - 2)
		end

		local price = container_fill:Add "pluto_label"
		price:Dock(FILL)
		price:SetText(tostring(data.Price))
		price:SetContentAlignment(6)
		price:SetFont "pluto_inventory_font"
		price:SetTextColor(pluto.ui.theme "TextActive")
		price:SetRenderSystem(pluto.fonts.systems.shadow)
		price:SizeToContentsY()
		container:SetTall(price:GetTall())

		pnl.PricePanel = price
		table.insert(self.Items, pnl)
		self:InvalidateLayout(true)
	end

	function panel:PerformLayout(w, h)
		if (not self.Items) then
			return
		end
		local total_size = 0
		for _, child in pairs(self:GetChildren()) do
			total_size = total_size + child:GetWide()
		end

		local sx = w / 2 - total_size / 2 - (5 * (#self.Items - 1)) / 2

		for _, item in ipairs(self.Items) do
			item:SetPos(sx, h / 2 - item:GetTall() / 2)
			sx = sx + item:GetWide() + 5
		end
	end
end

function PANEL:Init()
	self:DockPadding(3, 3, 3, pluto.ui.sizings "pluto_inventory_font")
	self.ShopScroll = self:Add "EditablePanel"
	self.ShopScroll:Dock(RIGHT)
	self.ShopScroll:SetWide(pluto.ui.sizings "ItemSize" * 5 + 5 * 4)
	self.ShopScroll:DockMargin(5 + 20, 0, 0, 0)

	self.SpecialArea = self.ShopScroll:Add "ttt_curved_panel_outline"
	self.SpecialArea:SetColor(pluto.ui.theme "InnerColorSeperator")
	self.SpecialArea:SetCurve(6)
	self.SpecialArea:SetTall(pluto.ui.sizings "pluto_inventory_font_xlg" + 8 + 5 * 2 + pluto.ui.sizings "ItemSize")
	self.SpecialArea:Dock(TOP)
	self.SpecialArea:DockMargin(0, 0, 0, 25)

	self.Header = self.SpecialArea:Add "ttt_curved_panel"
	self.Header:Dock(TOP)
	self.Header:SetColor(pluto.ui.theme "InnerColorSeperator")
	self.Header:SetTall(pluto.ui.sizings "pluto_inventory_font_xlg" + 8)
	self.Header:DockMargin(0, 0, 0, 5)
	self.Header:SetCurve(6)
	self.Header:SetCurveBottomRight(false)
	self.Header:SetCurveBottomLeft(false)

	self.TextHeader = self.Header:Add "pluto_label"
	self.TextHeader:SetRenderSystem(pluto.fonts.systems.shadow)
	self.TextHeader:SetText "SPECIALS"
	self.TextHeader:SetFont "pluto_inventory_font_xlg"
	self.TextHeader:SetContentAlignment(5)
	self.TextHeader:Dock(FILL)
	self.TextHeader:SetTextColor(pluto.ui.theme "TextActive")

	self.RefreshTimer = self.Header:Add "pluto_label"
	self.RefreshTimer:SetRenderSystem(pluto.fonts.systems.shadow)
	self.RefreshTimer:SetText "Refresh Timer"
	self.RefreshTimer:SetTextColor(Color(255, 255, 255, 128))
	self.RefreshTimer:SetFont "pluto_inventory_font_s"
	self.RefreshTimer:SetContentAlignment(3)
	self.RefreshTimer:Dock(FILL)
	self.RefreshTimer:DockMargin(0, 0, 5, 5)

	function self.RefreshTimer:Think()
		if (not self.EndTime) then
			return
		end

		local diff = self.EndTime - os.time()
		local text
		if (diff < 0) then
			text = "next map"
		elseif (diff < 60) then
			text = diff .. "s"
		elseif (diff < 60 * 60) then
			text = math.Round(diff / 60) .. "m"
		else
			text = math.Round(diff / 60 / 60) .. "h"
		end

		self:SetText("Refreshes: " .. text)
	end


	self.SpecialFill = self.SpecialArea:Add "EditablePanel"
	self.SpecialFill:Dock(TOP)
	self.SpecialFill:SetTall(pluto.ui.sizings "ItemSize")
	install(self.SpecialFill, pluto.currency.byname.tp)

	self.Fill = self:Add "EditablePanel"
	self.Fill:Dock(FILL)

	self.SpecialCurrencyArea = self.Fill:Add "ttt_curved_panel_outline"
	self.SpecialCurrencyArea:SetColor(pluto.ui.theme "InnerColorSeperator")
	self.SpecialCurrencyArea:SetCurve(6)
	self.SpecialCurrencyArea:SetTall(pluto.ui.sizings "pluto_inventory_font_xlg" + 8 + 5 * 2 + pluto.ui.sizings "ItemSize")
	self.SpecialCurrencyArea:Dock(TOP)
	self.SpecialCurrencyArea:DockMargin(0, 0, 0, 25)

	self.CurrencyHeader = self.SpecialCurrencyArea:Add "ttt_curved_panel"
	self.CurrencyHeader:Dock(TOP)
	self.CurrencyHeader:SetColor(pluto.ui.theme "InnerColorSeperator")
	self.CurrencyHeader:SetTall(pluto.ui.sizings "pluto_inventory_font_xlg" + 8)
	self.CurrencyHeader:DockMargin(0, 0, 0, 5)
	self.CurrencyHeader:SetCurve(6)
	self.CurrencyHeader:SetCurveBottomRight(false)
	self.CurrencyHeader:SetCurveBottomLeft(false)

	self.CurrencyTextHeader = self.CurrencyHeader:Add "pluto_label"
	self.CurrencyTextHeader:SetRenderSystem(pluto.fonts.systems.shadow)
	self.CurrencyTextHeader:SetText "THIS MAP ONLY"
	self.CurrencyTextHeader:SetFont "pluto_inventory_font_xlg"
	self.CurrencyTextHeader:SetContentAlignment(5)
	self.CurrencyTextHeader:Dock(FILL)
	self.CurrencyTextHeader:SetTextColor(pluto.ui.theme "TextActive")

	self.CurrencySpecialFill = self.SpecialCurrencyArea:Add "EditablePanel"
	self.CurrencySpecialFill:Dock(TOP)
	self.CurrencySpecialFill:SetTall(pluto.ui.sizings "ItemSize")
	install(self.CurrencySpecialFill, pluto.currency.byname.stardust)

	self.StardustItems = self.Fill:Add "EditablePanel"
	self.StardustItems:Dock(TOP)
	self.StardustItems:SetTall(pluto.ui.sizings "ItemSize" * 2 + 5 * 2)

	self.Lines = {}
	self.StardustItemPanels = {}
	for i = 1, 2 do
		local line = self.StardustItems:Add "EditablePanel"
		line:SetSize(pluto.ui.sizings "ItemSize" * 5 + 5 * 4, pluto.ui.sizings "ItemSize")
		self.Lines[i] = line

		for x = 1, 5 do
			local item = line:Add "pluto_inventory_item"
			item:Dock(LEFT)
			item:SetWide(pluto.ui.sizings "ItemSize")
			item:DockMargin(0, 0, 5, 0)

			function item:OnLeftClick()
				self:OnRightClick()
			end
			function item:OnRightClick()
				pluto.ui.rightclickmenu(self.Item, function(menu, item)
					menu:AddOption("Buy for " .. self.PricePanel:GetText() .. " stardust", function()
						RunConsoleCommand("pluto_buy_stardust_shop", self.StardustShopID)
					end):SetIcon "icon16/money_delete.png"
				end)
			end
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
	hook.Add("PlutoBlackmarketReceived", self, self.PlutoBlackmarketReceived)

	local cur_select = self.ShopScroll:Add "EditablePanel"
	cur_select:Dock(TOP)
	cur_select:SetTall(pluto.ui.sizings "ItemSize")
	install(cur_select, pluto.currency.byname.tp)

	cur_select:AddCurrency({
		Currency = pluto.currency.byname.potato,
		Amount = 1,
		Price = 195
	}, function()
		RunConsoleCommand("pluto_blackmarket_buy", "1")
	end)

	self.FiveMod = setmetatable({
		Type = "Shard",
		Tier = pluto.tiers.byname.unique,
		SpecialName = "Random 5+ mod shard"
	}, pluto.inv.item_mt)

	cur_select:AddItem({
		Item = self.FiveMod,
		Price = 20
	}, function()
		RunConsoleCommand("pluto_blackmarket_buy", "2")
	end)

	cur_select:AddCurrency({
		Currency = pluto.currency.byname._emojibag,
		Amount = 1,
		Price = 5
	}, function()
		RunConsoleCommand("pluto_blackmarket_buy", "3")
	end)

	for _, offer in ipairs(self:GetCurrencySpecials()) do
		self.CurrencySpecialFill:AddCurrency(offer, function(cur)
			pluto.inv.message()
				:write("exchangestardust", cur.InternalName, 1)
				:send()
		end)
	end
end

function PANEL:Think()
	if ((self.LastChange or -math.huge) < CurTime() - 0.4) then
		self.LastChange = CurTime()
		self.FiveMod.Tier = table.Random(pluto.tiers.filter_real("Weapon", function(tier) return tier.affixes >= 5 end))
	end
end

function PANEL:PlutoBlackmarketReceived(data)
	self.RefreshTimer.EndTime = os.time() + data.Remaining
	for id, data in pairs(data.Offers) do
		self.SpecialFill:AddItem(data, function(self)
			RunConsoleCommand("pluto_blackmarket_buy_offer", id, self:GetItem().ClassName)
		end)
	end
end

function PANEL:ReceiveStardustShop(stardusts)
	for i, item in ipairs(stardusts) do
		self.StardustItemPanels[i]:SetItem(item.Item)
		self.StardustItemPanels[i].StardustShopID = i
		self.StardustItemPanels[i].PricePanel:SetText(item.Price)
	end
end

function PANEL:GetCurrencySpecials()
	local i = 1
	local offers = {}
	while (GetGlobalInt("pluto_currency_exchange.Ratio:" .. i, false) ~= false) do
		offers[i] = {
			Price = GetGlobalInt("pluto_currency_exchange.Ratio:" .. i),
			Amount = GetGlobalInt("pluto_currency_exchange.Amount:" .. i),
			Currency = pluto.currency.byname[GetGlobalString("pluto_currency_exchange.Currency:" .. i)],
		}
		i = i + 1
	end

	return offers
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
		RunConsoleCommand "pluto_send_blackmarket"
	end
end

vgui.Register("pluto_inventory_blackmarket", PANEL, "EditablePanel")

function pluto.inv.readblackmarket()
	local data = {
		Remaining = net.ReadUInt(32),
		Offers = {}
	}
	while (1) do
		local id = net.ReadUInt(8)
		if (id == 0) then
			break
		end

		local price = net.ReadUInt(32)
		local what = setmetatable({}, pluto.inv.item_mt)
		pluto.inv.readbaseitem(what)
		data.Offers[id] = {
			Price = price,
			Item = what,
		}
	end

	hook.Run("PlutoBlackmarketReceived", data)
end