hook.Add("TTTRWScoreboardPlayer", "pluto_level", function(ply, add)
	local pnl = add()

	local col = ply:GetPlutoLevelColor()

	if (isfunction(col)) then
		hook.Add("Tick", pnl, function(self)
			self:SetColor(col())
		end)
	else
		pnl:SetColor(col)
	end

	pnl:SetText(ply:GetPlutoLevel())
end)