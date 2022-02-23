--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
util.AddNetworkString "round_data"
util.AddNetworkString "mini_speed"
util.AddNetworkString "round_notify"

local pluto_mini_boost = CreateConVar("pluto_mini_boost", 1, FCVAR_ARCHIVE, "Direct multiplier to the odds of mini-events occuring", 0)

--- Rounds ---

pluto.rounds = pluto.rounds or {}

pluto.rounds.minis = pluto.rounds.minis or {}

-- Prepares a round
function pluto.rounds.prepare(name)
    if (not name) then
        return false, "No name provided"
    end

	if (not pluto.rounds.infobyname[name]) then
		return false, "Event does not exist"
	end

    local type = pluto.rounds.infobyname[name].Type

    if (GetConVar "ttt_round_limit":GetInt() <= ttt.GetRoundNumber()) then
        return false, "Round limit"
    end

    if (type == "Mini") then
        if (pluto.rounds.minis[name]) then
            return false, "Already queued mini"
        end

        pluto.rounds.minis[name] = true

        return true, "Queued mini"
    else
        if (ttt.GetNextRoundEvent() ~= "") then
            return false, "Event already prepared"
        end
    
        ttt.SetNextRoundEvent(name)
    
        return true, "NextRoundEvent set to " .. name
    end

end

-- Queues a round
function pluto.rounds.queue(name, steamid, db)
    steamid = steamid or 0
    if (not name) then
        return false, "No name provided"
    end

	if (not pluto.rounds.infobyname[name]) then
		return false, "Event does not exist"
	end

    local serv_var = GetConVar "pluto_cross_id"
    local serv = (serv_var and serv_var:GetString()) or "unknown"

    if (db) then
        mysql_stmt_run(db, "INSERT INTO pluto_round_queue (server, time, name, requester) VALUES (?, NOW(), ?, ?)", serv, name, steamid)
    else
        pluto.db.instance(function(db)
            mysql_stmt_run(db, "INSERT INTO pluto_round_queue (server, time, name, requester) VALUES (?, NOW(), ?, ?)", serv, name, steamid)
        end)
    end

    return true, "Event Queue Attempted"
end

-- Checks if the given event has sufficient players
function pluto.rounds.goodplayercount(name)
	local event = pluto.rounds.infobyname[name]

	if (not event) then
		return false, "Event does not exist"
	end

	if (event.MinPlayers and #player.GetAll() < event.MinPlayers) then
		return false, "Not enough players"
	end

    if (event.MaxPlayers and #player.GetAll() > event.MaxPlayers) then
        return false, "Too many players"
    end

	return true
end

-- Chooses a random round of the given parameters
function pluto.rounds.chooserandom(typ, needminplayers, smalls)
	local events = {}

    -- Skips ineligible rounds
	for name, event in pairs(pluto.rounds.infobyname) do
		if (not event.Type or event.Type ~= typ) then
			continue
		end

        if (event.NoRandom and not smalls) then
            continue
        end

        if (smalls and not event.Small) then
            continue
        end

		if (needminplayers and not pluto.rounds.goodplayercount(name)) then
			continue
		end

		events[name] = event
	end

	if (table.Count(events) == 0) then
		return
	end

	return pluto.inv.roll(events)
end

-- Clears the current round
function pluto.rounds.clear()
	ttt.SetNextRoundEvent("")

    pluto.rounds.forfun = nil

	return true, "NextRoundEvent cleared"
end

-- Called in sh_init OnCurrentRoundEventChange, prepares common round functions
function pluto.rounds.preparecommon(event, state)
    -- Cleans up laggy entities
    if (not event.NoCleanup) then
        hook.Add("PlayerRagdollCreated", "pluto_event_cleanup", function(ply, rag, atk, dmg)
            timer.Simple(1, function()
                -- Deletes ragdolls
                if (IsValid(rag)) then
                    rag:Remove()
                end
            end)
        end)

        timer.Create("pluto_event_cleanup", 10, 0, function()
            -- Removes decals
            game.GetWorld():RemoveAllDecals()

            for k, ent in ipairs(ents.GetAll()) do
                -- Removes floor weapons
                if (ent:IsWeapon() and not IsValid(ent:GetOwner())) then
                    ent:Remove()
                end

                local classname = ent:GetClass()

                -- Removes ammo, body entities
                if (string.find(classname, "item_ammo") or string.find(classname, "item_box") or string.find(classname, "ttt_body_info")) then
                    ent:Remove()
                end
            end
        end)
    end

    -- Sets up respawn protection
    if (not event.NoProtection) then
        state.protectuntil = {}
        hook.Add("PlayerSpawn", "pluto_event_protection", function(ply)
            state.protectuntil[ply] = CurTime() + (event.ProtectionTime or 1.5)
        end)

        hook.Add("PlayerShouldTakeDamage", "pluto_event_protection", function(self, state, ply, atk)
            if (IsValid(ply) and IsValid(atk) and atk:IsPlayer()) then
                return (state and state.protectuntil and state.protectuntil[ply] and state.protectuntil[ply] < CurTime())
            end
        end)
    end
end

-- Called in sh_init TTTEndRound, terminates common round functions
function pluto.rounds.endcommon()
    hook.Remove("PlayerRagdollCreated", "pluto_event_cleanup")
    timer.Remove("pluto_event_cleanup")
    hook.Remove("PlayerSpawn", "pluto_event_protection")
    hook.Remove("PlayerShouldTakeDamage", "pluto_event_protection")
end

-- Sounds info about the current round to the players
pluto.rounds.WriteRoundData = function(name, arg, ply)
    net.Start "round_data"
        local typ = type(arg)
        net.WriteString(name)
        net.WriteString(typ)
        if (typ == "string") then
            var = net.WriteString(arg)
        elseif (typ == "number") then
            var = net.WriteUInt(arg, 32)
        elseif (typ == "boolean") then
            var = net.WriteBool(arg)
        end
    if (IsValid(ply)) then
        net.Send(ply)
    else
        net.Broadcast()
    end
end

-- Sends a notification to the players
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

-- Gives the player their regular inventory loadout
pluto.rounds.GiveDefaults = function(ply, nogrenade)
	ply:StripAmmo()
	ply:StripWeapons()

    for i = 1, 6 do
        if (i == 4 and nogrenade) then
            continue
        end

		local wepid = tonumber(ply:GetInfo("pluto_loadout_slot" .. i, nil))
        if (not wepid) then
            continue
        end

		local wep = pluto.itemids[wepid]
		if (wep and wep.Owner == ply:SteamID64()) then
			pluto.NextWeaponSpawn = wep
			local wep = ply:Give(wep.ClassName)
            wep.AllowDrop = false
		end
	end

	ply:Give "weapon_ttt_crowbar"
	ply:Give "weapon_ttt_unarmed"
	ply:Give "weapon_ttt_magneto"

    pluto.rounds.LoadAmmo(ply)
end

-- Gives the player an endless amount of ammo
pluto.rounds.LoadAmmo = function(ply)
    for k, wep in ipairs(ply:GetWeapons()) do
		if (wep.Primary and wep.Primary.Ammo and wep.Primary.ClipSize) then
			ply:SetAmmo(wep.Primary.ClipSize * 100, wep.Primary.Ammo)
		end
	end
end

-- Prepares mini events
hook.Add("TTTPrepareRound", "pluto_minis", function()
	if (ttt.GetCurrentRoundEvent() ~= "" or ttt.GetNextRoundEvent() ~= "" or not pluto.rounds.infobyname or not pluto.rounds.minis) then
		return
	end

    -- Decides which mini events are playable
    local playable = {}
    for name, event in pairs(pluto.rounds.infobyname) do
        -- Skip if already added
        if (pluto.rounds.minis[name]) then
            continue
        end

        -- Skip if ineligible
        if (event.NoRandom or not event.Type or event.Type ~= "Mini") then
            continue
        end

        -- Skip if bad player count
        if (not pluto.rounds.goodplayercount(name)) then
            continue
        end

        playable[name] = event
    end

    -- Chooses mini events to prepare
    local odds = 1/4
    local chosen = 0
    local choosemore = true
    while (choosemore) do
        -- Makes sure that if pluto_mini_boost is set really high high we'll still only have up to 10 mini events at once
        if (math.random() < math.min(1 - 0.1 * chosen, odds * pluto_mini_boost:GetFloat())) then
            pluto.rounds.minis[pluto.inv.roll(playable)] = true
            chosen = chosen + 1
        else
            choosemore = false
        end
    end
end)

function checkRoundQueue()
    if (ttt.GetNextRoundEvent() ~= "" or GetConVar "ttt_round_limit":GetInt() <= ttt.GetRoundNumber() + 1) then
        return
    end

    if (not pluto.rounds.infobyname) then
        return
    end

    local serv_var = GetConVar "pluto_cross_id"
    local serv = (serv_var and serv_var:GetString()) or "unknown"

    pluto.db.instance(function(db)
        local rounds = mysql_stmt_run(db, "SELECT * from pluto_round_queue WHERE server = ? AND NOT finished AND time <= NOW()", serv) 
        
        if (not rounds) then
            return
        end

        local minisonly = false

        for k, round in ipairs(rounds) do
            local name = round.name

            if (not name or not pluto.rounds.infobyname[name]) then
                mysql_stmt_run(db, "UPDATE pluto_round_queue SET finished = true WHERE idx = ?", round.idx)
                pluto.rounds.Notify(string.format("Please tell developers invalid round was queued with id: %i", round.idx))
                continue
            end

            if (minisonly and pluto.rounds.infobyname[name].Type ~= "Mini") then
                continue
            end

            if (pluto.rounds.infobyname[name].MinPlayers and pluto.rounds.infobyname[name].MinPlayers > #player.GetAll()) then
                continue
            end

            if (pluto.rounds.infobyname[name].MaxPlayers and pluto.rounds.infobyname[name].MaxPlayers < #player.GetAll()) then
                continue
            end

            local success, e = pluto.rounds.prepare(name)

            --[[if (success and pluto.rounds.infobyname[name].Type == "Mini") then
                --checkRoundQueue()
            end--]]

            if (success) then
                mysql_stmt_run(db, "UPDATE pluto_round_queue SET finished = true WHERE idx = ?", round.idx)
                if (pluto.rounds.infobyname[name].Type == "Mini") then
                    minisonly = true
                else
                    break
                end
            end
        end
    end)
end

hook.Add("TTTEndRound", "pluto_round_queue", checkRoundQueue)

function eventQueueUpdate(requester)
    local serv_var = GetConVar "pluto_cross_id"
    local serv = (serv_var and serv_var:GetString()) or "unknown"

    pluto.db.simplequery("SELECT name, usr.displayname from pluto_round_queue LEFT OUTER JOIN pluto_player_info usr ON usr.steamid = pluto_round_queue.requester WHERE server = ? AND NOT finished AND time <= NOW()", {serv}, function(rounds, err)
        pluto.inv.message(requester)
            :write("eventqueue", rounds)
        :send()
    end)
end

function pluto.inv.readgeteventqueue(requester)
    eventQueueUpdate(requester)
end

function pluto.inv.writeeventqueue(requester, rounds)
    if (not rounds or rounds.AFFECTED_ROWS == 0) then
        net.WriteUInt(0, 8)
        return
    end

    net.WriteInt(#rounds, 8)
    
    for i=1, #rounds do
        local curround = rounds[i]
        net.WriteString(curround.name)
        net.WriteString(curround.displayname)
    end
end

function pluto.inv.readqueueevent(requester)
    if (not IsValid(requester)) then return end

    local name = net.ReadString()
    local res = false 
    local msg = "Unknown error!"

    local round = pluto.rounds.infobyname[name]

    if (not round or round.NoBuy or not round.Type) then
        return
    end

    local price = -pluto.rounds.cost[round.Type]

    if (not price) then
        return
    end
    
    pluto.db.transact(function(db) 
		if (not pluto.inv.addcurrency(db, requester, "ticket", price)) then
			mysql_rollback(db)
			return
		end
        
        local res, msg = pluto.rounds.queue(name, requester:SteamID64(), db)

		mysql_commit(db)

        if (res and msg) then
            requester:ChatPrint(Color(50, 200, 50), msg)
        elseif (msg) then
            requester:ChatPrint(Color(200, 50, 50), msg)
        end

        for k, ply in ipairs(player.GetAll()) do
            eventQueueUpdate(ply)
        end
	end)
end

concommand.Add("pluto_prepare_round", function(ply, cmd, args)
    name = args[1]
    forfun = args[2]
    queue = args[3]

    if (not pluto.cancheat(ply) or not name) then
        return
    end

    if (forfun) then
        pluto.rounds.forfun = true
    end

    if (queue) then
        local success, msg = pluto.rounds.queue(name, ply:SteamID64())
    else
        local success, msg = pluto.rounds.prepare(name)
    end

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

    if (not pluto.rounds.infobyname[args[1]] or pluto.rounds.infobyname[args[1]].Type ~= "Mini") then
        ply:ChatPrint("There is no mini-event with the name of " .. tostring(args[1]))
        return
    end

    pluto.rounds.minis[args[1]] = true
    pluto.rounds.args = args
    ply:ChatPrint("The " .. tostring(args[1]) .. " Mini-Event has been prepared.")
end)

--- Testing ---
concommand.Add("pluto_view_queue", function(ply, cmd, args)
    if (not pluto.cancheat(ply)) then
        return
    end

    local serv_var = GetConVar "pluto_cross_id"
    local serv = (serv_var and serv_var:GetString()) or "unknown"

    ply:ChatPrint("Viewing queue. Your current server: " .. serv)

    pluto.db.instance(function(db)
        local rounds = mysql_stmt_run(db, "SELECT * from pluto_round_queue WHERE NOT finished") 
        
        if (not rounds) then
            ply:ChatPrint("No rounds found.")
            return
        end

        ply:ChatPrint "Rounds found:"
        for k, round in ipairs(rounds) do
            ply:ChatPrint(round.name, round.server)
        end
    end)
end)

