local AppendHeader = pluto.rounds.AppendHeader
local AppendStats = pluto.rounds.AppendStats
local FirstColor
local SecondColor

local function RenderIntro()
	local y = ScrH() / 10

	y = AppendHeader("Infection: Rise, dead, and take over the world!", 4, y, FirstColor)
	y = AppendHeader("Survivors, survive, and infected, infect!", 2, y)
end

local function RenderHeader(state)
	local y = ScrH() / 10

	y = AppendHeader("Infection: Rise, dead, and take over the world!", 4, y, FirstColor)
	if (state.infectedfound) then
		y = AppendHeader("Survivors, survive, and infected, infect!", 2, y)
	else
		y = AppendHeader("Survivors, fight! First dead will become the infected.", 2, y)
	end
end

local function RenderStats(state)
	local y = ScrH() / 5

	if (state.kills) then
		y = AppendStats(string.format("Survivors Killed: %i", state.kills), 1, y, FirstColor)
	end

	if (state.timesurvived) then
		y = AppendStats(string.format("Seconds Survived: %i", state.timesurvived), 1, y, SecondColor)
	end

	if (state.living) then
		y = AppendStats(string.format("Survivors remaining: %i", state.living), 1, y)
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
	FirstColor = Color(0, 128, 0)
	SecondColor = Color(128, 85, 0)

	pluto.rounds.Notify("The infection comes...", FirstColor)
end