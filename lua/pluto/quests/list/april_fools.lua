QUEST.Name = "Proper Etiquette"
QUEST.Description = "T-Bag people you have killed"
QUEST.Color = Color(40, 185, 171)

function QUEST:GetRewardText(seed)
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

function QUEST:Reward(data)
	local trans, new_item = pluto.inv.generatebufferweapon(data.Player, "unique", "weapon_ttt_jiggle_crowbar")
	trans:Run()

	data.Player:ChatPrint("You have received a ", new_item, white_text, " for completing ", self.Color, self.Name, white_text, "!")
end

function QUEST:IsType(type)
	return false
end

function QUEST:GetProgressNeeded(type)
	return 200
end
