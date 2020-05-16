QUEST.Name = "Noob Stomper"
QUEST.Description = "Goomba stomp people rightfully"
QUEST.Credits = "Eppen"
QUEST.Color = Color(204, 43, 75)

function QUEST:GetRewardText(seed)
	return "legacy egg"
end

function QUEST:Init(data)
	data:Hook("DoPlayerDeath", function(data, vic, atk, dmg)
		if (atk == data.Player and atk:GetRoleTeam() ~= vic:GetRoleTeam() and atk:Health() == atk:GetMaxHealth() and dmg:IsDamageType(DMG_FALL)) then
			data:UpdateProgress(1)
		end
	end)
end

function QUEST:Reward(data)
	local item = table.Random {
		"crate3_n",
		"crate3",
		"crate1",
	}

	pluto.inv.addcurrency(data.Player, item, 2)

	data.Player:ChatPrint(white_text, "You have received a ", pluto.currency.byname[item], white_text, "!")
end

function QUEST:IsType(type)
	return type == 2
end

function QUEST:GetProgressNeeded(type)
	return math.random(10, 15)
end