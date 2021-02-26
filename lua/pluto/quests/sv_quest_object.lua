pluto.quests.mt = pluto.quests.mt or {}

local QUEST = {}
pluto.quests.mt.__index = QUEST

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

	pluto.db.transact(function(db)
		mysql_stmt_run(db, "SELECT current_progress FROM pluto_quests_new WHERE idx = ? FOR UPDATE", self.RowID)
		local succ, err = mysql_stmt_run(db, "UPDATE pluto_quests_new SET current_progress = (@cur_prog:=LEAST(total_progress, current_progress + ?)) WHERE current_progress < total_progress AND idx = ?", amount, self.RowID)
		if (not succ or succ.AFFECTED_ROWS == 0) then
			return
		end

		local succ, err = mysql_stmt_run(db, "SELECT @cur_prog as current_progress")
		if (succ and succ[1].current_progress == self.TotalProgress) then
			self:Complete()
		end

		self.ProgressLeft = math.max(0, self.ProgressLeft - amount)
		mysql_commit(db)

		pluto.inv.message(self.Player)
			:write("quest", self)
			:send()
	end)
end

function QUEST:Complete()
	pluto.db.simplequery("UPDATE pluto_quests_new SET expiry_time = LEAST(expiry_time, TIMESTAMPADD(SECOND, ?, CURRENT_TIMESTAMP)) WHERE idx = ?", {self.TYPE.Cooldown, self.RowID}, function(d, err)
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
