--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
local PANEL = {}

function PANEL:SetTab()
	self.Tab = {
		Items = {},
		ID = 0,
		Type = "craft",
		Active = true,
	}
	self.Item:SetItem(nil, self.Tab)
	self.Item.TabIndex = 1
end

function PANEL:Init()
	self.ItemContainer = self:Add "EditablePanel"
	self.ItemContainer:Dock(TOP)
	self.ItemContainer:SetTall(100)
	function self.ItemContainer:PerformLayout()
		self:GetParent().Item:Center()
	end

	self.Item = self.ItemContainer:Add "pluto_inventory_item"
	self.Item:SetSize(64, 64)

	function self.Item:SwitchWith(other)
		if (other.Tab.ID == 0) then
			return
		end


		if (other.Item) then
			self:SetItem(other.Item)
		end

		pluto.ui.unsetghost()
	end

	function self.Item:RightClick()
		self:SetItem()
	end
end

vgui.Register("pluto_divine_crafting", PANEL, "EditablePanel")