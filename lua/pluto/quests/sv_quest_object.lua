pluto.quests.mt = pluto.quests.mt or {}

local QUEST = {}
pluto.quests.mt.__index = QUEST

function pluto.quests.mt.__tostring(self)
	return string.format("Quest [%i] (%s) for player %s", self.RowID, self.QuestID, tostring(self.Player))
end

function QUEST:IsValid()
	return self.EndTime > os.time() and IsValid(self.Player) and self.ProgressLeft > 0 and self.RowID
end

function QUEST:Hook(event, fn)
	hook.Add(event, self, fn)
end

function QUEST:SelectForUpdate(db)
	mysql_cmysql()
	mysql_stmt_run(db, "SELECT current_progress FROM pluto_quests_new WHERE idx = ? FOR UPDATE", self.RowID)
end

function QUEST:UpdateProgress(amount)
	if (amount == 0) then
		return
	end

	local p = self.Player
	if (IsValid(p) and p.Punishments and p.Punishments.questban and p.Punishments.questban.Ending > os.time()) then
		return
	end

	if (self.ProgressLeft <= 0) then
		return
	end

	pluto.db.transact(function(db)
		self:SelectForUpdate(db)
		mysql_stmt_run(db, "SELECT current_progress FROM pluto_quests_new WHERE idx = ? FOR UPDATE", self.RowID)
		local succ, err = mysql_stmt_run(db, "UPDATE pluto_quests_new SET current_progress = (@cur_prog:=LEAST(total_progress, current_progress + ?)) WHERE current_progress < total_progress AND idx = ?", amount, self.RowID)
		if (not succ or succ.AFFECTED_ROWS == 0) then
			pluto.warn("QUEST", self, " AFFECTED_ROWS = " .. succ.AFFECTED_ROWS, " tried to add ", amount)
			return
		end
		self.ProgressLeft = math.max(0, self.ProgressLeft - amount)

		local succ, err = mysql_stmt_run(db, "SELECT @cur_prog as current_progress")
		if (succ and succ[1].current_progress == self.TotalProgress) then
			pluto.message("QUEST", self, " completed. Running reward code.")
			if (not self:Complete(db)) then
				pluto.error("QUEST", "Quest Complete failed for ", self)
				mysql_rollback(db)
				return
			end
		end

		mysql_commit(db)
		self:NotifyUpdate()
	end)
end

function QUEST:Complete(db)
	mysql_cmysql()
	self:SelectForUpdate(db)
	PrintTable(mysql_stmt_run(db, "UPDATE pluto_quests_new SET expiry_time = LEAST(expiry_time, TIMESTAMPADD(SECOND, ?, CURRENT_TIMESTAMP)) WHERE idx = ?", self:GetQuestTypeData().Cooldown, self.RowID))

	local QUESTDATA = self:GetQuestData()
	local success = false
	if (QUESTDATA.Reward) then
		success = QUESTDATA:Reward(db, self)
	elseif (self.Reward) then
		success = self:Reward(db)
	end

	if (not success) then
		pluto.error("QUEST", "Quest reward failed for ", self)
		mysql_rollback(db)
		return false
	end

	self.EndTime = math.min(self.EndTime, os.time() + self:GetQuestTypeData().Cooldown)

	self:UpdateEndTime()

	return true
end

function QUEST:NotifyUpdate()
	pluto.inv.message(self.Player)
		:write("quest", self)
		:send()	
end

function QUEST:UpdateEndTime()
	timer.Create("pluto_quest_" .. self.RowID, self.EndTime - os.time(), 1, function()
		if (not IsValid(self.Player)) then
			return
		end

		pluto.quests.delete(self)
	end)
end

function QUEST:GetRewardText()
    return pluto.quests.poolrewardtext(self.RewardData, self)
end

function QUEST:Reward(db)
	hook.Run("PlutoQuestCompleted", self.Player, self, self.Type)
	return pluto.quests.poolreward(self.RewardData, db, self)
end

function QUEST:GetQuestData()
	return pluto.quests.byname[self.QuestID]
end

function QUEST:GetQuestTypeData()
	return pluto.quests.bypool[self.Type]
end

function pluto.quests.getpoolreward(type)
	local typequests = pluto.quests.rewards[type]

	return typequests and typequests[pluto.inv.roll(typequests)] or { Type="unique" }
end
