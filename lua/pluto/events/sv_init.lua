util.AddNetworkString "round_data"
util.AddNetworkString "mini_speed"

--- Rounds ---

pluto.rounds = pluto.rounds or {}

pluto.rounds.WriteData = function(name, arg, ply)
    net.Start "round_data"
        local typ = type(arg)
        net.WriteString(name)
        net.WriteString(typ)
        if (typ == "string") then
            var = net.WriteString(arg)
        elseif (typ == "number") then
            var = net.WriteUInt(arg, 32)
        elseif (typ == "bool") then
            var = net.WriteBool(arg)
        end
    if (IsValid(ply)) then
        net.Send(ply)
    else
        net.Broadcast()
    end
end

concommand.Add("pluto_prepare_round", function(ply, cmd, args)
    if (not pluto.cancheat(ply) or not args[1]) then
        return
    end

    local success, msg = pluto.rounds.prepare(args[1])
    print(msg)
    ply:ChatPrint(msg)
end)

concommand.Add("pluto_clear_round", function(ply, cmd, args)
    if (not pluto.cancheat(ply)) then
        return
    end

    local success, msg = pluto.rounds.clear()
    print(msg)
    ply:ChatPrint(msg)
end)

--- Minis ---

pluto.rounds.minis = pluto.rounds.minis or {}

concommand.Add("pluto_prepare_mini", function(ply, cmd, args)
    if (not pluto.cancheat(ply) or not args[1]) then
        return
    end

    pluto.rounds.minis[args[1]] = true
    pluto.rounds.args = args
    ply:ChatPrint("The " .. tostring(args[1]) .. " mini-event will take place next round.")
end)