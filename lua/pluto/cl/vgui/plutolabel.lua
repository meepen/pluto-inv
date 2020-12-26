
local PANEL = {}
AccessorFunc(PANEL, "Font", "Font")
AccessorFunc(PANEL, "TextColor", "TextColor")
AccessorFunc(PANEL, "Text", "Text")
AccessorFunc(PANEL, "surface", "RenderSystem")

function PANEL:Init()
	self:SetCursor "beam"
	self:SetMouseInputEnabled(false)
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

function PANEL:Paint(w, h)
	local surface = self:GetRenderSystem()
	surface.SetFont(self:GetFont())
	surface.SetTextColor(self:GetTextColor())
	local txt = self:GetText()
	local tw, th = surface.GetTextSize(txt)


	surface.SetTextPos(w / 2 - tw / 2, h - th)
	surface.DrawText(txt)

	if (self.Clickable) then
		surface.SetDrawColor(self:GetTextColor())
		surface.DrawLine(w / 2 - tw / 2, h - 1, w / 2 + tw / 2, h - 1)
	end
end

function PANEL:OnMousePressed(m)
	if (m == MOUSE_LEFT) then
		self:DoClick()
	end
end

vgui.Register("pluto_label", PANEL, "EditablePanel")