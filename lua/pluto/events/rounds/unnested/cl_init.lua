local AppendHeader = pluto.rounds.AppendHeader
local AppendStats = pluto.rounds.AppendStats
local FirstColor = Color(255, 166, 166)
local SecondColor = Color(255, 255, 102)

local function RenderIntro()
	local y = ScrH() / 10

	y = AppendHeader("Dolls Unnested: Unnest your rivals before they unnest you!", 4, y, FirstColor)
	y = AppendHeader("Shrink after dying, up until you're gone!", 2, y)
end

local function RenderHeader()
	local y = ScrH() / 10

	y = AppendHeader("Dolls Unnested: Unnest your rivals before they unnest you!", 4, y, FirstColor)
	y = AppendHeader("Shrink after dying, up until you're gone!", 2, y)
end

local function RenderStats(state)
	local y = ScrH() / 5

	if (state.left) then
		y = AppendStats(string.format("Dolls Remaining: %i", state.left), 1, y, FirstColor)
	end

	if (state.kills) then
		y = AppendStats(string.format("Your Kills: %i", state.kills), 1, y, SecondColor)
	end

	if (state.deaths) then
		y = AppendStats(string.format("Extra Lives: %i", math.max(0, 3 - state.deaths)), 1, y)
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
	pluto.rounds.Notify("The curse of the nesting dolls returns...", FirstColor)
end