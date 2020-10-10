QUEST.Name = "Noob Stomper"
QUEST.Description = "Goomba stomp people rightfully without movement abilities"
QUEST.Credits = "Eppen"
QUEST.Color = Color(204, 43, 75)

function QUEST:GetRewardText(seed)
	return pluto.quests.poolrewardtext("daily", seed)
end

function QUEST:Init(data)
	local failed = false
	data:Hook("TTTBeginRound", function()
		failed = false
	end)
	data:Hook("DoPlayerDeath", function(data, vic, atk, dmg)
		if (failed) then
			return
		end
		if (atk == data.Player and atk:GetRoleTeam() ~= vic:GetRoleTeam() and dmg:IsDamageType(DMG_FALL)) then
			data:UpdateProgress(1)
		end
	end)
	data:Hook("PlutoMovementAbility", function(ply, what)
		failed = true
	end)
end

function QUEST:Reward(data)
	data.Name = self.Name
	data.Color = self.Color
	pluto.quests.poolreward("daily", data)
end

function QUEST:IsType(type)
	return type == 2
end

function QUEST:GetProgressNeeded(type)
	return math.random(10, 15)
end