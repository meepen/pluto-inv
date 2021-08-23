--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
local NODE = pluto.nodes.get "distance"

NODE.Name = "Distance Increase"
NODE.Experience = 1900

function NODE:GetDescription(node)
	return string.format("Falloff distance is increased by %.2f%%", 5 + node.node_val1 * 5)
end

function NODE:ModifyWeapon(node, wep)
	wep.Pluto.DamageDropoffRangeMax = wep.Pluto.DamageDropoffRangeMax + (5 + node.node_val1 * 5) / 100
end
