pluto.divine = pluto.divine or {}
pluto.divine.stardust_shop = pluto.divine.stardust_shop or {}

function pluto.inv.readstardustshop()
	pluto.divine.stardust_shop = {}
	for i = 1, net.ReadUInt(32) do
		local item = {}
		pluto.inv.readbaseitem(item)
		local price = net.ReadUInt(32)
		local endtime = net.ReadUInt(32)
		pluto.divine.stardust_shop[i] = {
			ID = i,
			Item = setmetatable(item, pluto.inv.item_mt),
			Price = price,
			EndTime = endtime + os.time(),
		}
	end

	hook.Run("ReceiveStardustShop", pluto.divine.stardust_shop)
end

surface.CreateFont("headline_font", {
	font = "Permanent Marker",
	size = 48,
	antialias = true,
	weight = 500
})

surface.CreateFont("special_offer_font", {
	font = "Roboto Bk",
	size = 18,
	weight = 500
})

surface.CreateFont("stardust_shop_price", {
	font = "Roboto",
	size = 18,
	weight = 500,
})

local PANEL = {}

function PANEL:SetTab()
end

function PANEL:Init()
	RunConsoleCommand "pluto_send_stardust_shop"
	self.TopLine = self:Add "EditablePanel"
	function self.TopLine:Paint(w, h)
		surface.SetDrawColor(white_text)
		surface.DrawRect(0, 0, w, h)
	end

	self.TopLine:Dock(TOP)
	self.TopLine:SetTall(3)

	self.SpecialLabel = self:Add "DLabel"
	self.SpecialLabel:Dock(TOP)
	self.SpecialLabel:SetText "Limited Availability"
	self.SpecialLabel:SetFont "headline_font"
	self.SpecialLabel:SetContentAlignment(5)
	self.SpecialLabel:SizeToContents()
	self.SpecialLabel:SetTextColor(white_text)

	self.BottomLine = self:Add "EditablePanel"
	function self.BottomLine:Paint(w, h)
		surface.SetDrawColor(white_text)
		surface.DrawRect(0, 0, w, h)
	end

	self.Specials = self:Add "EditablePanel"
	self.Specials:Dock(TOP)
	self.Specials:SetTall(140)

	self.Specials2 = self:Add "EditablePanel"
	self.Specials2:Dock(TOP)
	self.Specials2:SetTall(140)

	function self.Specials:OnChildAdded(c)
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
	function self.Specials2:OnChildAdded(c)
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

	self.BottomLine:Dock(TOP)
	self.BottomLine:SetTall(3)

	self.TopLine2 = self:Add "EditablePanel"
	function self.TopLine2:Paint(w, h)
		surface.SetDrawColor(white_text)
		surface.DrawRect(0, 0, w, h)
	end

	self.TopLine2:Dock(TOP)
	self.TopLine2:SetTall(3)


	self.Offers = {}

	hook.Add("ReceiveStardustShop", self, self.ReceiveStardustShop)
end

function PANEL:ReceiveStardustShop(items)
	for _, item in ipairs(items) do
		self:AddItem(item)
	end
end

function PANEL:AddItem(itemt)
	local i = #self.Offers + 1
	self.Offers[i] = {
		Item = itemt.Item,
		Price = itemt.price
	}

	local p = (i > 4 and self.Specials2 or self.Specials):Add "EditablePanel"
	p:SetSize(64, 103)

	local remaining = p:Add "DLabel"
	remaining:Dock(TOP)
	remaining:SetTall(20)
	remaining:SetFont "stardust_shop_price"
	remaining:SetContentAlignment(5)
	local hours = math.Round((itemt.EndTime - os.time()) / 60 / 60)
	local text = hours .. "h left"
	if (hours == 0) then
		text = "Ending soon!"
	end
	remaining:SetText(text)

	local item = p:Add "pluto_inventory_item"
	item:SetSize(64, 64)
	item:Dock(TOP)
	item:SetNoMove()
	item:SetItem(itemt.Item, {Items = {}})

	function item:OverrideClick()
		RunConsoleCommand("pluto_buy_stardust_shop", itemt.ID)
	end

	local pricelbl = p:Add "DLabel"
	pricelbl:Dock(FILL)
	pricelbl:SetFont "stardust_shop_price"
	pricelbl:SetText(itemt.Price)
	pricelbl:SetContentAlignment(5)

	local img = p:Add "DImage"
	img:Dock(RIGHT)
	img:SetImage(pluto.currency.byname.stardust.Icon)
	img:DockMargin(2, 2, 2, 2)
	function img:PerformLayout(w, h)
		self:SetWide(h)
	end
end

vgui.Register("pluto_stardust_shop", PANEL, "EditablePanel")

local PANEL = {}

function PANEL:Init()
	self:SetCurve(6)
	self:SetSize(80, 60)
end

vgui.Register("pluto_stardust_offer_inner", PANEL, "ttt_curved_panel_outline")

local PANEL = {}
function PANEL:Init()
	self:SetSize(90, 70)
	self.Inner = self:Add "pluto_stardust_offer_inner"
	self.Inner:Center()
end
vgui.Register("pluto_stardust_offer", PANEL, "EditablePanel")