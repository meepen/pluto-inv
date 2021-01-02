
local PANEL = {}
AccessorFunc(PANEL, "Font", "Font")
AccessorFunc(PANEL, "TextColor", "TextColor")
AccessorFunc(PANEL, "Text", "Text")
AccessorFunc(PANEL, "surface", "RenderSystem")

function PANEL:Init()
	self:SetCursor "beam"
	self:SetMouseInputEnabled(false)
	self:SetFade(0, -1, true)
	self.Alignment = 2
end

function PANEL:GetRenderSystem()
	return self.surface or pluto.fonts.systems.default
end

function PANEL:SetClickable(clickable)
	self.Clickable = clickable

	if (clickable) then
		self:SetMouseInputEnabled(true)
		if (clickable.Cursor) then
			self:SetCursor(clickable.Cursor)
		end
	end
end

function PANEL:DoClick()
	local click = self.Clickable
	if (click and click.Run) then
		click.Run()
	end
end

function PANEL:SizeToContentsX()
	local surface = self:GetRenderSystem()
	surface.SetFont(self:GetFont())
	self:SetWide((surface.GetTextSize(self:GetText())))
end

function PANEL:SizeToContents()
	local surface = self:GetRenderSystem()
	surface.SetFont(self:GetFont())
	self:SetSize(surface.GetTextSize(self:GetText()))
end

function PANEL:SizeToContentsY()
	local surface = self:GetRenderSystem()
	surface.SetFont(self:GetFont())
	self:SetTall(select(2, surface.GetTextSize(self:GetText())))
end

function PANEL:SetContentAlignment(alignment)
	self.Alignment = alignment
end

function PANEL:Paint(w, h)
	local col = self:GetTextColor()

	if (self:GetFadeLength() ~= -1 and self:GetFadeSustain() ~= -1 and self.Creation + self:GetFadeSustain() < CurTime()) then
		col = ColorAlpha(col, col.a * (1 - math.min(1, (CurTime() - self.Creation - self:GetFadeSustain()) / self:GetFadeLength())))
	end

	local surface = self:GetRenderSystem()
	surface.SetFont(self:GetFont())
	surface.SetTextColor(col)
	local txt = self:GetText()
	local tw, th = surface.GetTextSize(txt)


	if (self.Alignment == 2) then
		surface.SetTextPos(w / 2 - tw / 2, h - th)
	else -- if (self.Alignment == 5) then
		surface.SetTextPos(w / 2 - tw / 2, h / 2 - th / 2 + 1)
	end
	surface.DrawText(txt)

	if (self.Clickable) then
		surface.SetDrawColor(col)
		surface.DrawLine(w / 2 - tw / 2, h - 1, w / 2 + tw / 2, h - 1)
	end
end

function PANEL:OnMousePressed(m)
	if (m == MOUSE_LEFT) then
		self:DoClick()
	end
end

function PANEL:SetFade(sustain, length, reset)
	self.Fade = {
		Sustain = sustain,
		Length = length
	}
	if (reset) then
		self:ResetFade()
	end
end

function PANEL:GetFadeLength()
	return self.Fade and self.Fade.Length or -1
end

function PANEL:GetFadeSustain()
	return self.Fade and self.Fade.Sustain or -1
end

function PANEL:ResetFade()
	self.Creation = CurTime()
end

vgui.Register("pluto_label", PANEL, "EditablePanel")