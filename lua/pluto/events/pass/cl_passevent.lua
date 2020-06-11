
surface.CreateFont("godly_font", {
	font = "Niconne",
	size = 26,
	antialias = true,
	weight = 500
})
surface.CreateFont("ungodly_font", {
	font = "Aladin",
	size = 48,
	antialias = true,
	weight = 500
})

local PANEL = {}
function PANEL:Init()
	self.Label = self:Add "DLabel"
	self.Label:Dock(FILL)
	self.Label:SetFont "godly_font"
	self.Label:SetText "I beg of you... save everyone..."
	self.Label:SetContentAlignment(5)
end

function PANEL:SetTab(tab)
end

vgui.Register("pluto_pass", PANEL, "pluto_inventory_base")

local has_pass_started = CreateConVar("pluto_passevent_draw", 0, {FCVAR_ARCHIVE})

if (has_pass_started:GetBool()) then
	return
end

-- has_pass_started:SetBool(true)


hook.Add("HUDPaint", "pluto_passevent", function()
	hook.Remove("HUDPaint", "pluto_passevent")

	local start = SysTime()
	local ends = SysTime() + 5

	local texts = {
		"this world... will be absorbed",
		"do not test me",
		"i have plans for you..."
	}

	local text = table.Random(texts)

	hook.Add("DrawOverlay", "pluto_passevent", function()
		if (ends < SysTime()) then
			hook.Remove("DrawOverlay", "pluto_passevent")
			return
		end

		local frac = (SysTime() - start) / (ends - start)
		surface.SetDrawColor(0, 0, 0, 240 - frac * 220)
		surface.DrawRect(0, 0, ScrW(), ScrH())

		draw.SimpleText(text, "ungodly_font", ScrW() / 2, ScrH() / 2, ColorAlpha(white_text, 240 - frac * 240), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end)
end)
