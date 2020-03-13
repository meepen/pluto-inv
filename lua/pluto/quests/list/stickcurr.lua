QUEST.Name = "Currency Revealer"
QUEST.Description = "Work with other people to stick their currency with a sticky grenade"
QUEST.Color = Color(254, 233, 105)

function QUEST:GetRewardText(seed)
	return "random grenade"
end

function QUEST:Init(data)
	local done = {}
	data:Hook("TTTGrenadeStuck", function(data, gren)
		local parent = gren:GetParent()
		if (not IsValid(parent)) then
			return
		end

		if (parent:GetClass() ~= "pluto_currency") then
			return
		end

		if (parent:GetOwner() == data.Player or done[parent]) then
			return
		end

		done[parent] = true

		data:UpdateProgress(1)
	end)
end

function QUEST:Reward(data)
	-- 8 + math.floor(seed * 3) droplets
end

function QUEST:IsType(type)
	return type == 1
end

function QUEST:GetProgressNeeded(type)
	return math.random(6, 8)
end