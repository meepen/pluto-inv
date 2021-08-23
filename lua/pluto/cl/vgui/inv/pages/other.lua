--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
local PANEL = {}

function PANEL:Init()
	self:AddTab "Snake":Add "pluto_inventory_other_snake":Dock(FILL)
end

function PANEL:SizeTab(tab)
	tab:SetSize(self:GetWide() - 10, self:GetTall() - 24 - 10)
	tab:Center()
end

vgui.Register("pluto_inventory_other", PANEL, "pluto_inventory_component_tabbed")
