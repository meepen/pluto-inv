QUEST.Name = "The Greater Good"
QUEST.Description = "Use Inevitables and Unusuals in crafting"
QUEST.Color = Color(170, 0, 255)
QUEST.RewardPool = "weekly"

function QUEST:Init(data)
	data:Hook("PlutoWeaponCrafted", function(data, ply, wpn, items, cur)
		if (data.Player ~= ply) then
			return
		end

		for _, item in pairs(items) do
			if (item.Tier and item.Tier.InternalName and (item.Tier.InternalName == "inevitable" or item.Tier.InternalName == "unusual")) then
				data:UpdateProgress(1)
			end
		end
	end)
end

function QUEST:IsType(type)
	return type == 3
end

function QUEST:GetProgressNeeded(type)
	return math.random(15, 20)
end
