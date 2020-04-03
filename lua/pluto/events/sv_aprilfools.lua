hook.Remove("TTTBeginRound", "pluto_april_fools", function()
	if (math.random() > 0.95) then
		hook.Remove("TTTBeginRound", "pluto_april_fools")
		for _, ply in pairs(player.GetAll()) do
			for bone = 0, ply:GetBoneCount() - 1 do
				ply:ManipulateBoneJiggle(bone, 1)
			end
		end
	end
end)
