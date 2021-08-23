--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
-- Author: add___123

local name = "smalls"

if (SERVER) then
    hook.Add("TTTBeginRound", "pluto_mini_" .. name, function()
        if (not pluto.rounds.minis[name]) then
            return
        end

		pluto.rounds.minis[name] = nil

        timer.Simple(15, function()
            local name = pluto.rounds.chooserandom("Random", true, true)

            local success, e = pluto.rounds.prepare(name)

            if (success) then
                return
            end

            pluto.rounds.queue(name)
        end)
    end)
else

end