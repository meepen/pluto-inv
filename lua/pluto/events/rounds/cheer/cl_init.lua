surface.CreateFont("cheer_header", {
	font = "Lato",
	size = math.max(24, ScrH() * 0.05),
})
surface.CreateFont("cheer_small", {
	font = "Roboto",
	size = math.max(16, ScrH() * 0.025),
})

local color_words = {
	blue = "blue, delivered by you!",
	green = "green, they are quite keen!",
	red = "red, to get joy spread!",
	yellow = "yellow, so be a kind fellow!",
}

local radar_outline = Color(0, 0, 0)
local indicator = surface.GetTextureID("effects/select_ring")

local function RenderIntro()
	local y = ScrH() / 10
	local _, h = draw.SimpleTextOutlined("This, hard, hard year has drained us of cheer.", "cheer_header", ScrW() / 2, y, white_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(12, 13, 15))
	y = y + h

	local _, h = draw.SimpleTextOutlined("Find and deliver toys to bring back our joys!", "cheer_small", ScrW() / 2, y, white_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(12, 13, 15))
end

local function RenderHeader(state)
	local ply = ttt.GetHUDTarget()
	if (not IsValid(ply) or not ply:Alive()) then
		return
	end

	local y = ScrH() / 10
	local x = ScrW() / 2

	local _, h = draw.SimpleTextOutlined("Find and deliver toys to bring back our joys!", "cheer_header", x, y, white_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(12, 13, 15))
	y = y + h

	if (state.bonus) then
		_, h = draw.SimpleTextOutlined(string.format("You need %i more scored to get a reward!", state.bonus), "cheer_small", x, y, white_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(12, 13, 15))
		y = y + h
	end

	if (state.target and state.color) then
		_, h = draw.SimpleTextOutlined(state.target .. " needs a toy of " .. color_words[state.color], "cheer_small", x, y, white_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(12, 13, 15))
		y = y + h
	end

	if (state.message) then
		_, h = draw.SimpleTextOutlined(state.message, "cheer_header", x, y, white_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(12, 13, 15))
		y = y + h
	end
end

local function RenderStats(state)
	local y = ScrH() / 5
	local x = 4
	if (state.cheer) then
		local _, h = draw.SimpleTextOutlined(string.format("Cheer Level: %i!", state.cheer), "cheer_small", x, y, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(12, 13, 15))
		y = y + h
	end

	if (state.found and state.target) then
		local _, h = draw.SimpleTextOutlined("Give your toy to " .. state.target .. "!", "cheer_small", x, y, ttt.roles.Child.Color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(12, 13, 15))
		y = y + h
	elseif (state.color) then
		local _, h = draw.SimpleTextOutlined("Find a " .. state.color .. " toy!", "cheer_small", x, y, ttt.roles.Monke.Color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(12, 13, 15))
		y = y + h
	end
end

local function RenderRadar(targets)
	surface.SetTexture(indicator)

	for _, target in pairs(targets) do
		local scrpos = target.Pos:ToScreen()
		if (not scrpos.visible) then continue end
		local sz = IsOffScreen(scrpos) and 12 or 24
		scrpos.x = math.Clamp(scrpos.x, sz, ScrW() - sz)
		scrpos.y = math.Clamp(scrpos.y, sz, ScrH() - sz)
		if (IsOffScreen(scrpos)) then return end

		local text = math.ceil(LocalPlayer():GetPos():Distance(target.Pos))
		surface.SetFont "ttt_radar_num_font"
		surface.SetDrawColor(target.Color)
		local w, h = surface.GetTextSize(text)
		-- Show range to target

		local mult = surface.GetAlphaMultiplier()
		local dist = Vector(ScrW() / 2, ScrH() / 2):Distance(Vector(scrpos.x, scrpos.y)) / math.sqrt(ScrW() * ScrH()) * 1500
		if (dist < 400) then
			surface.SetAlphaMultiplier(0.1 + 0.5 * dist / 400)
		else
			surface.SetAlphaMultiplier(1)
		end

		draw.SimpleTextOutlined(text, "ttt_radar_num_font", scrpos.x, scrpos.y, white_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0, 255))

		surface.SetDrawColor(target.Color)

		surface.DrawOutlinedRect(scrpos.x - w / 2 - 5, scrpos.y - h / 2 - 5, w + 10, h + 10)
		surface.DrawOutlinedRect(scrpos.x - w / 2 - 6, scrpos.y - h / 2 - 6, w + 12, h + 12)
		surface.SetAlphaMultiplier(mult)
	end
end

net.Receive("cheer_data", function()
	if (not pluto.rounds.state) then
		return
	end

	local str = net.ReadString()
	if (str == "cheer" or str == "bonus") then
		pluto.rounds.state[str] = net.ReadUInt(32)
	elseif (str == "target" or str == "color") then
		pluto.rounds.state[str] = net.ReadString()
		EmitSound("ambient/levels/canals/drip3.wav", vector_origin, -2, CHAN_STATIC, 1)
	elseif (str == "found") then
		pluto.rounds.state[str] = net.ReadBool()
	elseif (str == "message") then
		pluto.rounds.state.message = net.ReadString()
		if (net.ReadBool()) then
			EmitSound("ambient/levels/canals/windchime2.wav", vector_origin, -2, CHAN_STATIC, 1)
		else
			EmitSound("common/warning.wav", vector_origin, -2, CHAN_STATIC, 1)
		end
		timer.Simple(5, function()
			if (pluto.rounds and pluto.rounds.state) then
				pluto.rounds.state.message = nil 
			end
		end)
	elseif (str == "radar") then
		pluto.rounds.state.radar = {}
		for i = 1, net.ReadUInt(32) do
			pluto.rounds.state.radar[i] = {
				Pos = Vector(net.ReadFloat(), net.ReadFloat(), net.ReadFloat()),
				Color = Color(net.ReadUInt(32), net.ReadUInt(32), net.ReadUInt(32)),
			}
		end
	end
end)

function ROUND:Prepare(state)
	timer.Simple(5, function()
		--EmitSound("pluto/dkrap.ogg", vector_origin, -2, CHAN_STATIC, 1)
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
		if (state.radar) then
			RenderRadar(state.radar)
		end
	end
end)

ROUND:Hook("PreventRDMManagerPopup", function()
	return true
end)

function ROUND:NotifyPrepare()
	chat.AddText(white_text, "In the distance,", ttt.roles["S.A.N.T.A. Agent"].Color, " bells", white_text, " begin to", ttt.roles["S.A.N.T.A. Agent"].Color, " jingle...")
end