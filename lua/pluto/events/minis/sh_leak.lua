-- Author: add___123

if (SERVER) then
    hook.Add("TTTBeginRound", "pluto_mini_leak", function()
        if (ttt.GetCurrentRoundEvent() ~= "") then
            return
        end

        if (not pluto.rounds or not pluto.rounds.minis) then
            return
        end

        if (not pluto.rounds.minis.leak --[[ and math.random(50) ~= 1--]]) then
            return
        end

        pluto.rounds.minis.leak = nil

        pluto.rounds.Notify("INTEL LEAK: EQUIPMENT PURCHASES MAY HAVE UNINTENDED CONSEQUENCES!", Color(255, 100, 0))

        -- Add hook to reroute equipment purchases
    end)
else

end