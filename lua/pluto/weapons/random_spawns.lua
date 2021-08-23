--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
hook.Add("TTTWeaponInitialize", "pluto_modify", function(e)
	timer.Simple(0, function()
		if (not IsValid(e) or e.IsPlutoModified or IsValid(e:GetOwner())) then
			return
		end
	end)
end)