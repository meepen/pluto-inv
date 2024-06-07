--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
-- Author: add___123

local name = "wave"

local wave_min = 0.7
local wave_max = 1.4
local period = 1.75

local start_time = 0

local function get_speed()
    return Lerp((math.sin((CurTime() - start_time) / period) + 1) / 2, wave_min, wave_max)
end

if (SERVER) then
    util.AddNetworkString("pluto_mini_" .. name)

    hook.Add("TTTBeginRound", "pluto_mini_" .. name, function()
        if (not pluto.rounds.minis[name]) then
            return
        end

		pluto.rounds.minis[name] = nil

        pluto.rounds.Notify("Fast or slow? Make up your mind!", Color(213, 128, 230))

        start_time = CurTime()

        hook.Add("TTTUpdatePlayerSpeed", "pluto_mini_" .. name, function(ply, data)
            data[name] = get_speed()
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
        start_time = CurTime()

        hook.Add("TTTUpdatePlayerSpeed", "pluto_mini_" .. name, function(ply, data)
            data[name] = get_speed()
        end)

        hook.Add("TTTEndRound", "pluto_mini_" .. name, function()
            hook.Remove("TTTEndRound", "pluto_mini_" .. name)
            hook.Remove("TTTUpdatePlayerSpeed", "pluto_mini_" .. name)
        end)
    end)
end