ROUND.Reward = "tp"
ROUND.WinnerEarnings = 20
ROUND.EachDecrease = 5
ROUND.WinnerBonus = 5

ROUND.Boss = true

local WriteRoundData = pluto.rounds.WriteRoundData

function ROUND:Prepare(state)
	timer.Create("pluto_event_timer", 5, 0, function()
		if (not state.score) then
			return
		end
		for ply, count in pairs(state.score) do
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
	timer.Remove "pluto_souls_timer"
end

function ROUND:Loadout(ply)
	ply:StripWeapons()
	pluto.NextWeaponSpawn = false
	local wep = ply:Give "weapon_ttt_ak47_u"
	wep.AllowDrop = false
end

ROUND:Hook("TTTSelectRoles", function(self, state, plys)
	plys = table.shuffle(plys)

	for i, ply in ipairs(plys) do
		pluto.NextWeaponSpawn = false
		local wep = ply:Give "weapon_ttt_ak47_u"
		wep.AllowDrop = false

		pluto.rounds.LoadAmmo(ply)

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
	state.score = {}
	state.souls = {}
	state.spawntime = {}

	for k, ply in pairs(fighters) do
		state.score[ply] = 0
		state.souls[ply] = 0
		state.spawntime[ply] = CurTime()
		WriteRoundData("score", 0, ply)
		WriteRoundData("souls", 0, ply)
		if (ply:Alive()) then
			self:Initialize(state, ply)
		end
		ply:SetMaxHealth(150)
		ply:SetHealth(150)
	end

	self:ChooseLeader(state)

	timer.Create("pluto_souls_timer", 1, 0, function()
		for ply, souls in pairs(state.souls) do
			if (souls == 0) then
				continue
			end

			self:UpdateScore(state, ply, math.min(10, souls))
		end
	end)

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
	local sorted = {}

	for ply, score in pairs(state.score) do
		table.insert(sorted, {
			Player = ply,
			Score = score,
		})
	end

	table.SortByMember(sorted, "Score")

	local new = (sorted[1] and sorted[1].Player or nil)

	if (not IsValid(new)) then
		return
	end

	if (IsValid(state.leader) and new ~= state.leader) then
		if (CurTime() - last_notification >= 0.25) then
			last_notification = CurTime()
			pluto.rounds.Notify(string.format("The souls of %s have grown great!", new:Nick()), Color(153, 0, 26), nil, true)
		end
	end
	
	state.leader = new
	WriteRoundData("leader", new:Nick())
	WriteRoundData("leaderscore", state.score[new])
end

function ROUND:UpdateScore(state, ply, score)
	state.score[ply] = (state.score[ply] or 0) + (score or 1)

	WriteRoundData("score", state.score[ply], ply)

	self:ChooseLeader(state)
end

ROUND:Hook("SetupMove", function(self, state, ply, mv)
	if (ply.ForcePos) then
		mv:SetOrigin(ply.ForcePos)
		ply.ForcePos = nil
	end
end)

function ROUND:Spawn(state, ply)
	ply:SetMaxHealth(100)
	ply:SetHealth(100)
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

	self:ChooseLeader(state)

	local sorted = {}

	for ply, score in pairs(state.score) do
		table.insert(sorted, {
			Player = ply,
			Score = score,
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
	end

	if (IsValid(state.leader)) then
		pluto.rounds.Notify(state.leader:Nick() .. " has amassed the greatest soul hoard!", Color(153, 0, 26))
		hook.Run("PlutoSpecialWon", {state.leader})
		pluto.db.instance(function(db)
			pluto.inv.addcurrency(db, state.leader, self.Reward, self.WinnerBonus)
			pluto.rounds.Notify(string.format("You get %i extra Refinium Vials for winning!", self.WinnerBonus), pluto.currency.byname[self.Reward].Color, state.leader)
		end)
	else
		pluto.rounds.Notify("No winners here...")
	end
end

ROUND:Hook("PlayerCanPickupWeapon", function(self, state, ply, wep)
	return wep:GetClass() == "weapon_ttt_ak47_u"
end)

ROUND:Hook("TTTHasRoundBeenWon", function(self, state)
	if (#round.GetActivePlayersByRole "Fighter" == 0) then
		return true, "traitor", false
	end

	return false
end)

ROUND:Hook("PlayerDisconnected", function(self, state, ply)
	if (not state.score or not state.score[ply]) then
		return
	end

	state.score[ply] = nil
	state.deaths[ply] = nil
end)

ROUND:Hook("PlayerDeath", function(self, state, vic, inf, atk)
	if (not IsValid(vic) or not state.score or not state.souls) then
		return
	end

	local stolen = state.souls[vic]

	state.souls[vic] = 0

	WriteRoundData("souls", state.souls[vic], vic)

	if (not IsValid(atk) or not atk:IsPlayer() or vic == atk) then
		return
	end

	state.souls[atk] = (state.souls[atk] or 0) + stolen + 1

	WriteRoundData("souls", state.souls[atk], atk)

	pluto.rounds.Notify(string.format("Souls stolen: %i!", stolen + 1), Color(153, 0, 26), atk, true)

	local wep = atk:GetActiveWeapon()

	if (not IsValid(wep) or wep:GetClass() ~= "weapon_ttt_ak47_u") then
		return
	end

	wep:SetKills(wep:GetKills() + stolen)
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