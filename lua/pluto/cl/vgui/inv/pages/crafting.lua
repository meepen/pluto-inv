local PANEL = {}

function PANEL:Init()
	self:AddTab "Shards":Add "pluto_inventory_crafting_shards":Dock(FILL)
	self:AddTab "Currency":Add "pluto_inventory_crafting_currency":Dock(FILL)
end

vgui.Register("pluto_inventory_crafting", PANEL, "pluto_inventory_component_tabbed")