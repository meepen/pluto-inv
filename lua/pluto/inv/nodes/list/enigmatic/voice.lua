--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
local NODE = pluto.nodes.get "enigmatic_voice"

NODE.Name = "Enigmatic Voice"
NODE.Description = "This gun has been possessed by a soul of pure toxicity."
NODE.Experience = 4800

function NODE:ModifyWeapon(node, wep)
	wep.EnigmaticVoice = true
end
