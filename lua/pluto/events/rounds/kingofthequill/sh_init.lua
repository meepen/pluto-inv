ROUND.PrintName = "King of the Quill"
ROUND.Name = "King of the Quill"
ROUND.Author = "add___123"
ROUND.Type = "Special"

function ROUND:TTTPrepareRoles(Team, Role)
	Role("Quill Holder", "traitor")
		:SetColor(Color(255, 213, 0))
		:SetCalculateAmountFunc(function(total_players)
			return 0
		end)
        :SeenByAll()
		:SetCanUseBuyMenu(false)
end

ROUND:Hook("TTTUpdatePlayerSpeed", function(self, state, ply, data)
	if (not state or not state.holder) then
        data.kingofthequill = 1.25
		return
	end

    if ((SERVER and state.holder == ply) or (CLIENT and LocalPlayer():GetRole() == "Quill Holder")) then
	    data.kingofthequill = 0.75
	else
		data.kingofthequill = 1.1
    end
end)