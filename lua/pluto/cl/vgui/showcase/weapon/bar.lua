local PANEL = {}

local line_color = Color(161, 161, 161)

function PANEL:Init()
	self.Bars = {}
	self:NoClipping(true)
end

function PANEL:AddFilling(pct, txt, col)
	table.insert(self.Bars, {
		Color = col or Color(59, 255, 64),
		Text = txt,
		Percent = pct
	})
end

function PANEL:DrawBar(bar, sx, w, h)
	local scrx, scry = self:LocalToScreen(sx, 0)
	local scrx2, scry2 = self:LocalToScreen(sx + w, h)
	local scrw, scrh = ScrW(), ScrH()
	render.SetScissorRect(scrx, scry, scrx2, scry2, true)
	surface.SetDrawColor(bar.Color)
	local lh = h - 4
	local ly = 3

	surface.DrawRect(sx, ly, w, lh)

	local hue, s, v = ColorToHSV(bar.Color)

	local darkest = HSVToColor(hue, math.min(1, s + 0.1), math.max(0, v - 0.3))
	local darker = HSVToColor(hue, math.min(1, s + 0.05), math.max(0, v - 0.05))

	local interval = 9
	for x = sx - interval, sx + w - 1 + interval, interval do
		surface.SetDrawColor(darker)
		surface.DrawLine(x - lh + 1, ly + lh - 1, x, ly)
		surface.DrawLine(x - lh - 1, ly + lh - 1, x - 2, ly)
		surface.SetDrawColor(darkest)
		surface.DrawLine(x - lh, ly + lh - 1, x - 1, ly)
	end

	surface.SetDrawColor(line_color)
	surface.DrawLine(sx + w - 1, 0, sx + w - 1, h - 1)
	render.SetScissorRect(0, 0, scrw, scrh, false)

	surface.SetFont "pluto_showcase_suffix_text"
	local tw, th = surface.GetTextSize(bar.Text)
	surface.SetTextPos(sx + w - 1 - tw, -th - 1)
	surface.DrawText(bar.Text)
end

function PANEL:Paint(w, h)
	local x = 1
	for _, bar in ipairs(self.Bars) do
		local bw = math.Round((w - 2) * bar.Percent)
		self:DrawBar(bar, x, bw, h)
		x = x + bw
	end
	surface.SetDrawColor(line_color)
	surface.DrawLine(0, 0, 0, h)
	surface.DrawLine(0, h - 1, w, h - 1)
	surface.DrawLine(w - 1, 0, w - 1, h - 1)
end

vgui.Register("pluto_showcase_bar", PANEL, "EditablePanel")