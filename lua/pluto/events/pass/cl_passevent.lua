
surface.CreateFont("godly_font", {
	font = "Niconne",
	size = 26,
	antialias = true,
	weight = 500
})

local PANEL = {}
function PANEL:Init()
	self.Label = self:Add "DLabel"
	self.Label:Dock(FILL)
	self.Label:SetFont "godly_font"
	self.Label:SetText "INVALID TAB"
	self.Label:SetContentAlignment(5)
end

function PANEL:SetTab(tab)
	self.Label:SetText("I beg of you... save everyone...")
end

vgui.Register("pluto_pass", PANEL, "pluto_inventory_base")
