--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
-- Author: add___123

local name = "dice"

if (SERVER) then
    local chancedice = {}

    hook.Add("TTTBeginRound", "pluto_mini_" .. name, function()
        if (not pluto.rounds.minis[name]) then
            return
        end

		pluto.rounds.minis[name] = nil

        pluto.rounds.Notify("Chance Dice have spawned around the map!", pluto.currency.byname._chancedice.Color)
        
        local count = #player.GetHumans()

        for _, ply in pairs(player.GetHumans()) do
            if (not ply:Alive()) then
                continue
            end
            for i = 1, math.max(8 - count / 6, 4) do
                table.insert(chancedice, pluto.currency.spawnfor(ply, "_chancedice", nil, true))
            end
        end

        hook.Add("TTTEndRound", "pluto_mini_" .. name, function()
            hook.Remove("TTTEndRound", "pluto_mini_" .. name)
            for k, cur in ipairs(chancedice) do
                cur:Remove()
            end

            chancedice = {}
        end)
    end)
else

end