local PANEL = {}

function PANEL:Init()
	self:AddTab "Snake":Add "pluto_inventory_other_snake":Dock(FILL)
end

function PANEL:SizeTab(tab)
	tab:SetSize(self:GetWide() - 10, self:GetTall() - 24 - 10)
	tab:Center()
end

vgui.Register("pluto_inventory_other", PANEL, "pluto_inventory_component_tabbed")
