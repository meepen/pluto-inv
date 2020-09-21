QUEST.Name = "Floor Licker"
QUEST.Description = "Kill players rightfully with floor weapons"
QUEST.Credits = "Mia Fey"
QUEST.Color = Color(24, 125, 216)

function QUEST:GetRewardText(seed)
	return "legacy egg"
end

function QUEST:Init(data)
	data:Hook("PlayerDeath", function(data, vic, inf, atk)
		if (ttt.GetRoundState() == ttt.ROUNDSTATE_ACTIVE and atk == data.Player and atk:GetRoleTeam() ~= vic:GetRoleTeam() and inf.FloorWeapon) then
			data:UpdateProgress(1)
		end
	end)
end

function QUEST:Reward(data)
	local item = pluto.inv.roll {
		crate3_n = 10,
		crate3 = 1,
		crate1 = 10,
	}

	pluto.inv.addcurrency(data.Player, item, 1)

	local cur = pluto.currency.byname[item]
	data.Player:ChatPrint(white_text, "You have received ", startswithvowel(cur.Name) and "an " or "a ", cur, white_text, " for completing ", self.Color, self.Name, white_text, "!")
end

function QUEST:IsType(type)
	return type == 1
end

function QUEST:GetProgressNeeded(type)
	return math.random(10, 15)
end
