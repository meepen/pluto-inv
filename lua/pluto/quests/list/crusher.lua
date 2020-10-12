QUEST.Name = "Noob Crusher"
QUEST.Description = "Crush people rightfully without movement abilities"
QUEST.Credits = "Eppen"
QUEST.Color = Color(204, 43, 75)
QUEST.RewardPool = "daily"

function QUEST:Init(data)
	local failed = false
	data:Hook("TTTBeginRound", function()
		failed = false
	end)
	data:Hook("PlutoMovementAbility", function(data, ply, what)
		if data.Player == ply then
			failed = true
		end
	end)
	data:Hook("DoPlayerDeath", function(data, vic, atk, dmg)
		local succ = false

		if (IsValid(atk)) then
			succ = ((not failed and dmg:IsDamageType(DMG_FALL)) or dmg:IsDamageType(DMG_CRUSH)) and atk == data.Player
		elseif (dmg:IsDamageType(DMG_FALL) and vic.was_pushed and data.Player == vic.was_pushed.att and vic.was_pushed.t > CurTime() - 5) then
			succ = true
			atk = vic.was_pushed.att
		end

		if (IsValid(atk) and atk:IsPlayer() and atk:GetRoleTeam() ~= vic:GetRoleTeam() and succ) then
			data:UpdateProgress(1)
		end
	end)
end

function QUEST:IsType(type)
	return type == 2
end

function QUEST:GetProgressNeeded(type)
	return math.random(10, 15)
end