QUEST.Name = "The Collector"
QUEST.Description = "Collect currencies from mini-events"
QUEST.Color = Color(212, 0, 255)
QUEST.RewardPool = "weekly"

function QUEST:Init(data)
	data:Hook("PlutoCurrencyPickup", function(data, cur, ply)
		if (not IsValid(cur) or not IsValid(ply) or data.Player ~= ply) then
			return
		end

		local name = cur:GetCurrencyType()
		local movetype = cur:GetMovementType()

		if (name == "_shootingstar" or name == "_chancedice" or movetype == CURRENCY_MOVEDOWN) then
			data:UpdateProgress(1)
		end
	end)
end

function QUEST:GetProgressNeeded()
	return math.random(60, 75)
end