ROUND.Name = "Bunny Attack"
ROUND.EggsPerCluster = 10
ROUND.EggSpread = 150
ROUND.BunnyLives = 3
ROUND.CollisionGroup = COLLISION_GROUP_DEBRIS_TRIGGER

local badasses = {
	"hank",
	"revenant",
	"chimp",
	"doomguy",
}

ROUND.RoundDatas = {
	{
		BunnyModel = "kanna",
		Health = 50,
		ChildModel = badasses,
		Shares = 1,
	},
	{
		BunnyModel = "miku_cupid",
		Health = 100,
		ChildModel = badasses,
		Shares = 1,
	},
	{
		BunnyModel = {"dom_rabbit", "wild_rabbit"},
		Health = 50,
		ChildModel = {"male_child", "female_child"},
		Shares = 15,
	}
}

function ROUND:Prepare(state)
	net.Start "posteaster_sound"
	net.Broadcast()
	state.Data = self.RoundDatas[pluto.inv.roll(self.RoundDatas)]
end

function ROUND:Loadout(ply)
	ply:StripWeapons()
	ply:Give "weapon_ttt_unarmed"
end

ROUND:Hook("TTTSelectRoles", function(self, state, plys)
	plys = table.shuffle(plys)

	local roles_needed = {
		Child = math.max(1, math.floor(#plys / 4)),
	}

	PrintTable(plys)
	PrintTable(roles_needed)

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


		if (role == "Child") then
			ply:StripWeapons()
			ply:Give "tfa_cso_laserfist"
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

local function GetModel(model)
	if (istable(model)) then
		model = table.Random(model)
	end

	return pluto.models[model].Model
end

ROUND:Hook("TTTBeginRound", function(self, state)
	-- remove doors gae
	for _, ent in pairs(ents.GetAll()) do
		if (Doors[ent:GetClass()]) then
			ent:Remove()
		end
	end

	local children = round.GetActivePlayersByRole "Child"
	state.children = table.Copy(children)
	state.lives = {}
	local bunnies = round.GetActivePlayersByRole "Bunny"

	for _, ply in pairs(children) do
		ply:SetModel(GetModel(state.Data.ChildModel))
		ply:SetCollisionGroup(self.CollisionGroup)
	end
	for _, ply in pairs(bunnies) do
		ply:SetModel(GetModel(state.Data.BunnyModel))
		ply:SetHealth(state.Data.Health)
		ply:SetMaxHealth(state.Data.Health)
		state.lives[ply] = self.BunnyLives
		ply:SetCollisionGroup(self.CollisionGroup)
	end

	state.clusters = {}

	local tries = 1000
	while (#children > 0 and tries > 0) do
		tries = tries - 1

		local random, nav = pluto.currency.randompos()

		if (random) then
			local cluster = {random, Player = children[1]}

			local navs = pluto.currency.navs_filter(function(nav)
				return nav:GetClosestPointOnArea(random):Distance(random) < self.EggSpread
			end)

			local spawn_location_tries = 5 * self.EggsPerCluster
			while (#cluster < self.EggsPerCluster) do
				spawn_location_tries = spawn_location_tries - 1
				if (spawn_location_tries <= 0) then
					break
				end

				for k, nav in pairs(navs) do
					local newpos = pluto.currency.validpos(nav)
					if (not newpos) then
						continue
					end

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

			if (spawn_location_tries > 0) then
				table.insert(state.clusters, cluster)
				table.remove(children, 1)
			end
		end
	end

	if (tries <= 0) then
		-- TODO(meep): backup code, spawn randomly
	end

	for _, cluster in pairs(state.clusters) do
		timer.Simple(0, function()
			if (IsValid(cluster.Player)) then
				cluster.Player:SetPos(cluster[1])
			end
		end)

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
			if (not IsValid(ent)) then
				continue
			end

			for _, child in pairs(children) do
				if (not IsValid(child)) then
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

ROUND:Hook("PlayerCanPickupWeapon", function(self, state, ply, wep)
	return wep:GetClass() == "tfa_cso_laserfist" or wep:GetClass() == "weapon_ttt_unarmed"
end)

ROUND:Hook("PostPlayerDeath", function(self, state, ply)
	if (not state.lives) then
		return
	end

	if (state.lives[ply] and state.lives[ply] > 0) then
		timer.Simple(1, function()
			if (IsValid(ply)) then
				ttt.ForcePlayerSpawn(ply)
				state.lives[ply] = state.lives[ply] - 1
				ply:SetHealth(state.Data.Health)
				ply:SetMaxHealth(state.Data.Health)
				ply:SetCollisionGroup(self.CollisionGroup)
			end
		end)
	else
		ttt.CheckTeamWin()
	end
end)

ROUND:Hook("TTTHasRoundBeenWon", function(self, state)
	if (not state.lives) then
		return
	end

	local have_lives = false

	for ply, lives in pairs(state.lives) do
		if (IsValid(ply) and (ply:Alive() or lives > 0)) then
			have_lives = true
			break
		end
	end

	if (not have_lives) then
		return true, "innocent", false
	end

	if (#round.GetActivePlayersByRole "Child" == 0) then
		return true, "traitor", false
	end

	local alive = false

	for _, cluster in pairs(state.clusters) do
		for _, ent in pairs(cluster.Currencies) do
			if (IsValid(ent)) then
				alive = true
				break
			end
		end

		if (alive) then
			break
		end
	end

	if (not alive) then
		return true, "traitor", false
	end

	return false
end)

ROUND:Hook("CanPlayerSuicide", function(self, state, ply)
	if (ply:GetRole() == "Child") then
		return false
	end
end)

ROUND:Hook("PlayerShouldTakeDamage", function(self, state, ply, atk)
	if (IsValid(ply) and IsValid(atk) and atk:IsPlayer() and ply:IsPlayer()) then
		return ply:GetRoleTeam() ~= atk:GetRoleTeam()
	end
end)

function ROUND:PlayerSetModel(state, ply)
	if (ply:GetRoleTeam() == "traitor") then
		ply:SetModel(GetModel(state.Data.BunnyModel))
	else
		ply:SetModel(GetModel(state.Data.ChildModel))
	end

	return true
end
