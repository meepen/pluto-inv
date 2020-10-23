QUEST.Name = "Hitman"
QUEST.Description = "Rightfully one-shot players in one round"
QUEST.Credits = "zeBaconcake"
QUEST.Color = Color(204, 61, 5)
QUEST.RewardPool = "hourly"

function QUEST:Init(data)
	local current = 0
	data:Hook("TTTBeginRound", function(data, gren)
		current = 0
	end)

	data:Hook("PlayerDeath", function(data, vic, inf, atk)
		vic.DamageTakens = vic.DamageTakens or {}
		if (vic.DamageTakens[atk] == 1 and atk == data.Player and atk:GetRoleTeam() ~= vic:GetRoleTeam()) then
			current = current + 1

			if (current == data.ProgressLeft) then
				data:UpdateProgress(data.ProgressLeft)
			end
		end
	end)
end

hook.Add("EntityTakeDamage", "oneshot_quest", function(e, dmg)
	if (IsValid(e) and e:IsPlayer() and dmg:GetDamage() > 0 and not dmg:IsDamageType(DMG_DIRECT)) then
		e.DamageTakens = e.DamageTakens or {}
		e.DamageTakens[dmg:GetAttacker()] = (e.DamageTakens[dmg:GetAttacker()] or 0) + 1
	end
end)

hook.Add("TTTBeginRound", "oneshot_quest", function(e, dmg)
	for _, ply in pairs(player.GetAll()) do
		ply.DamageTakens = {}
	end
end)

function QUEST:GetProgressNeeded()
	return math.random(2, 3)
end