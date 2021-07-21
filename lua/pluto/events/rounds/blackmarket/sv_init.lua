ROUND.Reward = "tp"
ROUND.WinnerEarnings = 20
ROUND.EachDecrease = 5
ROUND.WinnerBonus = 5

ROUND.Primaries = {
	"weapon_ttt_ak47_u",
	"weapon_ttt_chargeup",
	"weapon_tfa_cso2_m3dragon",
	"tfa_cso_darkknight_v6",
	"tfa_cso_elvenranger",
	"tfa_cso_skull5",
	"tfa_cso_batista",
	"tfa_cso_paladin",
	"tfa_cso_starchaserar",
	"tfa_cso_starchasersr",
}

ROUND.Secondaries = {
	"weapon_ttt_deagle_u",
	"tfa_cso_tbarrel",
	"weapon_neszapper",
	"weapon_raygun",
	"weapon_ttt_deagle_gold",
	"tfa_cso_skull1",
	"tfa_cso_sapientia",
}

ROUND.Melees = {
	"tfa_cso_tomahawk",
	"tfa_cso_thanatos9",
	"weapon_lightsaber_rainbow",
	"weapon_lightsaber_rb",
	"tfa_cso_skull9",
}

ROUND.Pickups = {}
for k, v in ipairs(ROUND.Primaries) do
	ROUND.Pickups[v] = true
end
for k, v in ipairs(ROUND.Secondaries) do
	ROUND.Pickups[v] = true
end
for k, v in ipairs(ROUND.Melees) do
	ROUND.Pickups[v] = true
end

ROUND.Boss = true

local WriteRoundData = pluto.rounds.WriteRoundData

function ROUND:Prepare(state)
	timer.Create("pluto_event_timer", 5, 0, function()
		if (not state.kills) then
			return
		end
		for ply, count in pairs(state.kills) do
			if (IsValid(ply) and not ply:Alive()) then
				ttt.ForcePlayerSpawn(ply)
			end
		end
	end)

	timer.Pause "tttrw_afk"
end

function ROUND:Finish()
	timer.Remove "pluto_event_timer"
end

function ROUND:Loadout(ply)
	ply:StripWeapons()
	pluto.NextWeaponSpawn = false
	ply:Give(table.Random(self.Primaries))
	pluto.NextWeaponSpawn = false
	ply:Give(table.Random(self.Secondaries))
	pluto.NextWeaponSpawn = false
	ply:Give(table.Random(self.Melees))

	pluto.rounds.LoadAmmo(ply)
end

ROUND:Hook("TTTSelectRoles", function(self, state, plys)
	plys = table.shuffle(plys)

	for i, ply in ipairs(plys) do
		pluto.NextWeaponSpawn = false
		ply:Give(table.Random(self.Primaries))
		pluto.NextWeaponSpawn = false
		ply:Give(table.Random(self.Secondaries))
		pluto.NextWeaponSpawn = false
		ply:Give(table.Random(self.Melees))

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
	state.kills = {}
	state.deaths = {}

	for k, ply in pairs(fighters) do
		state.kills[ply] = 0
		state.deaths[ply] = 0
		WriteRoundData("kills", 0, ply)
		WriteRoundData("deaths", 0, ply)
		if (ply:Alive()) then
			self:Initialize(state, ply)
		end
		ply:SetMaxHealth(100)
		ply:SetHealth(100)
	end

	self:ChooseLeader(state)

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

	for ply, kills in pairs(state.kills) do
		table.insert(sorted, {
			Player = ply,
			Score = kills - (state.deaths[ply] or 0),
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
			pluto.rounds.Notify(string.format("%s has taken the lead!", new:Nick()), Color(255, 225, 75), nil, true)
		end
	end
	
	state.leader = new
	WriteRoundData("leader", new:Nick())
	WriteRoundData("leaderkills", state.kills[new])
end

function ROUND:UpdateScore(state, ply)
	state.kills[ply] = (state.kills[ply] or 0) + 1

	WriteRoundData("kills", state.kills[ply], ply)

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
	self:ChooseLeader(state)

	local sorted = {}

	for ply, kills in pairs(state.kills) do
		table.insert(sorted, {
			Player = ply,
			Score = kills - (state.deaths[ply] or 0),
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
		pluto.rounds.Notify(state.leader:Nick() .. " is the leading brawler!", Color(255, 225, 75))
		hook.Run("PlutoSpecialWon", {state.leader})
		pluto.db.instance(function(db)
			pluto.inv.addcurrency(db, state.leader, self.Reward, self.WinnerBonus)
			pluto.rounds.Notify(string.format("You get %i extra Refinium Vials for winning!", self.WinnerBonus), pluto.currency.byname[self.Reward].Color, state.leader)
		end)
	else
		pluto.rounds.Notify("No winners here...")
	end

	GetConVar("ttt_karma"):Revert()

	timer.UnPause("tttrw_afk")
end

ROUND:Hook("PlayerCanPickupWeapon", function(self, state, ply, wep)
	for k, _wep in ipairs(ply:GetWeapons()) do
		if wep:GetSlot() == _wep:GetSlot() then
			return false
		end		
	end

	return self.Pickups[wep:GetClass()] or false
end)

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

	if (not IsValid(atk) or not atk:IsPlayer() or vic == atk) then
		return
	end

	self:UpdateScore(state, atk)
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