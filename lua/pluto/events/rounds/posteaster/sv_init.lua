ROUND.Name = "Bunny Attack"
ROUND.EggsPerCluster = 10
ROUND.EggSpread = 170
ROUND.BunnyLives = 3
ROUND.CollisionGroup = COLLISION_GROUP_DEBRIS_TRIGGER

ROUND.BunnySpawnDistances = {
	Min = 7000,
	Max = 12000
}

ROUND.Boss = true

local badasses = {
	"hank",
	"revenant",
	"chimp",
	"doomguy",
}

ROUND.RoundDatas = {
	{
		BunnyModel = "kanna",
		Health = 40,
		ChildModel = badasses,
		Shares = 0,
	},
	{
		BunnyModel = "miku_cupid",
		Health = 70,
		ChildModel = badasses,
		Shares = 0,
	},
	{
		BunnyModel = {"dom_rabbit", "wild_rabbit"},
		Health = 20,
		ChildModel = {"male_child", "female_child"},
		Shares = 15,
	}
}

function ROUND:Prepare(state)
	net.Start "posteaster_sound"
	net.Broadcast()
	state.Data = self.RoundDatas[pluto.inv.roll(self.RoundDatas)]

	timer.Create("pluto_event_timer", 10, 0, function()
		if (not state.lives) then
			return
		end
		for ply, lives in pairs(state.lives) do
			if (IsValid(ply) and not ply:Alive() and lives > 0) then
				ttt.ForcePlayerSpawn(ply)
			end
		end
	end)
end

function ROUND:Finish()
	timer.Remove "pluto_event_timer"
end

function ROUND:Loadout(ply)
	ply:StripWeapons()
	ply:Give "weapon_ttt_unarmed"
end

ROUND:Hook("TTTSelectRoles", function(self, state, plys)
	plys = table.shuffle(plys)

	local roles_needed = {
		Child = math.max(1, math.ceil(#plys / 4)),
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


		if (role == "Child") then
			ply:StripWeapons()
			pluto.NextWeaponSpawn = false
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

function ROUND:BunnySpawn(ply, state)
	local cluster = state.cluster
	for i = 1, 5 do
		local r = self:FindPosition(cluster.SpawnNavs, self.BunnySpawnDistances.Min, self.BunnySpawnDistances.Max)
		if (r) then
			return r
		end
	end
end

function ROUND:FindPosition(navs, distance_min, distance_max)
	distance_min = distance_min or -math.huge
	distance_max = distance_max or math.huge

	for _, nav in RandomPairs(navs) do
		local pos = pluto.currency.validpos(nav.Nav)

		if (not pos) then
			continue
		end

		local dist = nav.Distance + nav.LastPos:Distance(pos)

		if (dist <= distance_max and dist >= distance_min) then
			return pos, nav.Nav
		end
	end
end

function ROUND:ProcessNav(output, nav, max_distance, target, cur_distance)
	if (not output.processed) then
		output.processed = {}
	end

	if (not cur_distance) then
		cur_distance = 0
	end

	for _, area in pairs(nav:GetAdjacentAreas()) do
		local closest = area:GetClosestPointOnArea(target)
		local distance = closest:Distance(target) + cur_distance

		local processed = output.processed[area:GetID()]

		if (processed and processed.Distance < distance) then
			continue
		end

		if (distance < max_distance) then
			local t = processed or {}

			t.Nav = nav
			t.Distance = distance
			t.LastPos = closest

			output.processed[area:GetID()] = t
			table.insert(output, t)
			self:ProcessNav(output, area, max_distance, target, distance)
		end
	end
end

function ROUND:FilterByMinimum(navs, min)
	for i = #navs, 1, -1 do
		local info = navs[i]
		local nav = info.Nav
		
		local size = math.sqrt(nav:GetSizeX() ^ 2 * nav:GetSizeY() ^ 2)
		
		if (size + info.Distance < min) then
			table.remove(navs, i)
		end
	end
end

function ROUND:ProcessNavAreasNear(output, nav, max_distance, target, cur_distance)
	self:ProcessNav(output, nav, max_distance, target, cur_distance)

	output.processed = nil
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

	local tries = 100
	while (tries > 0) do
		tries = tries - 1

		local random, nav
		random, nav = pluto.currency.randompos()

		if (random) then
			local cluster = {random}

			local navs = {}
			self:ProcessNavAreasNear(navs, nav, self.EggSpread * 2 ^ (#children - 1), random)
			
			-- generate navmeshes close to this
			cluster.SpawnNavs = {}
			self:ProcessNavAreasNear(cluster.SpawnNavs, nav, self.BunnySpawnDistances.Max, random)
			self:FilterByMinimum(cluster.SpawnNavs, self.BunnySpawnDistances.Min)

			local amount = self.EggsPerCluster * #children
			local spawn_location_tries = 5 * amount
			while (#cluster < amount) do
				spawn_location_tries = spawn_location_tries - 1
				if (spawn_location_tries <= 0) then
					break
				end

				for k, nav in RandomPairs(navs) do
					local newpos = pluto.currency.validpos(nav.Nav)
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
						if (#cluster >= amount) then
							break
						end
					end
				end
			end

			if (spawn_location_tries > 0) then
				state.cluster = cluster
				break
			end
		end
	end

	if (tries <= 0) then
		-- TODO(meep): backup code, spawn randomly
	end

	local cluster = state.cluster
	cluster.Currencies = {}
	for i, pos in ipairs(cluster) do
		table.insert(cluster.Currencies, pluto.currency.spawnfor(children[math.ceil(i / self.EggsPerCluster)], "crate3_n", pos, true))
	end

	for _, ply in pairs(bunnies) do
		state.lives[ply] = self.BunnyLives
		if (ply:Alive()) then
			self:Initialize(state, ply)
		end
	end

	for _, ply in pairs(children) do
		if (ply:Alive()) then
			self:Initialize(state, ply)
		end
	end
end)

function ROUND:Initialize(state, ply)
	self:PlayerSetModel(state, ply)
	self:Spawn(state, ply)
	local pos = self:ResetPosition(state, ply)
	if (pos) then
		ply.ForcePos = pos
	end
end

ROUND:Hook("SetupMove", function(self, state, ply, mv)
	if (ply.ForcePos) then
		mv:SetOrigin(ply.ForcePos)
		ply.ForcePos = nil
	end
end)

function ROUND:Spawn(state, ply)
	ply:SetCollisionGroup(self.CollisionGroup)
	if (state.lives and state.lives[ply]) then
		state.lives[ply] = state.lives[ply] - 1
		ply:SetHealth(state.Data.Health)
		ply:SetMaxHealth(state.Data.Health)

		ply:ChatPrint("You have ", ply:GetRoleData().Color, state.lives[ply], white_text, " live(s) left in reserve!")
	end
end

ROUND:Hook("PlayerSpawn", ROUND.Spawn)

function ROUND:ResetPosition(state, ply)
	if (not state.cluster) then
		return
	end

	if (ply:GetRoleTeam() == "innocent") then
		for k, pos in RandomPairs(state.cluster) do
			if (isnumber(k)) then
				return pos
			end
		end
	end

	return self:BunnySpawn(ply, state)
end

ROUND:Hook("PlayerSelectSpawnPosition", ROUND.ResetPosition)

ROUND:Hook("TTTEndRound", function(self, state)
	local children = state.children

	for _, ent in ipairs(state.cluster.Currencies) do
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

	if (not state.lives[ply] or state.lives[ply] <= 0) then
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

	for _, ent in pairs(state.cluster.Currencies) do
		if (IsValid(ent)) then
			alive = true
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
