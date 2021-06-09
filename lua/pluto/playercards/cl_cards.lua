function pluto.ui.playercard(player)
	local container = vgui.Create("pluto_playercard")
	container:SetPlayer(player)
	return container	
end

function pluto.inv.writeplayercardreq(ply)
	net.WriteEntity(ply)
end

pluto.playercards = {cache = {}, waiting = {}}

local function cachePlayercard(ply)
	if not IsValid(ply) then return end
	pluto.playercards.cache[ply:SteamID64()] = {
		valid = true,
		playtime = net.ReadUInt(32), 
		IsValid = function(self)
			return self.valid
		end
	}
end

local PANEL = {}

surface.CreateFont("pluto_playercard_name", {
	font = "Roboto",
	size = 30,
	weight = 450,
})

surface.CreateFont("pluto_playercard_id", {
	font = "Roboto",
	size = 14,
	weight = 450,
})

surface.CreateFont("pluto_playercard_small", {
	font = "Roboto",
	size = 20,
	weight = 450
})

surface.CreateFont("pluto_showcase_xsmall", {
	font = "Roboto",
	size = 12,
	weight = 450,
	italic = true
})

surface.CreateFont("pluto_showcase_suffix_text", {
	font = "Roboto",
	size = 14,
	weight = 450,
})

function PANEL:Init()
	for _, child in pairs(self:GetChildren()) do
		child:Remove()
	end

	self:SetColor(Color(84, 86, 90, 255))

	self.InfoContainer = self:Add("EditablePanel")
	self.InfoContainer:Dock(FILL)
	self.InfoContainer:DockPadding(1,1,1,1)

	self:SetCurve(4)

	self.TextContainer = self.InfoContainer:Add("EditablePanel")
	self.TextContainer:Dock(FILL)
	self.TextContainer:DockMargin(10,10,11,0)

	self.UsernameContainer = self.TextContainer:Add("EditablePanel")
	self.UsernameContainer:Dock(TOP)
	
	self.Username = self.UsernameContainer:Add("pluto_label")
	self.Username:SetRenderSystem(pluto.fonts.systems.shadow)
	self.Username:SetFont("pluto_playercard_name")
	self.Username:SetTextColor(pluto.ui.theme("TextActive"))
	self.Username:Dock(LEFT)
	self.Username:SetContentAlignment(4)

	self.Level = self.UsernameContainer:Add "ttt_scoreboard_rank"
	self.Level:SetColor(Color(0, 0, 0, 255))
	self.Level:SetFont("ttt_scoreboard_rank")
	self.Level:SetTextColor(white_text)
	self.Level:SetMouseInputEnabled(false)
	self.Level:SetCurve(4)
	self.Level:Dock(LEFT)
	self.Level:DockMargin(10,0,0,0)

	self.Playtime = self.TextContainer:Add("pluto_label")
	self.Playtime:SetRenderSystem(pluto.fonts.systems.shadow)
	self.Playtime:SetFont("pluto_playercard_small")
	self.Playtime:SetTextColor(Color(174, 174, 174, 200))
	self.Playtime:Dock(TOP)
	self.Playtime:SetContentAlignment(4)

	self.SteamID = self.TextContainer:Add("pluto_label")
	self.SteamID:SetRenderSystem(pluto.fonts.systems.shadow)
	self.SteamID:SetFont("pluto_playercard_id")
	self.SteamID:SetTextColor(Color(174, 174, 174, 200))
	self.SteamID:Dock(BOTTOM)
	self.SteamID:SetContentAlignment(4)

	self.Avatar = self.InfoContainer:Add("AvatarImage")
	self.Avatar:SetSize(128, 128)
	self.Avatar:Dock(LEFT)

	self.AvatarOverlay = self.Avatar:Add("EditablePanel")
	self.AvatarOverlay:Dock(BOTTOM)

	self.Rank = self.AvatarOverlay:Add("ttt_scoreboard_rank")
	self.Rank:SetColor(Color(0, 0, 0, 0))
	self.Rank:SetFont("ttt_scoreboard_rank")
	self.Rank:SetText("Rank")
	self.Rank:SetTextColor(white_text)
	self.Rank:SetMouseInputEnabled(true)
	self.Rank:SetCurve(4)
	self.Rank:SizeToContents()
	self.Rank:Dock(LEFT)

	self:SetSize(300, 132)

	self:InvalidateLayout(true)
end

DEFINE_BASECLASS "ttt_curved_panel"

function PANEL:Paint(w, h)
	BaseClass.Paint(self, w, h)

	surface.SetDrawColor(38, 38, 38)
	ttt.DrawCurvedRect(1, 1, w - 2, h - 2, self:GetCurve() / 2)
	
	surface.SetDrawColor(36, 36, 36)
	local scrx, scry = self:LocalToScreen(1, 1)
	local scrx2, scry2 = self:LocalToScreen(w - 1, h - 1)
	render.SetScissorRect(scrx, scry, scrx2, scry2, true)
	local step = 11
	for y = 0, h + w + step, step do
		surface.DrawLine(1, y, w - 2, y - w - 2)
	end
	render.SetScissorRect(scrx, scry, scrx2, scry2, false)
end

function PANEL:SetPlayer(ply)
	self.Player = ply
	pluto.inv.readplayercardinfo = function()
		if not IsValid(self) then return end
		cachePlayercard(ply)
		self:PlayerInfo()
	end

	pluto.inv.message()
		:write("playercardreq", ply)
	:send()

	self.Player = ply
	self.Username:SetText(ply:GetName())
	self.Username:SizeToContents()
	self.SteamID:SetText(ply:SteamID())
	self.SteamID:SizeToContentsX()
	self.Avatar:SetPlayer(ply, 184)

	local col = self.Player:GetPlutoLevelColor()

	if (isfunction(col)) then
		hook.Add("Tick", self, function(self)
			self:SetColor(col())
			self.Level:SetColor(col())
		end)
	else
		self:SetColor(col)
		self.Level:SetColor(col)
	end

	self.Level:SetText(ply:GetPlutoLevel())
	self.Level:SizeToContents()

	self.UsernameContainer:SetTall(self.Username:GetTall())

	local col = hook.Run("TTTGetPlayerColor", ply) or color_white
	self.Rank:SetColor(ColorAlpha(col, 0.9 * 255))
	self.Rank:SetText(hook.Run("TTTGetRankPrintName", ply:GetUserGroup()) or ply:GetUserGroup())
	self.Rank:SizeToContents()

	self.Playtime:SetText("Loading...")
	self.Playtime:SizeToContentsX()

	local x,_,y = self.TextContainer:GetDockMargin()
	local u,_,v = self.InfoContainer:GetDockPadding()
	self:SetWide(self.Username:GetWide() + self.Level:GetWide() + self.Avatar:GetWide() + x + y + u + v + self.Level:GetDockMargin())

	if (IsValid(pluto.playercards.cache[ply:SteamID64()])) then
		self:PlayerInfo()
	end
end

function PANEL:PlayerInfo()
	local cache = pluto.playercards.cache[self.Player:SteamID64()]
	self.Playtime:SetText(admin.nicetimeshort(cache.playtime))
	self.Playtime:SizeToContentsX()

	local x,_,y = self.TextContainer:GetDockMargin()
	local u,_,v = self.InfoContainer:GetDockPadding()
	self:SetWide(self.Username:GetWide() + self.Level:GetWide() + self.Avatar:GetWide() + x + y + u + v + self.Level:GetDockMargin())
end

function PANEL:GetCanvas()
	return self.Inner
end

vgui.Register("pluto_playercard", PANEL, "ttt_curved_panel")

--[[if (x != nil) then
	x:Remove()
end

pluto.ui.playercard(LocalPlayer(), function(self)
	x = self
	self:SetPos(100, 100)
end)]]

hook.Add("TTTRWScoreboardPlayer", "pluto_level", function(ply, add, self)
	function self.Avatar:OnCursorEntered()
		if (pluto.scoreboard_playercard != nil) then
			pluto.scoreboard_playercard:Remove()
			pluto.scoreboard_playercard = nil
		end

		local card = pluto.ui.playercard(ply)
		pluto.scoreboard_playercard = card
		local x, y = input.GetCursorPos()
		card:SetPos(x, y + 25)
		card:MakePopup()
		card:SetKeyboardInputEnabled(false)
		card:MoveToFront()

		card.Think = function(card)
			if (!self:IsHovered() or pluto.scoreboard_playercard ~= card) then
				card:Remove()
				pluto.scoreboard_playercard = nil
			else if (input.IsMouseDown(MOUSE_LEFT)) then
				local steamid = ply:SteamID64() or ""
					gui.OpenURL("https://steamcommunity.com/profiles/" .. steamid)
				end
			end
		end
	end

	function self.Avatar:OnCursorMoved(x, y)
		if (pluto.scoreboard_playercard != nil) then
			pluto.scoreboard_playercard:SetPos(self:LocalToScreen(x, y + 25))
		end
	end

	self.Avatar:SetCursor("hand")

	function self.Avatar:Think()
		
	end
end)

hook.Add("ScoreboardHide", "RemovePlayercard", function()
	if (pluto.scoreboard_playercard != nil) then
		pluto.scoreboard_playercard:Remove()
	end
end)