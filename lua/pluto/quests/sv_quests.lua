pluto.quests = pluto.quests or {}

pluto.quests.byperson = pluto.quests.byperson or {}

pluto.quests.current = pluto.quests.current or {}

pluto.quests.loading = pluto.quests.loading or {}

pluto.quests.types = {
	[0] = {
		Name = "Special",
		Time = 60 * 60 * 24, -- day
		Amount = 0,
		Cooldown = 0,
	},
	[1] = {
		Name = "Hourly",
		Time = 60 * 60,
		Amount = 2,
		Cooldown = 60 * 7.5,
	},
	[2] = {
		Name = "Daily",
		Time = 60 * 60 * 24, -- day
		Amount = 0,
		Cooldown = 0,
	},
	[3] = {
		Name = "Weekly",
		Time = 60 * 60 * 24 * 7, -- week
		Amount = 0,
		Cooldown = 0,
	},
}

pluto.quests.list = pluto.quests.list or {}

for _, id in pairs {
	"melee",
	"nojump",
	"oneshot",
	"stickcurr",
	"traitors",
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
		"UPDATE pluto_quests SET progress_needed = GREATEST(0, progress_needed - ?) WHERE progress_needed > 0 AND idx = ?",
		{
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
	pluto.db.query("UPDATE pluto_quests SET expiry_time = LEAST(expiry_time, TIMESTAMPADD(SECOND, ?, CURRENT_TIMESTAMP)) WHERE idx = ?", {self.TYPE.Cooldown, self.RowID}, function(err, q)
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

function pluto.quests.init_nocache(ply, cb)
	print("loading - no cache", ply)
	local sid = pluto.db.steamid64(ply)

	local transact = pluto.db.transact()

	transact:AddQuery("DELETE FROM pluto_quests WHERE steamid = ? AND expiry_time < CURRENT_TIMESTAMP", {sid}, function(err, q)
	end)

	transact:AddQuery("SELECT idx, quest_id, type, progress_needed, total_progress, TIMESTAMPDIFF(SECOND, CURRENT_TIMESTAMP, expiry_time) as expire_diff, rand as seed FROM pluto_quests WHERE steamid = ?", {sid}, function(err, q)
		local quests = pluto.quests.byperson[ply] or {
			byid = {},
		}

		local have = {}

		for _, data in pairs(q:getData() or {}) do
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

			local quest = quests.byid[data.idx] or setmetatable({
				RowID = data.idx,
			}, pluto.quests.quest_mt)
			
			quest.Type = data.type
			quest.QuestID = data.quest_id
			quest.ProgressLeft = data.progress_needed
			quest.TotalProgress = data.total_progress
			quest.EndTime = os.time() + data.expire_diff
			quest.Player = ply
			quest.QUEST = quest_data
			quest.TYPE = quest_type
			quest.Seed = data.seed
			quest.Dead = false

			quests.byid[quest.RowID] = quest

			table.insert(quests[quest_type.Name], quest)
			have[data.quest_id] = true
		end

		local adder = pluto.db.transact()
		local needs_run = false

		for type, type_data in pairs(pluto.quests.types) do
			local type_quests = quests[type_data.Name]
			if ((type_quests and #type_quests or 0) >= type_data.Amount) then
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
						local quest = setmetatable({
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
						}, pluto.quests.quest_mt)

						quests.byid[quest.RowID] = quest

						table.insert(type_quests, quest)
					end
				)
			end

			needs_run = true
		end

		if (needs_run) then
			adder:AddCallback(function()
				pluto.quests.init_nocache(ply, cb)
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

function pluto.quests.init(ply, _cb)
	if (pluto.quests.loading[ply]) then
		table.insert(pluto.quests.loading[ply], _cb)
		return
	end

	pluto.quests.loading[ply] = {_cb}
	print("loading", ply)

	pluto.quests.init_nocache(ply, function(dat)
		pluto.quests.byperson[ply] = dat

		for type, questlist in pairs(dat) do
			for _, quest in pairs(questlist) do
				if (quest.HasInit) then
					continue
				end
				quest.QUEST:Init(quest)
				quest.HasInit = true
			end
		end

		pluto.inv.message(ply)
			:write "quests"
			:send()
	
		local list = pluto.quests.loading[ply]
		pluto.quests.loading[ply] = nil

		for _, _cb in pairs(list) do
			_cb(dat)
		end
	end)
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
			for index, quest in pairs(quests) do
				if (quest.RowID == idx and quest:IsValid()) then
					local byperson = pluto.quests.byperson[ply]
					byperson.byid[quest.RowID] = nil
					quests[index] = nil
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

concommand.Add("pluto_test_quest", function(ply, cmd, args)
	if (not pluto.cancheat(ply)) then
		return
	end

	local quest = pluto.quests.list[args[1]]

	if (not quest) then
		ply:ChatPrint("No quest found for id ", tostring(args[1]))
		return
	end

	quest:Reward {
		Player = ply,
		Seed = math.random()
	}

	ply:ChatPrint("pluto_test_quest: Rewarded for quest ", quest.Color, quest.Name)
end)

concommand.Add("pluto_add_quest", function(ply, cmd, args)
	if (not pluto.cancheat(ply)) then
		return
	end

	local target

	for type, quests in pairs(pluto.quests.byperson[ply] or {}) do
		for _, quest in pairs(quests) do
			if (quest.QUEST.ID == args[1]) then
				target = quest
				break
			end
		end
	end


	if (IsValid(target)) then
		local progress = tonumber(args[2]) or 1
		ply:ChatPrint("Found quest. Adding " .. progress .. " progress.")

		target:UpdateProgress(progress)
	end
end)
