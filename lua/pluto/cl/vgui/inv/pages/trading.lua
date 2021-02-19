
local PANEL = {}

function PANEL:Init()
	self.StartTrading = self:AddTab "Start Trade"
	self.PastTrades   = self:AddTab "Past Trades"
	self:AddTab "Active Trade":Add "pluto_inventory_trading_active":Dock(FILL)

	hook.Add("PlutoPastTradesReceived", self.PastTrades, self.PlutoPastTradesReceived)
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

	function self.PastTrades:OnRowSelected(index)
		local trade = trades[index]
		if (not trade.snapshot) then
			pluto.inv.message()
				:write("gettradesnapshot", trade.ID)
				:send()
			chat.AddText("Retrieving data for trade " .. trade.ID .. "...")
			return
		end
		local frame = vgui.Create "pluto_trade_log"
		frame:SetTrade(trades[index])
	end
end

function PANEL:Think()
	if (player.GetCount() ~= self.LastPlayerCount) then
		self.LastPlayerCount = player.GetCount()
		for _, ply in pairs(player.GetAll()) do
			if (LocalPlayer() == ply) then
				continue
			end

			local pnl = self.StartTrading:Add "pluto_inventory_playercard"
			pnl:Dock(TOP)
			pnl:SetPlayer(ply)
			pnl:DockMargin(0, 7, 0, 0)

			function pnl.DoClick()
				pnl:SetLoading()
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
end

function PANEL:SetLoading()
	if (IsValid(self.StatusPanel)) then
		self.StatusPanel:Remove()
	end

	self.StatusPanel = self.StatusArea:Add "pluto_inventory_loading"
	self.StatusPanel:Dock(FILL)
end

function PANEL:SetStatus(status)
	if (IsValid(self.StatusPanel)) then
		self.StatusPanel:Remove()
	end
end

function PANEL:SetPlayer(ply)
	self.PlayerNameLabel:SetText(ply:Nick())
	self.PlayerNameLabel:SizeToContentsX()
	self.PlayerIcon:SetPlayer(ply, 64)
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
	self.Incoming = self:Add "EditablePanel"
	self.Incoming:Dock(FILL)

	self.IncomingLabel = self.Incoming:Add "pluto_label"
	self.IncomingLabel:SetFont "pluto_inventory_font"
	self.IncomingLabel:SetTextColor(Color(255, 255, 255))
	self.IncomingLabel:SetText "They offer:"
	self.IncomingLabel:SizeToContents()
	self.IncomingLabel:SetContentAlignment(4)
	self.IncomingLabel:SetRenderSystem(pluto.fonts.systems.shadow)
	self.IncomingLabel:Dock(TOP)
	self.IncomingLabel:DockMargin(0, 0, 0, 5)

	self.IncomingCurrency = self.Incoming:Add "EditablePanel"
	self.IncomingCurrency:Dock(TOP)
	self.IncomingCurrency:SetTall(self.ItemSize)
	self.IncomingCurrency:DockMargin(0, 0, 0, 5)
	function self.IncomingCurrency:PerformLayout(w, h)
		local pos = w / 2 + 5
		for _, child in pairs(self:GetChildren()) do
			pos = pos - child:GetWide() / 2 - 5 / 2
		end
		for _, child in pairs(self:GetChildren()) do
			child:SetPos(pos, 0)
			pos = pos + child:GetWide() + 5
		end
	end

	self.IncomingCurrencies = {}

	for i = 1, 4 do
		local cur = self.IncomingCurrency:Add "pluto_inventory_currency_selector"
		cur:SetWide(self.ItemSize - 16)
		cur:ShowAmount(true)
		self.IncomingCurrencies[i] = cur
	end

	self.IncomingItemContainer = self.Incoming:Add "EditablePanel"
	self.IncomingItemContainer:Dock(TOP)
	self.IncomingItemContainer:SetTall(self.ItemSize * 2 + 5)

	self.IncomingItems = {}

	local line
	for i = 1, 8 do
		if ((i - 1) % 4 == 0) then
			line = self.IncomingItemContainer:Add "EditablePanel"
			line:SetSize(self.ItemSize * 4 + 5 * 3, self.ItemSize)
			line:Center()
			if (i == 1) then
				line:SetPos(0, 0)
			else
				line:SetPos(0, self.ItemSize + 5)
			end
		end

		local item = line:Add "pluto_inventory_item"
		item:SetSize(self.ItemSize, self.ItemSize)
		self.IncomingItems[i] = item
		item:Dock(LEFT)
		item:DockMargin(0, 0, 5, 0)
		function item:OnLeftClick() end
		function item:OnRightClick() end
	end

	function self.IncomingItemContainer:PerformLayout(w, h)
		for _, child in pairs(self:GetChildren()) do
			local x, y = child:GetPos()
			child:SetPos(w / 2 - child:GetWide() / 2, y)
		end
	end

	self.Outgoing = self:Add "EditablePanel"
	self.Outgoing:Dock(BOTTOM)

	self.OutgoingLabel = self.Outgoing:Add "pluto_label"
	self.OutgoingLabel:SetFont "pluto_inventory_font"
	self.OutgoingLabel:SetTextColor(Color(255, 255, 255))
	self.OutgoingLabel:SetText "Your offers:"
	self.OutgoingLabel:SizeToContents()
	self.OutgoingLabel:SetContentAlignment(4)
	self.OutgoingLabel:SetRenderSystem(pluto.fonts.systems.shadow)
	self.OutgoingLabel:Dock(TOP)
	self.OutgoingLabel:DockMargin(0, 0, 0, 5)

	self.OutgoingCurrency = self.Outgoing:Add "EditablePanel"
	self.OutgoingCurrency:Dock(TOP)
	self.OutgoingCurrency:SetTall(self.ItemSize)
	self.OutgoingCurrency:DockMargin(0, 0, 0, 5)
	function self.OutgoingCurrency:PerformLayout(w, h)
		local pos = w / 2 + 5
		for _, child in pairs(self:GetChildren()) do
			pos = pos - child:GetWide() / 2 - 5 / 2
		end
		for _, child in pairs(self:GetChildren()) do
			child:SetPos(pos, 0)
			pos = pos + child:GetWide() + 5
		end
	end

	self.OutgoingCurrencies = {}

	for i = 1, 4 do
		local cur = self.OutgoingCurrency:Add "pluto_inventory_currency_selector"
		cur:SetWide(self.ItemSize - 16)
		cur:ShowAmount(true)
		self.OutgoingCurrencies[i] = cur
	end

	self.OutgoingItemContainer = self.Outgoing:Add "EditablePanel"
	self.OutgoingItemContainer:Dock(TOP)
	self.OutgoingItemContainer:SetTall(self.ItemSize * 2 + 5)

	self.OutgoingItems = {}

	line = nil
	for i = 1, 8 do
		if ((i - 1) % 4 == 0) then
			line = self.OutgoingItemContainer:Add "EditablePanel"
			line:SetSize(self.ItemSize * 4 + 5 * 3, self.ItemSize)
			line:Center()
			if (i == 1) then
				line:SetPos(0, 0)
			else
				line:SetPos(0, self.ItemSize + 5)
			end
		end

		local item = line:Add "pluto_inventory_item"
		item:SetSize(self.ItemSize, self.ItemSize)
		self.OutgoingItems[i] = item
		item:SetMouseInputEnabled(false)
		item:Dock(LEFT)
		item:DockMargin(0, 0, 5, 0)
	end

	function self.OutgoingItemContainer:PerformLayout(w, h)
		for _, child in pairs(self:GetChildren()) do
			local x, y = child:GetPos()
			child:SetPos(w / 2 - child:GetWide() / 2, y)
		end
	end
end

function PANEL:PerformLayout(w, h)
	self.Outgoing:SetTall(56 * 2 + 5 + 20 + 32 + 5)
end

vgui.Register("pluto_inventory_trading_active", PANEL, "EditablePanel")

