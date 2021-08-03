local PANEL = {}

function PANEL:Init()
	self:AddTab "Marketplace":Add "pluto_inventory_auction":Dock(FILL)
	self:AddTab "Your Listings":Add "pluto_inventory_auction_reclaim":Dock(FILL)
	self:AddTab "Stardust Exchange":Add "pluto_inventory_blackmarket":Dock(FILL)
	--self:AddTab "Currency Market":Add "EditablePanel":Dock(FILL) -- TODO(meep) (added by Addi) Temporarily removed because I deployed on accident
end

function PANEL:SizeTab(tab)
	tab:SetSize(self:GetWide() - 10, self:GetTall() - 24 - 10)
	tab:Center()
end

vgui.Register("pluto_inventory_divine_market", PANEL, "pluto_inventory_component_tabbed")
