-- Author: add___123

if (SERVER) then
    hook.Add("TTTBeginRound", "pluto_mini_hops", function()
        if (ttt.GetCurrentRoundEvent() ~= "") then
            return
        end

        if (not pluto.rounds or not pluto.rounds.minis) then
            return
        end

        if (not pluto.rounds.minis.hops --[[ and math.random(50) ~= 1--]]) then
            return
        end

        pluto.rounds.minis.hops = nil

        pluto.rounds.Notify("It's leg day! Each time you jump, you'll get even hoppier!", ttt.roles.Bunny.Color)

        hook.Add("Move", "pluto_mini_hops", function(ply, mv)
            if (not ply:Alive() or ply:WaterLevel() >= 2) then
                return
            end

            if (bit.band(mv:GetButtons(), IN_JUMP) ~= IN_JUMP) then
                return
            end

            if (not ply:IsOnGround() or bit.band(mv:GetOldButtons(), IN_JUMP) == IN_JUMP) then
                return
            end

            ply:SetJumpPower(ply:GetJumpPower() + 3)
        end)
    end)

    hook.Add("TTTEndRound", "pluto_mini_hops", function()
        hook.Remove("Move", "pluto_mini_hops")
    end)
else

end