ROUND.PrintName = "Tri-Fight"
ROUND.Name = "Tri-Fightt"
ROUND.Author = "add___123"
ROUND.Type = "Special"

--[[function ROUND:TTTPrepareRoles(Team, Role)

end--]]

ROUND:Hook("TTTUpdatePlayerSpeed", function(self, state, ply, data)
	data.trifight = 1.1
end)