--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
local NODE = pluto.nodes.get "firerate"

NODE.Name = "Firerate Increase"
NODE.Experience = 2450

function NODE:GetDescription(node)
	return string.format("Firerate is increased by %.2f%%", 2 + node.node_val1 * 4)
end

function NODE:ModifyWeapon(node, wep)
	wep.Pluto.Delay = wep.Pluto.Delay + (2 + node.node_val1 * 4) / 100
end
