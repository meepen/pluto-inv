--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
local PANEL = {}

function PANEL:Init()
	self.Snake = self:Add "pluto_minigame_snake"
	self.Snake:Dock(FILL)
end

vgui.Register("pluto_inventory_other_snake", PANEL, "EditablePanel")
