sql.Query "CREATE TABLE IF NOT EXISTS pluto_map_plays (mapname VARCHAR(32) NOT NULL PRIMARY KEY, last_played INT UNSIGNED NOT NULL)"
local last_played = sql.Query("SELECT * from pluto_map_plays ORDER BY last_played desc limit 3") or {}

sql.Query("INSERT INTO pluto_map_plays (mapname, last_played) VALUES (" .. sql.SQLStr(game.GetMap()) .. ", CAST(strftime('%s', 'now') AS INT UNSIGNED)) ON CONFLICT(mapname) DO UPDATE SET last_played = CAST(strftime('%s', 'now') AS INT UNSIGNED)")

pluto.mapvote = pluto.mapvote or {}

function pluto.mapvote.broadcast()
	for _, ply in pairs(player.GetAll()) do
		pluto.inv.message(ply)
			:write "mapvote"
			:send()
	end

	
	round.SetState(ttt.ROUNDSTATE_PREPARING, 15):_then(function()
		local votes = {}
		for map in pairs(pluto.mapvote.state.votable) do
			votes[map] = 0
		end
		for ply, map in pairs(pluto.mapvote.state.votes) do
			if (IsValid(ply)) then
				votes[map] = (votes[map] or 0) + 1
			end
		end

		local v = {}
		for map, votes in pairs(votes) do
			v[#v + 1] = {
				Map = map,
				Votes = votes + math.random()
			}
		end

		table.sort(v, function(a, b) 
			return a.Votes > b.Votes
		end)
		
		RunConsoleCommand("changelevel", v[1].Map)
	end)
end

function pluto.inv.writemapvote(cl)
	local state = pluto.mapvote.state
	net.WriteUInt(table.Count(state.votable), 8)

	for map in pairs(state.votable) do
		net.WriteString(map)

		local info = state.maps[map]
		net.WriteUInt(info.likes, 32)
		net.WriteUInt(info.dislikes, 32)
		net.WriteUInt(info.played, 32)
	end

	local info = state.maps[game.GetMap()]

	net.WriteUInt(info.likes, 32)
	net.WriteUInt(info.dislikes, 32)
	net.WriteUInt(info.played, 32)
end

function pluto.inv.readlikemap(cl)
	local liked = net.ReadBool()

	pluto.db.simplequery("INSERT INTO pluto_map_vote (voter, liked, mapname) VALUES(?, ?, ?) ON DUPLICATE KEY UPDATE liked = VALUE(liked)", {pluto.db.steamid64(cl), liked, game.GetMap()}, function() end)
end

function pluto.inv.readvotemap(cl)
	if (not pluto.mapvote.state) then
		return
	end

	local map = net.ReadString()

	if (not pluto.mapvote.state.votable[map]) then
		return
	end

	pluto.mapvote.state.votes[cl] = map

	local votes = {}

	for ply, map in pairs(pluto.mapvote.state.votes) do
		if (IsValid(ply)) then
			votes[map] = (votes[map] or 0) + 1
		end
	end

	for _, ply in pairs(player.GetAll()) do
		pluto.inv.message(ply)
			:write("mapvotes", votes)
			:send()
	end
end

function pluto.inv.writemapvotes(cl, votes)
	net.WriteUInt(table.Count(votes), 8)

	for map, vote in pairs(votes) do
		net.WriteString(map)
		net.WriteUInt(vote, 8)
	end
end

function pluto.mapvote.start()
	local valid = pluto.GetValidMaps()

	for i, map in pairs(valid) do
		if (map == game.GetMap()) then
			table.remove(valid, i)
			break
		end
	end

	for _, data in pairs(last_played) do
		if (#valid <= 8) then
			break
		end

		local maptoremove = data.mapname

		for i, map in pairs(valid) do
			if (map == maptoremove) then
				table.remove(valid, i)
				break
			end
		end
	end

	if (#valid < 8) then
		game.LoadNextMap()
		pwarnf("Cannot get enough valid maps: %s", table.concat(valid, ", "))
		return
	end

	for i, map in pairs(valid) do
		valid[i] = {map, math.random()}
	end

	table.sort(valid, function(a, b)
		return a[2] < b[2]
	end)

	for i = 9, #valid do
		valid[i] = nil
	end

	for i = 1, 8 do
		valid[i] = valid[i][1]
	end

	local state = {
		maps = {},
		votes = {},
		votable = {},
		needed = {
			likes = true,
			played = true,
		}
	}

	pluto.mapvote.state = state

	for _, map in pairs(valid) do
		state.votable[map] = true
	end

	valid[#valid + 1] = game.GetMap()

	for _, map in pairs(valid) do
		state.maps[map] = {
			played = 0,
			likes = 0,
			dislikes = 0,
		}
	end

	local function checkdone(from)
		state.needed[from] = nil
		if (table.Count(state.needed) == 0) then
			pluto.mapvote.broadcast()
		end
	end

	pluto.db.simplequery("SELECT COUNT(*) as votes, liked, mapname FROM pluto_map_vote WHERE mapname IN (?, ?, ?, ?, ?, ?, ?, ?, ?) GROUP BY liked, mapname", valid, function(dat, err)
		if (not dat) then
			return
		end

		for _, d in ipairs(dat) do
			local cur = state.maps[d.mapname]
			if (d.liked == 1) then
				cur.likes = d.votes
			else
				cur.dislikes = d.votes
			end
		end

		checkdone "likes"
	end)

	pluto.db.simplequery("SELECT played, mapname FROM pluto_map_info WHERE mapname IN (?, ?, ?, ?, ?, ?, ?, ?, ?)", valid, function(dat, err)
		if (not dat) then
			return
		end

		for _, d in ipairs(dat) do
			local cur = state.maps[d.mapname]
			cur.played = d.played
		end

		checkdone "played"
	end)
end

hook.Add("Initialize", "pluto_map", function()
	pluto.db.simplequery("INSERT INTO pluto_map_info (mapname, played) VALUES(?, 1) ON DUPLICATE KEY UPDATE played = played + VALUE(played)", {game.GetMap()}, function(dat, err)
		if (not dat) then
			return
		end

		print "updated map played thing"
	end)
end)

hook.Add("ChangeMap", "pluto_mapvote", function(reason)
    for _, ply in pairs(player.GetAll()) do
        ply:ChatPrint("Server is changing map. Reason: " .. reason)
	end

	round.SetState(ttt.ROUNDSTATE_PREPARING, math.huge)


	timer.Simple(4, pluto.mapvote.start)

	return true
end)