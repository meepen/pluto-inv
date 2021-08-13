local AppendHeader = pluto.rounds.AppendHeader
local AppendStats = pluto.rounds.AppendStats
local FirstColor = Color(77, 166, 255)
local SecondColor = Color(0, 230, 80)

local function RenderIntro()
	local y = ScrH() / 10

	y = AppendHeader("Saber Fools: Who is the best flailer around?", 4, y, FirstColor)
	y = AppendHeader("Be warned: the jiggle is deceiving!", 2, y)
end

local function RenderHeader()
	local y = ScrH() / 10

	y = AppendHeader("Saber Fools: Who is the best flailer around?", 4, y, FirstColor)
	y = AppendHeader("Fight all others to become the master!", 2, y)
end

local function RenderStats(state)
	local y = ScrH() / 5

	if (state.leader) then
		y = AppendStats(string.format("%s has the best K/D!", state.leader), 1, y, FirstColor)
	end

	if (state.kills) then
		y = AppendStats(string.format("Your kills: %i", state.kills), 1, y, SecondColor)
	end

	if (state.deaths) then
		y = AppendStats(string.format("Your deaths: %i", state.deaths), 1, y)
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
	pluto.rounds.Notify("A duel of fools approaches!", FirstColor)
end