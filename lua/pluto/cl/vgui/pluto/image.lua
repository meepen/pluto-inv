local PANEL = {}
AccessorFunc(PANEL, "TextColor", "TextColor")
function PANEL:Init()
	self.Image = self:Add "DImage"
	self:SetCursor "beam"
end

function PANEL:SetMaterial(mat)
	self.Image:SetMaterial(mat)
end

function PANEL:SetImageSize(w, h)
	self:SetWide(w)
	self.Image:SetWide(w)
	self.Image:SetTall(h)
end

function PANEL:PerformLayout()
	self.Image:Center()
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

function PANEL:OnMousePressed(m)
	if (m == MOUSE_LEFT) then
		self:DoClick()
	end
end

function PANEL:DoClick()
	local click = self.Clickable
	if (click and click.Run) then
		click.Run()
	end
end

function PANEL:Paint(w, h)
	if (self.Clickable) then
		surface.SetDrawColor(self:GetTextColor())
		surface.DrawLine(0, h - 1, w - 1, h - 1)
	end
end

function PANEL:GetText()
	return ""
end

vgui.Register("pluto_image", PANEL, "EditablePanel")