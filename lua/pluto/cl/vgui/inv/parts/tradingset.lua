local PANEL = {}

PANEL.ItemSize = 36
PANEL.CurrencySize = 16
PANEL.Padding = 3
PANEL.LabelTall = 12
PANEL.ActiveColor = Color(91, 226, 84)

function PANEL:Init()
	self.Inner = self:Add "ttt_curved_panel_outline"
	self.Inner:SetCurve(6)
	self.Inner:SetSize(self.ItemSize * 3 + self.Padding * 5, self.ItemSize * 3 + self.Padding * 7 + self.CurrencySize * 3 + self.LabelTall / 2)

	self.Inner.Label = self:Add "pluto_label"
	self.Inner.Label:SetRenderSystem(pluto.fonts.systems.shadow)
	self.Inner.Label:SetFont "pluto_inventory_font"
	self.Inner.Label:SetTextColor(pluto.ui.theme "TextActive")
	self.Inner.Label:SetText "hi"
	self.Inner.Label:SetContentAlignment(8)
	self.Inner.Label:SizeToContentsX(5)
	self.Inner.Label:SetTall(self.LabelTall)
	self.Inner.Label:SetPos(10, 0)
	self.Inner.Label:CenterHorizontal()
	self.Inner:SetColor(pluto.ui.theme "InnerColorSeperator")

	function self.Inner:AddToStencil(w, h)
		local x, y = self:ScreenToLocal(self.Label:LocalToScreen(0, 0))
		surface.DrawRect(x, y, self.Label:GetSize())
	end

	self.CurrencySelectors = {}

	for slot = 1, 3 do
		local selector = self.Inner:Add "pluto_inventory_trading_set_currency_selector"
		self.CurrencySelectors[slot] = selector
		selector:Dock(BOTTOM)
		selector:SetTall(self.CurrencySize)
		selector:DockMargin(self.Padding, self.Padding, self.Padding, slot == 1 and self.Padding or 0)

		function selector.OnCurrencyUpdated(s)
			self:OnCurrencyUpdated(slot, s:GetCurrency(), s:GetAmount())
		end
	end

	self.ItemLines = {}

	self.ItemLines[3] = self.Inner:Add "EditablePanel"
	self.ItemLines[3]:Dock(BOTTOM)
	self.ItemLines[3]:SetTall(self.ItemSize)
	self.ItemLines[3]:DockMargin(self.Padding, self.Padding, self.Padding, 0)

	self.ItemLines[2] = self.Inner:Add "EditablePanel"
	self.ItemLines[2]:Dock(BOTTOM)
	self.ItemLines[2]:SetTall(self.ItemSize)
	self.ItemLines[2]:DockMargin(self.Padding, self.Padding, self.Padding, 0)

	self.ItemLines[1] = self.Inner:Add "EditablePanel"
	self.ItemLines[1]:Dock(BOTTOM)
	self.ItemLines[1]:SetTall(self.ItemSize)
	self.ItemLines[1]:DockMargin(self.Padding, self.Padding, self.Padding, 0)

	self.ItemContainers = {}
	self.Lookup = {}

	for slot = 1, 9 do
		local itempnl = self.ItemLines[math.ceil(slot / 3)]:Add "pluto_inventory_item"
		itempnl:SetSize(self.ItemSize, self.ItemSize)
		itempnl:Dock(LEFT)
		itempnl:DockMargin(0, 0, self.Padding, 0)

		function itempnl.OnSetItem(s, item)
			if (s.OldItem) then
				self.Lookup[s.OldItem] = nil
			end

			if (item) then
				self.Lookup[item] = slot
			end

			s.OldItem = item
			self:OnItemUpdated(slot, item)
		end

		self.ItemContainers[slot] = itempnl
	end

	self:SizeToContents()

	self:SetText "Trading Set"

	function self.Inner:PerformLayout(w, h)
		self:Center()
	end
end

function PANEL:AcceptInput()
	for slot, itempnl in ipairs(self.ItemContainers) do
		function itempnl.CanClickWith(s, other)
			local i = other.Item
			return not self.Lookup[i] or self.Lookup[i] == slot
		end
		function itempnl.ClickedWith(s, other)
			s:SetItem(other.Item)
		end
		function itempnl.OnRightClick(s)
			s:SetItem(nil)
		end
		function itempnl.OnLeftClick(s)
			if (not s.Item) then
				return
			end

			pluto.ui.highlight(s.Item)
		end
	end

	for _, curr in ipairs(self.CurrencySelectors) do
		curr.InputAccepted = true
	end
end

function PANEL:OnItemUpdated(slot, item)
end

function PANEL:OnCurrencyUpdated(slot, currency, amount)
end

function PANEL:SetText(text)
	self.Inner.Label:SetText(text)
	self.Inner.Label:SizeToContentsX(5)
	self.Inner.Label:CenterHorizontal()
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

function PANEL:SetReady(ready)
	self.Ready = ready
	self.Inner:SetColor(self.Ready and self.ActiveColor or pluto.ui.theme "InnerColorSeperator")
end

vgui.Register("pluto_inventory_trading_set", PANEL, "EditablePanel")

local PANEL = {}
AccessorFunc(PANEL, "Currency", "Currency")
AccessorFunc(PANEL, "CurrencyAmount", "Amount")

function PANEL:Init()
	self.Inner = self:Add "ttt_curved_panel"
	self.Inner:Dock(FILL)

	self.CurrencyIcon = self.Inner:Add "DImage"
	self.CurrencyIcon:SetMouseInputEnabled(true)
	function self.CurrencyIcon:PerformLayout(w, h)
		self:SetWide(h)
	end
	self.CurrencyIcon:SetCursor "hand"
	function self.CurrencyIcon.OnMousePressed(s, m)
		if (m == MOUSE_LEFT and self.InputAccepted) then
			pluto.ui.currencyselect("Select a currency to trade",
				function(cur)
					if (not IsValid(self)) then
						return
					end

					self:SetCurrency(cur)
				end,
				function(cur)
					return (pluto.cl_currency[cur.InternalName] or 0) > 0
				end
			)
		elseif (m == MOUSE_RIGHT and self.InputAccepted) then
			self:Reset()
		end
	end

	self.Amount = self.Inner:Add "pluto_label"
	self.Amount:Dock(FILL)
	self.Amount:SetRenderSystem(pluto.fonts.systems.shadow)
	self.Amount:SetFont "pluto_inventory_font"
	self.Amount:SetTextColor(pluto.ui.theme "TextActive")
	self.Amount:SetText "hi"
	self.Amount:SetContentAlignment(6)
	self.Amount:SetCursor "beam"
	self.Amount:SetMouseInputEnabled(true)
	self.Amount:DockMargin(3, 0, 3, 0)

	function self.Amount.OnMousePressed(s)
		if (not self:GetCurrency()) then
			return
		end

		local t = s:GetText()
		s:SetText ""
		local input = s:Add "DTextEntry"
		input:SetTextColor(s:GetTextColor())
		input:SetFont(s:GetFont())
		input:Dock(FILL)
		pluto.ui.pnl:SetKeyboardFocus(input, true)
		input:RequestFocus()
		input:SetUpdateOnType(true)

		local function finish()
			local num = tonumber(input:GetText() or 1)
			self:SetAmount(math.Clamp(math.Round(num), 1, pluto.cl_currency[self:GetCurrency().InternalName]))
			input:Remove()
		end

		function input.OnEnter()
			finish()
		end

		function input.OnFocusChanged(gained)
			if (not gained) then
				finish()
			end
		end

		function input.OnRemove()
			pluto.ui.pnl:SetKeyboardFocus(input, false)
		end
	end

	self.CurrencyIcon:Dock(LEFT)

	self.CurrencyIcon:DockMargin(3, 0, 3, 0)

	self:SetColor(pluto.ui.theme "InnerColorSeperator")
	self:SetCurve(2)
	self.Inner:SetCurve(2)
	self.Inner:SetColor(Color(53, 53, 60))

	self:Reset()
end

function PANEL:SetCurrency(cur)
	self.Currency = cur

	if (cur) then
		self:SetAmount(1)
		self.CurrencyIcon:SetImage(cur.Icon)
	else
		self:Reset()
	end

	self:OnCurrencyUpdated()
end

function PANEL:SetAmount(amount)
	self.CurrencyAmount = amount or 0
	self.Amount:SetText(amount or "")
	self:OnCurrencyUpdated()
end

function PANEL:OnCurrencyUpdated()
end

function PANEL:Reset()
	self.Currency = nil
	self.CurrencyIcon:SetImage "pluto/currencies/questionmark.png"
	self:SetAmount()
end

vgui.Register("pluto_inventory_trading_set_currency_selector", PANEL, "ttt_curved_panel_outline")
