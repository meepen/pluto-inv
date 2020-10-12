QUEST.Name = "Craftsman"
QUEST.Description = "Craft weapons with 4 or more mods"
QUEST.Color = Color(153, 102, 7)

function QUEST:GetRewardText(seed)
	return pluto.quests.poolrewardtext("weekly", seed)
end

function QUEST:Init(data)
	data:Hook("PlutoWeaponCrafted", function(data, ply, wpn, items, cur)
		if (data.Player == ply and wpn:GetMaxAffixes() >= 4) then
			data:UpdateProgress(1)
		end
	end)
end

function QUEST:Reward(data)
	data.Name = self.Name
	data.Color = self.Color
	pluto.quests.poolreward("weekly", data)
end

function QUEST:IsType(type)
	return type == 3
end

function QUEST:GetProgressNeeded(type)
	return math.random(20, 30)
end
