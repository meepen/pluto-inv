--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
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
