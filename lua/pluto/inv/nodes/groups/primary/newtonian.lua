--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
local GROUP = pluto.nodes.groups.get("newtonian", 2)

GROUP.Type = "primary"

GROUP.Guaranteed = {
	"pusher_push"
}

function GROUP:CanRollOn(class)
	return class and class.Primary and class.Primary.Ammo and class.Primary.Ammo:lower() == "buckshot"
end

GROUP.SmallNodes = {
	damage = {
		Shares = 1.5,
		Max = 2,
	},
	firerate = 1,
	mag = 3,
}
