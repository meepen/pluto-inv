ROUND.Reward = "tp"
ROUND.WinnerEarnings = 10
ROUND.SecondEarnings = 5
ROUND.CollisionGroup = COLLISION_GROUP_DEBRIS_TRIGGER
ROUND.Health = 250

ROUND.Boss = true

local WriteRoundData = pluto.rounds.WriteRoundData

function ROUND:Prepare(state)
	timer.Pause "tttrw_afk"

	local spawns = {}
	for i = 1, 10 do
		spawns[i] = pluto.currency.randompos(hull_mins, hull_maxs)
	end

	local redspawn
	local bluespawn
	local best_dist = 0

	for i = 1, #spawns do
		if (not redspawn) then
			redspawn = spawns[i]
		end

		for j = i + 1, #spawns do
			if (not bluespawn) then
				bluespawn = spawns[j]
			end

			local cur_dist = spawns[i]:DistToSqr(spawns[j])
			if (cur_dist > best_dist) then
				best_dist = cur_dist
				redspawn = spawns[i]
				bluespawn = spawns[j]
			end
		end
	end

	spawns = {}
	for i = 1, 15 do
		spawns[i] = pluto.currency.randompos(hull_mins, hull_maxs)
	end

	local greenspawn
	best_dist = 0

	for i = 1, #spawns do
		if (not greenspawn) then
			greenspawn = spawns[i]
		end

		local cur_dist = spawns[i]:DistToSqr(redspawn) * spawns[i]:DistToSqr(bluespawn)

		if (cur_dist > best_dist) then
			best_dist = cur_dist
			greenspawn = spawns[i]
		end
	end

	state.redspawn = redspawn
	state.greenspawn = greenspawn
	state.bluespawn = bluespawn

	timer.Create("pluto_event_timer", 5, 0, function()
		if (state.red) then
			for k, ply in ipairs(state.red) do
				if (IsValid(ply) and not ply:Alive()) then
					ttt.ForcePlayerSpawn(ply)
					state.spawntime[ply] = CurTime()
				end
			end
		end
		if (state.green) then
			for k, ply in ipairs(state.green) do
				if (IsValid(ply) and not ply:Alive()) then
					ttt.ForcePlayerSpawn(ply)
					state.spawntime[ply] = CurTime()
				end
			end
		end
		if (state.blue) then
			for k, ply in ipairs(state.blue) do
				if (IsValid(ply) and not ply:Alive()) then
					ttt.ForcePlayerSpawn(ply)
					state.spawntime[ply] = CurTime()
				end
			end
		end
	end)
end

function ROUND:Finish()
	timer.Remove "pluto_event_timer"
end

function ROUND:Loadout(ply)
	pluto.rounds.GiveDefaults(ply, true)
end

ROUND:Hook("TTTSelectRoles", function(self, state, plys)
	plys = table.shuffle(plys)

	for i, ply in ipairs(plys) do
		pluto.rounds.GiveDefaults(ply, true)

		local role = ttt.roles.Red
		if (i % 3 == 1) then
			role = ttt.roles.Green
		elseif (i % 3 == 2) then
			role = ttt.roles.Blue
		end

		round.Players[i] = {
			Player = ply,
			SteamID = ply:SteamID(),
			Nick = ply:Nick(),
			Role = role
		}
	end

	return true
end)

local Doors = {
	"func_door", "func_door_rotating", "prop_door_rotating", "func_breakable", "func_breakable_surf"
}

for _, v in pairs(Doors) do
	Doors[v] = true
end

ROUND:Hook("TTTBeginRound", function(self, state)
	for _, ent in pairs(ents.GetAll()) do
		if (Doors[ent:GetClass()]) then
			ent:Remove()
		end
	end

	local reds = round.GetActivePlayersByRole "Red"
	local greens = round.GetActivePlayersByRole "Green"
	local blues = round.GetActivePlayersByRole "Blue"
	state.red = {}
	state.redkills = {}
	state.green = {}
	state.greenkills = {}
	state.blue = {}
	state.bluekills = {}
	state.spawntime = {}

	for k, ply in ipairs(reds) do
		state.red[#state.red + 1] = ply
		state.redkills[ply] = 0
		state.spawntime[ply] = CurTime()
		if (ply:Alive()) then
			self:Initialize(state, ply)
		end
		ply:SetMaxHealth(self.Health)
		ply:SetHealth(self.Health)
	end

	for k, ply in ipairs(greens) do
		state.green[#state.green + 1] = ply
		state.greenkills[ply] = 0
		state.spawntime[ply] = CurTime()
		if (ply:Alive()) then
			self:Initialize(state, ply)
		end
		ply:SetMaxHealth(self.Health)
		ply:SetHealth(self.Health)
	end

	for k, ply in ipairs(blues) do
		state.blue[#state.blue + 1] = ply
		state.bluekills[ply] = 0
		state.spawntime[ply] = CurTime()
		if (ply:Alive()) then
			self:Initialize(state, ply)
		end
		ply:SetMaxHealth(self.Health)
		ply:SetHealth(self.Health)
	end

	self:WriteScores(state)

	GetConVar("ttt_karma"):SetBool(false)
	
	timer.Simple(1, function()
		round.SetRoundEndTime(CurTime() + 240)
		ttt.SetVisibleRoundEndTime(CurTime() + 240)
	end)
end)

ROUND:Hook("PostPlayerDeath", function(self, state, ply)
	ply:Extinguish()
	return true
end)

function ROUND:Initialize(state, ply)
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
	ply:SetMaxHealth(self.Health)
	ply:SetHealth(self.Health)
end

ROUND:Hook("PlayerSpawn", ROUND.Spawn)

local hull_mins, hull_maxs = Vector(-22, -22, 0), Vector(22, 22, 90)

function ROUND:ResetPosition(state, ply)
	if (not state) then
		return pluto.currency.randompos(hull_mins, hull_maxs)
	end

	if (ply:GetRole() == "Red" and state.redspawn) then
		return state.redspawn
	elseif(ply:GetRole() == "Green" and state.greenspawn) then
		return state.greenspawn
	elseif(ply:GetRole() == "Blue" and state.bluespawn) then
		return state.bluespawn
	end

	return pluto.currency.randompos(hull_mins, hull_maxs)
end

ROUND:Hook("PlayerSelectSpawnPosition", ROUND.ResetPosition)

function ROUND:TTTEndRound(state)
	if (not state) then
		return
	end
	
	local first, second, third = self:WriteScores(state, true)

	if (state[first]) then
		local winnerrole = string.upper(string.sub(first, 1, 1)) .. string.sub(first, 2)
		pluto.rounds.Notify(winnerrole .. " is the winning team!", ttt.roles[winnerrole].Color)
		hook.Run("PlutoSpecialWon", state[first])
		for k, ply in ipairs(state[first]) do
			pluto.db.instance(function(db)
				pluto.inv.addcurrency(db, ply, self.Reward, self.WinnerEarnings)
				pluto.rounds.Notify(string.format("You get %i Refinium Vials for winning!", self.WinnerEarnings), pluto.currency.byname[self.Reward].Color, ply)
			end)
		end
		if (state[second]) then
			for k, ply in ipairs(state[second]) do
				pluto.db.instance(function(db)
					pluto.inv.addcurrency(db, ply, self.Reward, self.SecondEarnings)
					pluto.rounds.Notify(string.format("You get %i Refinium Vials for placing second!", self.SecondEarnings), pluto.currency.byname[self.Reward].Color, ply)
				end)
			end
		end
	else
		pluto.rounds.Notify("No winners here...")
	end

	GetConVar("ttt_karma"):Revert()

	timer.UnPause("tttrw_afk")
end

function ROUND:UpdateScore(state, ply)
	state = state or pluto.rounds.state

	if (not state.redkills or not state.greenkills or not state.bluekills) then
		return
	end

	if (state.redkills[ply]) then
		state.redkills[ply] = state.redkills[ply] + 1
	elseif (state.greenkills[ply]) then
		state.greenkills[ply] = state.greenkills[ply] + 1
	elseif (state.bluekills[ply]) then
		state.bluekills[ply] = state.bluekills[ply] + 1
	end

	self:WriteScores(state)
end

function ROUND:WriteScores(state, order)
	state = state or pluto.rounds.state

	if (not state.red or not state.green or not state.blue) then
		return
	end

	local red = 0
	local green = 0
	local blue = 0

	for ply, score in pairs(state.redkills) do
		red = red + score
	end

	WriteRoundData("redkills", red)

	for ply, score in pairs(state.greenkills) do
		green = green + score
	end
	
	WriteRoundData("greenkills", green)

	for ply, score in pairs(state.bluekills) do
		blue = blue + score
	end
	
	WriteRoundData("bluekills", blue)

	if (not order) then
		return
	end

	local sorted = {}

	table.insert(sorted, {
		Team = "red",
		Score = red,
	})

	table.insert(sorted, {
		Team = "green",
		Score = green,
	})

	table.insert(sorted, {
		Team = "blue",
		Score = blue,
	})

	table.SortByMember(sorted, "Score")

	return sorted[1].Team, sorted[2].Team, sorted[3].Team
end

--[[ROUND:Hook("PlayerCanPickupWeapon", function(self, state, ply, wep)
	return
end)--]]

ROUND:Hook("TTTHasRoundBeenWon", function(self, state)
	state = state or pluto.rounds.state

	if (#round.GetActivePlayersByRole "red" == 0 and #round.GetActivePlayersByRole "green" == 0 and #round.GetActivePlayersByRole "blue" == 0) then
		return true, "traitor", false
	end

	return false
end)

ROUND:Hook("PlayerDisconnected", function(self, state, ply)
	state = state or pluto.rounds.state

	if (not IsValid(ply)) then
		return
	end

	if (state.redkills[ply]) then
		state.redkills[ply] = nil
		table.remove(state.red, table.KeyFromValue(state.red, ply))
	elseif (state.greenkills[ply]) then
		state.greenkills[ply] = nil
		table.remove(state.green, table.KeyFromValue(state.green, ply))
	elseif (state.bluekills[ply]) then
		state.bluekills[ply] = nil
		table.remove(state.blue, table.KeyFromValue(state.blue, ply))
	end

	self:WriteScores(state)
end)

ROUND:Hook("PlayerDeath", function(self, state, vic, inf, atk)
	state = state or pluto.rounds.state

	if (not IsValid(vic)) then
		return 
	end

	if (not IsValid(atk) or not atk:IsPlayer()) then
		return
	end

	self:UpdateScore(state, atk)
end)

ROUND:Hook("PlayerShouldTakeDamage", function(self, state, ply, atk)
	if (IsValid(ply) and IsValid(atk) and atk:IsPlayer() and ply:IsPlayer()) then
		return (ply:GetRoleTeam() ~= atk:GetRoleTeam() and (state and state.spawntime and state.spawntime[ply] and state.spawntime[ply] + 3 < CurTime()))
	end
end)

--[[ROUND:Hook("PlayerCanHearPlayersVoice", function(self, state, listener, speaker)
	if (IsValid(speaker) and IsValid(listener)) then
		return listener:GetRoleTeam() == speaker:GetRoleTeam()
	end
end)

ROUND:Hook("PlayerCanSeePlayersChat", function(self, state, text, _, listener, speaker)
	if (IsValid(speaker) and IsValid(listener)) then
		return listener:GetRoleTeam() == speaker:GetRoleTeam()
	end
end)--]]

--[[ROUND:Hook("PlayerRagdollCreated", function(self, state, ply, rag, atk, dmg)
	timer.Simple(5, function()
		if (IsValid(rag)) then
			rag:Remove()
		end
	end)
end)--]]

--[[function ROUND:PlayerSetModel(state, ply)

end--]]