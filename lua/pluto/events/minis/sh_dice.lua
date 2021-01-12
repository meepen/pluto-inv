-- Author: add___123

if (SERVER) then
    local chancedice = {}

    hook.Add("TTTBeginRound", "pluto_mini_dice", function()
        if (ttt.GetCurrentRoundEvent() ~= "") then
            return
        end

        if (not pluto.rounds or not pluto.rounds.minis) then
            return
        end

        if (not pluto.rounds.minis.dice and math.random(30) ~= 1) then
            return
        end

        pluto.rounds.minis.dice = nil

        ttt.chat(pluto.currency.byname.dice.Color, "Chance Dice", white_text, " have spawned around the map!")

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

    hook.Add("TTTEndRound", "pluto_mini_dice", function()
        for k, cur in ipairs(chancedice) do
            cur:Remove()
        end

        chancedice = {}
    end)
else

end