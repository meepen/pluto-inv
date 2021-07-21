local AppendHeader = pluto.rounds.AppendHeader
local AppendStats = pluto.rounds.AppendStats
local FirstColor
local SecondColor

local function RenderIntro()
	local y = ScrH() / 10

	y = AppendHeader("Phantom Fight: Eliminate the other team to win!", 4, y, FirstColor)
	y = AppendHeader("Dead teammates will be able to communicate with the living!", 2, y)
end

local function RenderHeader()
	local y = ScrH() / 10

	y = AppendHeader("Phantom Fight: Eliminate the other team to win!", 4, y, FirstColor)
	if (LocalPlayer():Alive()) then
		y = AppendHeader("Follow the direction of your phantom teammates!", 2, y)
	else
		y = AppendHeader("You're a phantom. Give direction to your living teammates!", 2, y)
	end
end

local function RenderStats(state)
	local y = ScrH() / 5

	if (state.teamlives) then
		y = AppendStats(string.format("Living teammates: %i", state.teamlives), 1, y, FirstColor)
	end

	if (state.enemylives) then
		y = AppendStats(string.format("Living enemies: %i", state.enemylives), 1, y, SecondColor)
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
	FirstColor = Color(115, 115, 125)
	SecondColor = Color(160, 160, 170)

	pluto.rounds.Notify("A ghostly battle looms ahead...", FirstColor)
	print("Credits to Limeinade for the inspiration via the Ghosting idea")
end