local AppendHeader = pluto.rounds.AppendHeader
local AppendStats = pluto.rounds.AppendStats
local FirstColor
local SecondColor

local function RenderIntro()
	local y = ScrH() / 10

	y = AppendHeader("King of the Quill: Fight to claim the golden quill!", 4, y, FirstColor)
	y = AppendHeader("Hold the quill for the longest to win!", 2, y)
end

local function RenderHeader()
	local y = ScrH() / 10

	y = AppendHeader("King of the Quill: Fight to claim the golden quill!", 4, y, FirstColor)
	y = AppendHeader("Hold the quill for the longest to win!", 2, y)
end

local function RenderStats(state)
	local y = ScrH() / 5

	if (state.leader and state.leaderscore) then
		y = AppendStats(string.format("%s has the greatest score: %i!", state.leader, state.leaderscore), 1, y, FirstColor)
	end

	if (state.score) then
		y = AppendStats(string.format("Your score: %i", state.score), 1, y, SecondColor)
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
	FirstColor = pluto.currency.byname._quill.Color
	SecondColor = pluto.currency.byname.quill.Color

	pluto.rounds.Notify("Which of you shall be the king of the quill?", FirstColor)
	print("Sort-of-credits to Limeinade for the 'original' King of the Hill idea (not really original but oh well)")
end