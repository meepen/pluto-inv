local PANEL = {}

function PANEL:Init()
	self:AddTab "Hourly"
	self:AddTab "Daily"
	self:AddTab "Weekly"
	self:AddTab "Unique"
end

vgui.Register("pluto_inventory_quests", PANEL, "pluto_inventory_component_tabbed")