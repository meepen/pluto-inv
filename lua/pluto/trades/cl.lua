surface.CreateFont("pluto_trade_numbers", {
	font = "Roboto",
	size = 14
})

surface.CreateFont("pluto_trade_buttons", {
	font = "Roboto",
	size = 14,
	bold = true,
	weight = 400,
})

surface.CreateFont("pluto_trade_chat_bold", {
	font = "Roboto",
	size = 14,
	bold = true,
	weight = 700,
})

surface.CreateFont("pluto_trade_chat", {
	font = "Roboto",
	size = 14,
	weight = 300,
})

surface.CreateFont("pluto_trade_offerring", {
	font = "Lato",
	size = 16,
	weight = 300,
})

surface.CreateFont("pluto_trade_player", {
	font = "Lato",
	size = 18,
	weight = 300,
})
surface.CreateFont("pluto_close_button", {
	font = "Roboto",
	size = 16,
	weight = 300,
})

local function trademsg(noalive, ...)
	if (not noalive or not LocalPlayer():Alive() or ttt.GetRoundState() ~= ttt.ROUNDSTATE_ACTIVE) then
		chat.AddText(white_text, "[", ttt.teams.traitor.Color, "TRADE", white_text, "] ", ttt.teams.innocent.Color, ...)
	end
end

local function tradeevent(event, ...)
	hook.Run(event, ...)
	if (not pluto.trade) then
		return
	end

	table.insert(pluto.trade.Events, {Event = event, ...})
end

local curve = pluto.ui.curve
local count = 6

function pluto.inv.writetrademessage(msg)
	net.WriteString(msg)
end

function pluto.inv.writetradeaccept(accepted, cancel)
	net.WriteBool(accepted)
	net.WriteBool(cancel)
end

function pluto.inv.writetradeupdate(tab)
	local items, currencies = tab.Items, tab.Currency
	net.WriteUInt(table.Count(currencies), 3)
	for currency, amount in pairs(currencies) do
		net.WriteString(currency)
		net.WriteUInt(amount, 32)
	end

	net.WriteUInt(table.Count(tab.Items), 4)
	for i, item in pairs(tab.Items) do
		net.WriteUInt(i, 4)
		net.WriteUInt(item.ID, 32)
	end
end

function pluto.inv.writetraderequest(ply)
	net.WriteEntity(ply)
end

function pluto.inv.readtradeaccept()
	local accepted = net.ReadBool()
	hook.Run("PlutoTradeAccept", accepted)
	trademsg(true, IsValid(pluto.trade.Other) and pluto.trade.Other:Nick() or "Other Player", accepted and " is ready to accept" or " is no longer ready to accept")
end

function pluto.inv.readtrademessage()
	local ply = net.ReadEntity()
	local msg = net.ReadString()

	trademsg(true, ply:Nick(), ": ", white_text, msg)
	tradeevent("PlutoTradeMessage", ply, msg)
end

function pluto.inv.readtradeupdate()
	local trade

	if (net.ReadBool()) then
		trade = {
			Currency = {},
			Items = {},
			Other = net.ReadEntity(),
			Events = {},
		}

		for i = 1, net.ReadUInt(3) do
			trade.Currency[net.ReadString()] = net.ReadUInt(32)
		end

		for i = 1, net.ReadUInt(4) do
			trade.Items[net.ReadUInt(4)] = pluto.inv.readitem()
		end

		trade.CanAccept = net.ReadBool()
	else
		trademsg(false, "Trade" .. (pluto.trade and IsValid(pluto.trade.Other) and " with " .. pluto.trade.Other:Nick() or "") .. " ended")
	end

	if (not pluto.trade and trade) then
		table.Empty(pluto.tradetab.Items)
		table.Empty(pluto.tradetab.Currency)
	end

	if (not pluto.trade) then
		trademsg(false, "Trade with ", trade.Other:Nick(), " opened")
	end

	pluto.trade = trade
	
	tradeevent("PlutoTradeUpdate", trade)
end

local function SendUpdate()
	pluto.inv.message()
		:write("tradeupdate", pluto.tradetab)
		:send()
end

local PANEL = {}

function PANEL:Init()
	self:SetCurve(4)
	self:SetColor(Color(31, 31, 32))
	self:SetTall(50)
	self.Image = self:Add "DImage"
	self.Image:Dock(LEFT)
	self.Image:DockMargin(0, 0, 10, 0)
	self:DockPadding(10, 4, 10, 4)

	function self.Image:PerformLayout(w, h)
		self:SetWide(h)
	end

	self.Top = self:Add "DLabel"
	self.Top:Dock(TOP)
	self.Top:SetFont "pluto_trade_chat"

	self.Bottom = self:Add "EditablePanel"
	self.Bottom:Dock(FILL)

	self.Input = self:Add "DTextEntry"
	self.Input:Dock(FILL)
	self.Input:SetNumeric(true)
	self.Input:SetText "1"
	self.Input:SetFont "pluto_trade_chat_bold"
	self.Input:SetTextColor(Color(0, 0, 0))
	self.Input:DockMargin(0, 0, 8, 0)

	self.Add = self:Add "ttt_curved_button"
	self.Add:SetFont "pluto_trade_buttons"
	self.Add:Dock(RIGHT)
	self.Add:SetCurve(4)
	self.Add:SetText "Add"
	self.Add:SetWide(40)
	self.Add:SetColor(Color(197, 132, 54))
	self.Add:SetTextColor(Color(17, 15, 13))

	self.Add.DoClick = function() self:DoClick(self.Input:GetInt()) end
end

function PANEL:SetCurrency(cur)
	local c = pluto.currency.byname[cur]

	self.Image:SetImage(c.Icon)
	self.Top:SetText(c.Name)
	self.Input:SetText(pluto.cl_currency[cur] or 0)
end

function PANEL:DoClick()
end

vgui.Register("pluto_currency_select_currency", PANEL, "ttt_curved_panel")

local PANEL = {}

function PANEL:Init()
	self.CurrencyHolder = self:Add "EditablePanel"
	self.CurrencyHolder:Dock(TOP)
	self.CurrencyHolder:SetTall(48)

	self.Currency = self.CurrencyHolder:Add "DImage"
	self.Currency:SetSize(48, 48)

	function self.CurrencyHolder.PerformLayout(s, w, h)
		self.Currency:SetPos(w / 2 - self.Currency:GetWide() / 2)
	end


	self.YouHave = self:Add "DLabel"
	self.YouHave:Dock(TOP)
	self.YouHave:SetTall(24)
	self.YouHave:SetTextColor(white_text)
	self.YouHave:SetText ""
	self.YouHave:SetFont "pluto_close_button"
	self.YouHave:SetContentAlignment(5)

	self.Text = self:Add "DLabel"
	self.Text:Dock(TOP)
	self.Text:SetTall(24)
	self.Text:SetTextColor(white_text)
	self.Text:SetText "Input amount then hit Enter"
	self.Text:SetFont "pluto_close_button"
	self.Text:SetContentAlignment(5)

	self.Input = self:Add "DTextEntry"
	self.Input:Dock(FILL)

	function self.Input.AllowInput(s, c)
		return c < '0' or c > '9'
	end

	self.Input.OnValueChange = function(s, value)
		self:OnConfirm(math.Clamp(tonumber(value), 0, pluto.cl_currency[self.CurrencyData.InternalName] or 0))
	end

	self:SetSize(200, 200)
	self:DockPadding(6, 6, 6, 6)

	self.Deny = self:Add "ttt_curved_button"
	self.Deny:SetCurve(4)
	self.Deny:SetFont "pluto_trade_buttons"
	self.Deny:SetColor(ttt.teams.traitor.Color)
	self.Deny:SetTextColor(white_text) -- pluto_trade_buttons

	self.Deny:Dock(BOTTOM)
	self.Deny:DockMargin(0, 4, 0, 0)
	self.Deny:SetSkin "tttrw"
	self.Deny:SetText "Cancel"
	self.Deny.DoClick = function()
		self:Remove()
	end
end

function PANEL:SetCurrency(data)
	self.Currency:SetImage(data.Icon)
	self.CurrencyData = data
	self.YouHave:SetText(string.format("You have %i", pluto.cl_currency[data.InternalName] or 0))
end

vgui.Register("pluto_currency_input", PANEL, "pluto_inventory_base")

local PANEL = {}

function PANEL:FilterAdd(filter)
	filter = filter or function() return true end

	local cur_layer

	for currency, data in pairs(pluto.currency.byname) do
		if (data.Fake) then
			continue
		end

		if (not filter(data)) then
			continue
		end

		if (not self.Selected) then
			self:Select(currency)
		end

		if (not cur_layer or cur_layer.Items >= 3) then
			cur_layer = self.Layout:Add "EditablePanel"
			cur_layer:Dock(TOP)
			cur_layer:SetTall(48)
			cur_layer.Items = 1
		else
			cur_layer.Items = cur_layer.Items + 1
		end

		local p = cur_layer:Add "DImageButton"
		p:Dock(LEFT)
		p:SetWide(48)
		p:SetImage(data.Icon)

		function p.DoClick()
			self:Select(currency)
		end
	end
end

function PANEL:Select(currency)
	local data = pluto.currency.byname[currency]

	self.Selected = currency
	self.Label:SetText(data.Name)
	self:SetAmount(self:GetMax() ~= 0 and 1 or 0)
end

function PANEL:SetAmount(amt)
	self.TextEntry:SetText(tostring(amt))
	self.Slider:SetSlideX(amt / self:GetMax())
end

function PANEL:GetAmount()
	return tonumber(self.TextEntry:GetText())
end

function PANEL:GetMax()
	return pluto.cl_currency[self.Selected] or 0
end

function PANEL:Init()
	self:SetCurve(4)
	self:SetColor(solid_color)
	self:SetSize(48 * 3 + 30, 400)

	self.Text = self:Add "DLabel"
	self.Text:Dock(TOP)
	self.Text:SetTall(24)
	self.Text:SetTextColor(white_text)
	self.Text:SetText "Select Currency"
	self.Text:SetFont "pluto_close_button"
	self.Text:SetContentAlignment(5)

	self:DockPadding(6, 6, 6, 6)

	self.Layout = self:Add "DScrollPanel"
	self.Layout:Dock(FILL)

	self.CloseContainer = self:Add "EditablePanel"
	self.CloseContainer:Dock(BOTTOM)
	self.CloseContainer:SetTall(52)

	self.Slider = self:Add "DSlider"
	self.Slider:Dock(BOTTOM)
	self.Slider:SetTall(28)

	self.TextEntry = self:Add "DTextEntry"
	self.TextEntry:Dock(BOTTOM)
	self.TextEntry:SetTall(28)
	self.TextEntry:SetFont "pluto_trade_buttons"

	self.Label = self:Add "DLabel"
	self.Label:SetFont "pluto_close_button"
	self.Label:SetTextColor(white_text)
	self.Label:SetContentAlignment(5)
	self.Label:Dock(BOTTOM)
	self.Label:SetTall(28)

	self.TextEntry.AllowInput = function(s, c)
		return c < '0' or c > '9'
	end

	self.TextEntry.OnValueChange = function(s, val)
		local num = tonumber(val)
		if (not num) then
			return
		end

		self.Slider:SetSlideX(num / self:GetMax())
	end

	function self.Slider.TranslateValues(s, x, y)
		self.TextEntry:SetText(math.Round(x * self:GetMax()))
		return x, y
	end

	self.Deny = self.CloseContainer:Add "ttt_curved_button"
	self.Deny:SetCurve(4)
	self.Deny:SetFont "pluto_trade_buttons"
	self.Deny:SetColor(ttt.teams.traitor.Color)
	self.Deny:SetTextColor(white_text) -- pluto_trade_buttons

	self.Deny:Dock(BOTTOM)
	self.Deny:SetSkin "tttrw"
	self.Deny:SetText "Cancel"
	self.Deny:SetTall(24)
	function self.Deny.DoClick()
		self:Remove()
	end

	self.Accept = self.CloseContainer:Add "ttt_curved_button"
	self.Accept:SetCurve(4)
	self.Accept:SetFont "pluto_trade_buttons"
	self.Accept:SetColor(ttt.teams.innocent.Color)
	self.Accept:SetTextColor(white_text) -- pluto_trade_buttons

	self.Accept:DockMargin(0, 0, 0, 4)

	self.Accept:Dock(FILL)
	self.Accept:SetSkin "tttrw"
	self.Accept:SetText "Accept"
	function self.Accept.DoClick()
		self:OnSelect {
			Currency = self.Selected,
			Amount = self:GetAmount()
		}

		self:Remove()
	end
end

function PANEL:SetCurrent(data)
end

DEFINE_BASECLASS "pluto_inventory_base"
function PANEL:OnRemove()
	if (BaseClass.OnRemove) then
		BaseClass.OnRemove(self)
	end

	if (IsValid(self.Input)) then
		self.Input:Remove()
	end
end

vgui.Register("pluto_currency_select", PANEL, "pluto_inventory_base")

function CurrencySelect(pnl, cb, filter)
	local p = vgui.Create "pluto_currency_select"
	p:SetCurrent(currentdata)
	p:MakePopup()
	p:Center()
	p:FilterAdd(filter)

	local rem = pnl.OnRemove
	function pnl:OnRemove()
		if (IsValid(p)) then
			p:Remove()
		end

		if (rem) then
			rem(self)
		end
	end
	function p:OnSelect(data)
		cb(data)
	end
end

local PANEL = {}
function PANEL:Init()
	self.Under = self:Add "ttt_curved_panel"
	self.Under:Dock(BOTTOM)
	self.Under:SetCurve(4)
	self.Under:SetColor(Color(43, 43, 44))
	self:DockPadding(0, 0, 0, 2)

	self.TextCurve = self:Add "ttt_curved_panel"
	self.TextCurve:SetColor(Color(83, 89, 89))
	self.TextCurve:SetCurve(4)
	self.TextCurve:SetTall(16)
	self.Text = self.TextCurve:Add "DLabel"
	self.Text:Dock(FILL)
	self.Text:SetFont "pluto_trade_numbers"
	self.Text:SetContentAlignment(5)
	self.Text:SetText ""
	self.TextCurve:SetVisible(false)

	self.TextCurve:SetZPos(1)

	function self.TextCurve.OnMousePressed(s, m)
		if (m == MOUSE_RIGHT) then
			self:SetInfo()
		elseif (m == MOUSE_LEFT and self.Modifiable) then
			self.Selector = CurrencySelect(self, function(data)
				if (not IsValid(self)) then
					return
				end

				self:SetInfo(data.Currency, data.Amount)
			end, self.Filter)
		end
	end
end

function PANEL:Reset()
	if (IsValid(self.Image)) then
		self.Image:Remove()
	end

	if (self.Info and self.Info.Currency) then
		self.TextCurve:SetVisible(true)
		local text = self.Info.Amount .. "x"
		surface.SetFont(self.Text:GetFont())
		local w, h = surface.GetTextSize(text)
		self.Text:SetText(text)
		self.TextCurve:SetWide(w + 8)

		self.Image = self:Add "DImage"
		self.Image:SetImage(pluto.currency.byname[self.Info.Currency].Icon)
		
		self:InvalidateLayout(true)
	elseif (self.Modifiable) then
		self.TextCurve:SetVisible(true)
		self.TextCurve:SetWide(self.TextCurve:GetTall())
		self.Text:SetText "+"
	else
		self.TextCurve:SetVisible(false)
	end
end

function PANEL:SetInfo(cur, amt, upd)
	if (self.Currency and self.Modifiable) then
		pluto.tradetab.Currency[self.Currency] = nil
	end

	self.Currency = cur

	if (not cur or amt == 0 or self.Modifiable and not upd and pluto.tradetab.Currency[cur]) then
		self.Info = nil
	else
		if (self.Modifiable) then
			pluto.tradetab.Currency[cur] = amt
		end
		self.Info = {
			Currency = cur,
			Amount = amt,
		}
	end

	if (self.Modifiable and not upd) then
		self:OnUpdate()
	end
	self:Reset()
end

function PANEL:OnUpdate()
	SendUpdate()
end

function PANEL:PerformLayout(w, h)
	self.Under:SetTall(h / 3)
	local size = math.min(w, h)
	if (IsValid(self.Image)) then
		local pad = size * 0.5 / 3
		self.Image:SetSize(size - pad, size - pad)
		self.Image:SetPos(pad / 2, h - size + pad)
	end

	self.TextCurve:SetPos(w - self.TextCurve:GetWide(), h - 16)
end

function PANEL:SetModifiable()
	self.Modifiable = true
	self.TextCurve:SetCursor "hand"
	self:Reset()
end

vgui.Register("pluto_trade_currency", PANEL, "EditablePanel")

local PANEL = {}
function PANEL:Init()
	pluto.ui.tradechat = self
	local pad = pluto.ui.pad

	self.Inner = self:Add "ttt_curved_panel"
	self.Inner:SetCurve(curve(4))
	self.Inner:Dock(FILL)
	self.Inner:SetColor(Color(17, 15, 13, 0.75 * 255))
	self.Text = self.Inner:Add "RichText"
	self.Text:Dock(FILL)

	self.Text:InsertColorChange(198, 132, 57, 255)
	self.Text:AppendText "Trade Chat\nThis will be recorded for future reference.\n"

	function self.Text:PerformLayout()
		self:SetFontInternal "pluto_trade_chat_bold"
	end

	function self.Text:PlutoTradeMessage(ply, msg)
		local col = ttt.teams.innocent.Color
		self:InsertColorChange(col.r, col.g, col.b, col.a)
		self:AppendText(ply:Nick())
		col = white_text
		self:InsertColorChange(col.r, col.g, col.b, col.a)
		self:AppendText ": "
		self:AppendText(msg)
		self:AppendText "\n"
	end

	hook.Add("PlutoTradeMessage", self.Text, self.Text.PlutoTradeMessage)

	function self.Text:PlutoTradeUpdate()
		self:InsertColorChange(230, 58, 80, 255)
		self:AppendText "Trade has been updated.\n"

		if (pluto.trade and not pluto.trade.CanAccept) then
			self:AppendText "You cannot accept.\n"
		end
	end

	hook.Add("PlutoTradeUpdate", self.Text, self.Text.PlutoTradeUpdate)

	function self.Text:PlutoTradeAcept(accepted)
		if (accepted) then
			self:InsertColorChange(58, 230, 80, 255)
			self:AppendText "Other player has accepted\n"
		else
			self:InsertColorChange(230, 58, 80, 255)
			self:AppendText "Other player has unaccepted\n"
		end
	end

	hook.Add("PlutoTradeAccept", self.Text, self.Text.PlutoTradeAccept)

	for _, event in pairs((pluto.trade or {Events = {}}).Events) do
		if (self.Text[event.Event]) then
			self.Text[event.Event](self.Text, unpack(event))
		end
	end

	self.TextEntry = self.Inner:Add "DTextEntry"
	self.TextEntry:Dock(BOTTOM)
	function self.TextEntry:OnMousePressed(m)
		self:SetKeyboardInputEnabled(true)
		pluto.ui.pnl:SetKeyboardInputEnabled(true)
	end

	function self.TextEntry:OnFocusChanged(gained)
		if (not gained) then
			self:SetKeyboardInputEnabled(false)
			pluto.ui.pnl:SetKeyboardInputEnabled(false)
		end
	end

	self.TextEntry:SetEnterAllowed(false)

	function self.TextEntry:OnKeyCode(code)
		if (code == KEY_ENTER) then
			pluto.inv.message()
				:write("trademessage", self:GetText())
				:send()
			self:SetText ""
			timer.Simple(0, function()
				if (IsValid(self)) then
					self:OnMousePressed()
					self:RequestFocus()
				end
			end)
		end
	end

	local pad = self.Inner:GetCurve() / 2
	self.Inner:DockPadding(pad, pad, pad, pad)
end
vgui.Register("pluto_trade_chat", PANEL, "EditablePanel")


local PANEL = {}
function PANEL:Init()
	local pad = pluto.ui.pad

	self.Top = self:Add "EditablePanel"
	self.Top:Dock(TOP)
	self.TopDesc = self.Top:Add "EditablePanel"
	self.TopDesc:Dock(FILL)
	self.TopLayout = self.Top:Add "DIconLayout"
	self.TopLayout:Dock(BOTTOM)

	self.TopInfo = self.TopDesc:Add "EditablePanel"
	self.TopInfo:Dock(FILL)
	self.TopDesc.Info = self.TopInfo
	self.TopText = self.TopInfo:Add "DLabel"
	self.TopInfo.Text = self.TopText
	self.TopText:Dock(LEFT)
	self.TopText:SetAutoStretchVertical(true)
	self.TopText:SetWrap(true)
	self.TopText:SetContentAlignment(4)
	self.TopText:SetTextColor(color_white)
	self.TopText:SetFont "pluto_trade_offerring"
	self.TopText:SetText "Other person is offerring:"
	self.TopText:SetZPos(2)

	self.TopCurrency = self.TopInfo:Add "EditablePanel"
	self.TopCurrency:Dock(FILL)
	self.TopCurrencies = {}

	for i = 1, 4 do
		local p = self.TopCurrency:Add "pluto_trade_currency"
		self.TopCurrencies[i] = p
		if (list[i]) then
			p:SetInfo(list[i][1], list[i][2], true)
		end
		p:Dock(LEFT)
	end

	function self.TopCurrency.PerformLayout(s, w, h)
		local size = w / 5
		local divide = (w - size * 4) / 3

		for i = 1, 4 do
			self.TopCurrencies[i]:SetWide(size)
			self.TopCurrencies[i]:DockMargin(0, 0, divide, pluto.ui.pad)
		end
	end

	function self.TopInfo.PerformLayout(s, w, h)
		self.TopText:SetWide(w * 2 / 5)
	end

	self.TopCurrency = self.TopDesc:Add "EditablePanel"
	self.TopCurrency:Dock(FILL)
	self.TopCurrency:SetZPos(2)
	self.TopCurrency:DockMargin(6,6,6,16)
	function self.TopCurrency:PerformLayout(w, h)
		self:SetWide(self:GetParent():GetWide())
	end

	function self.TopDesc:PerformLayout(w, h)
		self.Info:SetTall(h / 2)
	end

	self.Chat = self:Add "pluto_trade_chat"
	self.Chat:Dock(LEFT)

	self.Bottom = self:Add "EditablePanel"
	self.Bottom:Dock(FILL)
	self.BottomText = self.Bottom:Add "DLabel"
	self.BottomText:SetMouseInputEnabled(true)
	self.BottomText:Dock(TOP)
	self.BottomText:SetContentAlignment(4)
	self.BottomText:SetFont "pluto_trade_offerring"
	self.BottomText:SetText "You are offerring:"
	self.BottomText:SetTextColor(color_white)

	function self.Bottom.PerformLayout(s, w, h)
		self.BottomText:SetTall(h / 6)
		self.BottomLayout:SetTall(h / 3)
	end

	self.YourCurrency = self.Bottom:Add "EditablePanel"
	self.YourCurrency:Dock(FILL)
	self.YourCurrency:DockMargin(6,6,6,16)
	self.YourCurrencies = {}

	local list = {}
	for k, v in pairs(pluto.tradetab.Currency) do
		list[#list + 1] = {k, v}
	end

	for i = 1, 4 do
		local p = self.YourCurrency:Add "pluto_trade_currency"
		p:SetModifiable()
		if (list[i]) then
			p:SetInfo(list[i][1], list[i][2], true)
		end
		self.YourCurrencies[i] = p
		p:Dock(TOP)
	end

	function self.YourCurrency.PerformLayout(s, w, h)
		local size = h / 4

		for i = 1, 4 do
			self.YourCurrencies[i]:SetTall(size)
			self.YourCurrencies[i]:DockMargin(0, 0, 0, 0)
		end
	end

	self.BottomButtons = self.Bottom:Add "EditablePanel"
	self.BottomButtons:Dock(BOTTOM)
	self.BottomButtons.Accept = self.BottomButtons:Add "ttt_curved_button"
	self.AcceptStatus = 0

	self.BottomButtons.Deny = self.BottomButtons:Add "ttt_curved_button"
	function self.BottomButtons:PerformLayout(w, h)
		local pad = 8
		self.Accept:DockMargin(pad / 2, 0, 0, 0)
		self.Deny:DockMargin(0, 0, pad / 2, 0)
		self.Accept:SetWide(w / 2 - pad / 2)
	end

	self.BottomButtons.Accept.DoClick = function()
		self.AcceptStatus = (self.AcceptStatus + 1) % 3

		if (self.AcceptStatus == 2) then
			self.BottomButtons.Accept:SetText "Unaccept"
		else
			self.BottomButtons.Accept:SetText("Accept (" .. (2 - self.AcceptStatus) .. ")")
		end

		pluto.inv.message()
			:write("tradeaccept", self.AcceptStatus == 2)
			:send()
	end
	self.BottomButtons.Deny.DoClick = function()
		self.AcceptStatus = 0
		pluto.inv.message()
			:write("tradeaccept", false, true)
			:send()
	end

	self.BottomButtons.Accept:SetCurve(4)
	self.BottomButtons.Deny:SetCurve(4)
	self.BottomButtons.Accept:SetFont "pluto_trade_buttons"
	self.BottomButtons.Deny:SetFont "pluto_trade_buttons"
	self.BottomButtons.Accept:SetColor(ttt.teams.innocent.Color)
	self.BottomButtons.Deny:SetColor(ttt.teams.traitor.Color)
	self.BottomButtons.Accept:SetTextColor(white_text)
	self.BottomButtons.Deny:SetTextColor(white_text) -- pluto_trade_buttons

	self.BottomButtons.Accept:Dock(RIGHT)
	self.BottomButtons.Deny:Dock(FILL)
	self.BottomButtons.Accept:SetSkin "tttrw"
	self.BottomButtons.Deny:SetSkin "tttrw"
	self.BottomButtons.Accept:SetText "Accept (2)"
	self.BottomButtons.Deny:SetText "Cancel"
	self.BottomLayout = self.Bottom:Add "DIconLayout"
	self.BottomLayout:Dock(RIGHT)

	self.Items = {}

	self.TradeItems = {}

	for i = 1, 12 do
		local p = self.BottomLayout:Add "pluto_inventory_item"
		p.TabIndex = i
		self.Items[i] = p
		p.TradeItems = self.TradeItems
		function p:SwitchWith(other)
			if (other.Tab.ID == 0) then
				return
			end

			if (other and other.Item) then
				PrintTable(other.Item)
			end
			if (other and other.Item and other.Item.Untradeable) then
				return
			end

			if (self.Item) then
				self.TradeItems[self.Item.ID] = nil
			end
			if (other.Item and not self.TradeItems[other.Item.ID]) then
				self:SetItem(other.Item)
				self.Tab.Items[i] = other.Item
				
				SendUpdate(self.Tab)

				self.TradeItems[self.Item.ID] = true
			end

			pluto.ui.unsetghost()
		end

		function p:RightClick()
			if (self.Item) then
				self.TradeItems[self.Item.ID] = nil
			end
			self:SetItem()
			self.Tab.Items[i] = nil
			SendUpdate(self.Tab)
		end
	end
	for i = 13, 24 do
		local p = self.TopLayout:Add "pluto_inventory_item"
		function p:SwitchWith()
		end
		p.TabIndex = i
		self.Items[i] = p
	end

	hook.Add("PlutoTradeUpdate", self, self.Update)
end

function PANEL:Update()
	if (not pluto.trade) then
		return
	end

	local list = {}
	for k, v in pairs(pluto.trade.Currency) do
		list[#list + 1] = {k, v}
	end

	for i = 1, 4 do
		local info = list[i]
		if (info) then
			self.TopCurrencies[i]:SetInfo(info[1], info[2])
		else
			self.TopCurrencies[i]:SetInfo()
		end
	end

	self.TopText:SetText(IsValid(pluto.trade.Other) and pluto.trade.Other:Nick() or "Other Player" .. " is offering:")
	for i = 13, 24 do
		self.Items[i]:SetItem()
	end

	for ind, item in pairs(pluto.trade.Items) do
		ind = ind + 12
		self.Items[ind]:SetItem(item)
	end

	self.AcceptStatus = 0
	self.BottomButtons.Accept:SetText "Accept (2)"
end

function PANEL:PerformLayout(w, h)
	local pad = pluto.ui.pad
	self.Top:SetTall(h * 3 / 8)

	local size = math.floor(math.Round(w / (count + 2)) / 2) * 2
	local divide = math.floor((w - size * count) / (count + 2) / 2) * 2
	if (IsValid(self.Chat)) then
		self.Chat:SetWide(w * 3 / 7)

		self.Chat:DockPadding(0, pad / 2, divide, 0)
	end

	self.Bottom:DockPadding(0, pad / 2, 0, 0)

	for i = 13, 24 do
		self.Items[i]:SetSize(size, size)
	end

	self.TopLayout:SetSpaceX(divide)
	self.TopLayout:SetSpaceY(divide)
	self.TopLayout:SetTall(10)

	do
		local count = 3
		local w = math.floor(w * 3 / 10)
		self.BottomLayout:SetWide(w)
		local divide = divide / 2
		local new_size = (w - divide * 2) / 3
		for i = 1, 12 do
			self.Items[i]:SetSize(new_size, new_size)
		end

		self.BottomLayout:SetSpaceX(divide)
		self.BottomLayout:SetSpaceY(divide)
	end

	self.BottomButtons:SetTall(self.BottomButtons.Accept:GetTall())

	self:DockPadding(divide * 1.5, divide * 1.5, divide * 1.5, divide * 1.5)
end

function PANEL:SetTab(tab)
	for i, item in ipairs(self.Items) do
		item:SetItem(tab.Items[i], tab)
	end
	self:Update()
end

vgui.Register("pluto_in_trade", PANEL, "EditablePanel")

local PANEL = {}

function PANEL:Init()
	self.Layout = self:Add "DScrollPanel"
	self.Layout:Dock(FILL)

	self.Players = {}

	for _, ply in pairs(player.GetAll()) do
		if (ply == LocalPlayer()) then
			continue
		end

		self:AddPlayer(ply)
	end
end

function PANEL:AddPlayer(ply)
	if (self.Players[ply]) then
		return
	end
	local p = self.Layout:Add "ttt_curved_button"
	p:SetTall(40)
	p:DockMargin(4, 10, 4, 10)
	p:SetColor(Color(43, 43, 44))
	p:SetTextColor(white_text)
	p:SetCurve(6)
	p:SetFont "pluto_trade_player"
	p:SetText(ply:Nick())
	p:Dock(TOP)

	function p:DoClick()
		pluto.inv.message()
			:write("traderequest", ply)
			:send()
	end

	self.Players[ply] = p
end

function PANEL:SetTab()
end

function PANEL:PerformLayout(w, h)
	local size = math.floor(math.Round(w / (count + 2)) / 2) * 2
	local divide = math.floor((w - size * count) / (count + 2) / 2) * 2
	self:DockPadding(divide * 1.5, divide * 1.5, divide * 1.5, divide * 1.5)
end

vgui.Register("pluto_trade_players", PANEL, "EditablePanel")


local PANEL = {}
DEFINE_BASECLASS "pluto_inventory_base"

function PANEL:Init()
	BaseClass.Init(self)

	hook.Add("PlutoTradeUpdate", self, self.MakeInner)
	self:MakeInner()
end

function PANEL:OnRemove()
	if (pluto.trade) then
		-- TODO(meep): cancel
	end
end

function PANEL:MakeInner()
	local class = pluto.trade == nil and "pluto_trade_players" or "pluto_in_trade"

	if (IsValid(self.Inner)) then
		if (self.Inner.ClassName == class) then
			return
		end
		self.Inner:Remove()
	end

	self.Inner = self:Add(class)

	self.Inner:Dock(FILL)
	if (self.Tab) then
		self.Inner:SetTab(self.Tab)
	end
end

function PANEL:SetTab(t)
	self.Tab = t
	self.Inner:SetTab(t)
end

vgui.Register("pluto_trade", PANEL, "pluto_inventory_base")