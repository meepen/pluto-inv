local PANEL = {}

function PANEL:SetTab()
end

function PANEL:Init()
	
	self.TopLine = self:Add "EditablePanel"
	function self.TopLine:Paint(w, h)
		surface.SetDrawColor(white_text)
		surface.DrawRect(0, 0, w, h)
	end

	self.TopLine:Dock(TOP)
	self.TopLine:SetTall(3)

	self.SpecialLabel = self:Add "DLabel"
	self.SpecialLabel:Dock(TOP)
	self.SpecialLabel:SetText "Specials"
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

	self.BottomLine:Dock(TOP)
	self.BottomLine:SetTall(3)

	self.TopLine2 = self:Add "EditablePanel"
	function self.TopLine2:Paint(w, h)
		surface.SetDrawColor(white_text)
		surface.DrawRect(0, 0, w, h)
	end

	self.TopLine2:Dock(TOP)
	self.TopLine2:SetTall(3)

	self.ExchangeLabel = self:Add "DLabel"
	self.ExchangeLabel:Dock(TOP)
	self.ExchangeLabel:SetText "Exchange"
	self.ExchangeLabel:SetFont "headline_font"
	self.ExchangeLabel:SetContentAlignment(5)
	self.ExchangeLabel:SizeToContents()
	self.ExchangeLabel:SetTextColor(white_text)

	self.BottomLine2 = self:Add "EditablePanel"
	function self.BottomLine2:Paint(w, h)
		surface.SetDrawColor(white_text)
		surface.DrawRect(0, 0, w, h)
	end

	self.BottomLine2:Dock(TOP)
	self.BottomLine2:SetTall(3)

	for _, data in ipairs(self:GetSpecials()) do
		local offer = self.Specials:Add "pluto_trade_currency"
		offer.Info = data
		offer:SetSize(64, 64)
		offer:Reset()
	end

	self.Converter = self:Add "EditablePanel"
	self.Converter:Dock(TOP)
	self.Converter:SetTall(74)

	function self.Converter.PerformLayout(s, w, h)
		self.Selector:SetSize(64, 64)
		self.Stardust:SetSize(64, 64)
		self.Stardust:SetPos(w / 2 - self.Stardust:GetWide() * 1.5, h / 2 - self.Stardust:GetTall() / 2)
		self.Selector:SetPos(w / 2 + self.Selector:GetWide() / 2, h / 2 - self.Selector:GetTall() / 2)
	end

	local function UpdateCurrencyPanels()
		local other_num = tonumber(self.SliderNum:GetText())
		local stardust = other_num * self:GetRatio()
		self.Stardust.Info.Amount = stardust
		self.Stardust:Reset()

		if (self.Selector.Info) then
			self.Selector.Info.Amount = other_num
			self.Selector:Reset()
		end
	end

	function self.Converter.Paint(s, w, h)
		surface.SetDrawColor(white_text)
		surface.DrawLine(w / 2 + 20, h / 2, w / 2 - 20, h / 2)
		surface.DrawLine(w / 2 + 20, h / 2, w / 2 + 5, h / 2 - 15)
		surface.DrawLine(w / 2 + 20, h / 2, w / 2 + 5, h / 2 + 15)
	
		surface.SetTextColor(white_text)
		surface.SetFont "pluto_trade_buttons"
		local text = self:GetRatio() .. ":1"
		local tw = surface.GetTextSize(text)
		surface.SetTextPos(w / 2 - tw / 2, h / 2 + 20)
		surface.DrawText(text)
	end

	self.Selector = self.Converter:Add "pluto_trade_currency"
	self.Selector:SetModifiable()
	function self.Selector:OnUpdate()
	end
	function self.Selector.OverrideInfo(s, cur, amt)
		s.Info = {
			Currency = cur,
			Amount = 0,
		}
		
		self.Slider:SetSlideX(0)
		self.SliderNum:SetText "0"
		UpdateCurrencyPanels()
	end

	self.Selector.Filter = function(t)
		if (t.StardustRatio) then
			return t.StardustRatio
		end

		local specials = self:GetSpecials()

		for _, offer in ipairs(self:GetSpecials()) do
			if (offer.Currency == t.InternalName) then
				return true
			end
		end
	end

	self.Stardust = self.Converter:Add "pluto_trade_currency"
	self.Stardust.Info = {
		Currency = "stardust",
		Amount = 0
	}
	self.Stardust:Reset()

	function self.Stardust.OnUpdate()
	end

	self.Slider = self:Add "DSlider"
	self.Slider:Dock(TOP)
	self.Slider:SetTall(28)
	self.Slider:DockMargin(20, 0, 20, 0)

	self.SliderNum = self:Add "DTextEntry"
	self.SliderNum:Dock(TOP)
	self.SliderNum:SetTall(28)
	self.SliderNum:DockMargin(20, 0, 20, 0)
	self.SliderNum:SetFont "pluto_trade_buttons"

	function self.Slider.TranslateValues(s, x, y)
		local amt = math.Round(x * self:GetMax())
		self.SliderNum:SetText(amt)
		UpdateCurrencyPanels()
		return amt / self:GetMax(), y
	end

	self.SliderNum.AllowInput = function(s, c)
		return c < '0' or c > '9'
	end
	function self.SliderNum:OnMousePressed(m)
		self:SetKeyboardInputEnabled(true)
		pluto.ui.pnl:AddKeyboardFocus(1)
	end

	function self.SliderNum:OnFocusChanged(gained)
		if (not gained) then
			self:SetKeyboardInputEnabled(false)
			pluto.ui.pnl:AddKeyboardFocus(-1)
			local num = tonumber(self:GetText())
			if (not num) then
				num = 0
				self:SetText "0"
			end

			num = math.floor(math.min(num, self:GetParent():GetMax()))

			self:SetText(num)

			self:GetParent().Slider:SetSlideX(num / self:GetParent():GetMax())

			UpdateCurrencyPanels()
		end
	end

	self.SliderNum.OnValueChange = function(s, val)
		local num = tonumber(val)
		if (not num) then
			return
		end

		self.Slider:SetSlideX(num / self:GetMax())
	end
	self.SliderNum:SetKeyboardInputEnabled(true)

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
	self.Rest.Inner:SetText "Trade Stardust"
	self.Rest.Inner:SetSize(120, 24)
	function self.Rest.Inner.DoClick()
		pluto.divine.confirm("Exchange", function()
			pluto.inv.message()
				:write("exchangestardust", self.Selector.Info.Currency, self.SliderNum:GetText())
				:send()
		end)
	end
	self.Rest.Inner:Center()
end

function PANEL:GetRatio()
	local other = self.Selector.Info
	if (not other) then
		return 1
	end

	local ratio = pluto.currency.byname[other.Currency].StardustRatio
	if (ratio) then
		return ratio
	end

	
	local specials = self:GetSpecials()

	for _, offer in ipairs(self:GetSpecials()) do
		if (offer.Currency == other.Currency) then
			return offer.Ratio
		end
	end
end

function PANEL:GetMax()
	local other = self.Selector.Info
	if (not other) then
		return 0
	end

	local real_max = math.huge

	local specials = self:GetSpecials()

	for _, offer in ipairs(self:GetSpecials()) do
		if (offer.Currency == other.Currency) then
			real_max = offer.Amount

			break
		end
	end

	local stardust = pluto.cl_currency.stardust
	local max = math.floor(stardust / self:GetRatio())

	return math.min(real_max, max)
end

function PANEL:GetSpecials()
	local i = 1
	local offers = {}
	while (GetGlobalInt("pluto_currency_exchange.Ratio:" .. i, false) ~= false) do
		offers[i] = {
			Ratio = GetGlobalInt("pluto_currency_exchange.Ratio:" .. i),
			Amount = GetGlobalInt("pluto_currency_exchange.Amount:" .. i),
			Currency = GetGlobalString("pluto_currency_exchange.Currency:" .. i),
		}
		i = i + 1
	end

	return offers
end

vgui.Register("pluto_stardust_exchange", PANEL, "EditablePanel")

function pluto.inv.writeexchangestardust(forwhat, howmany)
	net.WriteString(forwhat)
	net.WriteUInt(howmany, 32)
end