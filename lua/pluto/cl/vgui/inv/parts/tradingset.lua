local PANEL = {}

PANEL.ItemSize = 36
PANEL.CurrencySize = Vector(36, 36 + 16)
PANEL.Padding = 3
PANEL.LabelTall = 12

function PANEL:Init()
	self.Inner = self:Add "ttt_curved_panel_outline"
	self.Inner:SetCurve(6)
	self.Inner:SetSize(self.ItemSize * 3 + self.Padding * 5, self.ItemSize * 3 + self.Padding * 6 + self.CurrencySize.y)

	self.Inner.Label = self:Add "pluto_label"
	self.Inner.Label:SetRenderSystem(pluto.fonts.systems.shadow)
	self.Inner.Label:SetFont "pluto_inventory_font"
	self.Inner.Label:SetTextColor(Color(255, 255, 255))
	self.Inner.Label:SetText "hi"
	self.Inner.Label:SetContentAlignment(8)
	self.Inner.Label:SizeToContentsX(5)
	self.Inner.Label:SetTall(self.LabelTall)
	self.Inner.Label:SetPos(10, 0)

	function self.Inner:AddToStencil(w, h)
		local x, y = self:ScreenToLocal(self.Label:LocalToScreen(0, 0))
		surface.DrawRect(x, y, self.Label:GetSize())
	end

	self.ItemLines = {}

	self.ItemLines[3] = self.Inner:Add "EditablePanel"
	self.ItemLines[3]:Dock(BOTTOM)
	self.ItemLines[3]:SetTall(self.ItemSize)
	self.ItemLines[3]:DockMargin(self.Padding, self.Padding, self.Padding, self.Padding)

	self.ItemLines[2] = self.Inner:Add "EditablePanel"
	self.ItemLines[2]:Dock(BOTTOM)
	self.ItemLines[2]:SetTall(self.ItemSize)
	self.ItemLines[2]:DockMargin(self.Padding, self.Padding, self.Padding, 0)

	self.ItemLines[1] = self.Inner:Add "EditablePanel"
	self.ItemLines[1]:Dock(BOTTOM)
	self.ItemLines[1]:SetTall(self.ItemSize)
	self.ItemLines[1]:DockMargin(self.Padding, self.Padding, self.Padding, 0)

	self.ItemContainers = {}

	for i = 1, 9 do
		local item = self.ItemLines[math.ceil(i / 3)]:Add "pluto_inventory_item"
		item:SetSize(self.ItemSize, self.ItemSize)
		item:Dock(LEFT)
		item:DockMargin(0, 0, self.Padding, 0)

		self.ItemContainers[i] = item
	end

	self.CurrencyContainer = self.Inner:Add "EditablePanel"
	self.CurrencyContainer:Dock(BOTTOM)
	self.CurrencyContainer:SetTall(self.CurrencySize.y)
	self.CurrencyContainer:DockMargin(self.Padding, self.Padding, self.Padding, 0)

	self.CurrencySelectors = {}

	for i = 1, 4 do
		local selector = self.CurrencyContainer:Add "pluto_inventory_currency_selector"
		self.CurrencySelectors[i] = selector
		selector:Dock(LEFT)
		selector:SetWide(self.CurrencySize.x)
		selector:DockMargin(0, 0, self.Padding, 0)
		selector:ShowAmount(true)
	end

	self:SizeToContents()

	self:SetText "Trading Set"

	function self.Inner:PerformLayout(w, h)
		self:Center()
	end
end

function PANEL:SetText(text)
	self.Inner.Label:SetText(text)
	self.Inner.Label:SizeToContentsX(5)
end

function PANEL:PerformLayout(w, h)
end

function PANEL:SizeToContentsY()
	self:SetTall(self.Inner:GetTall() + self.LabelTall)
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
	self.CurrencySelectors[index]:SetAmount(amount or 0)
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
