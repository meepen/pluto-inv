
local PANEL = {}

function PANEL:Init()
	self.StartTrading = self:AddTab "Start Trade"
	self.TradingScroll = self.StartTrading:Add "DScrollPanel"
	self.TradingScroll:Dock(FILL)
	self.PastTrades   = self:AddTab "Past Trades"
	local active = self:AddTab "Active Trade":Add "pluto_inventory_trading_active"
	active.OutgoingNew:AcceptInput()
	active:Dock(FILL)
	active:UpdateFromTradeData()

	hook.Add("PlutoPastTradesReceived", self.PastTrades, self.PlutoPastTradesReceived)
	hook.Add("PlutoTradeLogSnapshot", self.PastTrades, self.PlutoTradeLogSnapshot)
	function self.PastTrades:Paint(w, h)
		if (not self.HasRendered) then
			self.HasRendered = true
			
			pluto.inv.message()
				:write("gettrades", LocalPlayer():SteamID64())
				:send()
		end
	end
end

function PANEL:PlutoPastTradesReceived(trades)
	self.HasInfo = true

	local function CreateTradeThing(snap)
		self.PastTrades:SetVisible(false)

		local active = self:Add "pluto_inventory_trading_active"
		active:Dock(FILL)
		active:SetSnapshot(snap)

		function active:OnCancel()
			self:Remove()
		end
		function active.OnRemove()
			if (IsValid(self.PastTrades)) then
				self.PastTrades:SetVisible(true)
			end
		end
	end

	self.PastTrades = self:Add "DListView"
	self.PastTrades:Dock(FILL)
	self.PastTrades:AddColumn "ID"
	self.PastTrades:AddColumn "Other Player"

	for _, trade in ipairs(trades) do
		self.PastTrades:AddLine(trade.ID, trade.p2name)
	end

	self.Trades = trades

	function self.PastTrades:OnRowSelected(index)
		local trade = trades[index]
		if (not trade.snapshot) then
			pluto.inv.message()
				:write("gettradesnapshot", trade.ID)
				:send()
			chat.AddText("Retrieving data for trade " .. trade.ID .. "...")
			return
		else
			CreateTradeThing(trade.snapshot)
		end
	end
end

function PANEL:PlutoTradeLogSnapshot(id, data)
	local trade
	for _, tr in pairs(self.Trades) do
		if (tr.ID == id) then
			trade = tr
			break
		end
	end

	if (not trade) then
		return
	end

	trade.snapshot = data

	chat.AddText("Trade " .. id .. " received.")
end

function PANEL:Think()
	if (player.GetCount() ~= self.LastPlayerCount) then
		self.LastPlayerCount = player.GetCount()

		for _, child in pairs(self.TradingScroll:GetCanvas():GetChildren()) do
			child:Remove()
		end

		for _, ply in pairs(player.GetAll()) do
			if (LocalPlayer() == ply) then
				continue
			end

			local pnl = self.TradingScroll:Add "pluto_inventory_playercard"
			pnl:Dock(TOP)
			pnl:SetPlayer(ply)
			pnl:DockMargin(0, 7, 0, 0)

			function pnl.DoClick()
				pluto.inv.message()
					:write("requesttrade", ply)
					:send()

				pnl:SetStatus "outbound"
			end
		end
	end
end

vgui.Register("pluto_inventory_trading", PANEL, "pluto_inventory_component_tabbed")

local PANEL = {}

function PANEL:Init()
	self:SetTall(36)
	self:SetCurve(4)
	self:SetColor(pluto.ui.theme "InnerColorSeperator")
	self:SetMouseInputEnabled(true)
	self:SetCursor "hand"

	self.Inner = self:Add "ttt_curved_panel"
	self.Inner:SetMouseInputEnabled(false)
	self.Inner:SetCurve(2)
	self.Inner:Dock(FILL)
	self.Inner:DockMargin(1, 1, 1, 1)

	self.Inner:SetColor(Color(53, 53, 60))

	self.PlayerIcon = self.Inner:Add "AvatarImage"
	self.PlayerIcon:Dock(LEFT)
	self.PlayerIcon:DockMargin(2, 2, 2, 2)
	function self.PlayerIcon:PerformLayout(w, h)
		self:SetWide(h)
	end

	self.PlayerNameLabel = self.Inner:Add "pluto_label"
	self.PlayerNameLabel:SetContentAlignment(4)
	self.PlayerNameLabel:SetFont "pluto_inventory_font"
	self.PlayerNameLabel:SetRenderSystem(pluto.fonts.systems.shadow)
	self.PlayerNameLabel:SetTextColor(pluto.ui.theme "TextActive")
	self.PlayerNameLabel:SetText "PLAYER NAME"
	self.PlayerNameLabel:Dock(LEFT)
	self.PlayerNameLabel:DockMargin(2, 0, 0, 0)

	self.StatusArea = self.Inner:Add "pluto_label"
	self.StatusArea:SetMouseInputEnabled(false)
	self.StatusArea:Dock(RIGHT)
	self.StatusArea:DockMargin(5, 5, 5, 5)
	self.StatusArea:SetTextColor(Color(247, 249, 43))
	self.StatusArea:SetFont "pluto_inventory_font_s"
	self.StatusArea:SetRenderSystem(pluto.fonts.systems.shadow)
	self.StatusArea:SetText "hello"
	self.StatusArea:SetContentAlignment(5)

	hook.Add("PlutoTradeRequestInfo", self, self.PlutoTradeRequestInfo)
end

function PANEL:PlutoTradeRequestInfo(oply, status)
	if (oply == self.Player) then
		self:SetStatus(status)
	end
end

PANEL.Types = {
	["in progress"] = "Trade in progress",
	["outbound"] = "Trade request sent",
	["inbound"] = "Trade request received",
	["none"] = "",
}

function PANEL:SetStatus(status)
	self.StatusArea:SetText(self.Types[status] or status)
	self.StatusArea:SizeToContentsX()
end

function PANEL:SetPlayer(ply)
	self.PlayerNameLabel:SetText(ply:Nick())
	self.PlayerNameLabel:SizeToContentsX()
	self.PlayerIcon:SetPlayer(ply, 64)
	self.Player = ply

	self:SetStatus(pluto.trades.status[ply] or "none")
end

function PANEL:OnMousePressed(m)
	if (m == MOUSE_LEFT) then
		self:DoClick()
	end
end

function PANEL:DoClick()
end

vgui.Register("pluto_inventory_playercard", PANEL, "ttt_curved_panel")

local PANEL = {}

PANEL.ItemSize = 48

function PANEL:Init()
	self.IncomingOutgoingContainer = self:Add "EditablePanel"
	self.IncomingOutgoingContainer:Dock(TOP)

	self.IncomingNew = self.IncomingOutgoingContainer:Add "pluto_inventory_trading_set"
	self.IncomingNew:Dock(LEFT)
	self.IncomingNew:SetText "Their offer"
	self.IncomingOutgoingContainer:SetTall(self.IncomingNew:GetTall())

	self.OutgoingNew = self.IncomingOutgoingContainer:Add "pluto_inventory_trading_set"
	self.OutgoingNew:Dock(RIGHT)
	self.OutgoingNew:SetText "Your offer"

	function self.OutgoingNew.OnCurrencyUpdated(s, slot, currency, amount)
		if (IsValid(pluto.ui.pnl)) then
			pluto.ui.pnl:ChangeToTab "Trading"
		end

		self:SendUpdate("currency", slot, currency, amount)
	end

	function self.OutgoingNew.OnItemUpdated(s, slot, item)
		if (IsValid(pluto.ui.pnl)) then
			pluto.ui.pnl:ChangeToTab "Trading"
		end

		self:SendUpdate("item", slot, item)
	end

	self.ChatContainer = self:Add "ttt_curved_panel_outline"
	self.ChatContainer:Dock(FILL)
	self.ChatContainer:DockMargin(0, 14, 0, 14)
	self.ChatContainer:SetColor(pluto.ui.theme "InnerColorSeperator")
	self.ChatContainer:SetZPos(1)

	self.Chat = self.ChatContainer:Add "ttt_curved_panel"
	self.Chat:SetColor(Color(44, 46, 56))
	self.Chat:Dock(FILL)
	self.Chat:DockPadding(3, 3, 3, 3)

	self.ChatText = self.Chat:Add "pluto_text"
	self.ChatText:Dock(FILL)
	self.ChatText:SetDefaultFont "pluto_inventory_font"
	self.ChatText:SetDefaultTextColor(pluto.ui.theme "TextActive")
	self.ChatText:SetDefaultRenderSystem(pluto.fonts.systems.shadow)

	local oldlayout = self.ChatText.PerformLayout
	function self.ChatText.PerformLayout(s, w, h)
		if (oldlayout) then
			oldlayout(s, w, h)
		end

		if (not s.HasInitiated) then
			s.HasInitiated = true
			self:ChatInitiated()
		end
	end


	-- TOOD(meep): ask lovely for design
	self.ChatInputContainer = self.Chat:Add "ttt_curved_panel"
	self.ChatInputContainer:Dock(BOTTOM)
	self.ChatInputContainer:DockMargin(0, 3, 0, 0)
	self.ChatInputContainer:SetTall(16)
	self.ChatInputContainer:SetColor(Color(249, 249, 249))
	self.ChatInputContainer:DockPadding(3, 1, 3, 1)

	self.TextEntry = self.ChatInputContainer:Add "pluto_label"
	self.TextEntry:SetContentAlignment(4)
	self.TextEntry:SetFont "pluto_inventory_font"
	self.TextEntry:SetText "Write something..."
	self.TextEntry:SetTextColor(Color(2, 3, 4))
	self.TextEntry:Dock(FILL)
	self.TextEntry:SetMouseInputEnabled(true)

	function self.TextEntry.OnMousePressed(s)
		local t = s:GetText()
		s:SetText ""
		local input = s:Add "DTextEntry"
		input:SetTextColor(s:GetTextColor())
		input:SetFont(s:GetFont())
		input:Dock(FILL)
		pluto.ui.pnl:SetKeyboardFocus(s, true)
		input:RequestFocus()
		input:SetUpdateOnType(true)

		local function sendmessage(msg)
			if (msg:Trim() == "") then
				return
			end

			pluto.inv.message()
				:write("trademessage", msg)
				:send()
		end

		local function finish()
			sendmessage(input:GetText())
			s:SetText(t)
			input:Remove()
		end

		function input.OnEnter(s)
			if (input:GetText() == "") then
				finish()
			else
				sendmessage(input:GetText())
				s:SetText ""
				s:RequestFocus()
			end
		end

		function input.OnFocusChanged(gained)
			if (not gained) then
				finish()
			end
		end

		function input.OnRemove(s)
			if (IsValid(pluto.ui.pnl)) then
				pluto.ui.pnl:SetKeyboardFocus(s, false)
			end
		end
	end


	self.ButtonContainer = self:Add "EditablePanel"
	self.ButtonContainer:SetZPos(0)
	self.ButtonContainer:Dock(BOTTOM)

	self.AcceptButton = self.ButtonContainer:Add "pluto_inventory_button"
	self.AcceptButton:SetColor(Color(41, 150, 39), Color(67, 195, 50))
	self.AcceptButton:SetCurve(4)
	self.AcceptButton:SetText "Accept"

	function self.AcceptButton.DoClick()
		self:OnAccept()
	end

	self.CancelButton = self.ButtonContainer:Add "pluto_inventory_button"
	self.CancelButton:SetColor(Color(175, 30, 30), Color(237, 28, 36))
	self.CancelButton:SetCurve(4)
	self.CancelButton:SetText "Cancel"

	function self.CancelButton.DoClick()
		self:OnCancel()
	end

	function self.ButtonContainer.PerformLayout(s, w, h)
		local x = w / 2

		self.CancelButton:SetPos(x + 5, h / 2 - self.CancelButton:GetTall() / 2)
		self.AcceptButton:SetPos(x - self.AcceptButton:GetWide() - 5, h / 2 - self.CancelButton:GetTall() / 2)
	end

	self:AppendText "--beginning of trade--\n"
end

function PANEL:PlutoTradePlayerStatus(ply, b)
	(ply == LocalPlayer() and self.OutgoingNew or self.IncomingNew):SetReady(b)
end

function PANEL:PlutoTradeUpdate(side, what, index, data)
	local lookup
	if (what == "currency") then
		lookup = side == "incoming" and self.IncomingNew or self.OutgoingNew

		local currency = lookup[index]
		self.Updating = true
		if (data) then
			lookup:SetCurrency(index, data.What, data.Amount)
		else
			lookup:SetCurrency(index)
		end

		self.Updating = false
	elseif (what == "item") then
		lookup = side == "incoming" and self.IncomingNew or self.OutgoingNew

		self.Updating = true
		lookup:SetItem(index, data)
		self.Updating = false
	end
end

function PANEL:PerformLayout(w, h)
end

function PANEL:SendUpdate(type, index, ...)
	if (self.Updating) then
		return
	end

	if (type == "currency") then
		pluto.trades.settradedata("outgoing", type, index, ...)
	elseif (type == "item") then
		pluto.trades.settradedata("outgoing", type, index, ...)
	end
end

function PANEL:PlutoTradeRequestInfo(ply, status)
	if (status == "in progress") then
		self:UpdateFromTradeData()
	end
end

function PANEL:UpdateFromTradeData()
	hook.Add("PlutoTradeUpdate", self, self.PlutoTradeUpdate)
	hook.Add("PlutoTradeMessage", self, self.AddTradeMessage)
	hook.Add("PlutoTradePlayerStatus", self, self.PlutoTradePlayerStatus)
	hook.Add("PlutoTradeRequestInfo", self, self.PlutoTradeRequestInfo)
	self.IncomingNew:SetReady(pluto.trades.data.incoming.accepted)
	self.OutgoingNew:SetReady(pluto.trades.data.outgoing.accepted)
	for _, msg in ipairs(pluto.trades.data.messages) do
		self:AddTradeMessage(msg)
	end

	self.Updating = true
	local tradedata = pluto.trades.getdata()

	for i = 1, 9 do
		self.OutgoingNew:SetItem(i, tradedata.outgoing.item[i])
	end
	for i = 1, 3 do
		local dat = tradedata.outgoing.currency[i]
		if (not dat) then
			self.OutgoingNew:SetCurrency(i)
			continue
		end

		self.OutgoingNew:SetCurrency(i, dat.What, dat.Amount)
	end

	for i = 1, 9 do
		self.IncomingNew:SetItem(i, tradedata.incoming.item[i])
	end
	for i = 1, 3 do
		local dat = tradedata.incoming.currency[i]
		if (not dat) then
			self.IncomingNew:SetCurrency(i)
			continue
		end

		self.IncomingNew:SetCurrency(i, dat.What, dat.Amount)
	end

	self.Updating = false
end

function PANEL:SetSnapshot(snap)
	local trade = json.parse(snap)
	for _, msg in ipairs(trade.messages) do
		local newmsg = {msg["1"] or msg[1]}
		if (msg.sender and trade[msg.sender]) then
			newmsg.sender = trade[msg.sender].name
		end

		self:AddTradeMessage(newmsg)
	end

	local current = self.OutgoingNew

	for ply, t in pairs(trade) do
		if (not tonumber(ply)) then
			continue
		end

		current:SetText(t.name)

		for slot, item in pairs(t.item) do
			current:SetItem(tonumber(slot), setmetatable(item, pluto.inv.item_mt))
		end
		for slot, data in pairs(t.currency) do
			current:SetCurrency(tonumber(slot), pluto.currency.byname[data.What], data.Amount)
		end

		current = self.IncomingNew
	end
end

function PANEL:ChatInitiated()
	self.HasChatInitiated = true

	if (self.AppendedText) then
		for _, tex in ipairs(self.AppendedText) do
			self.ChatText:AppendText(unpack(tex, 1, tex.n))
		end
	end
end

function PANEL:AppendText(...)
	if (not self.HasChatInitiated) then
		self.AppendedText = self.AppendedText or {}

		table.insert(self.AppendedText, {n = select("#", ...), ...})
	else
		self.ChatText:AppendText(...)
	end
end

function PANEL:AddTradeMessage(msg)
	local sender = msg.sender
	local textcol = pluto.ui.theme "TextActive"
	if (isstring(sender)) then
		self:AppendText(Color(255, 222, 0), sender, ": ")
	elseif (IsValid(sender)) then
		self:AppendText(Color(255, 222, 0), sender:Nick(), ": ")
	else
		textcol = Color(237, 237, 52)
	end

	self:AppendText(textcol, msg[1], "\n")
end

function PANEL:OnCancel()
end

function PANEL:OnAccept()
	pluto.inv.message()
		:write "tradestatus"
		:send()
end

vgui.Register("pluto_inventory_trading_active", PANEL, "EditablePanel")

