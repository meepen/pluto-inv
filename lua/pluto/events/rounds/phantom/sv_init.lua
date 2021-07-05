ROUND.Reward = "tp"
ROUND.WinnerEarnings = 10
ROUND.CollisionGroup = COLLISION_GROUP_DEBRIS_TRIGGER

ROUND.Boss = true

local WriteRoundData = pluto.rounds.WriteRoundData

function ROUND:Prepare(state)
	timer.Pause "tttrw_afk"

	local spawns = {}
	for i = 1, 15 do
		spawns[i] = pluto.currency.randompos(hull_mins, hull_maxs)
	end

	local redspawn
	local bluespawn
	local best_dist

	for i = 1, #spawns do
		if (not redspawn) then
			redspawn = spawns[i]
		end

		for j = i + 1, #spawns do
			if (not bluespawn) then
				bluespawn = spawns[j]
				best_dist = redspawn:DistToSqr(bluespawn)
			end

			local cur_dist = spawns[i]:DistToSqr(spawns[j])
			if (cur_dist > best_dist) then
				best_dist = cur_dist
				redspawn = spawns[i]
				bluespawn = spawns[j]
			end
		end
	end

	state.redspawn = redspawn
	state.bluespawn = bluespawn
end

--[[function ROUND:Finish()

end--]]

function ROUND:Loadout(ply)
	pluto.rounds.GiveDefaults(ply)
end

ROUND:Hook("TTTSelectRoles", function(self, state, plys)
	plys = table.shuffle(plys)

	local red = true

	for i, ply in ipairs(plys) do
		pluto.rounds.GiveDefaults(ply)

		local role = ttt.roles.Blue
		if (red) then
			red = false
			role = ttt.roles.Red
		else
			red = true
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
	local blues = round.GetActivePlayersByRole "Blue"
	state.red = {}
	state.redliving = {}
	state.blue = {}
	state.blueliving = {}

	for k, ply in pairs(reds) do
		state.red[#state.red + 1] = ply
		state.redliving[ply] = true
		if (ply:Alive()) then
			self:Initialize(state, ply)
		end
		ply:SetMaxHealth(250)
		ply:SetHealth(250)
	end

	for k, ply in pairs(blues) do
		state.blue[#state.blue + 1] = ply
		state.blueliving[ply] = true
		if (ply:Alive()) then
			self:Initialize(state, ply)
		end
		ply:SetMaxHealth(250)
		ply:SetHealth(250)
	end

	self:WriteLiving(state)

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
	ply:SetMaxHealth(250)
	ply:SetHealth(250)
end

ROUND:Hook("PlayerSpawn", ROUND.Spawn)

local hull_mins, hull_maxs = Vector(-22, -22, 0), Vector(22, 22, 90)

function ROUND:ResetPosition(state, ply)
	if (not state) then
		return pluto.currency.randompos(hull_mins, hull_maxs)
	end

	if (ply:GetRole() == "Red" and state.redspawn) then
		return state.redspawn
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

	if (state.winner) then
		local winnerrole = string.upper(string.sub(state.winner, 1, 1)) .. string.sub(state.winner, 2)
		pluto.rounds.Notify(winnerrole .. " is the winning team!", ttt.roles[winnerrole].Color)
		for k, ply in ipairs(state[state.winner]) do
			
			pluto.db.instance(function(db)
				pluto.inv.addcurrency(db, ply, self.Reward, self.WinnerEarnings)
				pluto.rounds.Notify(string.format("You get %i Refinium Vials for winning!", self.WinnerEarnings), pluto.currency.byname[self.Reward].Color, ply)
			end)
		end
	else
		pluto.rounds.Notify("No winners here...")
	end

	GetConVar("ttt_karma"):Revert()

	timer.UnPause("tttrw_afk")
end

function ROUND:RemovePlayer(state, ply, disconnected)
	if (not state) then
		return 
	end

	if (state.redliving[ply]) then
		state.redliving[ply] = nil
		local key = table.KeyFromValue(state.red, ply)
		if (disconnected and key) then
			table.remove(state.red, key)
		end
		if (table.Count(state.redliving) == 0) then
			state.winner = "blue"
			ttt.CheckTeamWin()
		end
	elseif (state.blueliving[ply]) then
		state.blueliving[ply] = nil
		local key = table.KeyFromValue(state.blue, ply)
		if (disconnected and key) then
			table.remove(state.blue, key)
		end
		if (table.Count(state.blueliving) == 0) then
			state.winner = "red"
			ttt.CheckTeamWin()
		end
	end

	self:WriteLiving(state)
end

function ROUND:WriteLiving(state)
	if (not state or not state.red or not state.blue) then
		return
	end

	for k, ply in ipairs(state.red) do
		WriteRoundData("teamlives", table.Count(state.redliving), ply)
		WriteRoundData("enemylives", table.Count(state.blueliving), ply)
	end

	for k, ply in ipairs(state.blue) do
		WriteRoundData("enemylives", table.Count(state.redliving), ply)
		WriteRoundData("teamlives", table.Count(state.blueliving), ply)
	end
end

--[[ROUND:Hook("PlayerCanPickupWeapon", function(self, state, ply, wep)
	return
end)--]]

ROUND:Hook("TTTHasRoundBeenWon", function(self, state)
	state = state or pluto.rounds.state

	if (state.winner) then
		return true, state.winner, false
	end

	if (not state.redliving or not state.blueliving) then
		return
	end

	if (table.Count(state.redliving) == 0) then
		state.winner = "blue"
		return true, "blue", false
	elseif (table.Count(state.blueliving) == 0) then
		state.winner = "red"
		return true, "red", false
	end

	return false
end)

ROUND:Hook("PlayerDisconnected", function(self, state, ply)
	if (not state) then
		return
	end

	self:RemovePlayer(state, ply, true)
end)

ROUND:Hook("PlayerDeath", function(self, state, vic, inf, atk)
	if (not IsValid(vic) or not state) then
		return
	end

	self:RemovePlayer(state, vic)

	pluto.rounds.Notify("You have died, but you can still speak to guide your teammates!", Color(160, 160, 170), vic)
end)

ROUND:Hook("PlayerShouldTakeDamage", function(self, state, ply, atk)
	if (IsValid(ply) and IsValid(atk) and atk:IsPlayer() and ply:IsPlayer()) then
		return (ply:GetRoleTeam() ~= atk:GetRoleTeam())
	end
end)

ROUND:Hook("PlayerCanHearPlayersVoice", function(self, state, listener, speaker)
	if (IsValid(speaker) and IsValid(listener)) then
		return listener:GetRoleTeam() == speaker:GetRoleTeam()
	end
end)

ROUND:Hook("PlayerCanSeePlayersChat", function(self, state, text, _, listener, speaker)
	if (IsValid(speaker) and IsValid(listener)) then
		return listener:GetRoleTeam() == speaker:GetRoleTeam()
	end
end)

--[[ROUND:Hook("PlayerRagdollCreated", function(self, state, ply, rag, atk, dmg)
	timer.Simple(5, function()
		if (IsValid(rag)) then
			rag:Remove()
		end
	end)
end)--]]

--[[function ROUND:PlayerSetModel(state, ply)

end--]]