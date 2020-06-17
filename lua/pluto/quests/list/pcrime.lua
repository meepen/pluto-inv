QUEST.Name = "Perfect Crime"
QUEST.Description = "Prevent the bodies of your victims from being discovered"
QUEST.Credits = "Froggy & add__123"
QUEST.Color = Color(204, 43, 75)

function QUEST:GetReward(seed)
	local guns = {
		"weapon_cod4_ak47_silencer",
		"weapon_cod4_m4_silencer",
		"weapon_cod4_m14_silencer",
		"weapon_cod4_m16_silencer",
		"weapon_cod4_g3_silencer",
		"weapon_cod4_g36c_silencer",
	}
	return baseclass.Get(guns[math.floor(seed * #guns) + 1])
end

function QUEST:GetRewardText(seed)
	local wep = self:GetReward(seed)
	return "uncommon " .. wep.PrintName
end

function QUEST:Init(data)
end

function QUEST:Reward(data)
	local wep = self:GetReward(data.Seed)

	local transact, wep = pluto.inv.generatebufferweapon(data.Player, "uncommon", wep.ClassName)
	transact:Run()

	data.Player:ChatPrint(white_text, "You have received a ", wep, white_text, "!")
end

function QUEST:IsType(type)
	return type == 2
end

function QUEST:GetProgressNeeded(type)
	return math.random(50, 70)
end