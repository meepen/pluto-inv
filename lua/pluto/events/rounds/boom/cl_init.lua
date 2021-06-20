local AppendHeader = pluto.rounds.AppendHeader
local AppendStats = pluto.rounds.AppendStats
local FirstColor = Color(204, 34, 0)
local SecondColor = Color(255, 119, 51)

local function RenderIntro()
	local y = ScrH() / 10

	y = AppendHeader("Boomer Time: Last alive wins!", 4, y, FirstColor)
	y = AppendHeader("Fight for survival with fire, explosions, and burns!", 2, y)
end

local function RenderHeader()
	local y = ScrH() / 10

	y = AppendHeader("Survive as long as you can!", 4, y, FirstColor)
	y = AppendHeader("As the round progresses, you will slowly bake alive.", 2, y)
	y = AppendHeader("Get kills and damage to increase your flame resistance!", 2, y)
end

local function RenderStats(state)
	local y = ScrH() / 5

	if (state.living) then
		y = AppendStats(string.format("Fighters remaining: %i!", state.living), 1, y, FirstColor)
	end

	if (state.resistance) then
		y = AppendStats(string.format("Your flame resistance: %i%%", state.resistance), 1, y, SecondColor)
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
	pluto.rounds.Notify("Get ready to turn up the heat!", FirstColor)
end