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

            if (CurTime() - (last_hops[ply] or 0) < 0.25) then
                return
            end

            ply:SetJumpPower(ply:GetJumpPower() + 3)
            last_hops[ply] = CurTime()
        end)
    end)

    hook.Add("TTTEndRound", "pluto_mini_" .. name, function()
        hook.Remove("Move", "pluto_mini_" .. name)
    end)
else

end