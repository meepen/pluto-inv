--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
local AppendHeader = pluto.rounds.AppendHeader
local AppendStats = pluto.rounds.AppendStats
local FirstColor = Color(153, 0, 26)
local SecondColor = Color(163, 144, 148)

local function RenderIntro()
	local y = ScrH() / 10

	y = AppendHeader("Soul Hoarders: Kill enemies to steal their souls!", 4, y, FirstColor)
	y = AppendHeader("Gain one point per second per soul hoarded!", 2, y)
end

local function RenderHeader()
	local y = ScrH() / 10

	y = AppendHeader("Soul Hoard: Kill enemies to steal their souls", 4, y, FirstColor)
	y = AppendHeader("Gain one point per second per soul hoarded!", 2, y)
end

local function RenderStats(state)
	local y = ScrH() / 5

	if (state.leader and state.leaderscore) then
		y = AppendStats(string.format("%s has the greatest soul hoard: %i!", state.leader, state.leaderscore), 1, y, FirstColor)
	end

	if (state.score) then
		y = AppendStats(string.format("Your score: %i", state.score), 1, y)
	end

	if (state.souls) then
		y = AppendStats(string.format("Your seeker's souls: %i", state.souls), 1, y, SecondColor)
	end

	if (state.souls) then
		y = AppendStats(string.format("Your points per second: %i", math.min(10, state.souls)), 1, y, SecondColor)
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
	pluto.rounds.Notify("So many free spirits! So many ready souls...", SecondColor)
end