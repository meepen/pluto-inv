--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
-- Author: add___123

local name = "jugg"

local jugg_mult = 1.5

if (SERVER) then
    hook.Add("TTTBeginRound", "pluto_mini_jugg", function()
        if (not pluto.rounds or not pluto.rounds.minis or not pluto.rounds.minis[name]) then
            return
        end

		pluto.rounds.minis[name] = nil

        pluto.rounds.Notify(string.format("Juggernaut Round! Your health has been multiplied by %i.", jugg_mult), Color(50, 220, 70))

        timer.Simple(0.1, function()
            for k, ply in ipairs(player.GetAll()) do
                if (IsValid(ply) and ply:Alive()) then
                    ply:SetMaxHealth(ply:GetMaxHealth() * jugg_mult)
                    ply:SetHealth(ply:Health() * jugg_mult)
                    ply:SetArmor(ply:Armor() * jugg_mult)
                end
            end
        end)
    end)
else

end