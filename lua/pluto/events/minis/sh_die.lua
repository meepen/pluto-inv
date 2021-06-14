-- Author: add___123

if (SERVER) then
    util.AddNetworkString "pluto_mini_die"

    local time = 0

    hook.Add("TTTBeginRound", "pluto_mini_die", function()
        if (ttt.GetCurrentRoundEvent() ~= "") then
            return
        end

        if (not pluto.rounds or not pluto.rounds.minis) then
            return
        end

        if (not pluto.rounds.minis.die --[[and math.random(50) ~= 1]]) then
            return
        end
        
        pluto.rounds.minis.die = nil

        for k, ply in ipairs(player.GetAll()) do
            net.Start "pluto_mini_die"
            net.Send(ply)    
        end

        time = CurTime() + 20
    end)

    net.Receive("pluto_mini_die", function(len, ply)
        if (not IsValid(ply) or not ply:Alive() or time < CurTime()) then
            return 
        end

        if (math.random() < 0.90) then
            ply:Kill()
            pluto.rounds.Notify(ply:Nick() .. " has died!", nil, nil, true)
        else
            pluto.db.instance(function(db)
                pluto.inv.addcurrency(db, ply, tp, 50)
                pluto.rounds.Notify(ply:Nick() .. " has received 50 vials of refinium!", pluto.currency.byname[tp].Color)
            end)
        end
    end)
else
    net.Receive("pluto_mini_die", function()
        local diebutton = vgui.Create "pluto_mini_button"
        diebutton:ChangeText "Click to get death or refinium."
        diebutton:ChangeMini "die"
        diebutton.FillColor = Color(255, 255, 255)

        timer.Simple(19, function()
            if (IsValid(diebutton)) then
                diebutton:Remove()
            end
        end)
    end)
end