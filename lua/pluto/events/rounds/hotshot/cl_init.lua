local AppendHeader = pluto.rounds.AppendHeader
local AppendStats = pluto.rounds.AppendStats
local HotshotColor
local HeaderColor = Color(150, 150, 175)

local function RenderIntro()
	local y = ScrH() / 10

	y = AppendHeader("Hotshot: Sudden Death Free-For-All!", 4, y, HeaderColor)
	y = AppendHeader("Shots are 3 points, Melees are 5, Deaths are -1", 2, y)
end

local function RenderHeader()
	local y = ScrH() / 10

	y = AppendHeader("Gain the most points to become the Hotshot!", 4, y, HeaderColor)
	y = AppendHeader("Shots are 3 points, Melees are 5, Deaths are -1", 2, y)
	y = AppendHeader("Kill the Hotshot for double points!", 2, y)
end

local function RenderStats(state)
	local y = ScrH() / 5

	if (state.leader and state.leaderscore) then
		y = AppendStats(string.format("%s is the Hotshot with the most points: %i!", state.leader, state.leaderscore), 1, y, HotshotColor)
	end

	if (state.score) then
		y = AppendStats(string.format("Your points: %i", state.score), 1, y)
	end
end

ROUND:Hook("TTTBeginRound", function(self, state)	
	pluto.rounds.FillerMusic()
end)

ROUND:Hook("HUDPaint", function(self, state)
	if (not pluto.rounds.state) then
		return
	end

	if (ttt.GetRoundState() == ttt.ROUNDSTATE_PREPARING) then
		RenderIntro(state)
	elseif (ttt.GetRoundState() == ttt.ROUNDSTATE_ACTIVE) then
		RenderHeader(state)
		RenderStats(state)
	end
end)

ROUND:Hook("PreventRDMManagerPopup", function()
	return true
end)

function ROUND:NotifyPrepare()
	HotshotColor = ttt.roles.Hotshot.Color

	pluto.rounds.Notify("Think you're some hotshot? Get ready to prove it!", HotshotColor)
	print("Credits to Eppen for the original Hotshot idea")
end