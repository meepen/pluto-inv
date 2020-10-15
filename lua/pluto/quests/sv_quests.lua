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
	"postround",
	"healthgain",

	"dnatrack",
	"fourcraft",
	"sacrifices",
	"burn",
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

            pluto.inv.addcurrency(data.Player, self.Currency, amount)

            data.Player:ChatPrint(white_text, "You have received ", amount, " ", cur, amount == 1 and "" or "s", white_text, " for completing ", data.QUEST.Color, data.QUEST.Name, white_text, "!")
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

			pluto.inv.savebufferitem(data.Player, new_item):Run()

			data.Player:ChatPrint(white_text, "You have received ", startswithvowel(new_item.Tier.Name) and "an " or "a ", new_item, white_text, " for completing ", data.QUEST.olor, data.QUEST.Name, white_text, "!")
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
			if (self.ModMin) then
				table.insert(append, " at least " .. tostring(self.ModMin) .. " mods")
			end
			if (self.ModMax) then
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

			pluto.inv.generatebuffershard(data.Player, tier):Run()

			tier = pluto.tiers.byname[tier]

			data.Player:ChatPrint(white_text, "You have received ", startswithvowel(tier.Name) and "an " or "a ", tier.Color, tier.Name, " Tier Shard", white_text, " for completing ", data.QUEST.Color, data.QUEST.Name, white_text, "!")
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
			if (self.ModMin) then
				table.insert(append, " at least " .. tostring(self.ModMin) .. " mods")
			end
			if (self.ModMax) then
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
			Type = "currency",
			Currency = "droplet",
			Amount = 1,
		},
	},
	hourly = {
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
		},
		{
			Type = "weapon",
			ModMin = 3,
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
			ModMin = 4,
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
			Mods = {"hearted",},
			ModMin = 5,
			ModMax = 5,
			Small = "Hearted gun with 5 mods"
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

function QUEST:GetRewardText(seed)
    return pluto.quests.poolrewardtext(self.QUEST.RewardPool, seed)
end

function QUEST:Reward(data)
	pluto.quests.poolreward(self.QUEST.RewardPool, data)
end

local function poolpick(type, seed)
	local typequests = pluto.quests.rewards[type or "unique"]

	if (not typequests) then
		return
	end

	return typequests[math.floor((seed * 100) % 1 * #typequests) + 1]
end

function pluto.quests.poolreward(type, quest)
	local pick = poolpick(type, quest.Seed)

	if (pick) then
		pluto.quests.rewardhandlers[pick.Type].reward(pick, quest)
	end
end

function pluto.quests.poolrewardtext(type, seed)
	local pick = poolpick(type, seed)

	if (pick) then
		return pluto.quests.rewardhandlers[pick.Type].small(pick)
	else
		return "Error: No reward found"
	end
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

function pluto.quests.give(ply, type, new, transact)
	local type_data = pluto.quests.types[type]
	local progress_needed = new:GetProgressNeeded(type)
	local seed = math.random()
	local quests = pluto.quests.byperson[ply] or {
		byid = {},
	}
	local type_quests = quests[type_data.Name]

	pluto.db.transact_or_query(adder,
		"INSERT INTO pluto_quests (steamid, quest_id, type, progress_needed, total_progress, expiry_time, rand) VALUES (?, ?, ?, ?, ?, TIMESTAMPADD(SECOND, ?, CURRENT_TIMESTAMP), ?)",
		{
			ply:SteamID64(),
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
		pluto.quests.byperson[ply] = quests

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

			pluto.quests.byperson[ply].byid[data.idx] = quest
			
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
				if (not new) then
					return
				end

				table.remove(oftype, 1)
				
				pluto.quests.give(ply, type, new, adder)

				needs_run = true
			end
		end

		if (needs_run) then
			adder:AddCallback(function()
				pluto.quests.init_nocache(ply, cb)
			end)
			adder:Run()
		else
			for type, quests in pairs(quests) do
				for _, quest in pairs(quests) do
					timer.Create("quest_" .. quest.RowID, quest.EndTime - os.time() + 5, 1, function()
						print("DELETE", quest.RowID, "OWNED BY", quest.Player)
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
		print("init callback for", ply)
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

	net.WriteBool(quest.QUEST.Credits)
	if (quest.QUEST.Credits) then
		net.WriteString(quest.QUEST.Credits)
	end

	net.WriteString(quest.QUEST.GetRewardText and quest.QUEST:GetRewardText(quest.Seed) or quest:GetRewardText(quest.Seed))

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

	pluto.db.query("DELETE FROM pluto_quests WHERE steamid = ?", {pluto.db.steamid64(ply)}, function(err)
		if (err or not IsValid(ply)) then
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