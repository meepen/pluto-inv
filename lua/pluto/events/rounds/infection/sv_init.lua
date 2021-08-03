ROUND.Reward = "tp"
ROUND.EarningsPerPerson = 3
ROUND.CollisionGroup = COLLISION_GROUP_DEBRIS_TRIGGER
ROUND.Health = 150

ROUND.Boss = true

local WriteRoundData = pluto.rounds.WriteRoundData

function ROUND:Prepare(state)
	timer.Create("pluto_event_timer", 3, 0, function()
		if (not state.infected) then
			return
		end
		for ply, bool in pairs(state.infected) do
			if (IsValid(ply) and not ply:Alive()) then
				ttt.ForcePlayerSpawn(ply)
			end
		end
	end)

	timer.Pause "tttrw_afk"
end

function ROUND:Finish()
	timer.Remove "pluto_event_timer"
	timer.Remove "pluto_infection_timer"
end

function ROUND:Loadout(ply)
	local state = pluto.rounds.state

	if (not state or not state.infected or not state.infected[ply]) then
		pluto.rounds.GiveDefaults(ply, true)
		for k, wep in ipairs(ply:GetWeapons()) do
			if (wep.Primary and wep.Primary.Delay) then
				wep.Primary.Delay = wep.Primary.Delay * 1.5
			end
		end
	else
		local wep = ply:Give "weapon_ttt_fists"
		wep.Primary.Damage = 50
		wep.HitDistance = 96
	end
end

ROUND:Hook("TTTSelectRoles", function(self, state, plys)
	plys = table.shuffle(plys)

	for i, ply in ipairs(plys) do
		pluto.rounds.GiveDefaults(ply)

		round.Players[i] = {
			Player = ply,
			SteamID = ply:SteamID(),
			Nick = ply:Nick(),
			Role = ttt.roles.Survivor
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

	local survivors = round.GetActivePlayersByRole "Survivor"
	state.timesurvived = {}
	state.kills = {}
	state.survivors = {}
	state.infected = {}

	for k, ply in pairs(survivors) do
		state.timesurvived[ply] = 0
		state.kills[ply] = 0
		state.survivors[ply] = true
		if (ply:Alive()) then
			self:Initialize(state, ply)
		end
		ply:SetMaxHealth(150)
		ply:SetHealth(150)
	end

	self:WriteLiving(state)

	timer.Create("pluto_infection_timer", 1, 0, function()
		if (state.survivors) then
			for ply, bool in pairs(state.survivors) do
				if (IsValid(ply) and ply:Alive()) then
					self:UpdateTimeSurvived(state, ply)
				end
			end
		end
	end)

	pluto.rounds.Notify("Battle, survivors, to determine who will be the first infected!", Color(128, 85, 0))

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
	self:PlayerSetModel(state, ply)
	self:Spawn(state, ply)
	local pos = self:ResetPosition(state, ply)
	if (pos) then
		ply.ForcePos = pos
	end
end

function ROUND:UpdateTimeSurvived(state, ply)
	state = state or pluto.rounds.state

	if (not IsValid(ply) or not state.timesurvived) then
		return 
	end

	state.timesurvived[ply] = (state.timesurvived[ply] or 0) + 1
	WriteRoundData("timesurvived", state.timesurvived[ply], ply)
end

function ROUND:UpdateKills(state, ply)
	state = state or pluto.rounds.state

	if (not IsValid(ply) or not state.kills) then
		return 
	end

	state.kills[ply] = (state.kills[ply] or 0) + 1
	WriteRoundData("kills", state.kills[ply], ply)
end

ROUND:Hook("SetupMove", function(self, state, ply, mv)
	if (ply.ForcePos) then
		mv:SetOrigin(ply.ForcePos)
		ply.ForcePos = nil
	end
end)

function ROUND:Spawn(state, ply)
	ply:SetCollisionGroup(self.CollisionGroup)

	local hp = self.Health

	if (state and state.infected and state.infected[ply] and state.survivors) then
		local inf = table.Count(state.infected)
		local sur = table.Count(state.survivors)
		if (inf <= 0) then
			inf = 1
		end
		hp = math.Clamp(hp * sur / inf * 1.5, 250, 1000)
		ply:SetJumpPower(ply:GetJumpPower() * 1.75)
	else
		ply:SetJumpPower(ply:GetJumpPower() / 1.75)
	end

	ply:SetMaxHealth(hp)
	ply:SetHealth(hp)
end

ROUND:Hook("PlayerSpawn", ROUND.Spawn)

local hull_mins, hull_maxs = Vector(-22, -22, 0), Vector(22, 22, 90)

function ROUND:ResetPosition(state, ply)
	return pluto.currency.randompos(hull_mins, hull_maxs)
end

ROUND:Hook("PlayerSelectSpawnPosition", ROUND.ResetPosition)

function ROUND:TTTEndRound(state)
	GetConVar("ttt_karma"):Revert()
	timer.UnPause("tttrw_afk")

	if (pluto.rounds.forfun) then
		pluto.rounds.forfun = nil
		pluto.rounds.Notify("This round was for fun only, thanks for playing!")
		return
	end
	
	if (not state) then
		return
	end

	if (state.kills) then
		local totalkills = 0
		local totalreward = 0
		local max_kills = 0
		local winner

		for ply, kills in pairs(state.kills) do
			if (not IsValid(ply)) then
				continue
			end

			if (kills > max_kills) then
				max_kills = kills
				winner = ply
			end

			totalkills = totalkills + kills
			totalreward = totalreward + self.EarningsPerPerson			
		end

		if (IsValid(winner)) then
			pluto.rounds.Notify(winner:Nick() .. " had the most survivor kills!", Color(0, 128, 0))
			hook.Run("PlutoSpecialWon", {winner})
		end

		for ply, kills in pairs(state.kills) do
			if (not IsValid(ply)) then
				continue
			end

			local togive = math.floor(kills / totalkills * totalreward)

			if (togive < 1) then
				continue
			end

			pluto.db.instance(function(db)
				pluto.inv.addcurrency(db, ply, self.Reward, togive)
				pluto.rounds.Notify(string.format("You get %i Refinium Vials for having a kill count of %i!", togive, kills), pluto.currency.byname[self.Reward].Color, ply)
			end)
		end
	else
		pluto.rounds.Notify("No killers here...")
	end

	if (state.timesurvived) then
		local totaltimesurvived = 0
		local totalreward = 0
		local max_timesurvived = 0
		local winner

		for ply, timesurvived in pairs(state.timesurvived) do
			if (not IsValid(ply)) then
				continue
			end

			totaltimesurvived = totaltimesurvived + timesurvived
			totalreward = totalreward + self.EarningsPerPerson			
		end

		if (IsValid(winner)) then
			pluto.rounds.Notify(winner:Nick() .. " survived the longest!", Color(128, 85, 0))
			hook.Run("PlutoSpecialWon", {winner})
		end

		for ply, timesurvived in pairs(state.timesurvived) do
			if (not IsValid(ply)) then
				continue
			end

			local togive = math.floor(timesurvived / totaltimesurvived * totalreward)

			if (togive < 1) then
				continue
			end

			pluto.db.instance(function(db)
				pluto.inv.addcurrency(db, ply, self.Reward, togive)
				pluto.rounds.Notify(string.format("You get %i Refinium Vials for having a survival time of %i!", togive, timesurvived), pluto.currency.byname[self.Reward].Color, ply)
			end)
		end
	else
		pluto.rounds.Notify("No survivors here...")
	end
end

function ROUND:RemovePlayer(state, ply)
	if (not state or not state.kills or not state.timesurvived or not state.infected or not state.survivors) then
		return 
	end

	state.kills[ply] = nil
	state.timesurvived[ply] = nil
	state.infected[ply] = nil
	state.survivors[ply] = nil

	ttt.CheckTeamWin()

	self:WriteLiving(state)
end

function ROUND:WriteLiving(state)
	if (not state or not state.survivors) then
		return
	end

	WriteRoundData("living", table.Count(state.survivors), ply)
end

ROUND:Hook("PlayerCanPickupWeapon", function(self, state, ply, wep)
	if (IsValid(ply) and ply:GetRole() == "Infected") then
		return wep:GetClass() == "weapon_ttt_fists"
	end
end)

ROUND:Hook("TTTHasRoundBeenWon", function(self, state)
	state = state or pluto.rounds.state

	if (state.survivors and table.Count(state.survivors) == 0) then
		return true, "traitor", false
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
	if (not IsValid(vic) or not state or not state.survivors or not state.infected) then
		return
	end

	if (state.survivors[vic]) then
		state.infected[vic] = true
		state.survivors[vic] = nil
		pluto.rounds.Notify("You have been infected, so go out and attack the survivors!", Color(128, 85, 0), vic)
		vic:SetRole "Infected"

		if (not state.infectedfound) then
			pluto.rounds.Notify(string.format("%s has been infected! Now, survivors, work together!", vic:Nick()), Color(0, 128, 0))
			WriteRoundData("infectedfound", true)

			for ply, bool in pairs(state.survivors) do
				if (not IsValid(ply) or not ply:Alive()) then
					continue
				end

				ply:SetMaxHealth(self.Health)
				ply:SetHealth(self.Health)

				state.infectedfound = true
			end
		end

		if (IsValid(atk) and atk:IsPlayer() and state.kills) then
			self:UpdateKills(state, atk)
		end

		self:WriteLiving(state)
	end
end)

ROUND:Hook("PlayerShouldTakeDamage", function(self, state, ply, atk)
	if (IsValid(ply) and IsValid(atk) and atk:IsPlayer() and ply:IsPlayer()) then
		return (ply:GetRole() ~= atk:GetRole() or not state or not state.infectedfound)
	end
end)

ROUND:Hook("PlayerRagdollCreated", function(self, state, ply, rag, atk, dmg)
	timer.Simple(5, function()
		if (IsValid(rag)) then
			rag:Remove()
		end
	end)
end)

ROUND:Hook("PlutoHealthGain", function(self, state, ply)
	if (IsValid(ply) and ply:GetRole() == "Survivor") then
		return true
	end
end)

function ROUND:PlayerSetModel(state, ply)
	if (state and state.infected and state.infected[ply]) then
		ply:SetModel "models/player/zombie_classic.mdl"
		ply:SetupHands()

		return true
	end
end