--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
-- Author: add___123

local name = "hops"

if (SERVER) then
    local last_hops = {}

    hook.Add("TTTBeginRound", "pluto_mini_" .. name, function()
        if (not pluto.rounds.minis[name]) then
            return
        end

		pluto.rounds.minis[name] = nil

        pluto.rounds.Notify("It's leg day! Each hop will make you hoppier!", Color(235, 70, 150))

        last_hops = {}

        hook.Add("Move", "pluto_mini_" .. name, function(ply, mv)
            if (not ply:Alive() or ply:WaterLevel() >= 2) then
                return
            end

            if (bit.band(mv:GetButtons(), IN_JUMP) ~= IN_JUMP) then
                return
            end

            if (not ply:IsOnGround() or bit.band(mv:GetOldButtons(), IN_JUMP) == IN_JUMP) then
                return
            end

            if (CurTime() - (last_hops[ply] or 0) < 0.2) then
                return
            end

            ply:SetJumpPower(ply:GetJumpPower() + 3)
            last_hops[ply] = CurTime()
        end)

        hook.Add("TTTEndRound", "pluto_mini_" .. name, function()
            hook.Remove("TTTEndRound", "pluto_mini_" .. name)
            hook.Remove("Move", "pluto_mini_" .. name)
        end)
    end)
else

end