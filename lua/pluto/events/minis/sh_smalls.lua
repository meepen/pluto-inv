-- Author: add___123

local name = "smalls"

if (SERVER) then
    hook.Add("TTTBeginRound", "pluto_mini_" .. name, function()
        if (not pluto.rounds.minis[name]) then
            return
        end

		pluto.rounds.minis[name] = nil

        timer.Simple(15, function()
            local name = pluto.rounds.chooserandom("Random", true, true)

            local success, e = pluto.rounds.prepare(name)

            if (success) then
                return
            end

            pluto.rounds.queue(name)
        end)
    end)
else

end