QUEST.Name = "Perfect Crime"
QUEST.Description = "Prevent the bodies of your victims from being discovered"
QUEST.Credits = "Froggy & add__123"
QUEST.Color = Color(204, 43, 75)

function QUEST:GetReward(seed)
	local guns = {
		"weapon_cod4_ak47_silencer",
		"weapon_cod4_m4_silencer",
		"weapon_cod4_m14_silencer",
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
	local ragdolls = {}
	data:Hook("PlayerRagdollCreated", function(data, ply, rag, atk)
		print(ply, rag, atk)
		if (atk == data.Player and atk:GetRoleTeam() ~= ply:GetRoleTeam()) then
			ragdolls[rag] = true
		end
	end)

	data:Hook("TTTEndRound", function(data)
		data:UpdateProgress(table.Count(ragdolls))
		ragdolls = {}
	end)

	data:Hook("TTTRWPlayerInspectBody", function(data, ply, ent, pos, is_silent)
		if (not is_silent) then
			ragdolls[ent] = nil
		end
	end)
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