ROUND.Name = "Bunny Attack"

ROUND:Hook("TTTSelectRoles", function(self, state, plys)
	PrintTable(state)
	local roles_needed = {
		Bunny = math.ceil(1, math.floor(#plys / 4)),
	}

	for i, ply in ipairs(plys) do
		local role, amt = next(roles_needed)
		if (role) then
			if (amt == 1) then
				roles_needed[role] = nil
			else
				roles_needed[role] = amt - 1
			end
		else
			role = "Child"
		end

		round.Players[i] = {
			Player = ply,
			SteamID = ply:SteamID(),
			Nick = ply:Nick(),
			Role = ttt.roles[role]
		}
		print(ply, role)
	end

	print "yes"
	return true
end)
