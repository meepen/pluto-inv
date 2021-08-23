--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
local NODE = pluto.nodes.get "pusher_push"

NODE.Name = "Newtonian Strength"
NODE.Experience = 5600
NODE.Description = "This gun pushes props 6 times harder while dealing 40% less damage."

function NODE:ModifyWeapon(node, wep)
	wep.Pluto.Damage = wep.Pluto.Damage - 0.4

	wep.PropForce = (wep.PropForce or 1) * 6
end
