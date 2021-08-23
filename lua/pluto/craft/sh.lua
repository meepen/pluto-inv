--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
pluto.craft = pluto.craft or {}

function pluto.craft.valid(items)
	local i1, i2, i3 = items[1], items[2], items[3]

	if (not i1 or i1.Type ~= "Shard") then
		return 1
	end

	if (not i2 or i2.Type ~= "Shard") then
		return 2
	end

	if (not i3 or i3.Type ~= "Shard") then
		return 3
	end

	for i = 4, 7 do
		local item = items[i]
		if (item and item.Type ~= "Weapon") then
			return i
		end
	end

	return
end