-- Author: add___123

local name = "panic"

local panic_min = 0.8
local panic_max = 1.6

if (SERVER) then
    util.AddNetworkString("pluto_mini_" .. name)

    hook.Add("TTTBeginRound", "pluto_mini_" .. name, function()
        if (not pluto.rounds.minis[name]) then
            return
        end

		pluto.rounds.minis[name] = nil

        pluto.rounds.Notify("PANIC is in the air! The more you're hurt, the faster you'll run!", ttt.roles.Traitor.Color)

        hook.Add("TTTUpdatePlayerSpeed", "pluto_mini_" .. name, function(ply, data)
            data.panic = Lerp((ply:GetMaxHealth() - ply:Health()) / ply:GetMaxHealth(), panic_min, panic_max)
        end)

        net.Start("pluto_mini_" .. name)
        net.Broadcast()
    end)
else
    net.Receive("pluto_mini_" .. name, function()
        hook.Add("TTTUpdatePlayerSpeed", "pluto_mini_" .. name, function(ply, data)
            data.panic = Lerp((ply:GetMaxHealth() - ply:Health()) / ply:GetMaxHealth(), panic_min, panic_max)
        end)
    end)
end

hook.Add("TTTEndRound", "pluto_mini_" .. name, function()
    hook.Remove("TTTUpdatePlayerSpeed", "pluto_mini_" .. name)
end)