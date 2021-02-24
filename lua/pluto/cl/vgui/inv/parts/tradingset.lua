local PANEL = {}

PANEL.ItemSize = 48
PANEL.CurrencySize = Vector(32, 48)

function PANEL:Init()
	self.Inner = self:Add "EditablePanel"
	self.Inner:SetSize(self.ItemSize * 4 + 5 * 5, self.ItemSize * 2 + 5 * 3 + self.CurrencySize.y)

	self.CurrencyContainer = self.Inner:Add "EditablePanel"
	self.CurrencyContainer:SetSize(self.CurrencySize.x * 4 + 3 * 3, self.CurrencySize.y)
	self.CurrencyContainer:SetPos(self.Inner:GetWide() - self.CurrencyContainer:GetWide() - 6, 0)

	self.CurrencySelectors = {}

	for i = 1, 4 do
		local selector = self.CurrencyContainer:Add "pluto_inventory_currency_selector"
		self.CurrencySelectors[i] = selector
		selector:Dock(LEFT)
		selector:SetWide(self.CurrencySize.x)
		selector:DockMargin(0, 0, 3, 0)
		selector:ShowAmount(true)
	end

	self.Label = self.Inner:Add "pluto_label"
	self.Label:SetRenderSystem(pluto.fonts.systems.shadow)
	self.Label:SetFont "pluto_inventory_font"
	self.Label:SetTextColor(Color(255, 255, 255))

	self.ItemContainer = self.Inner:Add "ttt_curved_panel_outline"
	self.ItemContainer:SetColor(Color(95, 96, 102))
	self.ItemContainer:SetCurve(4)
	self.ItemContainer:Dock(BOTTOM)
	self.ItemContainer:SetTall(self.ItemSize * 2 + 5 * 3 + 4)
	function self.ItemContainer.AddToStencil(s, w, h)
		local x1, y1 = s:ScreenToLocal(self.Label:LocalToScreen(0, 0))
		local x2, y2 = s:ScreenToLocal(self.Label:LocalToScreen(self.Label:GetSize()))
		surface.DrawRect(x1 - 2, y1, x2 - x1 + 4, y2 - y1)

		for _, selector in ipairs(self.CurrencySelectors) do
			x1, y1 = s:ScreenToLocal(selector:LocalToScreen(0, 0))
			x2, y2 = s:ScreenToLocal(selector:LocalToScreen(selector:GetSize()))
			surface.DrawRect(x1, y1, x2 - x1, y2 - y1)
		end
	end

	self.ItemLines = {}

	self.ItemLines[2] = self.ItemContainer:Add "EditablePanel"
	self.ItemLines[2]:Dock(BOTTOM)
	self.ItemLines[2]:SetTall(self.ItemSize)
	self.ItemLines[2]:DockMargin(5, 5, 5, 5)

	self.ItemLines[1] = self.ItemContainer:Add "EditablePanel"
	self.ItemLines[1]:Dock(BOTTOM)
	self.ItemLines[1]:SetTall(self.ItemSize)
	self.ItemLines[1]:DockMargin(5, 5, 5, 0)

	self.ItemContainers = {}

	for i = 1, 8 do
		local item = self.ItemLines[math.ceil(i / 4)]:Add "pluto_inventory_item"
		item:SetSize(self.ItemSize, self.ItemSize)
		item:Dock(LEFT)
		item:DockMargin(0, 0, 5, 0)

		self.ItemContainers[i] = item
	end

	self:SizeToContents()

	self:SetText "Trading Set"
end

function PANEL:SetText(text)
	self.Label:SetText(text)
	self.Label:SizeToContents()
	self.Label:SetPos(6, self.Inner:GetTall() - self.ItemContainer:GetTall() - self.Label:GetTall() + 5)
end

function PANEL:PerformLayout(w, h)
	self.Inner:Center()
end

function PANEL:SizeToContentsY()
	self:SetTall(self.Inner:GetTall())
end

function PANEL:SizeToContentsX()
	self:SetWide(self.Inner:GetWide())
end

function PANEL:SizeToContents()
	self:SizeToContentsX()
	self:SizeToContentsY()
end

function PANEL:SetUserInputEnabled(b)
end

function PANEL:OnCurrencyChanged(index, currency, amount)
	print(self.Label:GetText(), index, currency, amount)
end

function PANEL:GetCurrencyPanel(index)
	return self.CurrencySelectors[index]
end

function PANEL:SetCurrency(index, currency, amount)
	self.CurrencySelectors[index]:SetCurrency(currency)
	self.CurrencySelectors[index]:SetAmount(amount)
end

function PANEL:GetCurrency(index)
	return self.CurrencySelectors[index]:GetCurrency()
end

function PANEL:GetItemPanel(index)
	return self.ItemContainers[index]
end

function PANEL:SetItem(index, item)
	self.ItemContainers[index]:SetItem(item)
end

function PANEL:GetItem(index)
	return self.ItemContainers[index]:GetItem()
end


vgui.Register("pluto_inventory_trading_set", PANEL, "EditablePanel")