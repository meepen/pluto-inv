--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
local NODE = pluto.nodes.get "reloading"

NODE.Name = "Reloading Speed"
NODE.Experience = 1350

function NODE:GetDescription(node)
	return string.format("Reloading is %.2f%% faster", 2 + node.node_val1 * 8)
end

function NODE:ModifyWeapon(node, wep)
	wep.Pluto.ReloadAnimationSpeed = wep.Pluto.ReloadAnimationSpeed + (2 + node.node_val1 * 8) / 100
end
