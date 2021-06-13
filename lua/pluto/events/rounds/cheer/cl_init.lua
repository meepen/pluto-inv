local AppendHeader = pluto.rounds.AppendHeader
local AppendStats = pluto.rounds.AppendStats
local ChildColor
local AgentColor

--[[surface.CreateFont("cheer_header", {
	font = "Lato",
	size = math.max(24, ScrH() * 0.05),
})
surface.CreateFont("cheer_medium", {
	font = "Roboto",
	size = math.max(20, ScrH() * 0.0375),
})
surface.CreateFont("cheer_small", {
	font = "Roboto",
	size = math.max(16, ScrH() * 0.025),
})

local outline_text = Color(12, 13, 15)--]]

--[[local color_words = {
	blue = "blue, delivered by you!",
	green = "green, they are quite keen!",
	red = "red, to get joy spread!",
	yellow = "yellow, so be a kind fellow!",
}--]]

local radar_outline = Color(0, 0, 0)
local indicator = surface.GetTextureID("effects/select_ring")

local function RenderIntro()
	local y = ScrH() / 10

	y = AppendHeader("This hard year has drained our cheer.", 4, y, ChildColor)
	y = AppendHeader("Find the right toy to bring back some joy!", 2, y, AgentColor)
	--[[local _, h = draw.SimpleTextOutlined("This, hard, hard year has drained us of cheer.", "cheer_header", ScrW() / 2, y, ttt.roles.Child.Color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, outline_text)
	y = y + h

	_, h = draw.SimpleTextOutlined("Find and deliver toys to bring back our joys!", "cheer_medium", ScrW() / 2, y, ttt.roles["S.A.N.T.A. Agent"].Color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, outline_text)
--]]
end

local function RenderHeader(state)
	local y = ScrH() / 10
	--local x = ScrW() / 2

	--[[local _, h = draw.SimpleTextOutlined("Find and deliver toys to bring back our joys!", "cheer_header", x, y, ttt.roles["S.A.N.T.A. Agent"].Color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, outline_text)
	y = y + h--]]
	y = AppendHeader("Find the right toy to bring back some joy!", 4, y, AgentColor)

	if (state.bonus) then
		y = AppendHeader(string.format("%i more scored to get a reward!", state.bonus), 1, y)
		--[[_, h = draw.SimpleTextOutlined(string.format("You need %i more scored to get a reward!", state.bonus), "cheer_small", x, y, white_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, outline_text)
		y = y + h--]]
	end

	--if (state.target and state.color) then
		--y = AppendHeader(state.target .. " needs a toy of " .. color_words[state.color], 1, y, pluto.currency.byname["_toy_" .. state.color].Color)
		--[[_, h = draw.SimpleTextOutlined(state.target .. " needs a toy of " .. color_words[state.color], "cheer_small", x, y, pluto.currency.byname["_toy_" .. state.color].Color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, outline_text)
		y = y + h--]]
	--end

	if (state.message) then
		y = AppendHeader(state.message, 2, y)
		--[[_, h = draw.SimpleTextOutlined(state.message, "cheer_medium", x, y, white_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, outline_text)
		y = y + h--]]
	end
end

local function RenderStats(state)
	local y = ScrH() / 5
	--local x = 4

	if (state.found and state.target) then
		y = AppendStats("Give your toy to " .. state.target .. "!", 1, y, pluto.currency.byname["_toy_" .. state.color].Color)
		--[[_, h = draw.SimpleTextOutlined("Give your toy to " .. state.target .. "!", "cheer_small", x, y, pluto.currency.byname["_toy_" .. state.color].Color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, outline_text)
		y = y + h--]]
	elseif (state.color and state.target) then
		y = AppendStats("Find a " .. state.color .. " toy for " .. state.target .. "!", 1, y, pluto.currency.byname["_toy_" .. state.color].Color)
		--[[_, h = draw.SimpleTextOutlined("Find a " .. state.color .. " toy!", "cheer_small", x, y, pluto.currency.byname["_toy_" .. state.color].Color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, outline_text)
		y = y + h--]]
	end

	if (state.earned) then
		y = AppendStats(string.format("You've earned %i presents!", state.bonus), 1, y)
		--[[local _, h = draw.SimpleTextOutlined(string.format("Cheer Level: %i!", state.cheer), "cheer_small", x, y, ttt.roles["S.A.N.T.A. Agent"].Color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, outline_text)
		y = y + h--]]
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
	--[[if (str == "cheer" or str == "bonus") then
		pluto.rounds.state[str] = net.ReadUInt(32)
	elseif (str == "target" or str == "color") then
		pluto.rounds.state[str] = net.ReadString()
		EmitSound("ambient/levels/canals/drip3.wav", vector_origin, -2, CHAN_STATIC, 1)
	elseif (str == "found") then
		pluto.rounds.state[str] = net.ReadBool()
	else--]]if (str == "message") then
		local message = net.ReadString()
		--pluto.rounds.state.message = net.ReadString()
		if (net.ReadBool()) then
			EmitSound("ambient/levels/canals/windchime2.wav", vector_origin, -2, CHAN_STATIC, 1)
		else
			EmitSound("common/warning.wav", vector_origin, -2, CHAN_STATIC, 1)
		end
		pluto.rounds.Notify(message, nil, true)
		--[[timer.Create("pluto_cheer_message", 8, 1, function()
			if (pluto.rounds and pluto.rounds.state) then
				pluto.rounds.state.message = nil 
			end
		end)--]]
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

ROUND:Hook("TTTBeginRound", function(self, state)
	EmitSound("pluto/cheersong.ogg", vector_origin, -2, CHAN_STATIC, 1)
	timer.Simple(85, function()
		EmitSound("pluto/cheersong.ogg", vector_origin, -2, CHAN_STATIC, 1)
	end)
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
		if (state.radar) then
			RenderRadar(state.radar)
		end
	end
end)

ROUND:Hook("PreventRDMManagerPopup", function()
	return true
end)

function ROUND:NotifyPrepare()
	ChildColor = ttt.roles.Child.Color
	AgentColor = ttt.roles["S.A.N.T.A. Agent"].Color
	pluto.rounds.Notify("In the distance, bells begin to jingle...", AgentColor)
end