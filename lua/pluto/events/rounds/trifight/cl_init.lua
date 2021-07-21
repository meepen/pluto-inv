local AppendHeader = pluto.rounds.AppendHeader
local AppendStats = pluto.rounds.AppendStats
local FirstColor
local SecondColor

local function RenderIntro()
	local y = ScrH() / 10

	y = AppendHeader("Tri-Fight: Compete in three-way battle!", 4, y, FirstColor)
	y = AppendHeader("The team with the most kills wins!", 2, y)
end

local function RenderHeader()
	local y = ScrH() / 10

	y = AppendHeader("Tri-Fight: Compete in three-way battle!", 4, y, FirstColor)
	if (LocalPlayer():Alive()) then
		y = AppendHeader(string.format("Get the most kills as Team %s to win!", LocalPlayer():GetRole()), 2, y, LocalPlayer():GetRoleData().Color)
	end
end

local function RenderStats(state)
	local y = ScrH() / 5

	if (state.redkills) then
		y = AppendStats(string.format("Red Team kills: %i", state.redkills), 1, y, ttt.roles.Red.Color)
	end

	if (state.greenkills) then
		y = AppendStats(string.format("Green Team kills: %i", state.greenkills), 1, y, ttt.roles.Green.Color)
	end

	if (state.bluekills) then
		y = AppendStats(string.format("Blue Team kills: %i", state.bluekills), 1, y, ttt.roles.Blue.Color)
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
	FirstColor = Color(255, 170, 0)
	SecondColor = Color(255, 255, 128)

	pluto.rounds.Notify("Three will fight, one will win.", FirstColor)
end