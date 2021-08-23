--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
local NODE = pluto.nodes.get "pierce_pierce"

NODE.Name = "Wall Piercer"
NODE.Experience = 7300
NODE.Description = "Your bullets pierce walls with 40 power."

function NODE:ModifyWeapon(node, wep)
	wep.Primary.PenetrationValue = (wep.Primary.PenetrationValue or 0) + 40
end