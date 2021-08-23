--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
local Effects = {
	-- noise maker
	function(ply)
		
	end
}

function pluto.inv.readnitro()
	local ply = net.ReadEntity()
	local reward_num = net.ReadUInt(16)


	local effect = Effects[reward_num]

	if (effect) then
		effect(ply)
	else
		pwarnf("No nitro effect for %i", reward_num)
	end
end