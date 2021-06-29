-- Author: add___123

local name = "ticket"

if (SERVER) then
    local ticket
    local active

    hook.Add("TTTBeginRound", "pluto_mini_ticket", function()
        if (not pluto.rounds or not pluto.rounds.minis or not pluto.rounds.minis[name]) then
            return
        end

		pluto.rounds.minis[name] = nil

        pluto.rounds.Notify("Find the ticket to activate a random round!", pluto.currency.byname.ticket.Color)

        active = true

        for _, ply in ipairs(table.shuffle(player.GetAll())) do
            ticket = pluto.currency.spawnfor(ply, "ticket", nil, true)

            if (IsValid(ticket)) then
                break
            end
        end
    end)

    hook.Add("TTTEndRound", "pluto_mini_ticket", function()
        if (IsValid(ticket)) then
            ticket:Remove()
        end

        ticket = nil
        active = false
    end)

    hook.Add("PlutoTicketPickup", "pluto_mini_ticket", function(ply)
        if (not active) then
            return 
        end

        active = false

        local name = pluto.rounds.chooserandom("Random", true)

        pluto.rounds.Notify(string.format("%s has found the ticket and queued a random round!", ply:Nick()), pluto.currency.byname.ticket.Color)

        local success, e = pluto.rounds.prepare(name)

        if (success) then
            print "round successfully prepared"
            return
        end

        --pluto.rounds.queue(name)
    end)
else

end