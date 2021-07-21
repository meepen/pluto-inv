local AppendHeader = pluto.rounds.AppendHeader
local AppendStats = pluto.rounds.AppendStats
local BunnyColor
local ChildColor

local function RenderIntro()
	local y = ScrH() / 10

	y = AppendHeader("The bunnies want their eggs back...", 4, y, BunnyColor)
	y = AppendHeader("Children have misused the treasures inside the eggs and they want them back!", 2, y, ChildColor)
end

local function RenderHeader()
	local y = ScrH() / 10

	local team = LocalPlayer():GetRoleTeam()

	if (team == "innocent") then
		y = AppendHeader("You are a child.", 4, y, ChildColor)
		y = AppendHeader("Protect your eggs at all costs!", 2, y)
	else
		y = AppendHeader("You are a bunny.", 4, y, BunnyColor)
		y = AppendHeader("Take your eggs back!", 2, y)
	end
end

local function RenderStats(state)
	local y = ScrH() / 5

	if (state.total_lives) then
		y = AppendHeader(string.format("%i bunnies remaining", state.total_lives), 1, y, BunnyColor)
	end

	if (state.lives) then
		y = AppendHeader(string.format("yYou have %i lives left", state.lives), 1, y, BunnyColor)
	end

	if (state.left) then
		y = AppendHeader(string.format("%i eggs remaining", state.left), 1, y, ChildColor)
	end

	if (state.start) then
		y = AppendHeader(string.format("%is until next wave", 11 - math.ceil((CurTime() - state.start) % 10)), 1, y)
	end
end

function ROUND:Prepare(state)
	state.start = CurTime()
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

ROUND:Hook("TTTBeginRound", function(self, state)
	EmitSound("pluto/blade_of_the_ruined_king.ogg", vector_origin, -2, CHAN_STATIC, 0.9)
end)

ROUND:Hook("CalcView", function(self, state, ply, pos, ang, fov, znear, zfar)
	if (ply:GetRoleTeam() == "traitor") then
		local tr = util.TraceLine {
			start = pos,
			endpos = pos - ply:GetAimVector() * 150,
			mask = MASK_PLAYERSOLID,
			filter = ply,
		}

		return {
			origin = tr.HitPos,
			angles = ang,
			fov = fov,
			zfar = zfar,
			znear = znear,
			drawviewer = true,
		}
	end
end)

function ROUND:NotifyPrepare()
	BunnyColor = ttt.roles.Bunny.Color
	ChildColor = ttt.roles.Child.Color

	pluto.rounds.Notify("Bunny whispers get louder...", BunnyColor)
end