-- Author: add___123

local name = "dice"

if (SERVER) then
    local chancedice = {}

    hook.Add("TTTBeginRound", "pluto_mini_" .. name, function()
        if (not pluto.rounds.minis[name]) then
            return
        end

		pluto.rounds.minis[name] = nil

        pluto.rounds.Notify("Chance Dice have spawned around the map!", pluto.currency.byname._chancedice.Color)
        
        local count = #player.GetHumans()

        for _, ply in pairs(player.GetHumans()) do
            if (not ply:Alive()) then
                continue
            end
            for i = 1, math.max(10 - count / 6, 5) do
                table.insert(chancedice, pluto.currency.spawnfor(ply, "_chancedice", nil, true))
            end
        end
    end)

    hook.Add("TTTEndRound", "pluto_mini_" .. name, function()
        for k, cur in ipairs(chancedice) do
            cur:Remove()
        end

        chancedice = {}
    end)
else

end