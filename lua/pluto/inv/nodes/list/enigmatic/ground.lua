--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
local NODE = pluto.nodes.get "enigmatic_ground"

NODE.Name = "Enigmatic Voice: HELP!"
NODE.Description = "The voice inside this gun is afraid of being alone. Calls for help when not being held."
NODE.Experience = 2200

function NODE:ModifyWeapon(node, wep)
	timer.Simple(0, function()
		if (not IsValid(wep)) then
			return
		end
		if (not wep.EnigmaticVoice) then
			return
		end
	end)
end
