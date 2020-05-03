--
surface.CreateFont("posteaster_header", {
	font = "Lato",
	size = math.max(24, ScrH() * 0.05),
})
surface.CreateFont("posteaster_small", {
	font = "Roboto",
	size = math.max(16, ScrH() * 0.025),
})

local function RenderHeader()
	local y = ScrH() / 10
	local _, h = draw.SimpleTextOutlined("The bunnies want their eggs back...", "posteaster_header", ScrW() / 2, y, white_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(12, 13, 15))
	y = y + h

	local _, h = draw.SimpleTextOutlined("Children have misused the treasures inside of their eggs and now they want them back.", "posteaster_small", ScrW() / 2, y, white_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(12, 13, 15))
end

local function RenderRole()
	local ply = ttt.GetHUDTarget()
	if (not IsValid(ply) or not ply:Alive()) then
		return
	end

	local team = ply:GetRoleTeam()
	local data = ply:GetRoleData()

	local y = ScrH() / 10
	local x = ScrW() / 2
	if (team == "innocent") then
		local _, h = draw.SimpleTextOutlined("You are a child.", "posteaster_header", x, y, data.Color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(12, 13, 15))
		y = y + h
	
		_, h = draw.SimpleTextOutlined("Protect your eggs at all costs.", "posteaster_small", x, y, white_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(12, 13, 15))
	else
		local _, h = draw.SimpleTextOutlined("You are a bunny.", "posteaster_header", x, y, data.Color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(12, 13, 15))
		y = y + h
	
		_, h = draw.SimpleTextOutlined("Take your eggs back.", "posteaster_small", x, y, white_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(12, 13, 15))
		y = y + h

		_, h = draw.SimpleTextOutlined("Cooperate with other bunnies to succeed.", "posteaster_small", x, y, white_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(12, 13, 15))
		y = y + h
	end
end

local function RenderStats(state)
	local y = ScrH() / 5
	local x = 4
	if (state.total_lives_left) then
		local _, h = draw.SimpleTextOutlined(string.format("%i bunnies remaining", state.total_lives_left), "posteaster_small", x, y, ttt.roles.Bunny.Color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(12, 13, 15))
		y = y + h
	end

	if (state.currency_left) then
		local _, h = draw.SimpleTextOutlined(string.format("%i eggs remaining", state.currency_left), "posteaster_small", x, y, ttt.roles.Child.Color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(12, 13, 15))
		y = y + h
	end

	if (state.Start) then
		local _, h = draw.SimpleTextOutlined(string.format("%is until next wave", 11 - math.ceil((CurTime() - state.Start) % 10)), "posteaster_small", x, y, ttt.roles.Bunny.Color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(12, 13, 15))
		y = y + h
	end
end

net.Receive("posteaster_data", function()
	local str = net.ReadString()
	if (str == "currency_left" or str == "lives_left" or str == "total_lives_left") then
		pluto.rounds.state[str] = net.ReadUInt(32)
	end
end)

function ROUND:Prepare(state)
	state.Start = CurTime()
end

ROUND:Hook("HUDPaint", function(self, state)
	if (ttt.GetRoundState() == ttt.ROUNDSTATE_PREPARING) then
		RenderHeader(state)
	elseif (ttt.GetRoundState() == ttt.ROUNDSTATE_ACTIVE) then
		RenderRole(state)
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
	chat.AddText(ttt.roles.Bunny.Color, "Bunnies", white_text, " whispers get louder..")
end