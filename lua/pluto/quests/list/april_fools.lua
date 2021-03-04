QUEST.Name = "Proper Etiquette"
QUEST.Description = "T-Bag people you have killed"
QUEST.Color = Color(40, 185, 171)
QUEST.RewardPool = "unique"

function QUEST:GetRewardText()
	return "Toilet Paper"
end

function QUEST:Init(data)
	local killed = {}
	local rags = {}
	data:Hook("TTTBeginRound", function(data)
		killed = {}
		rags = {}
	end)

	data:Hook("DoPlayerDeath", function(data, ply, atk)
		if (IsValid(atk) and IsValid(ply) and atk:IsPlayer() and ply:GetRoleTeam() ~= atk:GetRoleTeam() and atk == data.Player) then
			killed[ply] = true
		end
	end)

	data:Hook("PlayerRagdollCreated", function(data, ply, rag)
		rags[ply] = rag
	end)

	data:Hook("KeyPress", function(data, ply, btn)
		if (ply == data.Player and btn == IN_DUCK and ply:IsOnGround() and ply:Alive()) then
			for vic, rag in pairs(rags) do
				if (IsValid(rag) and killed[vic] and rag:GetPos():Distance(ply:GetPos()) <= 75) then
					data:UpdateProgress(1)
					killed[vic] = nil
				end
			end
		end
	end)
end

function QUEST:Reward(db, data)
	local new_item = pluto.inv.generatebufferweapon(db, data.Player, "unique", "weapon_ttt_jiggle_crowbar")
	if (not new_item) then
		mysql_rollback(db)
		return false
	end

	data.Player:ChatPrint(white_text, "You have received ", startswithvowel(new_item.Tier.Name) and "an " or "a ", new_item, white_text, " for completing ", self.Color, self.Name, white_text, "!")

	return true
end

function QUEST:GetProgressNeeded()
	return 200
end
