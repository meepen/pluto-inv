--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
local PANEL = {}

function PANEL:Init()
	self:AddTab "Shards":Add "pluto_inventory_crafting_shards":Dock(FILL)
	self:AddTab "Currency":Add "pluto_inventory_crafting_currency":Dock(FILL)
end

vgui.Register("pluto_inventory_crafting", PANEL, "pluto_inventory_component_tabbed")