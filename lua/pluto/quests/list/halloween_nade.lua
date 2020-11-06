QUEST.Name = "Ghost Buster"
QUEST.Description = "Kill ghosty bois"
QUEST.Color = Color(230, 230, 230)
QUEST.RewardPool = "unique"

function QUEST:GetRewardText()
	return "Jack o Lantern Grenade"
end

function QUEST:Init(data)
	data:Hook("PlutoPlayerKilledGhost", function(data, ply, atk)
		if (ply == data.Player) then
			data:UpdateProgress(1)
		end
	end)
end

function QUEST:Reward(data)
	pluto.db.transact(function(db)
		local new_item = pluto.inv.generatebufferweapon(db, data.Player, "QUEST", "unique", "tfa_cso_pumpkin")
		if (not new_item) then
			mysql_rollback(db)
			return
		end
		mysql_commit(db)

		data.Player:ChatPrint(white_text, "You have received ", startswithvowel(new_item.Tier.Name) and "an " or "a ", new_item, white_text, " for completing ", self.Color, self.Name, white_text, "!")
	end)
end

function QUEST:GetProgressNeeded()
	return 269
end
