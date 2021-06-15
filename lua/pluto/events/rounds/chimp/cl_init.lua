local AppendHeader = pluto.rounds.AppendHeader
local AppendStats = pluto.rounds.AppendStats
local MonkeColor
local BossColor
local ChildColor

local function RenderIntro()
	local y = ScrH() / 10

	y = AppendHeader("The chimps are trying to decide who is the Monke King", 4, y, MonkeColor)
	y = AppendHeader("Collect the most bananas to rise up above the rest of the chimps", 2, y)
end

local function RenderHeader()
	local y = ScrH() / 10

	y = AppendHeader("Monke... Want... BANNA!", 4, y, MonkeColor)
	y = AppendHeader("Grab banna! Fight for banna!", 2, y)
end

local function RenderStats(state)
	local y = ScrH() / 5

	if (state.leader) then
		y = AppendStats(state.leader, 1, y, BossColor)
	end

	if (state.left and state.left >= 0 and state.left <= 256) then
		y = AppendStats(string.format("%i banna left", state.left), 1, y, ChildColor)
	end

	if (state.score) then
		y = AppendStats(string.format("%i banna finded", state.score), 1, y, MonkeColor)
	end
end

function ROUND:Prepare(state)
	state.Start = CurTime()
	timer.Simple(5, function()
		EmitSound("pluto/dkrap.ogg", vector_origin, -2, CHAN_STATIC, 1)
	end)
end

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
	MonkeColor = ttt.roles.Monke.Color
	BossColor = ttt.roles["Banna Boss"].Color
	AgentColor = ttt.roles["S.A.N.T.A. Agent"].Color

	pluto.rounds.Notify("OOK! OOK! AH AH AH!", MonkeColor)
end