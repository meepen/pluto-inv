--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
local AppendHeader = pluto.rounds.AppendHeader
local AppendStats = pluto.rounds.AppendStats
local ChildColor
local AgentColor

local radar_outline = Color(0, 0, 0)
local indicator = surface.GetTextureID("effects/select_ring")

local function RenderIntro()
	local y = ScrH() / 10

	y = AppendHeader("This hard year has drained our cheer.", 4, y, ChildColor)
	y = AppendHeader("Find the right toy to bring back some joy!", 2, y, AgentColor)
end

local function RenderHeader(state)
	local y = ScrH() / 10
	y = AppendHeader("Find the right toy to bring back some joy!", 4, y, AgentColor)

	if (state.color and not state.found) then
		y = AppendHeader("Find a " .. state.color .. " toy!", 3, y)
	elseif (state.target) then
		y = AppendHeader("Find " .. state.target .. "!", 3, y)
	end

	if (state.bonus) then
		y = AppendHeader(string.format("%i more scored to get a reward!", state.bonus), 1, y, ChildColor)
	end
end

local function RenderStats(state)
	local y = ScrH() / 5

	if (state.found and state.target) then
		y = AppendStats("Give your toy to " .. state.target .. "!", 1, y, pluto.currency.byname["_toy_" .. state.color].Color)
	elseif (state.color and state.target) then
		y = AppendStats("Find a " .. state.color .. " toy for " .. state.target .. "!", 1, y, pluto.currency.byname["_toy_" .. state.color].Color)
	end

	if (state.reward) then
		y = AppendStats(string.format("You've earned %i presents!", state.reward), 1, y)
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
	if (str == "message") then
		if (net.ReadBool()) then
			EmitSound("ambient/levels/canals/windchime2.wav", vector_origin, -2, CHAN_STATIC, 1)
		else
			EmitSound("common/warning.wav", vector_origin, -2, CHAN_STATIC, 1)
		end
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
	EmitSound("pluto/cheersong.ogg", vector_origin, -2, CHAN_STATIC, 0.7)
	timer.Simple(85, function()
		EmitSound("pluto/cheersong.ogg", vector_origin, -2, CHAN_STATIC, 0.7)
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