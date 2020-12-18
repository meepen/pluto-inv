
QUEST.Name = "Operation Cheer"
QUEST.Description = "Hit a Total Cheer Level"
QUEST.Color = Color(153, 25, 0)
QUEST.RewardPool = "unique"

function QUEST:GetRewardText()
	return "Dart Pistol"
end

function QUEST:Init(data)
	data:Hook("PlutoToyDelivered", function(data, ply)
		data:UpdateProgress(1)
	end)
end

function QUEST:Reward(data)
	pluto.db.transact(function(db)
		local new_item = pluto.inv.generatebufferweapon(db, data.Player, "unique", "tfa_cso_dartpistol")
		new_item.CreationMethod = "QUEST"
		if (not new_item) then
			mysql_rollback(db)
			return
		end
		mysql_commit(db)

		data.Player:ChatPrint(white_text, "You have received ", startswithvowel(new_item.Tier.Name) and "an " or "a ", new_item, white_text, " for completing ", self.Color, self.Name, white_text, "!")
	end)
end

function QUEST:GetProgressNeeded()
	return 100
end
