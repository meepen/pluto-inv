
concommand.Add("pluto_test_quest", function(ply, cmd, args)
	if (not pluto.cancheat(ply)) then
		return
	end

	local quest = pluto.quests.list[args[1]]

	if (not quest) then
		ply:ChatPrint("No quest found for id ", tostring(args[1]))
		return
	end

	if (quest.Reward) then
		quest:Reward {
			Player = ply
		}
	elseif (quest.RewardPool) then
		pluto.quests.poolreward(pluto.quests.getpoolreward(quest.RewardPool), { QUEST = quest , Player = ply})
	else
		ply:ChatPrint("No quest reward for id ", tostring(args[1]))
	end

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
		local progress = tonumber(args[2]) or 1000
		ply:ChatPrint("Found quest. Adding " .. progress .. " progress.")

		target:UpdateProgress(progress)
	end
end)

concommand.Add("pluto_delete_quests", function(ply, cmd, args)
	if (not pluto.cancheat(ply)) then
		return
	end

	pluto.db.instance(function(db)
		mysql_stmt_run(db, "DELETE FROM pluto_quests_new WHERE owner = ?", ply:SteamID64())
	end)
end)

concommand.Add("pluto_give_quest", function(ply, cmd, args)
	if (not pluto.cancheat(ply)) then
		return
	end

	if (pluto.quests.list[args[1]]) then
		pluto.db.transact(function(db)
			local quest = pluto.quests.give(ply, args[1], db)
			if (quest) then
				pluto.inv.message(ply)
					:write("quest", quest)
					:send()
			end
			mysql_commit(db)
		end)
		ply:ChatPrint("Given quest: " .. args[1])
	end
end)