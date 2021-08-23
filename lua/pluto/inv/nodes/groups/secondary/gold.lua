--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
local GROUP = pluto.nodes.groups.get("gold_enchant", 1)

GROUP.Type = "secondary"

GROUP.Guaranteed = {
	"gold_enchant"
}

GROUP.SmallNodes = {
	gold_transform = {
		Shares = 1,
		Max = 1,
	},
	gold_spawns = {
		Shares = 1,
		Max = 1,
	}
}
