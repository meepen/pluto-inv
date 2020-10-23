pluto.quests = pluto.quests or {}

pluto.quests.byperson = pluto.quests.byperson or {}

pluto.quests.current = pluto.quests.current or {}

pluto.quests.loading = pluto.quests.loading or {}

pluto.quests.list = pluto.quests.list or {}

for _, id in pairs {
	"april_fools",
	"light1",
	"light2",
	"light3",

	"melee",
	"nojump",
	"oneshot",
	"stickcurr",
	"traitors",
	"floor",
	"wepswitch",
	"nomove",
	"winstreak",

	"nodamage",
	"credits",
	"pcrime",
	"crusher",
	"healthgain",

	"dnatrack",
	"fourcraft",
	"sacrifices",
	"burn",
	"postround",

	"halloween_nade",
} do
	QUEST = pluto.quests.list[id] or {}
	QUEST.ID = id
	QUEST.Name = id
	include("list/" .. id .. ".lua")
	pluto.quests.list[id] = QUEST
	QUEST = nil
end

pluto.quests.rewardhandlers = {
	currency = {
		reward = function(self, data)
            local cur = self.Currency and pluto.currency.byname[self.Currency] or pluto.currency.random()
            local amount = self.Amount or 1

			pluto.db.instance(function(db)
				pluto.inv.addcurrency(db, data.Player, self.Currency, amount)
				data.Player:ChatPrint(white_text, "You have received ", amount, " ", cur, amount == 1 and "" or "s", white_text, " for completing ", data.QUEST.Color, data.QUEST.Name, white_text, "!")
			end)

		end,
        small = function(self)
            if (self.Small) then
                return self.Small
            end

            local cur = pluto.currency.byname[self.Currency]
            local amount = self.Amount or 1

            return (amount == 1 and "" or "set of " .. amount .. " ") .. cur.Name .. (amount == 1 and "" or "s")
        end,
	},
	weapon = {
		reward = function(self, data)
			local classname = self.ClassName --[[or (self.Grenade and pluto.weapons.randomgrenade()) or (self.Melee and pluto.weapons.randommelee())]] or pluto.weapons.randomgun()
			-- Random grenade and random melee rewards, currently unused

			local tier = self.Tier or pluto.tiers.filter(baseclass.Get(classname), function(t)
				if (self.ModMin and t.affixes < self.ModMin) then
					return false
				end

				if (self.ModMax and t.affixes > self.ModMax) then
					return false
				end

				return true
			end).InternalName

			local new_item = pluto.weapons.generatetier(tier, classname)

			for _, mod in ipairs(self.Mods or {}) do
				pluto.weapons.addmod(new_item, mod)
			end

			if (self.RandomImplicit) then
				local mod = table.shuffle(pluto.mods.getfor(baseclass.Get(classname), function(m)
					return m.Type == "implicit" and not m.PreventChange and not m.NoCoined
				end))[1]

				pluto.weapons.addmod(new_item, mod.InternalName)
			end

			pluto.db.transact(function(db)
				pluto.inv.savebufferitem(db, data.Player, new_item)
				mysql_commit(db)
				data.Player:ChatPrint(white_text, "You have received ", startswithvowel(new_item.Tier.Name) and "an " or "a ", new_item, white_text, " for completing ", data.QUEST.Color, data.QUEST.Name, white_text, "!")
			end)
		end,
		small = function(self)
			if (self.Small) then
				return self.Small
			end

			local smalltext = ""

			if (self.Tier) then
				smalltext = pluto.tiers.byname[self.Tier].Name .. " "
			end

			if (self.ClassName) then
				smalltext = smalltext .. baseclass.Get(self.ClassName).PrintName
			else
				smalltext = smalltext .. "gun"
			end

			local append = {}
			if (self.RandomImplicit) then
				table.insert(append, " a random implicit")
			end
			if (self.ModMin and self.ModMax) then
				table.insert(append, " between " .. tostring(self.ModMin) .. " and " .. tostring(self.ModMax) .. " mods")
			elseif (self.ModMin) then
				table.insert(append, " at least " .. tostring(self.ModMin) .. " mods")
			elseif (self.ModMax) then
				table.insert(append, " at most " .. tostring(self.ModMax) .. " mods")
			end
			for _, text in ipairs(append) do
				smalltext = smalltext .. (_ == 1 and " with" or " and") .. text
			end

			return smalltext
		end,
	},
	shard = {
		reward = function(self, data)
			local tier = self.Tier or pluto.tiers.filter(baseclass.Get(pluto.weapons.randomgun()), function(t)
				if (self.ModMin and t.affixes < self.ModMin) then
					return false
				end

				if (self.ModMax and t.affixes > self.ModMax) then
					return false
				end

				return true
			end).InternalName

			pluto.db.transact(function(db)
				pluto.inv.generatebuffershard(db, data.Player, tier)
				mysql_commit(db)
				tier = pluto.tiers.byname[tier]
	
				data.Player:ChatPrint(white_text, "You have received ", startswithvowel(tier.Name) and "an " or "a ", tier.Color, tier.Name, " Tier Shard", white_text, " for completing ", data.QUEST.Color, data.QUEST.Name, white_text, "!")
			end)
		end,
		small = function(self)
            if (self.Small) then
                return self.Small
            end

			local smalltext = "shard"

			if (self.Tier) then
				smalltext = pluto.tiers.byname[self.Tier].Name .. " "
			end

			local append = {}
			if (self.ModMin and self.ModMax) then
				table.insert(append, " between " .. tostring(self.ModMin) .. " and " .. tostring(self.ModMax) .. " mods")
			elseif (self.ModMin) then
				table.insert(append, " at least " .. tostring(self.ModMin) .. " mods")
			elseif (self.ModMax) then
				table.insert(append, " at most " .. tostring(self.ModMax) .. " mods")
			end
			for _, text in ipairs(append) do
				smalltext = smalltext .. (_ == 1 and " with" or " and") .. text
			end

			return smalltext
		end,
	},
}

pluto.quests.rewards = {
	unique = { -- This should never be used
		{
			Type = "unique",
		},
	},
	hourly = {
		{
			Type = "currency",
			Currency = "tome",
			Amount = 2,
		},
		{
			Type = "currency",
			Currency = "crate3_n",
			Amount = 1,
		},
		{
			Type = "currency",
			Currency = "crate3",
			Amount = 1,
		},
		{
			Type = "currency",
			Currency = "crate1",
			Amount = 1,
		},
		{
			Type = "currency",
			Currency = "aciddrop",
			Amount = 1,
		},
		{
			Type = "currency",
			Currency = "pdrop",
			Amount = 1,
		},
		{
			Type = "weapon",
			RandomImplicit = true,
			ModMax = 4,
			ModMin = 3,
		},
		{
			Type = "weapon",
			ModMin = 4,
		},
		--[[ Random grenade, currently unused
		{
			Type = "weapon",
			Grenade = true,
		},
		--]]
		{
			Type = "weapon",
			Tier = "inevitable",
		},
		{
			Type = "shard",
			ModMin = 4,
			ModMax = 5,
		},
	},
	daily = {
		{
			Type = "currency",
			Currency = "crate2",
			Amount = 10,
		},
		{
			Type = "currency",
			Currency = "crate3_n",
			Amount = 10,
		},
		{
			Type = "currency",
			Currency = "crate3",
			Amount = 3,
		},
		{
			Type = "currency",
			Currency = "crate1",
			Amount = 5,
		},
		{
			Type = "weapon",
			ClassName = "weapon_cod4_ak47_silencer",
			Tier = "uncommon",
		},
		{
			Type = "weapon",
			ClassName = "weapon_cod4_m4_silencer",
			Tier = "uncommon",
		},
		{
			Type = "weapon",
			ClassName = "weapon_cod4_m14_silencer",
			Tier = "uncommon",
		},
		{
			Type = "weapon",
			ClassName = "weapon_cod4_g3_silencer",
			Tier = "uncommon",
		},
		{
			Type = "weapon",
			ClassName = "weapon_cod4_g36c_silencer",
			Tier = "uncommon",
		},
		{
			Type = "weapon",
			ModMin = 5,
		},
		{
			Type = "weapon",
			Tier = "uncommon",
			Mods = {"hearted",},
			Small = "Hearted Uncommon gun",
		},
		{
			Type = "weapon",
			Tier = "common",
			Mods = {"tomed",},
			Small = "Tomed Common gun"
		},
		{
			Type = "shard",
			ModMin = 5,
		},
	},
	weekly = {
		{
			Type = "currency",
			Currency = "tome",
			Amount = 15,
		},
		{
			Type = "currency",
			Currency = "coin",
			Amount = 1,
		},
		{
			Type = "currency",
			Currency = "quill",
			Amount = 1,
		},
		{
			Type = "currency",
			Currency = "tp",
			Amount = 1,
		},
		{
			Type = "weapon",
			ModMin = 6,
			ModMax = 6,
			Small = "gun with 6 mods",
		},
		{
			Type = "weapon",
			Mods = {"hearted",},
			ModMin = 5,
			ModMax = 5,
			Small = "Hearted gun with 5 mods",
		},
		{
			Type = "weapon",
			Tier = "mystical",
			Mods = {"dropletted", "handed", "diced",},
			Small = "Dropletted, Handed, Diced, Mystical gun",
		},
		{
			Type = "shard",
			ModMin = 6,
		},
	},
}

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
	local p = self.Player
	if (IsValid(p) and p.Punishments and p.Punishments.questban and p.Punishments.questban.Ending > os.time()) then
		return
	end

	if (self.ProgressLeft <= 0) then
		return
	end

	pluto.db.instance(function(db)
		local succ, err = mysql_stmt_run(db, "UPDATE pluto_quests_new SET current_progress = (@cur_prog:=LEAST(total_progress, current_progress + ?)) WHERE current_progress < total_progress AND idx = ?", amount, self.RowID)
		if (not succ or succ.AFFECTED_ROWS == 0) then
			return
		end

		local succ, err = mysql_stmt_run(db, "SELECT @cur_prog as current_progress")
		if (succ and succ[1].current_progress == self.TotalProgress) then
			self:Complete()
		end

		self.ProgressLeft = math.max(0, self.ProgressLeft - amount)

		pluto.inv.message(self.Player)
			:write("quest", self)
			:send()
	end)
end

function QUEST:Complete()
	pluto.db.simplequery("UPDATE pluto_quests_news SET expiry_time = LEAST(expiry_time, TIMESTAMPADD(SECOND, ?, CURRENT_TIMESTAMP)) WHERE idx = ?", {self.TYPE.Cooldown, self.RowID}, function(d, err)
		if (self.QUEST.Reward) then
			self.QUEST:Reward(self)
		elseif (self.Reward) then
			self:Reward(self)
		end
		self.EndTime = math.min(self.EndTime, os.time() + self.TYPE.Cooldown)

		pluto.inv.message(self.Player)
			:write("quest", self)
			:send()

		timer.Create("quest_" .. self.RowID, self.TYPE.Cooldown + 5, 1, function()
			pluto.quests.delete(self.RowID)
		end)
	end)
end

function QUEST:GetRewardText()
    return pluto.quests.poolrewardtext(self.RewardData, self)
end

function QUEST:Reward(data)
	pluto.quests.poolreward(self.RewardData, self)
end

function pluto.quests.getpoolreward(type)
	local typequests = pluto.quests.rewards[type]

	return typequests and (table.Random(typequests)) or { Type="unique" }
end

function pluto.quests.poolreward(pick, quest)
	if (quest.QUEST.Reward) then
		return quest.QUEST.Reward(quest)
	end
	return pluto.quests.rewardhandlers[pick.Type].reward(pick, quest)
end

function pluto.quests.poolrewardtext(pick, quest)
	if (quest.QUEST.GetRewardText) then
		return quest.QUEST.GetRewardText(quest)
	end
	return pluto.quests.rewardhandlers[pick.Type].small(pick)
end

function pluto.quests.oftype(type)
	local available = {}

	for id, QUEST in pairs(pluto.quests.list) do
		if (QUEST.RewardPool == type) then
			available[#available + 1] = QUEST
		end
	end

	return available
end

function pluto.quests.forplayer(ply)
	pluto.quests.byperson[ply] = pluto.quests.byperson[ply] or setmetatable({byid = {}}, {__index = function(self, k) self[k] = {} return self[k] end})

	return pluto.quests.byperson[ply]
end

function pluto.quests.addto(ply, quest)
	local quests = pluto.quests.forplayer(ply)
	quests.byid[quest.RowID] = quest
	table.insert(quests[quest.Type], quest)
end

function pluto.quests.give(ply, new, db)
	mysql_cmysql()

	if (isstring(new)) then
		new = pluto.quests.list[new]
	end
	if (not new) then
		pwarnf("couldn't find quest")
		return false
	end

	local type = new.RewardPool

	local type_data = pluto.quests.bypool[type]

	local progress_needed = new:GetProgressNeeded()
	local reward = pluto.quests.getpoolreward(type)

	local dat, err = mysql_stmt_run(
		db,
		"INSERT INTO pluto_quests_new (owner, quest_name, type, current_progress, total_progress, expiry_time, reward) VALUES (?, ?, ?, 0, ?, TIMESTAMPADD(SECOND, ?, CURRENT_TIMESTAMP), ?)",
		ply:SteamID64(),
		new.ID,
		new.RewardPool,
		progress_needed,
		type_data.Time,
		util.TableToJSON(reward)
	)

	if (not dat) then
		pwarnf("Couldn't give quest!: %s", err)
		return false
	end

	local quest = setmetatable({
		RowID = dat.LAST_INSERT_ID,
		QuestID = new.ID,
		ProgressLeft = progress_needed,
		TotalProgress = progress_needed,
		EndTime = os.time() + type_data.Time,
		Player = ply,
		Type = type,
		QUEST = new,
		TYPE = type_data,
		RewardData = reward
	}, pluto.quests.quest_mt)

	pluto.quests.addto(ply, quest)

	return quest
end

function pluto.quests.init_nocache(ply, cb)
	print("loading - no cache", ply)
	local sid = pluto.db.steamid64(ply)

	pluto.db.transact(function(db)
		mysql_stmt_run(db, "DELETE FROM pluto_quests_new WHERE owner = ? AND expiry_time < CURRENT_TIMESTAMP", sid)
		local dat, err = mysql_stmt_run(db, "SELECT idx, quest_name, CAST(reward as CHAR(1024)) as reward, CAST(type as CHAR(32)) as type, current_progress, total_progress, TIMESTAMPDIFF(SECOND, CURRENT_TIMESTAMP, expiry_time) as expire_diff FROM pluto_quests_new WHERE owner = ?", sid)

		local have = {}
		local types_have = setmetatable({}, {__index = function(self, k) self[k] = 0 return 0 end})
		local quests = pluto.quests.forplayer(ply)

		for _, data in ipairs(dat) do
			local quest_data = pluto.quests.list[data.quest_name]
			if (not quest_data) then
				pwarnf("Unknown quest id %s for %s", tostring(data.quest_name), sid)
				continue
			end

			local quest_type = pluto.quests.bypool[data.type]
			if (not quest_type) then
				pwarnf("Unknown quest type %s for %s", tostring(data.type), sid)
				continue
			end

			if (not quests[quest_type.RewardPool]) then
				quests[quest_type.RewardPool] = {}
			end

			local quest = quests.byid[data.idx] or setmetatable({
				RowID = data.idx,
			}, pluto.quests.quest_mt)

			quest.Type = data.type
			quest.QuestID = data.quest_name
			quest.ProgressLeft = data.total_progress - data.current_progress
			quest.TotalProgress = data.total_progress
			quest.EndTime = os.time() + data.expire_diff
			quest.Player = ply
			quest.RewardData = util.JSONToTable(data.reward)
			quest.Dead = false

			quest.QUEST = quest_data
			quest.TYPE = quest_type

			pluto.quests.addto(ply, quest)

			table.insert(have, quest.QuestID)
			types_have[data.type] = types_have[data.type] + 1
		end

		for _, type in ipairs(pluto.quests.types) do
			if (types_have[type.RewardPool] >= type.Amount) then
				continue
			end

			local quests_of_type = pluto.quests.oftype(type.RewardPool)

			-- clear already gotten ones
			for _, already_have in pairs(have) do
				for i, quest in pairs(quests_of_type) do
					if (quest.ID == already_have) then
						table.remove(quests_of_type, i)
						break
					end
				end
			end
			
			for i = types_have[type], type.Amount - 1 do
				local selected, idx = table.Random(quests_of_type)
				table.remove(quests_of_type, idx)
				if (not pluto.quests.give(ply, selected, db)) then
					pwarnf("couldn't add quest to player: %s", selected.ID)
				end
			end
		end

		mysql_commit(db)

		if (needs_run) then
			pluto.quests.init_nocache(ply, cb)
		else
			for type, quests in pairs(quests) do
				for _, quest in pairs(quests) do
					timer.Create("quest_" .. quest.RowID, quest.EndTime - os.time() + 5, 1, function()
						pluto.quests.delete(quest.RowID)
					end)
				end
			end
			cb(quests)
		end
	end)
end

function pluto.quests.init(ply, _cb)
	if (pluto.quests.loading[ply]) then
		table.insert(pluto.quests.loading[ply], _cb)
		return
	end

	pluto.quests.loading[ply] = {_cb}
	print("loading quests for", ply)

	pluto.quests.init_nocache(ply, function(dat)

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
	net.WriteString(quest.Type)

	net.WriteBool(quest.QUEST.Credits)
	if (quest.QUEST.Credits) then
		net.WriteString(quest.QUEST.Credits)
	end

	net.WriteString(pluto.quests.poolrewardtext(quest.RewardData, quest))

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

	for quest_type, quest_list in pairs(quests) do
		for _, quest in ipairs(quest_list) do
			if (quest.Dead) then
				continue
			end

			net.WriteBool(true)
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
				if (quest.RowID == idx) then
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

function pluto.quests.reset(ply)
	ply:ChatPrint "reloading quests"
	for type, quests in pairs(pluto.quests.byperson[ply] or {}) do
		for _, quest in pairs(quests) do
			quest.Dead = true
		end
	end

	pluto.db.simplequery("DELETE FROM pluto_quests WHERE steamid = ?", {pluto.db.steamid64(ply)}, function(dat)
		if (not dat or not IsValid(ply)) then
			return
		end

		pluto.quests.init(ply, function()
			ply:ChatPrint "reloaded"
		end)
	end)
end


function pluto.quests.reloadfor(ply)
	ply:ChatPrint "reloading quests"
	for type, quests in pairs(pluto.quests.byperson[ply] or {}) do
		for _, quest in pairs(quests) do
			quest.Dead = true
		end
	end

	pluto.quests.init_nocache(ply, function()
		ply:ChatPrint "reloaded"
	end)
end

function pluto.quests.reload()
	for k,v in pairs(player.GetHumans()) do
		pluto.quests.reloadfor(v)
	end
end

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

concommand.Add("pluto_test_pool", function(ply, cmd, args)
	if (not pluto.cancheat(ply)) then
		return
	end

	ply:ChatPrint("pluto_test_pool: Not finished")
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

concommand.Add("pluto_give_quest", function(ply, cmd, args)
	if (not pluto.cancheat(ply)) then
		return
	end

	local quest = pluto.quests.list[args[1]]
	if (quest) then
		pluto.quests.give(ply, 0, quest)
		ply:ChatPrint "given"
	end
end)

hook.Add("PlayerAuthed", "halloween_quest", function(p)
	pluto.db.transact(function(db)
		local quest = pluto.quests.give(p, "halloween_nade", db)
		if (quest) then
		
			pluto.inv.message(p)
				:write("quest", quest)
				:send()
			p:ChatPrint("A unique quest is active! Check your Quests!")
		else
			p:ChatPrint "Couldn't init your unique quest :("
		end
		mysql_commit(db)
	end)
end)