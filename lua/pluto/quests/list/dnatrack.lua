--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
QUEST.Name = "Traitor Tracker"
QUEST.Description = "Find the DNA of living traitors from their victims"
QUEST.Color = Color(21, 128, 0)
QUEST.RewardPool = "weekly"

function QUEST:Init(data)
	local collected = {}

	data:Hook("TTTFoundDNA", function(data, ply, own, ent)
		if (not IsValid(ply) or not IsValid(own) or not IsValid(ent)) then
			return
		end

		if (data.Player ~= ply or ent:GetClass() ~= "prop_ragdoll") then
			return
		end

		if (not own:IsPlayer() or own:GetRoleTeam() ~= "traitor") then
			return
		end

		collected[own] = true
	end)

	data:Hook("TTTEndRound", function(data)
		local count = table.Count(collected)
		collected = {}

		if (count > 0) then
			data:UpdateProgress(count)
		end
	end)
end

function QUEST:GetProgressNeeded()
	return math.random(15, 20)
end