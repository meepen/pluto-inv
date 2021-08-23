--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
local GROUP = pluto.nodes.groups.get("enigmatic", 1)

GROUP.Type = "primary"

GROUP.Guaranteed = {
	"enigmatic_voice"
}

function GROUP:CanRollOn(class)
	return false
end

GROUP.SmallNodes = {
	enigmatic_ground = {
		Shares = 1,
		Max = 1,
	},
	enigmatic_siren = {
		Shares = 1,
		Max = 1
	},
	enigmatic_warn = {
		Shares = 1,
		Max = 1
	}
}
