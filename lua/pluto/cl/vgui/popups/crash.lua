pluto.crashing = false
pluto.cancrash = false

local PANEL = {}

function PANEL:Init()
	self:SetColor(Color(95, 96, 102))
	self:SetSize(400, 400)
	self:Center()
	self:MakePopup()

	self.Inner = self:Add "ttt_curved_panel"
	self.Inner:Dock(FILL)

	self:SetCurve(4)

	self.Inner:SetColor(Color(44, 46, 56))
	self.Inner:SetCurve(self:GetCurve())

	self.Text = self.Inner:Add "pluto_label"
	self.Text:SetFont "pluto_inventory_font_xlg"
	self.Text:SetText "SERVER CRASHED :((((("
	self.Text:SetTextColor(Color(255, 200, 200))
	self.Text:SetRenderSystem(pluto.fonts.systems.shadow)
	self.Text:Dock(TOP)
	self.Text:SizeToContentsY()

	self.TextSmall = self.Inner:Add "pluto_label"
	self.TextSmall:SetFont "pluto_inventory_font"
	self.TextSmall:SetText "(blame garry)"
	self.TextSmall:SetTextColor(ColorAlpha(pluto.ui.theme "TextActive", 128))
	self.TextSmall:SetRenderSystem(pluto.fonts.systems.shadow)
	self.TextSmall:Dock(TOP)
	self.TextSmall:SizeToContentsY()

	self.PlsRejoinLabel = self.Inner:Add "pluto_label"
	self.PlsRejoinLabel:SetFont "pluto_inventory_font_lg"
	self.PlsRejoinLabel:SetText "Why not join another server we have?"
	self.PlsRejoinLabel:SetTextColor(pluto.ui.theme "TextActive")
	self.PlsRejoinLabel:SetRenderSystem(pluto.fonts.systems.shadow)
	self.PlsRejoinLabel:Dock(TOP)
	self.PlsRejoinLabel:SizeToContentsY()
	self.PlsRejoinLabel:DockMargin(0, 7, 0, 7)

	self.Inner:DockPadding(7, 7, 7, 7)

	http.Fetch("http://va1.pluto.gg:3000/servers", function(b)
		if (IsValid(self)) then
			self:DataReceived(b)
		end
	end)
end

function PANEL:DataReceived(b)
	local data = util.JSONToTable(b)
	if (not data or not data[1]) then
		screamreallyloud.exe()
	end

	for _, server in pairs(data[1]) do
		if (not server.info) then
			return
		end

		local pnl = self.Inner:Add "pluto_crash_server"
		pnl:Dock(TOP)
		pnl:SetServer(server)
		pnl:InvalidateLayout(true)
		pnl:InvalidateParent(true)
	end

	self.Inner:SizeToChildren(false, true)
	self:SizeToChildren(false, true)
	self:Center()
end

function PANEL:Think()
	if (not pluto.crashing) then
		self:Remove()
	end
end

vgui.Register("pluto_crash_popup", PANEL, "ttt_curved_panel_outline")

local PANEL = {}
PANEL.Padding = 3

function PANEL:Init()
	self:DockMargin(0, 0, 0, 5)
	self:SetColor(Color(95, 96, 102))
	self:SetCurve(4)

	self.Inner = self:Add "ttt_curved_panel"
	self.Inner:Dock(FILL)
	self.Inner:SetColor(pluto.ui.theme "InnerColor")
	self.Inner:SetCurve(self:GetCurve())
	self.Inner:DockPadding(self.Padding, self.Padding, self.Padding, self.Padding)
	self.Inner:SetMouseInputEnabled(false)

	self.ServerName = self.Inner:Add "pluto_label"
	self.ServerName:SetText "hi"
	self.ServerName:SetTextColor(pluto.ui.theme "TextActive")
	self.ServerName:SetFont "pluto_inventory_font_xlg"
	self.ServerName:SetRenderSystem(pluto.fonts.systems.shadow)
	self.ServerName:Dock(TOP)
	self.ServerName:SetContentAlignment(4)
	self.ServerName:SizeToContentsY()

	self.ServerInfo = self.Inner:Add "EditablePanel"
	self.ServerInfo:Dock(TOP)
	self.ServerInfo:DockMargin(0, self.Padding, 0, 0)
	
	self.ServerMap = self.ServerInfo:Add "pluto_label"
	self.ServerMap:SetText "hi"
	self.ServerMap:SetTextColor(ColorAlpha(pluto.ui.theme "TextActive", 200))
	self.ServerMap:SetFont "pluto_inventory_font"
	self.ServerMap:SetRenderSystem(pluto.fonts.systems.shadow)
	self.ServerMap:Dock(LEFT)
	self.ServerMap:SetContentAlignment(5)
	self.ServerMap:SizeToContents()

	self.ServerPlayers = self.ServerInfo:Add "pluto_label"
	self.ServerPlayers:SetText "hi"
	self.ServerPlayers:SetTextColor(ColorAlpha(pluto.ui.theme "TextActive", 200))
	self.ServerPlayers:SetFont "pluto_inventory_font"
	self.ServerPlayers:SetRenderSystem(pluto.fonts.systems.shadow)
	self.ServerPlayers:Dock(RIGHT)
	self.ServerPlayers:SetContentAlignment(5)
	self.ServerPlayers:SizeToContents()

	self.ServerInfo:SetTall(self.ServerMap:GetTall())

	for _, child in pairs(self.Inner:GetChildren()) do
		child:InvalidateLayout(true)
		child:InvalidateParent(true)
	end
	self.Inner:SizeToChildren(false, true)
	self:SizeToChildren(false, true)
	self:SetTall(self:GetTall() + self.Padding * 2)

	self:SetCursor "hand"
end

function PANEL:OnMousePressed(m)
	if (m == MOUSE_LEFT) then
		LocalPlayer():ConCommand("connect " .. self.server.address)
	end
end

function PANEL:SetServer(server)
	self.server = server
	self.ServerName:SetText(server.info.serverName)
	self.ServerMap:SetText("Map: " .. server.info.mapName)
	self.ServerMap:SizeToContentsX()
	self.ServerPlayers:SetText("Players: " .. server.info.players .. " / " .. server.info.maxPlayers)
	self.ServerPlayers:SizeToContentsX()
end

vgui.Register("pluto_crash_server", PANEL, "ttt_curved_panel_outline")

local t = SysTime
local function get()
	return GetGlobalInt("pluto_crash_time", 0)
end

local update_time = 4

local last = {
	Time = t(),
	Value = get()
}

hook.Add("DrawOverlay", "pluto_crash_detect", function()
	if (last.Time + update_time > t()) then
		return
	end
	local oldvalue = last.Value

	
	pluto.crashing = oldvalue == get()

	if (pluto.cancrash and pluto.crashing and not IsValid(pluto_crash_popup)) then
		pluto_crash_popup = vgui.Create "pluto_crash_popup"
	end

	last.Time, last.Value = t(), get()
end)


timer.Simple(10, function()
	pluto.cancrash = true
end)