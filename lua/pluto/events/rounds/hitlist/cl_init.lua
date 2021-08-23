--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
local AppendHeader = pluto.rounds.AppendHeader
local AppendStats = pluto.rounds.AppendStats
local FirstColor
local SecondColor

local radar_outline = Color(0, 0, 0)
local indicator = surface.GetTextureID("effects/select_ring")

local function RenderIntro()
	local y = ScrH() / 10

	y = AppendHeader("Hit List: Kill your mark, up your prize.", 4, y, FirstColor)
	y = AppendHeader("Eliminate your target before you're eliminated!", 2, y)
end

local function RenderHeader(state)
	local y = ScrH() / 10

	y = AppendHeader("Hit List: Kill your mark, up your prize.", 4, y, FirstColor)
	if (state.target and state.target ~= "") then
		y = AppendHeader(string.format("Eliminate %s before you're eliminated!", state.target), 2, y)
	end
end

local function RenderStats(state)
	local y = ScrH() / 5

	if (state.target and state.target ~= "") then
		y = AppendStats(string.format("%s is your current target!", state.target), 1, y, FirstColor)
	end

	if (state.score) then
		y = AppendStats(string.format("Your score: %i", state.score), 1, y, SecondColor)
	end

	if (state.living) then
		y = AppendStats(string.format("Players remaining: %i", state.living), 1, y)
	end

	if (state.left) then
		y = AppendStats(string.format("Rounds left: %i", state.left), 1, y)
	end
end

local function RenderRadar(target)
	surface.SetTexture(indicator)

	local scrpos = target.Pos:ToScreen()
	if (not scrpos.visible) then return end
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

net.Receive("hitlist_data", function()
	if (not pluto.rounds.state) then
		return
	end

	pluto.rounds.state.radar = {
		Pos = Vector(net.ReadFloat(), net.ReadFloat(), net.ReadFloat()),
		Color = ttt.roles.Fighter.Color,
	}
end)

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
		if (state.radar) then
			RenderRadar(state.radar)
		end
	end
end)

ROUND:Hook("PlayerDeath", function(self, state, vic, inf, atk)
	if (LocalPlayer() == vic) then
		state.radar = nil
	end
end)

ROUND:Hook("PreventRDMManagerPopup", function()
	return true
end)

function ROUND:NotifyPrepare()
	FirstColor = Color(38, 0, 77)
	SecondColor = Color(34, 102, 0)

	pluto.rounds.Notify("Assassination assignment inbound.", FirstColor)
end