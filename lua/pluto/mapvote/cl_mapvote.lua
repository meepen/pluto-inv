surface.CreateFont("pluto_mapvote_font", {
	font = "Lato", 
	size = 18
})

surface.CreateFont("pluto_mapvote_info_font", {
	font = "Roboto", 
	size = 16
})

local function GetImageMaterial(mapname, cb)
	if (file.Exists(mapname .. ".png", "DATA")) then
		return cb(Material("data/" .. mapname .. ".png"))
	end

	http.Fetch("https://cdn.pluto.gg/maps/" .. mapname .. ".png", function(dat, len, head, res)
		if (res == 200) then
			file.Write(mapname .. ".png", dat)
			GetImageMaterial(mapname, cb)
		end
	end)
end

local PANEL = {}

function PANEL:Init()
	self.Percent = 0.5
	self.Fill = self:Add "ttt_curved_panel"
	self.Fill:Dock(FILL)
	self.Top = self:Add "ttt_curved_panel"
	self.Top:Dock(TOP)

	self.Top:SetCurveBottomLeft(false)
	self.Top:SetCurveBottomRight(false)

	self.Fill:SetCurveTopLeft(false)
	self.Fill:SetCurveTopRight(false)

	self.Fill:SetCurve(2)
	self.Top:SetCurve(2)

	self:SetTopColor(Color(0, 0, 0, 0))

	self:SetFillColor(Color(0, 200, 200, 200))
end

function PANEL:SetFillPercent(pct)
	self.Percent = 1 - pct
	self:InvalidateLayout(true)
end

function PANEL:PerformLayout(w, h)
	self.Top:SetTall(h * self.Percent)
end

function PANEL:SetTopColor(col)
	self.Top:SetColor(col)
end

function PANEL:SetFillColor(col)
	self.Fill:SetColor(col)
end

vgui.Register("pluto_map_bar", PANEL, "EditablePanel")


local PANEL = {}

DEFINE_BASECLASS "DImageButton"

function PANEL:Init()
	self.Name = self:Add "ttt_curved_panel"
	self.Name:Dock(TOP)
	self.Name:SetTall(18 + 6)
	self.Name:SetMouseInputEnabled(false)

	self.Bar = self:Add "ttt_curved_panel"
	self.Bar:Dock(RIGHT)
	self.Bar:SetWide(28)
	self.Bar:SetMouseInputEnabled(false)
	self.Bar:DockPadding(4, 4, 4, 4)

	self.LikeBar = self:Add "ttt_curved_panel"
	self.LikeBar:Dock(RIGHT)
	self.LikeBar:SetWide(24)
	self.LikeBar:SetMouseInputEnabled(false)
	self.LikeBar:DockPadding(0, 4, 4, 4)

	self.Name:SetColor(Color(12, 13, 12, 220))
	self.Bar:SetColor(Color(12, 13, 12, 220))
	self.Bar:SetZPos(1)
	self.LikeBar:SetColor(Color(12, 13, 12, 220))
	self.LikeBar:SetZPos(0)

	self.LikeFill = self.LikeBar:Add "pluto_map_bar"
	self.LikeFill:Dock(FILL)
	self.LikeFill:SetTopColor(Color(56, 172, 87, 180))
	self.LikeFill:SetFillColor(Color(240, 20, 20, 180))
	self.LikeFill:DockMargin(2, 0, 2, 0)

	self.LikeImage = self.LikeBar:Add "DImage"
	self.LikeImage:Dock(BOTTOM)
	function self.LikeImage:PerformLayout(w, h)
		self:SetTall(w)
	end
	self.LikeImage:SetImage "pluto/icons/likednotvoted.png"
	self.LikeImage:DockMargin(0, 4, 0, 0)

	self.Bar:SetZPos(0)
	self.Name:SetZPos(1)

	self.Votes = self.Bar:Add "pluto_map_bar"
	self.Votes:Dock(FILL)
	self.Votes:SetTopColor(Color(0, 0, 0, 0))
	self.Votes:SetFillColor(Color(47, 70, 173, 200))
	self.Votes:DockMargin(2, 0, 2, 0)

	self.VoteImage = self.Bar:Add "DImage"
	self.VoteImage:Dock(BOTTOM)
	function self.VoteImage:PerformLayout(w, h)
		self:SetTall(w)
	end
	self.VoteImage:SetImage "pluto/icons/voted.png"
	self.VoteImage:DockMargin(0, 4, 0, 0)

	self.Name:DockPadding(3, 0, 0, 0)

	self.NameLabel = self.Name:Add "DLabel"
	self.NameLabel:SetContentAlignment(4)
	self.NameLabel:Dock(FILL)
	self.NameLabel:SetText "a"
	self.NameLabel:SetFont "pluto_mapvote_font"
	self.NameLabel:SetTextColor(white_text)

	self:SetKeepAspect(false)

	self:SetMouseInputEnabled(true)

	self:SetCursor "hand"

	self.Selected = self:Add "DImage"

	self.Selected:SetSize(24, 24)
	self.Selected:SetMouseInputEnabled(false)
	self.Selected:SetImage "pluto/icons/bluevoted.png"

	function self.Selected:PerformLayout(w, h)
		self:SetPos(3, self:GetParent():GetTall() - h - 3)
	end
	self.Selected:SetVisible(false)

	self.DoVotes = true
	hook.Add("PlutoMapVotesUpdated", self, self.PlutoMapVotesUpdated)
end

function PANEL:PlutoMapVotesUpdated()
	local pct = (pluto.mapvote.votes[self.Map] or 0) / (pluto.mapvote.total or 0)

	if (pct ~= pct) then
		pct = 1
	end

	self.Votes:SetFillPercent(pct)

	self.Selected:SetVisible(pluto.mapvote.voted == self.Map)
end

function PANEL:DisableVotes()
	self:SetCursor "arrow"
	self.DoVotes = false
	self.Bar:SetWide(0)
	self.LikeBar:SetWide(24)
	self.LikeBar:DockPadding(2, 4, 2, 4)

	self.DoVote = self:Add "ttt_curved_panel"
	self.DoVote:Dock(BOTTOM)
	self.DoVote:SetColor(Color(12, 13, 12, 220))
	self.DoVote:DockMargin(0, 0, 4, 0)
	self.DoVote:DockPadding(2, 2, 4, 2)

	self.VoteLabel = self.DoVote:Add "DLabel"

	self.VoteLabel:Dock(FILL)
	self.VoteLabel:SetTextColor(white_text)
	self.VoteLabel:SetText "Like map?"
	self.VoteLabel:SetFont "pluto_mapvote_font"
	self.VoteLabel:DockMargin(4, 1, 0, 0)

	self.Like = self.DoVote:Add "DImageButton"
	self.Like:SetImage "pluto/icons/likednotvoted.png"
	self.Like:Dock(RIGHT)
	self.Like:SetZPos(1)
	self.Like:DockMargin(0, 0, 4, 0)

	local s = self

	function self.Like:PerformLayout(w, h)
		self:SetWide(h)

		DEFINE_BASECLASS "DImageButton"
		BaseClass.PerformLayout(self, w, h)
	end

	function self.Like:DoClick()
		s.Dislike:SetImage "pluto/icons/dislikednotvoted.png"
		self:SetImage "pluto/icons/liked.png"
		pluto.inv.message()
			:write("likemap", true)
			:send()
	end

	self.Dislike = self.DoVote:Add "DImageButton"
	self.Dislike:SetImage "pluto/icons/dislikednotvoted.png"
	self.Dislike:Dock(RIGHT)

	self.Dislike:SetZPos(0)

	function self.Dislike:PerformLayout(w, h)
		self:SetWide(h)
		DEFINE_BASECLASS "DImageButton"
		BaseClass.PerformLayout(self, w, h)
	end

	function self.Dislike:DoClick()
		s.Like:SetImage "pluto/icons/likednotvoted.png"
		self:SetImage "pluto/icons/disliked.png"

		pluto.inv.message()
			:write("likemap", false)
			:send()
	end

	self.Selected:SetVisible(false)
end

function PANEL:OnMousePressed()
	if (not self.DoVotes) then
		return
	end
	self:DoClick()
end

function PANEL:SetMap(map)
	self.Map = map
	local info = pluto.mapvote.info[map]

	self.NameLabel:SetText((map:gsub("^ttt_", "")))

	if (info) then
		self:SetLikesDislikes(info.likes, info.dislikes)
	end

	self:PlutoMapVotesUpdated()

	GetImageMaterial(map, function(mat)
		if (IsValid(self)) then
			self:SetMaterial(mat)
		end
	end)
end

function PANEL:SetLikesDislikes(likes, dislikes)
	local pct = dislikes / (dislikes + likes)

	if (pct ~= pct) then
		pct = 0.5
	end

	self.LikeFill:SetFillPercent(pct)
	self.LikeBar:InvalidateLayout(true)
end

function PANEL:SetVotePercentage(p)
	self.Votes:SetFillPercent(p)
end

function PANEL:DoClick()
	print "click"
end

vgui.Register("pluto_mapvote_map", PANEL, "DImage")

local PANEL = {}

function PANEL:Init()
	self.Image = self:Add "DImage"
	self.Image:Dock(LEFT)
	self.Image:SetZPos(0)

	self.Image:SetImage "pluto/currencies/coin.png"

	self.ExtraInfo = self:Add "EditablePanel"
	self.ExtraInfo:Dock(FILL)
	self.ExtraInfo:SetZPos(1)
	self.ExtraInfo:DockPadding(0, 4, 0, 0)
	self.ExtraInfo:DockMargin(0, 0, 24, 0)

	self.NameBar = self.ExtraInfo:Add "ttt_curved_panel"
	self.NameBar:Dock(TOP)
	self.NameBar:SetCurveTopLeft(false)
	self.NameBar:SetCurveBottomLeft(false)
	self.NameBar:SetCurve(4)
	self.NameBar:SetColor(Color(32, 38, 41))

	self.NameLabel = self.NameBar:Add "DLabel"
	self.NameLabel:DockMargin(6, 2, 0, 4)

	self.NameLabel:Dock(FILL)
	self.NameLabel:SetContentAlignment(4)
	self.NameLabel:SetFont "pluto_mapvote_font"
	self.NameLabel:SetTextColor(white_text)


	self.ExtraInfoText = self.ExtraInfo:Add "EditablePanel"
	self.ExtraInfoText:Dock(FILL)
	self.ExtraInfoText:DockMargin(32, 4, 4, 4)

	self.LabelContainer = self.ExtraInfoText:Add "EditablePanel"
	self.LabelContainer:Dock(LEFT)

	self.TimesPlayedLabel = self.LabelContainer:Add "DLabel"
	self.TimesPlayedLabel:Dock(TOP)
	self.TimesPlayedLabel:SetText "Times Played:"
	self.TimesPlayedLabel:SetFont "pluto_mapvote_info_font"
	self.TimesPlayedLabel:SizeToContents()

	self.LikesLabel = self.LabelContainer:Add "DLabel"
	self.LikesLabel:Dock(TOP)
	self.LikesLabel:SetText "Likes:"
	self.LikesLabel:SetFont "pluto_mapvote_info_font"
	self.LikesLabel:SizeToContents()

	self.DislikesLabel = self.LabelContainer:Add "DLabel"
	self.DislikesLabel:Dock(TOP)
	self.DislikesLabel:SetText "Dislikes:"
	self.DislikesLabel:SetFont "pluto_mapvote_info_font"
	self.DislikesLabel:SizeToContents()

	self.LabelContainer:SetWide(math.max(self.TimesPlayedLabel:GetWide(), self.LikesLabel:GetWide(), self.DislikesLabel:GetWide()) + 20)

	self.InfoContainer = self.ExtraInfoText:Add "EditablePanel"
	self.InfoContainer:Dock(FILL)

	self.TimesPlayedInfo = self.InfoContainer:Add "DLabel"
	self.TimesPlayedInfo:Dock(TOP)
	self.TimesPlayedInfo:SetText "2"
	self.TimesPlayedInfo:SetFont "pluto_mapvote_info_font"
	self.TimesPlayedInfo:SizeToContents()

	self.LikesInfo = self.InfoContainer:Add "DLabel"
	self.LikesInfo:Dock(TOP)
	self.LikesInfo:SetText "3"
	self.LikesInfo:SetFont "pluto_mapvote_info_font"
	self.LikesInfo:SizeToContents()

	self.DislikesInfo = self.InfoContainer:Add "DLabel"
	self.DislikesInfo:Dock(TOP)
	self.DislikesInfo:SetText "4"
	self.DislikesInfo:SetFont "pluto_mapvote_info_font"
	self.DislikesInfo:SizeToContents()


	self.Bars = self:Add "ttt_curved_panel"
	self.Bars:DockPadding(4, 4, 4, 4)
	self.Bars:SetWide(20 * 3 + 4 * 4)
	self.Bars:Dock(RIGHT)
	self.Bars:DockMargin(0, 0, 24, 0)
	self.Bars:SetColor(Color(32, 38, 41))
	self.Bars:SetCurve(4)

	self.DislikeBar = self.Bars:Add "EditablePanel"
	self.DislikeBar:Dock(RIGHT)
	self.DislikeBar:SetWide(20)

	self.DislikeBarBarBackground = self.DislikeBar:Add "ttt_curved_panel"
	self.DislikeBarBarBackground:Dock(FILL)
	self.DislikeBarBarBackground:DockMargin(0, 0, 0, 4)
	self.DislikeBarBarBackground:SetCurve(2)
	self.DislikeBarBarBackground:SetColor(Color(14, 28, 32))
	self.DislikeBarBarBackground:DockPadding(2, 2, 2, 2)

	self.DislikeBarBar = self.DislikeBarBarBackground:Add "pluto_map_bar"
	self.DislikeBarBar:Dock(FILL)
	self.DislikeBarBar:SetFillColor(Color(240, 20, 20))

	self.DislikeImage = self.DislikeBar:Add "DImage"
	self.DislikeImage:Dock(BOTTOM)
	function self.DislikeImage:PerformLayout(w, h)
		self:SetTall(w)
	end
	self.DislikeImage:SetImage "pluto/icons/dislikednotvoted.png"

	self.LikeBar = self.Bars:Add "EditablePanel"
	self.LikeBar:DockMargin(4, 0, 4, 0)
	self.LikeBar:Dock(RIGHT)
	self.LikeBar:SetWide(20)

	self.LikeBarBarBackground = self.LikeBar:Add "ttt_curved_panel"
	self.LikeBarBarBackground:Dock(FILL)
	self.LikeBarBarBackground:DockMargin(0, 0, 0, 4)
	self.LikeBarBarBackground:SetCurve(2)
	self.LikeBarBarBackground:SetColor(Color(14, 28, 32))
	self.LikeBarBarBackground:DockPadding(2, 2, 2, 2)

	self.LikeBarBar = self.LikeBarBarBackground:Add "pluto_map_bar"
	self.LikeBarBar:Dock(FILL)
	self.LikeBarBar:SetFillColor(Color(56, 172, 87))

	self.LikeImage = self.LikeBar:Add "DImage"
	self.LikeImage:Dock(BOTTOM)
	function self.LikeImage:PerformLayout(w, h)
		self:SetTall(w)
	end
	self.LikeImage:SetImage "pluto/icons/likednotvoted.png"

	self.VoteBar = self.Bars:Add "EditablePanel"
	self.VoteBar:Dock(RIGHT)
	self.VoteBar:SetWide(20)

	self.VoteBarBarBackground = self.VoteBar:Add "ttt_curved_panel"
	self.VoteBarBarBackground:Dock(FILL)
	self.VoteBarBarBackground:DockMargin(0, 0, 0, 4)
	self.VoteBarBarBackground:SetCurve(2)
	self.VoteBarBarBackground:SetColor(Color(14, 28, 32))
	self.VoteBarBarBackground:DockPadding(2, 2, 2, 2)

	self.VoteBarBar = self.VoteBarBarBackground:Add "pluto_map_bar"
	self.VoteBarBar:Dock(FILL)
	self.VoteBarBar:SetFillColor(Color(56, 80, 210))

	self.VoteImage = self.VoteBar:Add "DImage"
	self.VoteImage:Dock(BOTTOM)
	function self.VoteImage:PerformLayout(w, h)
		self:SetTall(w)
	end
	self.VoteImage:SetImage "pluto/icons/voted.png"

	hook.Add("PlutoMapVotesUpdated", self, self.PlutoMapVotesUpdated)
end

function PANEL:PlutoMapVotesUpdated()
end

function PANEL:PerformLayout(w, h)
	self.Image:SetWide(h * 1.9)
end

function PANEL:PlutoMapVotesUpdated()
	local bestmp, bestvote
	for map, votes in pairs(pluto.mapvote.votes) do
		if (not bestvote or bestvote <= votes) then
			bestmp = map
			bestvote = votes
		end
	end

	self:SetMap(bestmp or pluto.mapvote.votable[1])

	local pct = (pluto.mapvote.votes[self.Map] or 0) / (pluto.mapvote.total or 0)

	if (pct ~= pct) then
		pct = 1
	end

	self.VoteBarBar:SetFillPercent(pct)
end

function PANEL:SetMap(map)
	if (not map) then
		return false
	end

	self.Map = map
	local info = pluto.mapvote.info[map]
	self.NameLabel:SetText((game.GetMap() == map and "On " or "Going to ") .. (map:gsub("^ttt_", "")))

	if (info) then
		self:SetLikesDislikes(info.likes, info.dislikes)
		self.LikesInfo:SetText(info.likes)
		self.DislikesInfo:SetText(info.dislikes)
		self.TimesPlayedInfo:SetText(info.played)
	end

	GetImageMaterial(map, function(mat)
		if (IsValid(self)) then
			self.Image:SetMaterial(mat)
		end
	end)

	return true
end

function PANEL:SetLikesDislikes(likes, dislikes)
	self.LikeBarBar:SetFillPercent(likes / (likes + dislikes))
	self.DislikeBarBar:SetFillPercent(dislikes / (likes + dislikes))
end

vgui.Register("pluto_mapvote_info", PANEL, "EditablePanel")


local PANEL = {}
function PANEL:Init()
	self:SetSize(594, 311)

	self.List = self:Add "ttt_curved_panel"
	self.List:DockPadding(6, 6, 6, 6)
	self.List:Dock(FILL)
	self.List:SetCurve(4)
	self.List:SetColor(Color(32, 38, 41))

	self.ListTop = self.List:Add "EditablePanel"
	self.ListTop:Dock(TOP)
	self.ListTop:DockMargin(0, 0, 0, 5)

	self.ListBottom = self.List:Add "EditablePanel"
	self.ListBottom:Dock(FILL)
	self.ListBottom:DockMargin(0, 5, 0, 0)

	function self.ListTop:PerformLayout()
		self:SetTall(self:GetParent():GetTall() / 2 - 6)
	end

	self.Maps = {}
	for i = 1, 8 do
		local p = (i <= 4 and self.ListTop or self.ListBottom):Add "pluto_mapvote_map"
		function p:PerformLayout(w, h)
			self:SetWide(self:GetParent():GetWide() / 4 - 30 / 4)
		end

		if (i % 4 ~= 1) then
			p:DockMargin(10, 0, 0, 0)
		end

		p:Dock(LEFT)
		self.Maps[i] = p
	end

	self.Bottom = self:Add "EditablePanel"
	self.Bottom:DockMargin(0, 10, 0, 0)
	self.Bottom:Dock(BOTTOM)
	self.Bottom:SetTall(100)

	self.Voted = self.Bottom:Add "pluto_mapvote_info"
	self.Voted:Dock(FILL)

	self.CurrentBackground = self.Bottom:Add "ttt_curved_panel"
	self.CurrentBackground:Dock(RIGHT)
	self.CurrentBackground:DockMargin(6, 0, 0, 0)
	self.CurrentBackground:DockPadding(6, 6, 6, 6)
	self.CurrentBackground:SetColor(Color(32, 38, 41))
	self.CurrentBackground:SetCurve(4)
	function self.CurrentBackground:PerformLayout()
		self:SetWide(self:GetParent():GetWide() / 4 + 12)
	end

	self.CurrentMap = self.CurrentBackground:Add "pluto_mapvote_map"
	self.CurrentMap:Dock(FILL)
	self.CurrentMap:DisableVotes()
end

function PANEL:Think()
	local p = self:GetParent()
	if (p ~= self.LastParent) then
		self:SetSize(p:GetSize())
		self.LastParent = p
	end
end

vgui.Register("pluto_mapvote", PANEL, "EditablePanel")


function pluto.inv.readmapvote()
	print("reading mapvote")

	local votable = net.ReadUInt(8) -- always 8 for now

	local state = {
		votable = {}, -- {maps...}
		info = {}, -- [map] = {likes, dislikes, played}
		votes = {}, -- [map] = amt
		total = 0,
	}

	pluto.mapvote = state

	for i = 1, votable do
		state.votable[i] = net.ReadString()
		state.info[state.votable[i]] = {
			likes = net.ReadUInt(32),
			dislikes = net.ReadUInt(32),
			played = net.ReadUInt(32),
		}
		print(i, state.votable[i])
		PrintTable(state.info[state.votable[i]])
	end

	state.info[game.GetMap()] = {
		likes = net.ReadUInt(32),
		dislikes = net.ReadUInt(32),
		played = net.ReadUInt(32),
	}

	PrintTable(state.info[game.GetMap()])

	pluto.mapvote_create()
end

function pluto.inv.readmapvotes()
	print("reading map votes")
	pluto.mapvote.total = 0
	pluto.mapvote.votes = {}
	for i = 1, net.ReadUInt(8) do
		local map = net.ReadString()
		local votes = net.ReadUInt(8)
		pluto.mapvote.votes[map] = votes
		pluto.mapvote.total = pluto.mapvote.total + votes
		print(i, map, votes)
	end

	hook.Run "PlutoMapVotesUpdated"
end

function pluto.inv.writelikemap(b)
	net.WriteBool(b)
end

function pluto.inv.writevotemap(s)
	pluto.mapvote.voted = s
	net.WriteString(s)
end

function pluto.mapvote_create()
	print("mapvote_create called")

	local state = pluto.mapvote
	PrintTable(state)

	if (IsValid(mapvote)) then
		print("removing old mapvote")
		mapvote:Remove()
	end

	if (not state) then
		print("returning due to no state")
		return
	end

	mapvote = vgui.Create "tttrw_base"

	local mv = vgui.Create "pluto_mapvote"
	for i = 1, #state.votable do
		print(i)
		local votable = state.votable[i]

		if (not state.info or not votable) then
			print("not state.info or not votable, removing mapvote and returning")
			mapvote:Remove()
			return
		end

		if (not mv.Maps[i]:SetMap(votable)) then
			print("not mv.Maps[i]:SetMap(votable), removing mapvote and returning")
			mapvote:Remove()
			return
		end

		local info = state.info[votable]

		mv.Maps[i].DoClick = function()
			pluto.inv.message()
				:write("votemap", state.votable[i])
				:send()
		end
	end
	
	if (not mv.CurrentMap:SetMap(game.GetMap())) then
		print("not mv.CurrentMap:SetMap(game.GetMap()), removing mapvote and returning")
		mapvote:Remove()
		return
	end
	mv.Voted:PlutoMapVotesUpdated()
	
	mapvote:AddTab("Mapvote", mv)
	
	mapvote:SetSize(math.min(800, ScrW()), 400)
	mapvote:Center()
	mapvote:MakePopup()
end

if (pluto.mapvote) then
	pluto.mapvote_create()
end