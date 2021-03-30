local PANEL = {}

function PANEL:Init()
	self:AddTab "Marketplace":Add "pluto_inventory_auction":Dock(FILL)
	self:AddTab "Your Items":Add "pluto_inventory_auction_reclaim":Dock(FILL)
	self:AddTab "Stardust Exchange"
	self:AddTab "Pandemic Specials":Add "pluto_inventory_blackmarket":Dock(FILL)
end

function PANEL:SizeTab(tab)
	tab:SetSize(self:GetWide() - 10, self:GetTall() - 24 - 10)
	tab:Center()
end

vgui.Register("pluto_inventory_divine_market", PANEL, "pluto_inventory_component_tabbed")
