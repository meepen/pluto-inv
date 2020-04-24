ROUND.PrintName = "Bunny Attack"

if (SERVER) then
	util.AddNetworkString "posteaster_sound"
else
	net.Receive("posteaster_sound", function()
		print "PLAY"
		surface.PlaySound "pluto/blade_of_the_ruined_king.ogg"
	end)
end

function ROUND:TTTPrepareRoles(Team, Role)
	Role("Bunny", "traitor")
		:SetColor(Color(235, 70, 150, 255))
		:SetCalculateAmountFunc(function(total_players)
			return 0
		end)
		:SeenByAll()

	Role("Child", "innocent")
		:SetColor(Color(128, 120, 129))
		:SetCalculateAmountFunc(function(total_players)
			return 0
		end)
end