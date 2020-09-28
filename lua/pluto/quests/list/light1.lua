
QUEST.Name = "Jedi Training"
QUEST.Description = "Kill players with a lightsaber (>5 players on)"
QUEST.Color = Color(7, 162, 247)

function QUEST:GetRewardText(seed)
	return "Lightsaber"
end

function QUEST:Init(data)
	data:Hook("DoPlayerDeath", function(data, ply, atk, dmg)
		if (player.GetCount() < 5) then
			return
		end

		local wep = dmg:GetInflictor()
		if (IsValid(atk) and IsValid(ply) and atk:IsPlayer() and ply:GetRoleTeam() ~= atk:GetRoleTeam() and atk == data.Player and IsValid(wep) and wep:IsWeapon() and rb655_IsLightsaber(wep)) then
			local gun = wep.PlutoGun
			if (not gun) then
				data:UpdateProgress(1)
			end
		end
	end)
end

function QUEST:Reward(data)
	local trans, new_item = pluto.inv.generatebufferweapon(data.Player, "unique", "weapon_rb566_lightsaber")
	trans:Run()

	data.Player:ChatPrint(white_text, "You have received ", startswithvowel(new_item.Tier.Name) and "an " or "a ", new_item, white_text, " for completing ", self.Color, self.Name, white_text, "!")

	pluto.quests.give(data.Player, 0, pluto.quests.list.light2)
end

function QUEST:IsType(type)
	return false -- type == 0
end

function QUEST:GetProgressNeeded(type)
	return 10
end
