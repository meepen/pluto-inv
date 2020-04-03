QUEST.Name = "Floor Licker"
QUEST.Description = "Kill players rightfully with floor weapons."
QUEST.Credits = "Mia Fey"
QUEST.Color = Color(24, 125, 216)

function QUEST:GetRewardText(seed)
	return "random gun with greed modifier"
end

function QUEST:Init(data)
	data:Hook("PlayerDeath", function(data, vic, inf, atk)
		if (ttt.GetRoundState() == ttt.ROUNDSTATE_ACTIVE and atk == data.Player and atk:GetRoleTeam() ~= vic:GetRoleTeam() and inf.FloorWeapon) then
			data:UpdateProgress(1)
		end
	end)
end

function QUEST:Reward(data)
	local gun = baseclass.Get(pluto.weapons.randomgun())
	local tier = pluto.tiers.filter(gun, function(t)
		return t.affixes >= 3
	end)

	local trans, gun = pluto.inv.generatebufferweapon(data.Player, tier, gun)
	trans:Run()

	data.Player:ChatPrint("You have received a ", gun, white_text, " for completing ", self.Color, self.Name, white_text, "! Check your inventory.")
end

function QUEST:IsType(type)
	return type == 1
end

function QUEST:GetProgressNeeded(type)
	return math.random(10, 15)
end
