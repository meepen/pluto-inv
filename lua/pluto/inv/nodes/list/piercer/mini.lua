--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
local NODE = pluto.nodes.get "pierce_mini"

NODE.Name = "Mini Wall Piercer"
NODE.Experience = 4300
NODE.Description = "Your bullets pierce walls with 15 more power."

function NODE:ModifyWeapon(node, wep)
	wep.Primary.PenetrationValue = (wep.Primary.PenetrationValue or 0) + 15
end