--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
local PANEL = {}

function PANEL:Init()
	self.Rotation = 0
end

function PANEL:Paint(w, h)
	local x, y = 0, 0
	local size = math.min(w, h)
	if (w > h) then
		y = h / 2 - size / 2
	elseif (w < h) then
		x = w / 2 - size / 2
	end

	self.Rotation = (self.Rotation - FrameTime() * 30) % 360
	
	draw.NoTexture()
	local polys = pluto.loading_polys(x, y, size, self.Rotation)
	for i, poly in ipairs(polys) do
		local col = ColorLerp((i - 1) / (#polys), Color(255, 0, 0), Color(0, 255, 0), Color(0, 0, 255), Color(255, 0, 0))
		surface.SetDrawColor(col)
		poly()
	end
end

vgui.Register("pluto_inventory_loading", PANEL, "EditablePanel")