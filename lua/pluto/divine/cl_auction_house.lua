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
				
				RunConsoleCommand("pluto_auction_buy", self.Item.ID)
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

	self.SearchLabel = self.Search:Add "DLabel"
	self.SearchLabel:SetText "SEARCH AREA"
	self.SearchLabel:Dock(FILL)
	self.SearchLabel:SetContentAlignment(5)

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
			Page = self.Page
		})
		:send()
end

function PANEL:PlutoReceiveAuctionData(items)
	for i, item in ipairs(self.Items) do
		item:SetItem(items[i] or nil)
		self.Prices[i]:SetText(items[i] and items[i].Price or "")
		self.Images[i]:SetVisible(items[i])
	end
end

vgui.Register("pluto_auction_house", PANEL, "EditablePanel")

function pluto.inv.readauctiondata()
	local items = {}

	for i = 1, net.ReadUInt(8) do
		items[i] = pluto.inv.readitem()
		items[i].Price = net.ReadUInt(32)
	end

	hook.Run("PlutoReceiveAuctionData", items)
end

function pluto.inv.writeauctionsearch(data)
	net.WriteUInt((data.Page or 1) - 1, 32)
end