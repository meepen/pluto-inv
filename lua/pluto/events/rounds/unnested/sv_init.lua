ROUND.Reward = "tp"
ROUND.WinnerEarnings = 10
ROUND.EachDecrease = 2

ROUND.Boss = true

local WriteRoundData = pluto.rounds.WriteRoundData

function ROUND:Prepare(state)
	timer.Create("pluto_event_timer", 5, 0, function()
		if (not state.active) then
			return
		end
		for ply, count in pairs(state.active) do
			if (IsValid(ply) and not ply:Alive()) then
				ttt.ForcePlayerSpawn(ply)
				state.spawntime[ply] = CurTime()
			end
		end
	end)

	timer.Pause "tttrw_afk"
end

function ROUND:Finish()
	timer.Remove "pluto_event_timer"
end

function ROUND:Loadout(ply)
	pluto.rounds.GiveDefaults(ply, true)

	if (not pluto.rounds.state or not pluto.rounds.state.active or not pluto.rounds.state.active[ply]) then
		return
	end

	ttt.Equipment.List["ttt_radar"]:OnBuy(ply)
end

ROUND:Hook("TTTSelectRoles", function(self, state, plys)
	plys = table.shuffle(plys)

	for i, ply in ipairs(plys) do
		pluto.rounds.GiveDefaults(ply, true)

		round.Players[i] = {
			Player = ply,
			SteamID = ply:SteamID(),
			Nick = ply:Nick(),
			Role = ttt.roles.Fighter
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

	local fighters = round.GetActivePlayersByRole "Fighter"
	state.active = {}
	state.kills = {}
	state.deaths = {}
	state.spawntime = {}

	for k, ply in pairs(fighters) do
		state.active[ply] = true
		state.kills[ply] = 0
		state.deaths[ply] = 0
		state.spawntime[ply] = CurTime()
		WriteRoundData("kills", 0, ply)
		WriteRoundData("deaths", 0, ply)
		if (ply:Alive()) then
			self:Initialize(state, ply)
		end
		ply:SetMaxHealth(250)
		ply:SetHealth(250)

		timer.Simple(1, function()
			if (not IsValid(ply) or not ply:Alive()) then
				return
			end

			ttt.Equipment.List["ttt_radar"]:OnBuy(ply)
		end)
	end

	WriteRoundData("left", table.Count(state.active))

	GetConVar("ttt_karma"):SetBool(false)
	
	timer.Simple(1, function()
		round.SetRoundEndTime(CurTime() + 180)
		ttt.SetVisibleRoundEndTime(CurTime() + 180)
	end)
end)

ROUND:Hook("PostPlayerDeath", function(self, state, ply)
	ply:Extinguish()
	return true
end)

function ROUND:Initialize(state, ply)
	self:Spawn(state, ply)
end

local last_notification = 0

function ROUND:ChooseLeader(state)
	
end

function ROUND:UpdateScore(state, ply)
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
	local reduction = 0
	if (state.deaths and state.deaths[ply]) then
		reduction = state.deaths[ply] * 75
	end

	ply:SetMaxHealth(250 - reduction)
	ply:SetHealth(250 - reduction)
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

	for k, ply in ipairs(player.GetAll()) do
		if (not IsValid(ply)) then
			continue
		end

		pluto.scaling.reset(ply)
	end

	if (pluto.rounds.forfun) then
		pluto.rounds.forfun = nil
		pluto.rounds.Notify("This round was for fun only, thanks for playing!")
		return
	end

	local sorted = {}

	for ply, kills in pairs(state.kills) do
		table.insert(sorted, {
			Player = ply,
			Score = kills,
		})
	end

	table.SortByMember(sorted, "Score")

	for k, entry in ipairs(sorted) do
		local amt = self.WinnerEarnings - (k * self.EachDecrease)

		if (not IsValid(entry.Player) or amt <= 0) then
			break 
		end

		pluto.db.instance(function(db)
			pluto.inv.addcurrency(db, entry.Player, self.Reward, amt)
			pluto.rounds.Notify(string.format("You earned %i Refinium Vials for achieving place #%i!", amt, k), pluto.currency.byname[self.Reward].Color, entry.Player)
		end)

		if (k == 1) then
			pluto.rounds.Notify(entry.Player:Nick() .. " was the most lethal doll!", Color(255, 255, 102))
			hook.Run("PlutoSpecialWon", {entry.Player})
		end
	end
end

--[[ROUND:Hook("PlayerCanPickupWeapon", function(self, state, ply, wep)
	
end)--]]

ROUND:Hook("TTTHasRoundBeenWon", function(self, state)
	if (#round.GetActivePlayersByRole "Fighter" == 0) then
		return true, "traitor", false
	end

	return false
end)

ROUND:Hook("PlayerDisconnected", function(self, state, ply)
	if (not state.kills or not state.kills[ply]) then
		return
	end

	state.kills[ply] = nil
	state.deaths[ply] = nil
end)

ROUND:Hook("PlayerDeath", function(self, state, vic, inf, atk)
	if (not IsValid(vic) or not state.kills or not state.deaths) then
		return
	end

	state.deaths[vic] = (state.deaths[vic] or 0) + 1

	WriteRoundData("deaths", state.deaths[vic], vic)

	if (state.deaths[vic] == 4) then
		state.active[vic] = nil
		WriteRoundData("left", table.Count(state.active))
	end

	pluto.scaling.set(vic, math.max(0.4, 1 - (state.deaths[vic] * 0.15)))

	if (not IsValid(atk) or not atk:IsPlayer() or vic == atk) then
		return
	end

	self:UpdateScore(state, atk)
end)

ROUND:Hook("PlayerShouldTakeDamage", function(self, state, ply, atk)
	if (IsValid(ply) and IsValid(atk) and atk:IsPlayer() and ply:IsPlayer()) then
		return (state and state.spawntime and state.spawntime[ply] and state.spawntime[ply] + 3 < CurTime())
	end
end)

ROUND:Hook("PlayerRagdollCreated", function(self, state, ply, rag, atk, dmg)
	timer.Simple(5, function()
		if (IsValid(rag)) then
			rag:Remove()
		end
	end)
end)

--[[function ROUND:PlayerSetModel(state, ply)

end--]]