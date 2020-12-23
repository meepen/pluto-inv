QUEST.Name = "Craftsman"
QUEST.Description = "Craft weapons with 4 or more mods"
QUEST.Color = Color(153, 102, 7)
QUEST.RewardPool = "weekly"

function QUEST:Init(data)
	data:Hook("PlutoWeaponCrafted", function(data, ply, wpn, items, cur)
		if (data.Player == ply and wpn:GetMaxAffixes() >= 4) then
			data:UpdateProgress(1)
		end
	end)
end

function QUEST:GetProgressNeeded()
	return math.random(12, 16)
end
