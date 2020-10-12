QUEST.Name = "The Greater Good"
QUEST.Description = "Sacrifice Inevitables and Unusuals"
QUEST.Color = Color(170, 0, 255)
QUEST.RewardPool = "weekly"

function QUEST:Init(data)
	data:Hook("PlutoWeaponCrafted", function(data, ply, wpn, items, cur)
		if (data.Player ~= ply) then
			return
		end

		for _, item in ipairs(items) do
			if (item.Type == "Weapon" and (item.Tier.Name == "Inevitable" or item.Tier.Name == "Unusual")) then
				data:UpdateProgress(1)
			end
		end
	end)
end

function QUEST:IsType(type)
	return type == 3
end

function QUEST:GetProgressNeeded(type)
	return math.random(20, 25)
end
