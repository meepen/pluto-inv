util.AddNetworkString "round_data"
util.AddNetworkString "mini_speed"
util.AddNetworkString "round_notify"

--- Rounds ---

pluto.rounds = pluto.rounds or {}

pluto.rounds.minis = pluto.rounds.minis or {}

function pluto.rounds.prepare(name)
    if (not name) then
        return false, "No name provided"
    end

	local event = pluto.rounds.byname[name]

	if (not event) then
		return false, "Event does not exist"
	end

	if (ttt.GetNextRoundEvent() ~= "") then
		return false, "Event already prepared"
	end

	if (GetConVar "ttt_round_limit":GetInt() <= ttt.GetRoundNumber()) then
		return false, "Round limit"
	end

	ttt.SetNextRoundEvent(name)

	return true, "NextRoundEvent set to " .. name
end

function pluto.rounds.queue(name)
    if (not name) then
        return false, "No name provided"
    end

    local serv_var = GetConVar "pluto_cross_id"
    local serv = (serv_var and serv_var:GetString()) or "test"

    --[[pluto.db.instance(function(db)
        mysql_stmt_run(db, "INSERT INTO pluto_round_queue (server, time, name) VALUES (?, NOW(), ?)", serv, name)
        return true, "Round queued"
    end)--]]
end

function pluto.rounds.minplayersmet(name)
	local event = pluto.rounds.infobyname[name]

	if (not event) then
		return false, "Event does not exist"
	end

	if (not event.MinPlayers or #player.GetAll() < event.MinPlayers) then
		return false, "Not enough players"
	end

	return true
end

function pluto.rounds.chooserandom(typ, needminplayers)
	local events = {}

	for name, event in pairs(pluto.rounds.infobyname) do
		if (not event.Type or event.Type ~= typ) then
			continue
		end

        if (event.NoRandom) then
            continue
        end

		if (needminplayers and not pluto.rounds.minplayersmet(name)) then
			continue
		end

		events[name] = event
	end

	if (table.Count(events) == 0) then
		return
	end

	return pluto.inv.roll(events)
end

function pluto.rounds.clear()
	ttt.SetNextRoundEvent("")

	return true, "NextRoundEvent cleared"
end

pluto.rounds.WriteRoundData = function(name, arg, ply)
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

pluto.rounds.Notify = function(msg, col, ply, short)
    col = col or color_white

    net.Start "round_notify"
        net.WriteString(msg)
        net.WriteUInt(col.r, 8)
        net.WriteUInt(col.g, 8)
        net.WriteUInt(col.b, 8)
        net.WriteBool(short or false)
    if (IsValid(ply)) then
        net.Send(ply)
    else
        net.Broadcast()
    end
end

pluto.rounds.GiveDefaults = function(ply)
	ply:StripAmmo()
	ply:StripWeapons()

    for i = 1, 6 do
		local wepid = tonumber(ply:GetInfo("pluto_loadout_slot" .. i, nil))
        if (not wepid) then
            continue
        end

		local wep = pluto.itemids[wepid]
		if (wep and wep.Owner == ply:SteamID64()) then
			pluto.NextWeaponSpawn = wep
			ply:Give(wep.ClassName)
		end
	end

	ply:Give "weapon_ttt_crowbar"
	ply:Give "weapon_ttt_unarmed"
	ply:Give "weapon_ttt_magneto"
end

hook.Add("TTTPrepareRound", "pluto_minis", function()
	if (ttt.GetCurrentRoundEvent() ~= "" or not pluto.rounds.infobyname or not pluto.rounds.minis) then
		return
	end

    for name, event in pairs(pluto.rounds.infobyname) do
        if (not event.Type or event.Type ~= "Mini") then
            continue
        end

        if (pluto.rounds.minis[name]) then
            continue
        end

        if (pluto.rounds.infobyname[name].NoRandom) then
            continue
        end

        if (not pluto.rounds.minplayersmet(name)) then
            continue
        end

        if (math.random() > pluto.rounds.infobyname[name].Odds) then
            continue
        end

        print("Preparing Mini-Event: " .. name)
        pluto.rounds.minis[name] = true
    end
end)

--[[hook.Add("TTTEndRound", "pluto_round_queue", function()
    print("trying to queue a round")
    if (ttt.GetNextRoundEvent() ~= "" or GetConVar "ttt_round_limit":GetInt() <= ttt.GetRoundNumber()) then
        print "returning due to already prepared or round limit"
        return
    end

    if (not pluto.rounds.infobyname) then
        print "returning due to lack of infobyname"
        return
    end

    local serv_var = GetConVar "pluto_cross_id"
    local serv = (serv_var and serv_var:GetString()) or "test"

    pluto.db.instance(function(db)
        local rounds = mysql_stmt_run(db, "SELECT * from pluto_round_queue WHERE server = ? AND NOT finished WHERE x AND time <= NOW()", serv) 

        if (not rounds) then
            print "returning due to lack of rounds"
            return
        end

        for k, round in ipairs(rounds) do
            local name = round.name

            if (not name or not pluto.rounds.byname[name]) then
                mysql_stmt_run(db, "UPDATE pluto_round_queue SET finished = true WHERE idx = ?", round.idx)
                pluto.rounds.Notify(string.format("Please tell developers invalid round was queued with id: %i", round.idx))
                continue
            end

            if (not pluto.rounds.infobyname[name] or pluto.rounds.infobyname[name].MinPlayers > #player.GetAll()) then
                continue
            end

            local success, e = pluto.rounds.prepare(name)

            if (success) then
                mysql_stmt_run(db, "UPDATE pluto_round_queue SET finished = true WHERE idx = ?", round.idx)
                break
            end
        end
    end)
end)--]]

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

concommand.Add("pluto_prepare_mini", function(ply, cmd, args)
    if (not pluto.cancheat(ply) or not args[1]) then
        return
    end

    pluto.rounds.minis[args[1]] = true
    pluto.rounds.args = args
    ply:ChatPrint("The " .. tostring(args[1]) .. " Mini-Event has been prepared.")
end)