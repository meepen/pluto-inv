-- Author: add___123

if (SERVER) then
    local leak_color = Color(225, 50, 25)

    local try_give = function(ply, class) -- Tries to give a player some sort of equipment
        local eq = ttt.Equipment.List[class]

        if (not eq) then
            return false
        end

        if (eq.Limit and ply.TTTRWEquipmentTracker and ply.TTTRWEquipmentTracker[class] and ply.TTTRWEquipmentTracker[class] >= eq.Limit) then
            return false -- Logs the fake purchase so that the player can't get duplicate items
        end

        if (eq:OnBuy(ply)) then -- Gives the item to the player
            ply.TTTRWEquipmentTracker = ply.TTTRWEquipmentTracker or {}
            ply.TTTRWEquipmentTracker[class] = (ply.TTTRWEquipmentTracker[class] or 0) + 1
            return true
        end
    end

    local actions = {
        {
            func = function(ply, class, cost) -- Gives a random innocent a copy of that item
                local plylist = table.shuffle(round.GetActivePlayers())
                for k, _ply in ipairs(plylist) do
                    _ply = _ply.Player
                    if (not IsValid(_ply) or not _ply:Alive() or ply == _ply or _ply:GetRoleTeam() ~= "innocent") then
                        continue -- Skips non-innocents
                    end

                    if (try_give(_ply, class)) then
                        pluto.rounds.Notify("You were given a copy of a traitor's recent purchase: " .. class .. "!", leak_color, _ply)
                        return -- Only gives to one player
                    end
                end
            end,
            Shares = 5,
        },
        {
            func = function(ply, class, cost) -- Refunds the purchaser their credit(s)
                ply:SetCredits(ply:GetCredits() + cost)
                pluto.rounds.Notify("You were refunded the cost of your purchase!", leak_color, ply)
            end,
            Shares = 3,
        },
        {
            func = function(ply, class, cost) -- Notifies the server that the item was purchased
                pluto.rounds.Notify("INTEL LEAK: " .. string.upper(ttt.Equipment.List[class].Name) .. " WAS BOUGHT!", leak_color, nil)
            end,
            Shares = 5,
        },
        {
            func = function(ply, class, cost) -- Gives all innocents a copy of that item
                for k, _ply in ipairs(round.GetActivePlayers()) do
                    _ply = _ply.Player
                    if (not IsValid(_ply) or not _ply:Alive() or ply == _ply or _ply:GetRoleTeam() ~= "innocent") then
                        continue -- Skips non-innocents
                    end

                    try_give(_ply, class)
                end
                pluto.rounds.Notify("INTEL LEAK: ALL INNOCENTS RECEIVE " .. string.upper(ttt.Equipment.List[class].Name) .. "!", leak_color)
            end,
            Shares = 1,
        },
        {
            func = function(ply, class, cost) -- Picks three random non-detective players and lists them as suspects
                local plylist = table.shuffle(round.GetActivePlayers())
                local leaks = {string.upper(ply:Nick())}
                for k, _ply in ipairs(plylist) do
                    _ply = _ply.Player
                    if (not IsValid(_ply) or not _ply:Alive() or ply == _ply or _ply:GetRole() == "Detective") then
                        continue -- Skips detectives
                    end

                    table.insert(leaks, string.upper(_ply:Nick()))

                    if (#leaks >= 3) then
                        break
                    end
                end

                if (#leaks ~= 3) then
                    return
                end

                leaks = table.shuffle(leaks)

                pluto.rounds.Notify("INTEL LEAK: EQUIPMENT BOUGHT BY " .. leaks[1] .. ", " .. leaks[2] .. ", OR " .. leaks[3] .. "!", leak_color)
            end,
            Shares = 3,
        },
    }

    hook.Add("TTTBeginRound", "pluto_mini_leak", function()
        if (ttt.GetCurrentRoundEvent() ~= "") then
            return
        end

        if (not pluto.rounds or not pluto.rounds.minis) then
            return
        end

        if (not pluto.rounds.minis.leak --[[ and math.random(50) ~= 1--]]) then
            return
        end

        pluto.rounds.minis.leak = nil

        pluto.rounds.Notify("INTEL LEAK: TRAITOR PURCHASES MAY HAVE UNINTENDED CONSEQUENCES!", leak_color)

        hook.Add("TTTOrderedEquipment", "pluto_mini_leak", function(ply, class, is_item, cost)
            if (not IsValid(ply) or ply:GetRoleTeam() ~= "traitor" or not class or not cost) then
                return
            end

            if (math.random() < 0.5) then -- Chance of activating an intel leak
                return
            end

            local action = actions[pluto.inv.roll(actions)] -- Getting one of the random intel leak actions

            if (not action or not action.func) then
                return
            end

            action.func(ply, class, cost) -- Doing the intel leak
        end)
    end)

    hook.Add("TTTEndRound", "pluto_mini_leak", function()
        hook.Remove("TTTOrderedEquipment", "pluto_mini_leak")
    end)
else

end