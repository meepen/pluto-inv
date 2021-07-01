-- Author: add___123

local name = "saber"

if (SERVER) then
    local sabers = {}

    hook.Add("TTTBeginRound", "pluto_mini_" .. name, function()
        if (not pluto.rounds.minis[name]) then
            return
        end

		pluto.rounds.minis[name] = nil

        pluto.rounds.Notify("Lightsabers have spawned around the map!", pluto.currency.byname._lightsaber.Color)

        for k, ply in ipairs(player.GetAll()) do
            if (not ply:Alive()) then
                continue
            end
            table.insert(sabers, pluto.currency.spawnfor(ply, "_lightsaber", nil, true))
        end
    end)

    hook.Add("TTTEndRound", "pluto_mini_" .. name, function()
        for k, cur in ipairs(sabers) do
            cur:Remove()
        end

        sabers = {}
    end)
else

end