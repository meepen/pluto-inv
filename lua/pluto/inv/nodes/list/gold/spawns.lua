--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
local NODE = pluto.nodes.get "gold_spawns"

NODE.Name = "Gold: Coined"
NODE.Experience = 6969

function NODE:GetDescription(node)
	return string.format("%.2f%% more currency from this gun", 10 + node.node_val1 * 10)
end

function NODE:ModifyWeapon(node, wep)
	timer.Simple(0, function()
		if (not IsValid(wep)) then
			return
		end
		if (not wep.GoldEnchant) then
			return
		end

		local old = wep.UpdateSpawnPoints
		function wep:UpdateSpawnPoints(state)
			if (old) then
				old(self, state)
			end

			state.Points = state.Points * (1 + (10 + node.node_val1 * 10) / 100)
		end
	end)
end