local AppendHeader = pluto.rounds.AppendHeader
local AppendStats = pluto.rounds.AppendStats
local FirstColor = Color(255, 225, 75)
local SecondColor = Color(150, 0, 175)

local function RenderIntro()
	local y = ScrH() / 10

	y = AppendHeader("Black Market Brawl: Take up rare arms and battle!", 4, y, FirstColor)
	y = AppendHeader("You're on your own, so attack anyone and everyone", 2, y)
end

local function RenderHeader()
	local y = ScrH() / 10

	y = AppendHeader("Black Market Brawl: Take up rare arms and battle!", 4, y, FirstColor)
	y = AppendHeader("Kill anyone and avoid dying!", 2, y)
end

local function RenderStats(state)
	local y = ScrH() / 5

	if (state.leader and state.leaderkills) then
		y = AppendStats(string.format("%s has the most kills: %i!", state.leader, state.leaderkills), 1, y, FirstColor)
	end

	if (state.kills) then
		y = AppendStats(string.format("Your kills: %i", state.kills), 1, y, SecondColor)
	end

	if (state.deaths) then
		y = AppendStats(string.format("Your deaths: %i", state.deaths), 1, y)
	end
end

--[[function ROUND:Prepare(state)

end--]]

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
	pluto.rounds.Notify("A uniquely legendary brawl approaches!", FirstColor)
end