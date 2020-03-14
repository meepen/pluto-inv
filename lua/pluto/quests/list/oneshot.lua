QUEST.Name = "Hitman"
QUEST.Description = "Rightfully one shot players in one round."
QUEST.Credits = "zeBaconcake"
QUEST.Color = Color(204, 61, 5)

function QUEST:GetRewardText(seed)
	return "random gun with at least 4 mods"
end

function QUEST:Init(data)
	local current = 0
	data:Hook("TTTBeginRound", function(data, gren)
		current = 0
	end)

	data:Hook("PlayerDeath", function(data, vic, inf, atk)
		if (vic.DamageTakens[atk] == 1 and atk == data.Player and atk:GetRoleTeam() ~= vic:GetRoleTeam()) then
			current = current + 1

			if (current == data.ProgressLeft) then
				data:UpdateProgress(data.ProgressLeft)
			end
		end
	end)
end

hook.Add("EntityTakeDamage", "oneshot_quest", function(e, dmg)
	if (IsValid(e) and e:IsPlayer() and dmg:GetDamage() > 0) then
		e.DamageTakens = e.DamageTakens or {}
		e.DamageTakens[dmg:GetAttacker()] = (e.DamageTakens[dmg:GetAttacker()] or 0) + 1
	end
end)
hook.Add("TTTBeginRound", "oneshot_quest", function(e, dmg)
	for _, ply in pairs(player.GetAll()) do
		ply.DamageTakens = {}
	end
end)

function QUEST:Reward(data)
	local gun = baseclass.Get(pluto.weapons.randomgun())
	local tier = pluto.tiers.filter(gun, function(t)
		return t.affixes >= 4
	end)

	local trans, gun = pluto.inv.generatebufferweapon(data.Player, tier, gun)
	trans:Run()

	data.Player:ChatPrint("You have received a ", tier.Color, gun:GetPrintName(), white_text, " for completing ", self.Color, self.Name, white_text, "! Check your inventory.")
end

function QUEST:IsType(type)
	return type == 1
end

function QUEST:GetProgressNeeded(type)
	return math.random(3, 4)
end