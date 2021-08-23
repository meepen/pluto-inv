--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
local GROUP = pluto.nodes.groups.get("demon", 1)

GROUP.Type = "primary"

GROUP.Guaranteed = {
	"demon_poss"
}

function GROUP:CanRollOn(class)
	return class and class.Slot == 2
end

GROUP.SmallNodes = {
	demon_damage = {
		Shares = 1,
		Max = 1,
	},
	demon_heal = {
		Shares = 1,
		Max = 1
	},
	demon_speed = {
		Shares = 1,
		Max = 2
	}
}
