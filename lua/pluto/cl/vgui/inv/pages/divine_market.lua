local PANEL = {}

function PANEL:Init()
	self:AddTab "Marketplace":Add "pluto_inventory_auction":Dock(FILL)
	self:AddTab "Your Items"
	self:AddTab "Stardust Items"
	self:AddTab "Currency Exchange"
	self:AddTab "Blackmarket"
end

function PANEL:SizeTab(tab)
	tab:SetSize(self:GetWide() - 10, self:GetTall() - 24 - 10)
	tab:Center()
end

vgui.Register("pluto_inventory_divine_market", PANEL, "pluto_inventory_component_tabbed")
