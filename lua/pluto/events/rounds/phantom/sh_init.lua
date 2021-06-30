ROUND.PrintName = "Phantom Fight"
ROUND.Name = "Phantom Fight"
ROUND.Author = "add___123"
ROUND.Type = "Special"

--[[function ROUND:TTTPrepareRoles(Team, Role)

end--]]

ROUND:Hook("TTTUpdatePlayerSpeed", function(self, state, ply, data)
	data.phantom = 1.2
end)