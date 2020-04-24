ROUND.Name = "Bunny Attack"

ROUND:Hook("TTTSelectRoles", function(self, state, plys)
	plys = table.shuffle(plys)

	local roles_needed = {
		Child = math.ceil(1, math.floor(#plys / 4)),
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
			role = "Bunny"
		end

		round.Players[i] = {
			Player = ply,
			SteamID = ply:SteamID(),
			Nick = ply:Nick(),
			Role = ttt.roles[role]
		}
	end

	return true
end)

local Doors = {
    "func_door", "func_door_rotating", "prop_door_rotating", "func_breakable"
}

for _, v in pairs(Doors) do
	Doors[v] = true
end

ROUND.EggsPerCluster = 10
ROUND.EggSpread = 150
ROUND:Hook("TTTBeginRound", function(self, state)
	-- remove doors gae
	for _, ent in pairs(ents.GetAll()) do
		if (Doors[ent:GetClass()]) then
			ent:Remove()
		end
	end

	local children = round.GetActivePlayersByRole "Child"
	state.children = children
	local bunnies = round.GetActivePlayersByRole "Bunny"

	state.clusters = {}

	local tries = 1000
	while (#state.clusters < #children) do
		tries = tries - 1
		if (tries <= 0) then
			pwarnf "FAILED TRYING"
			break
		end

		local random, nav = pluto.currency.randompos()

		if (random) then
			local child = table.remove(children, 1)
			local cluster = {random, Player = child}

			local navs = pluto.currency.navs_filter(function(nav)
				return nav:GetClosestPointOnArea(random):Distance(random) < self.EggSpread
			end)

			while (#cluster < self.EggsPerCluster) do
				tries = tries - 1
				if (tries <= 0) then
					break
				end

				for k, nav in pairs(navs) do
					local newpos = nav:GetRandomPoint()
					for _, pos in ipairs(cluster) do
						if (pos:Distance(newpos) < 40) then
							newpos = nil
							break
						end
					end
					if (newpos) then
						cluster[#cluster + 1] = newpos
						if (#cluster >= self.EggsPerCluster) then
							break
						end
					end
				end
			end

			
			table.insert(state.clusters, cluster)
		end
	end

	if (tries <= 0) then
		-- TODO(meep): backup code, spawn randomly
	end

	for _, cluster in pairs(state.clusters) do
		cluster.Player:SetPos(cluster[1])

		cluster.Currencies = {}

		for i, pos in ipairs(cluster) do
			cluster.Currencies[i] = pluto.currency.spawnfor(cluster.Player, "crate3_n", pos, true)
		end
	end
end)

ROUND:Hook("TTTEndRound", function(self, state)
	local children = state.children

	for _, cluster in pairs(state.clusters or {}) do
		for _, ent in ipairs(cluster.Currencies) do
			for _, child in pairs(children) do
				if (not IsValid(ent) or not IsValid(child)) then
					continue
				end

				ent:Reward(child)
			end

			ent:Remove()
		end
	end
end)

ROUND:Hook("PlutoCanPickup", function(self, state, ply, curr)
	return ply:GetRole() == "Bunny"
end)
