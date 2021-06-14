-- Author: add___123

local jugg_mult = 3

if (SERVER) then
    hook.Add("TTTBeginRound", "pluto_mini_jugg", function()
        if (ttt.GetCurrentRoundEvent() ~= "") then
            return
        end

        if (not pluto.rounds or not pluto.rounds.minis) then
            return
        end

        if (not pluto.rounds.minis.jugg --[[ and math.random(50) ~= 1--]]) then
            return
        end

        pluto.rounds.minis.jugg = nil

        pluto.rounds.Notify("Operation JUGG was a success! You have all grown " .. tostring(jugg_mult) .. " times sturdier.", Color(50, 220, 70))

        timer.Simple(0.1, function()
            for k, ply in ipairs(player.GetAll()) do
                if (IsValid(ply) and ply:Alive()) then
                    ply:SetMaxHealth(ply:GetMaxHealth() * jugg_mult)
                    ply:SetHealth(ply:Health() * jugg_mult)
                    ply:SetArmor(ply:Armor() * jugg_mult)
                end
            end
        end)
    end)
else

end