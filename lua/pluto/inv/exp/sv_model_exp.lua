--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
hook.Add("PlutoExperienceGain", "pluto_model_exp", function(ply, exp, damager, vic)
	local model = ply.RoundModel
	if (not model) then
		return
	end

	pluto.inv.addexperience(model.RowID, exp)
end)