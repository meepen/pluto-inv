pluto.quests = pluto.quests or {}

pluto.quests.byperson = pluto.quests.byperson or {}

pluto.quests.current = pluto.quests.current or {}

pluto.quests.types = {
	[1] = {
		Name = "Hourly",
		Time = 60 * 60,
		Amount = 2,
		Cooldown = 60 * 7.5,
	},
}

pluto.quests.list = pluto.quests.list or {}

for _, id in pairs {
	"stickcurr",
	"oneshot",
	"melee",
	"nojump",
} do
	QUEST = pluto.quests.list[id] or {}
	QUEST.ID = id
	QUEST.Name = id
	include("list/" .. id .. ".lua")
	pluto.quests.list[id] = QUEST
	QUEST = nil
end

pluto.quests.quest_mt = pluto.quests.quest_mt or {}

local QUEST = {}
pluto.quests.quest_mt.__index = QUEST

function QUEST:IsValid()
	return self.EndTime > os.time() and IsValid(self.Player) and self.ProgressLeft > 0 and self.RowID and not self.Dead
end

function QUEST:Hook(event, fn)
	hook.Add(event, self, fn)
end

function QUEST:UpdateProgress(amount)
	self.ProgressLeft = math.max(0, self.ProgressLeft - amount)
	local transact = pluto.db.transact()

	transact:AddQuery(
		"UPDATE pluto_quests SET progress_needed = IF(progress_needed < ?, 0, progress_needed - ?) WHERE progress_needed > 0 AND idx = ?",
		{
			amount,
			amount,
			self.RowID
		},
		function(err, q)
		end
	)

	transact:AddQuery("SELECT progress_needed FROM pluto_quests WHERE ROW_COUNT() = 1 AND progress_needed = 0 AND idx = ?", {self.RowID}, function(err, q)
		if (q:getData()[1]) then
			self:Complete()
		end
	end)

	pluto.inv.message(self.Player)
		:write("quest", self)
		:send()

	transact:Run()
end

function QUEST:Complete()
	pluto.db.query("UPDATE pluto_quests SET expiry_time = MIN(expiry_time, TIMESTAMPADD(SECOND, ?, CURRENT_TIMESTAMP)) WHERE idx = ?", {self.TYPE.Cooldown, self.RowID}, function(err, q)
		if (self.QUEST.Reward) then
			self.QUEST:Reward(self)
		end
		self.EndTime = math.min(self.EndTime, os.time() + self.TYPE.Cooldown)
		pluto.inv.message(self.Player)
			:write("quest", self)
			:send()

		timer.Simple(self.TYPE.Cooldown + 5, function()
			pluto.quests.delete(self.RowID)
		end)
	end)
end

function pluto.quests.oftype(type, ignore)
	local available = {}

	for id, QUEST in pairs(pluto.quests.list) do
		if (ignore[id]) then
			continue
		end

		if (QUEST:IsType(type)) then
			available[#available + 1] = QUEST
		end
	end

	return available
end

function pluto.quests.init(ply, _cb)
	if (pluto.quests.byperson[ply]) then
		return _cb(pluto.quests.byperson[ply])
	end

	local cb = function(dat)
		pluto.quests.byperson[ply] = dat

		for type, questlist in pairs(dat) do
			for _, quest in pairs(questlist) do
				quest.QUEST:Init(quest)
			end
		end

		pluto.inv.message(ply)
			:write "quests"
			:send()

		_cb(dat)
	end

	local sid = pluto.db.steamid64(ply)

	local transact = pluto.db.transact()

	transact:AddQuery("DELETE FROM pluto_quests WHERE steamid = ? AND expiry_time < CURRENT_TIMESTAMP", {sid}, function(err, q)
	end)

	transact:AddQuery("SELECT idx, quest_id, type, progress_needed, total_progress, TIMESTAMPDIFF(SECOND, CURRENT_TIMESTAMP, expiry_time) as expire_diff, rand as seed FROM pluto_quests WHERE steamid = ?", {sid}, function(err, q)
		local quests = {}
		local have = {}

		for _, data in pairs(q:getData()) do
			local quest_type = pluto.quests.types[data.type]
			if (not quest_type) then
				pwarnf("Unknown quest type %s for %s", tostring(data.type), sid)
				continue
			end

			local quest_data = pluto.quests.list[data.quest_id]
			if (not quest_data) then
				pwarnf("Unknown quest id %s for %s", tostring(data.quest_id), sid)
				continue
			end

			if (not quests[quest_type.Name]) then
				quests[quest_type.Name] = {}
			end

			table.insert(quests[quest_type.Name], setmetatable({
				RowID = data.idx,
				Type = data.type,
				QuestID = data.quest_id,
				ProgressLeft = data.progress_needed,
				TotalProgress = data.total_progress,
				EndTime = os.time() + data.expire_diff,
				Player = ply,
				QUEST = quest_data,
				TYPE = quest_type,
				Seed = data.seed,
			}, pluto.quests.quest_mt))
			have[data.quest_id] = true
		end

		local adder = pluto.db.transact()
		local needs_run = false

		for type, type_data in pairs(pluto.quests.types) do
			local type_quests = quests[type_data.Name]
			if (type_quests and #type_quests >= type_data.Amount) then
				continue
			end

			if (not type_quests) then
				type_quests = {}
				quests[type_data.Name] = type_quests
			end

			-- add quests
			local oftype = table.shuffle(pluto.quests.oftype(type, have))

			for i = type_quests and #type_quests + 1 or 1, type_data.Amount do
				local new = oftype[1]
				table.remove(oftype, 1)

				local progress_needed = new:GetProgressNeeded(type)
				local seed = math.random()

				adder:AddQuery(
					"INSERT INTO pluto_quests (steamid, quest_id, type, progress_needed, total_progress, expiry_time, rand) VALUES (?, ?, ?, ?, ?, TIMESTAMPADD(SECOND, ?, CURRENT_TIMESTAMP), ?)",
					{
						sid,
						new.ID,
						type,
						progress_needed,
						progress_needed,
						type_data.Time,
						seed,
					},
					function(err, q)
						table.insert(type_quests, setmetatable({
							RowID = q:lastInsert(),
							QuestID = new.ID,
							ProgressLeft = progress_needed,
							TotalProgress = progress_needed,
							EndTime = os.time() + type_data.Time,
							Seed = seed,
							Player = ply,
							Type = type,
							QUEST = new,
							TYPE = type_data,
						}, pluto.quests.quest_mt))
					end
				)
			end
			needs_run = true
		end

		if (needs_run) then
			adder:AddCallback(function()
				pluto.quests.init(ply, _cb)
			end)
			adder:Run()
		else
			for type, quests in pairs(quests) do
				for _, quest in pairs(quests) do
					timer.Simple(quest.EndTime - os.time() + 5, function()
						pluto.quests.delete(quest.RowID)
					end)
				end
			end
			cb(quests)
		end
	end)

	transact:Run()
end

--[[
			Name = "Die",
			Description = "Die at least 2 times",
			Color = Color(204, 61, 5),
			Tier = 2,
			Reward = "Big Gay",
			EndTime = os.time() + 10,
			TotalProgress = 2,
			ProgressLeft = 1,
]]

function pluto.inv.writequest(ply, quest)
	net.WriteUInt(quest.RowID, 32)

	net.WriteString(quest.QUEST.Name)
	net.WriteString(quest.QUEST.Description)
	net.WriteColor(quest.QUEST.Color)
	net.WriteUInt(quest.Type, 8)

	net.WriteString(quest.QUEST:GetRewardText(quest.Seed))

	net.WriteInt(quest.EndTime - os.time(), 32)
	net.WriteUInt(quest.ProgressLeft, 32)
	net.WriteUInt(quest.TotalProgress, 32)
end

function pluto.inv.writequests(ply)
	local quests = pluto.quests.byperson[ply]
	if (not quests) then
		net.WriteBool(false)
		return
	end

	net.WriteBool(true)

	for quest_type, quest_list in pairs(quests) do
		net.WriteBool(true)
		net.WriteUInt(#quest_list, 8)

		for _, quest in ipairs(quest_list) do
			pluto.inv.writequest(ply, quest)
		end
	end
	net.WriteBool(false)
end

function pluto.quests.delete(idx)
	local update_for
	
	for ply, questlist in pairs(pluto.quests.byperson) do
		for type, quests in pairs(questlist) do
			for _, quest in pairs(quests) do
				if (quest.RowID == idx) then
					update_for = ply
					break
				end
			end
		end
	end


	if (IsValid(update_for)) then
		pluto.quests.reloadfor(update_for)
	end
end

function pluto.quests.reloadfor(ply)
	ply:ChatPrint "reloading quests"
	for type, quests in pairs(pluto.quests.byperson[ply] or {}) do
		for _, quest in pairs(quests) do
			quest.Dead = true
		end
	end

	pluto.quests.byperson[ply] = nil

	pluto.quests.init(ply, function()
		ply:ChatPrint "reloaded"
	end)
end

function pluto.quests.reload()
	for k,v in pairs(player.GetHumans()) do
		pluto.quests.reloadfor(v)
	end
end

pluto.quests.reload()