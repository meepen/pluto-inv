--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
-- Author: Meepen

local name = "aprilfools"

if (SERVER) then
	hook.Add("TTTBeginRound", "pluto_mini_" .. name, function()
        if (not pluto.rounds.minis[name]) then
            return
        end

		pluto.rounds.minis[name] = nil

		--hook.Remove("TTTBeginRound", "pluto_mini_" .. name)
		for _, ply in ipairs(player.GetAll()) do
			for bone = 0, ply:GetBoneCount() - 1 do
				ply:ManipulateBoneJiggle(bone, 1)
			end
		end
	end)
else

end
