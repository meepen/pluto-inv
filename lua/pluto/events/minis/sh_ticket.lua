-- Author: add___123

local name = "ticket"

if (SERVER) then
    local ticket
    local active

    hook.Add("TTTBeginRound", "pluto_mini_" .. name, function()
        if (not pluto.rounds.minis[name]) then
            return
        end

		pluto.rounds.minis[name] = nil

        pluto.rounds.Notify("Find the ticket to activate a random round!", pluto.currency.byname.ticket.Color)

        for _, ply in ipairs(table.shuffle(player.GetAll())) do
            ticket = pluto.currency.spawnfor(ply, "ticket", nil, true)

            if (IsValid(ticket)) then
                break
            end
        end

        hook.Add("PlutoTicketPickup", "pluto_mini_" .. name, function(ply)
            hook.Remove("PlutoTicketPickup", "pluto_mini_" .. name)

            local name = pluto.rounds.chooserandom("Random", true)

            pluto.rounds.Notify(string.format("%s has found the ticket and queued %s!", ply:Nick(), pluto.rounds.infobyname[name].PrintName), pluto.currency.byname.ticket.Color)

            local success, e = pluto.rounds.prepare(name)

            if (success) then
                hook.Run("PlutoSpecialStarted", ply, name)
                return
            end

            pluto.rounds.queue(name)
            hook.Run("PlutoSpecialStarted", ply, name)
        end)

    hook.Add("TTTEndRound", "pluto_mini_" .. name, function()
        hook.Remove("TTTEndRound", "pluto_mini_" .. name)
        hook.Remove("PlutoTicketPickup", "pluto_mini_" .. name)
        
        if (IsValid(ticket)) then
            ticket:Remove()
        end

        ticket = nil
        active = false
    end)
    end)
else

end