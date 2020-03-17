QUEST.Name = "Clubber"
QUEST.Description = "Hit people rightfully with a melee, then kill them"
QUEST.Credits = "Phrot"
QUEST.Color = Color(204, 61, 5)

function QUEST:GetReward(seed)
	return pluto.currency.byname[seed < 0.5 and "aciddrop" or "pdrop"]
end

function QUEST:GetRewardText(seed)
	local cur = self:GetReward(seed)
	return cur.Name
end

function QUEST:Init(data)
	local meleed = {}
	data:Hook("TTTBeginRound", function(data, gren)
		meleed = {}
	end)

	data:Hook("EntityTakeDamage", function(data, vic, dmg)
		local inf, atk = dmg:GetInflictor(), dmg:GetAttacker()

		if (IsValid(inf) and atk == data.Player and inf.Slot == 0 and atk:GetRoleTeam() ~= vic:GetRoleTeam()) then
			meleed[vic] = true
		end
	end)

	data:Hook("PlayerDeath", function(data, vic, inf, atk)
		if (atk == data.Player and atk:GetRoleTeam() ~= vic:GetRoleTeam() and meleed[vic]) then
			data:UpdateProgress(1)
		end
	end)
end

function QUEST:Reward(data)
	local cur = self:GetReward(seed)
	pluto.inv.addcurrency(data.Player, cur.InternalName, 1, function(succ)
		data.Player:ChatPrint("You have received a ", cur.Color, cur.Name, white_text, " for completing ", self.Color, self.Name)
	end)
end

function QUEST:IsType(type)
	return type == 1
end

function QUEST:GetProgressNeeded(type)
	return math.random(4, 5)
end
