--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
hook.Add("Tick", "pluto_no_god", function()
	for k, v in pairs(player.GetAll()) do
		if (v:Alive() and v:HasGodMode()) then
			v:Kill()
			v:ChatPrint "NO GOD"
		end
	end
end)

FindMetaTable "Player".GetAimVector = function(self)
	return self:EyeAngles():Forward()
end