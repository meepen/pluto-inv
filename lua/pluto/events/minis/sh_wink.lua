-- Author: add___123

local name = "wink"

if (SERVER) then
    hook.Add("TTTBeginRound", "pluto_mini_" .. name, function()
        if (not pluto.rounds.minis[name]) then
            return
        end

		pluto.rounds.minis[name] = nil

        pluto.rounds.Notify("Why blink when you can wink?", Color(200, 50, 70))

        timer.Simple(0.1, function()
            for k, ply in ipairs(player.GetAll()) do
                if (IsValid(ply) and ply:Alive()) then
                    ply:Give "weapon_ttt_wink"
                end
            end
        end)
    end)
else

end