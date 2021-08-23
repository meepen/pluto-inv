--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
local GROUP = pluto.nodes.groups.get("normal", 0)

GROUP.Guaranteed = {}

GROUP.SmallNodes = {
	damage = {
		Shares = 1,
		Max = 1,
	},
	distance = 2,
	firerate = {
		Shares = 1,
		Max = 1
	},
	mag = 1,
	recoil = 1,
	reloading = 1
}
