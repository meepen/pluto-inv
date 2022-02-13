--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
-- Author: add___123

local name = "panic"

local panic_min = 0.9
local panic_max = 1.3

if (SERVER) then
    util.AddNetworkString("pluto_mini_" .. name)

    hook.Add("TTTBeginRound", "pluto_mini_" .. name, function()
        if (not pluto.rounds.minis[name]) then
            return
        end

		pluto.rounds.minis[name] = nil

        pluto.rounds.Notify("Panic round! The more you're hurt, the faster you'll run!", ttt.roles.Traitor.Color)

        hook.Add("TTTUpdatePlayerSpeed", "pluto_mini_" .. name, function(ply, data)
            data.panic = Lerp((ply:GetMaxHealth() - ply:Health()) / ply:GetMaxHealth(), panic_min, panic_max)
        end)

        net.Start("pluto_mini_" .. name)
        net.Broadcast()

        hook.Add("TTTEndRound", "pluto_mini_" .. name, function()
            hook.Remove("TTTEndRound", "pluto_mini_" .. name)
            hook.Remove("TTTUpdatePlayerSpeed", "pluto_mini_" .. name)
        end)
    end)
else
    net.Receive("pluto_mini_" .. name, function()
        hook.Add("TTTUpdatePlayerSpeed", "pluto_mini_" .. name, function(ply, data)
            data.panic = Lerp((ply:GetMaxHealth() - ply:Health()) / ply:GetMaxHealth(), panic_min, panic_max)
        end)

        hook.Add("TTTEndRound", "pluto_mini_" .. name, function()
            hook.Remove("TTTEndRound", "pluto_mini_" .. name)
            hook.Remove("TTTUpdatePlayerSpeed", "pluto_mini_" .. name)
        end)
    end)
end