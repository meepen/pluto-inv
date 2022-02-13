--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
-- Author: add___123

local name = "overflow"

if (SERVER) then
    hook.Add("TTTBeginRound", "pluto_mini_" .. name, function()
        if (not pluto.rounds.minis[name]) then
            return
        end

		pluto.rounds.minis[name] = nil

        local weps = {}

        for classname, ent in pairs(ttt.Equipment.List) do
            if (ent.IsWeapon and ent.CanBuy and ent.CanBuy.traitor) then
                table.insert(weps, classname)
            end
        end

        pluto.rounds.Notify("Equipment Overflow! Everyone receives a random traitor weapon.", Color(0, 102, 92))

        timer.Simple(0.1, function()
            for k, ply in ipairs(player.GetAll()) do
                if (not IsValid(ply) or not ply:Alive()) then
                    continue
                end

                ply:Give(weps[math.random(#weps)])
            end
        end)
    end)
else

end