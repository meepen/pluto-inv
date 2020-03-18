local PANEL = {}

function PANEL:SetFont(font)
	self.Font = font
end

function PANEL:SetText(...)
	self.Text = {n = select("#", ...), ...}
	self:InvalidateLayout(true)
end

function PANEL:Paint()
	if (not self.Lines) then
		return
	end

	for _, line in ipairs(self.Lines) do
		
	end
end

function PANEL:PerformLayout(w, h)
end
