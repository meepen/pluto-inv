-- Author: Meepen

if (SERVER) then
	hook.Add("TTTBeginRound", "pluto_mini_aprilfools", function()
		if (ttt.GetCurrentRoundEvent() ~= "") then
			return
		end

		if (not pluto.rounds or not pluto.rounds.minis) then
			return
		end

		if (not pluto.rounds.minis.aprilfools and true) then -- math.random() > 0.95
			return
		end

		pluto.rounds.minis.aprilfools = nil

		--hook.Remove("TTTBeginRound", "pluto_mini_aprilfools")
		for _, ply in pairs(player.GetAll()) do
			for bone = 0, ply:GetBoneCount() - 1 do
				ply:ManipulateBoneJiggle(bone, 1)
			end
		end
	end)
else

end
