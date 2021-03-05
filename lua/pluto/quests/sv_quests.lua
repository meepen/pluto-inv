pluto.quests.byid = pluto.quests.byid or setmetatable({}, {__mode = "v"})
pluto.quests.player_mt = pluto.quests.player_mt or {__index = {}}
local PLAYERQUESTS = pluto.quests.player_mt.__index
function PLAYERQUESTS:OfType(rewardtype)
	local ret = {}
	for _, quest in ipairs(self) do
		if (quest.Type == rewardtype) then
			table.insert(ret, quest)
			ret[quest.QuestID] = true
		end
	end

	return ret
end

pluto.quests.players = pluto.quests.players or setmetatable({}, {
	__index = function(self, ply)
		self[ply] = setmetatable({
			init = false, -- set in pluto.quests.init
			callbacks = {}
		}, pluto.quests.player_mt)

		return self[ply]
	end,
	__call = function(self, ply, cb)
		local t = self[ply]
		if (t.init and cb) then
			return cb(t)
		elseif (cb) then
			table.insert(t.callbacks, cb)
		else
			return t
		end
	end,
	__mode = "k"
})

function pluto.quests.create(ply, id)
	local quest = pluto.quests.byid[id]

	if (not quest) then
		quest = setmetatable({
			RowID = id
		}, pluto.quests.mt)
		pluto.quests.byid[id] = quest
		table.insert(pluto.quests.players(ply), quest)
	end

	return quest
end

function pluto.quests.populate(ply, data)
	local quest = pluto.quests.create(ply, data.idx)

	quest.Type = data.type
	quest.QuestID = data.quest_name
	quest.ProgressLeft = data.total_progress - data.current_progress
	quest.TotalProgress = data.total_progress
	quest.EndTime = os.time() + data.expire_diff
	quest.Player = ply
	quest.RewardData = util.JSONToTable(data.reward)

	quest:GetQuestData():Init(quest)
	quest:UpdateEndTime()

	return quest
end


function pluto.quests.forplayer(ply)
	return Promise(function(res, rej)
		local quests = pluto.quests.players(ply, res)
		if (not quests.init) then
			return
		end

		return res(quests)
	end)
end

function pluto.quests.oftype(type)
	local available = {}

	for id, QUEST in pairs(pluto.quests.byname) do
		if (QUEST.RewardPool == type) then
			available[#available + 1] = QUEST
		end
	end

	return available
end

function pluto.quests.generate(db, ply, questid)
	mysql_cmysql()

	local quest = questid

	if (isstring(questid)) then
		quest = pluto.quests.byname[questid]
	end

	if (not quest) then
		pwarnf("couldn't find quest: %s", tostring(questid))
		debug.Trace()
		return false
	end

	local type = quest.RewardPool or "unique"

	local type_data = pluto.quests.bypool[type]

	local progress_needed = quest:GetProgressNeeded()
	local reward = pluto.quests.getpoolreward(type)

	local dat, err = mysql_stmt_run(
		db,
		"INSERT INTO pluto_quests_new (owner, quest_name, type, current_progress, total_progress, expiry_time, reward) VALUES (?, ?, ?, 0, ?, TIMESTAMPADD(SECOND, ?, CURRENT_TIMESTAMP), ?)",
		ply:SteamID64(),
		quest.ID,
		quest.RewardPool,
		progress_needed,
		type_data.Time,
		util.TableToJSON(reward)
	)

	if (not dat) then
		pwarnf("Couldn't give quest!: %s", err)
		return false
	end

	local quest = pluto.quests.populate(ply, {
		idx = dat.LAST_INSERT_ID,
		type = quest.RewardPool,
		quest_name = quest.ID,
		current_progress = 0,
		total_progress = progress_needed,
		expire_diff = type_data.Time,
		reward = util.TableToJSON(reward),
	})

	quest:NotifyUpdate()

	return quest
end

function pluto.quests.repopulatequests(db, ply)
	mysql_cmysql()

	local sid = ply:SteamID64()

	mysql_stmt_run(db, "SELECT idx from pluto_quests_new WHERE owner = ? FOR UPDATE", sid)
	mysql_stmt_run(db, "DELETE FROM pluto_quests_new WHERE owner = ? AND expiry_time < CURRENT_TIMESTAMP + INTERVAL 5 SECOND", sid)

	local types_have, have = setmetatable({}, {__index = function() return 0 end}), {}

	local quests = pluto.quests.players(ply)
	if (not quests.init) then
		return
	end

	for _, quest in ipairs(quests) do
		have[quest:GetQuestData().ID] = true
		types_have[quest:GetQuestTypeData()] = types_have[quest:GetQuestTypeData()] + 1
	end

	for _, type in ipairs(pluto.quests.types) do
		if (types_have[type.RewardPool] >= type.Amount) then
			continue
		end

		local quests_of_type = pluto.quests.oftype(type.RewardPool)
		local have = quests:OfType(type.RewardPool)

		-- clear already gotten ones
		for i = #quests_of_type, 1, -1 do
			if (have[quests_of_type[i].ID]) then
				table.remove(quests_of_type, i)
			end
		end

		-- select ones to add
		
		for i = types_have[type] + 1, type.Amount do
			local selected, idx = table.Random(quests_of_type)
			table.remove(quests_of_type, idx)
			if (not pluto.quests.generate(db, ply, selected)) then
				pluto.warn("QUEST", "Couldn't add quest to player: ", selected.ID)
			end
		end
	end

	pluto.inv.message(ply)
		:write "quests"
		:send()
end

function pluto.quests.init(ply, cb)
	if (not cb) then
		local trace = debug.traceback()
		cb = function()
			pluto.warn("QUEST", "No callback in pluto.quests.init: \n", trace)
		end
	end
	local quests = pluto.quests.players(ply)

	if (quests.init) then
		return cb(quests)
	elseif (not quests.init and quests.loading) then
		table.insert(quests.callbacks, cb)
		return
	end

	quests.loading = true

	local sid = pluto.db.steamid64(ply)
	
	pluto.message("QUEST", "Loading data for ", ply)

	pluto.db.transact(function(db)
		-- freeze related entries and delete old ones
		mysql_stmt_run(db, "SELECT idx from pluto_quests_new WHERE owner = ? FOR UPDATE", sid)
		mysql_stmt_run(db, "DELETE FROM pluto_quests_new WHERE owner = ? AND expiry_time < CURRENT_TIMESTAMP + INTERVAL 5 SECOND", sid)
		local dat, err = mysql_stmt_run(db, "SELECT idx, quest_name, CAST(reward as CHAR(1024)) as reward, CAST(type as CHAR(32)) as type, current_progress, total_progress, TIMESTAMPDIFF(SECOND, CURRENT_TIMESTAMP, expiry_time) as expire_diff FROM pluto_quests_new WHERE owner = ?", sid)

		local types_have = setmetatable({}, {__index = function() return 0 end})

		local active_ids = {}
		
		for _, data in ipairs(dat) do
			local quest_data = pluto.quests.byname[data.quest_name]
			if (not quest_data) then
				pwarnf("Unknown quest %s for %s", tostring(data.quest_name), sid)
				continue
			end

			local quest_type = pluto.quests.bypool[data.type]
			if (not quest_type) then
				pwarnf("Unknown quest type %s for %s", tostring(data.type), tostring(data.quest_name))
				continue
			end

			local quest = pluto.quests.populate(ply, data)
			active_ids[data.idx] = true

			types_have[quest.Type] = types_have[quest.Type] + 1
		end

		-- remove inactive and stale quests from player's list
		for i = #quests, 1, -1 do
			if (not active_ids[quests[i].RowID]) then
				table.remove(quests, i)
			end
		end

		for _, type in ipairs(pluto.quests.types) do
			if (types_have[type.RewardPool] >= type.Amount) then
				continue
			end

			local quests_of_type = pluto.quests.oftype(type.RewardPool)
			local have = quests:OfType(type.RewardPool)

			-- clear already gotten ones
			for i = #quests_of_type, 1, -1 do
				if (have[quests_of_type[i].ID]) then
					table.remove(quests_of_type, i)
				end
			end

			-- select ones to add
			
			for i = types_have[type.RewardPool] + 1, type.Amount do
				local selected, idx = table.Random(quests_of_type)
				table.remove(quests_of_type, idx)
				if (not pluto.quests.generate(db, ply, selected)) then
					pluto.warn("QUEST", "Couldn't add quest to player: ", selected.ID)
				end
			end
		end

		mysql_commit(db)

		quests.init = true

		for _, callback in ipairs(quests.callbacks) do
			callback(quests)
		end

		pluto.message("QUEST", "Data loaded for ", ply)

		pluto.inv.message(ply)
			:write "quests"
			:send()

		cb(quests)
	end)
end

function pluto.quests.delete(quest)
	if (not IsValid(quest.Player)) then
		return
	end

	pluto.quests.players(quest.Player, function(quests)
		local removed = false
		for i, other in ipairs(quests) do
			if (other == quest) then
				table.remove(quests, i)
				removed = true
				break
			end
		end

		if (removed) then
			pluto.db.transact(function(db)
				pluto.quests.repopulatequests(db, quest.Player)
			end)
		end

		pluto.inv.message(quest.Player)
			:write "quests"
			:send()
	end)
end

function pluto.quests.reset(ply)
	-- TODO(meep)
end
