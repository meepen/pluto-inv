-- Author: add___123

local panic_min = 0.8
local panic_max = 1.6

if (SERVER) then
    util.AddNetworkString "pluto_mini_panic"

    hook.Add("TTTBeginRound", "pluto_mini_panic", function()
        if (ttt.GetCurrentRoundEvent() ~= "") then
            return
        end

        if (not pluto.rounds or not pluto.rounds.minis) then
            return
        end

        if (not pluto.rounds.minis.panic --[[ and math.random(50) ~= 1--]]) then
            return
        end

        pluto.rounds.minis.panic = nil

        pluto.rounds.Notify("PANIC is in the air! The more you're hurt, the faster you'll run!", ttt.roles.Traitor.Color)

        hook.Add("TTTUpdatePlayerSpeed", "pluto_mini_panic", function(ply, data)
            data.panic = Lerp((ply:GetMaxHealth() - ply:Health()) / ply:GetMaxHealth(), panic_min, panic_max)
        end)

        net.Start "pluto_mini_panic"
        net.Broadcast()
    end)
else
    net.Receive("pluto_mini_panic", function()
        hook.Add("TTTUpdatePlayerSpeed", "pluto_mini_panic", function(ply, data)
            data.panic = Lerp((ply:GetMaxHealth() - ply:Health()) / ply:GetMaxHealth(), panic_min, panic_max)
        end)
    end)
end

hook.Add("TTTEndRound", "pluto_mini_panic", function()
    hook.Remove("TTTUpdatePlayerSpeed", "pluto_mini_panic")
end)