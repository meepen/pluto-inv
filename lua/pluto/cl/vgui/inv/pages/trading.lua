
local PANEL = {}

function PANEL:Init()
	self.StartTrading = self:AddTab "Start Trade"
	self.TradingScroll = self.StartTrading:Add "DScrollPanel"
	self.TradingScroll:Dock(FILL)
	self.PastTrades   = self:AddTab "Past Trades"
	self:AddTab "Active Trade":Add "pluto_inventory_trading_active":Dock(FILL)

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
			SetClipboardText(trade.snapshot)
		
			chat.AddText("Trade " .. trade.ID .. " copied to clipboard.")
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
	SetClipboardText(data)

	chat.AddText("Trade " .. id .. " copied to clipboard.")
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
	self:SetColor(Color(95, 96, 102))
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
	self.PlayerNameLabel:SetTextColor(Color(255, 255, 255))
	self.PlayerNameLabel:SetText "PLAYER NAME"
	self.PlayerNameLabel:Dock(LEFT)
	self.PlayerNameLabel:DockMargin(2, 0, 0, 0)

	self.StatusArea = self.Inner:Add "EditablePanel"
	self.StatusArea:SetMouseInputEnabled(false)
	self.StatusArea:Dock(RIGHT)
	self.StatusArea:DockMargin(5, 5, 5, 5)
	function self.StatusArea:PerformLayout(w, h)
		self:SetWide(h)
	end

	hook.Add("PlutoTradeRequestInfo", self, self.PlutoTradeRequestInfo)
end

function PANEL:PlutoTradeRequestInfo(oply, status)
	if (oply == self.Player) then
		self:SetStatus(status)
	end
end

function PANEL:SetStatus(status)
	if (IsValid(self.StatusPanel)) then
		self.StatusPanel:Remove()
	end

	if (status == "inbound") then
		self.StatusPanel = self.StatusArea:Add "ttt_curved_panel"
		self.StatusPanel:Dock(FILL)
		self.StatusPanel:SetColor(Color(255, 0, 0))
	elseif (status == "outbound") then
		self.StatusPanel = self.StatusArea:Add "pluto_inventory_loading"
		self.StatusPanel:Dock(FILL)
	elseif (status == "in progress") then
		self.StatusPanel = self.StatusArea:Add "ttt_curved_panel"
		self.StatusPanel:Dock(FILL)
		self.StatusPanel:SetColor(Color(0, 255, 0))
	end
end

function PANEL:SetPlayer(ply)
	self.PlayerNameLabel:SetText(ply:Nick())
	self.PlayerNameLabel:SizeToContentsX()
	self.PlayerIcon:SetPlayer(ply, 64)
	self.Player = ply

	self:SetStatus(pluto.trades.status[ply])
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
	self.IncomingNew:SetText "They offer:"
	self.IncomingOutgoingContainer:SetTall(self.IncomingNew:GetTall())

	self.OutgoingNew = self.IncomingOutgoingContainer:Add "pluto_inventory_trading_set"
	self.OutgoingNew:Dock(RIGHT)
	self.OutgoingNew:SetText "You offer:"

	self.ChatContainer = self:Add "ttt_curved_panel_outline"
	self.ChatContainer:Dock(FILL)
	self.ChatContainer:DockMargin(0, 14, 0, 14)
	self.ChatContainer:SetColor(Color(95, 96, 102))
	self.ChatContainer:SetZPos(1)

	self.Chat = self.ChatContainer:Add "ttt_curved_panel"
	self.Chat:SetColor(Color(44, 46, 56))
	self.Chat:Dock(FILL)
	self.Chat:DockPadding(3, 3, 3, 3)

	self.ChatText = self.Chat:Add "pluto_text"
	self.ChatText:Dock(FILL)
	self.ChatText:SetDefaultFont "pluto_inventory_font"
	self.ChatText:SetDefaultTextColor(Color(255, 255, 255))
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
	self.ChatInputContainer = self.Chat:Add "ttt_curved_panel_outline"
	self.ChatInputContainer:Dock(BOTTOM)
	self.ChatInputContainer:DockMargin(0, 3, 0, 0)


	self.ButtonContainer = self:Add "EditablePanel"
	self.ButtonContainer:SetZPos(0)
	self.ButtonContainer:Dock(BOTTOM)

	self.AcceptButton = self.ButtonContainer:Add "pluto_inventory_button"
	self.AcceptButton:SetColor(Color(41, 150, 39), Color(67, 195, 50))
	self.AcceptButton:SetCurve(4)
	self.AcceptButton:SetText "Accept"

	self.CancelButton = self.ButtonContainer:Add "pluto_inventory_button"
	self.CancelButton:SetColor(Color(175, 30, 30), Color(237, 28, 36))
	self.CancelButton:SetCurve(4)
	self.CancelButton:SetText "Cancel"

	function self.ButtonContainer.PerformLayout(s, w, h)
		local x = w / 2

		self.CancelButton:SetPos(x + 5, h / 2 - self.CancelButton:GetTall() / 2)
		self.AcceptButton:SetPos(x - self.AcceptButton:GetWide() - 5, h / 2 - self.CancelButton:GetTall() / 2)
	end

	function self.OutgoingNew.OnCurrencyChanged(s, index, currency, amount)
		if (IsValid(pluto.ui.pnl)) then
			pluto.ui.pnl:ChangeToTab "Trading"
		end
		self:SendUpdate("currency", i)
	end


	for i = 1, 3 do
		local currencypnl = self.OutgoingNew:GetCurrencyPanel(i)

		function currencypnl.OnCurrencyUpdated()
			if (IsValid(pluto.ui.pnl)) then
				pluto.ui.pnl:ChangeToTab "Trading"
			end

			self:SendUpdate("currency", i)
		end

		currencypnl:AcceptInput(true)
		currencypnl:AcceptAmount(true)
	end

	for i = 1, 9 do
		local itempnl = self.OutgoingNew:GetItemPanel(i)

		function itempnl.CanClickWith(s, other)
			local item = other.Item
			return item
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

		function itempnl.OnSetItem(s, item)
			self:SendUpdate("item", i)
		end
	end

	self:UpdateFromTradeData()

	hook.Add("PlutoTradeUpdate", self, self.PlutoTradeUpdate)
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
			currency:SetCurrency(index)
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

function PANEL:SendUpdate(type, index)
	if (self.Updating) then
		return
	end

	if (type == "currency") then
		pluto.trades.settradedata("outgoing", type, index, self.OutgoingNew:GetCurrency(index))
	elseif (type == "item") then
		pluto.trades.settradedata("outgoing", type, index, self.OutgoingNew:GetItem(index))
	end
end

function PANEL:UpdateFromTradeData()
	self.Updating = true
	local tradedata = pluto.trades.getdata()

	for i = 1, 9 do
		self.OutgoingNew:SetItem(i, tradedata.outgoing.item[i])
	end
	for i = 1, 3 do
		local dat = tradedata.outgoing.currency[i]
		if (not dat) then
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
			continue
		end

		self.IncomingNew:SetCurrency(i, dat.What, dat.Amount)
	end

	self.Updating = false
end

function PANEL:ChatInitiated()
	self.ChatText:AppendText("hi chat has been initiated also im gay:\n")
end

vgui.Register("pluto_inventory_trading_active", PANEL, "EditablePanel")

