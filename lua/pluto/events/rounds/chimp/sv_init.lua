resource.AddFile("sound/pluto/dkrap.ogg")

ROUND.BananasPerPlayer = 6
ROUND.KillSteal = 1
ROUND.BananasForEgg = 5
ROUND.WinnerBonus = 1
ROUND.Reward = "brainegg"

ROUND.Boss = true

local WriteRoundData = pluto.rounds.WriteRoundData

function ROUND:Prepare(state)
	timer.Create("pluto_event_timer", 5, 0, function()
		if (not state.playerscores) then
			return
		end
		for ply, count in pairs(state.playerscores) do
			if (IsValid(ply) and not ply:Alive()) then
				ttt.ForcePlayerSpawn(ply)
			end
		end
	end)

	timer.Pause "tttrw_afk"
end

function ROUND:Finish()
	timer.Remove "pluto_event_timer"
	timer.Remove "pluto_monke_timer"
end

function ROUND:Loadout(ply)
	ply:StripWeapons()
	pluto.NextWeaponSpawn = false
	ply:Give "tfa_cso_ruyi"
	pluto.NextWeaponSpawn = false
	ply:Give "weapon_ttt_unarmed"
end

ROUND:Hook("TTTSelectRoles", function(self, state, plys)
	plys = table.shuffle(plys)

	local roles_needed = {
		["Banna Boss"] = 1,
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
			role = "Monke"
		end

		ply:StripWeapons()
		pluto.NextWeaponSpawn = false
		ply:Give "tfa_cso_ruyi"
		pluto.NextWeaponSpawn = false
		ply:Give "weapon_ttt_unarmed"

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

	local monkes = round.GetActivePlayersByRole "Monke"
	local banna = round.GetActivePlayersByRole "Banna Boss"
	state.players = {}
	state.playerscores = {}
	state.rewarded = {}
	state.lastactive = {}

	for k, ply in pairs(monkes) do
		table.insert(state.players, ply)
		if (ply:Alive()) then
			self:Initialize(state, ply)
		end
	end

	for k, ply in pairs(banna) do
		state.leader = ply
		table.insert(state.players, ply)
		if (ply:Alive()) then
			self:Initialize(state, ply)
		end
	end

	state.bananas = {}

	for k, ply in ipairs(state.players) do
		if IsValid(ply) then
			state.playerscores[ply] = 0
			state.lastactive[ply] = CurTime()
			local tospawn = self.BananasPerPlayer
			while (tospawn > 0) do
				tospawn = tospawn - 1
				table.insert(state.bananas, pluto.currency.spawnfor(ply, "_banna", nil, true))
			end

			self:UpdateScore(state, ply, 0)
		end
	end

	timer.Create("pluto_monke_timer", 5, 0, function()
		for _, ply in ipairs(state.players) do
			if (not IsValid(ply) or not state.lastactive[ply] or CurTime() - state.lastactive[ply] < 20)  then
				continue
			end
			if (not state.playerscores[ply] or state.playerscores[ply] < 7) then
				continue
			end

			pluto.statuses.bleed(ply, {Damage = 5})
			pluto.rounds.Notify("Me get hurt for not fight!", nil, ply, true)
		end
	end)

	WriteRoundData("left", #state.bananas)

	self:ChooseLeader(state)

	GetConVar("ttt_karma"):SetBool(false)
	
	timer.Simple(1, function()
		round.SetRoundEndTime(CurTime() + 165)
		ttt.SetVisibleRoundEndTime(CurTime() + 165)
	end)
end)

ROUND:Hook("PostPlayerDeath", function(self, state, ply)
	ply:Extinguish()
	return true
end)

function ROUND:Initialize(state, ply)
	self:PlayerSetModel(state, ply)
	self:Spawn(state, ply)
end

local last_notification = 0

function ROUND:ChooseLeader(state)
	local new = table.SortByKey(state.playerscores)[1]

	if (not IsValid(new)) then
		return
	end

	if (IsValid(state.leader) and new ~= state.leader) then
		state.leader:SetRole("Monke")
		if (CurTime() - last_notification >= 0.25) then
			last_notification = CurTime()
			pluto.rounds.Notify(new:Nick() .. " new Banna Boss!", ttt.roles["Banna Boss"].Color, nil, true)
		end
	end
	
	state.leader = new
	new:SetRole("Banna Boss")
	WriteRoundData("leader", new:Nick() .. " Banna Boss for hav " .. tostring(state.playerscores[new]) .. " banna")
end

function ROUND:UpdateScore(state, ply, amt)
	state.playerscores[ply] = (state.playerscores[ply] or 0) + amt
	state.lastactive[ply] = CurTime()

	if (state.playerscores[ply] >= self.BananasForEgg and not state.rewarded[ply]) then
		state.rewarded[ply] = true
		pluto.rounds.Notify("Me get brain egg for hav " .. tostring(self.BananasForEgg) .. " bannas!", pluto.currency.byname._banna.Color, ply)
	end

	WriteRoundData("score", state.playerscores[ply], ply)

	self:ChooseLeader(state)
end

ROUND:Hook("SetupMove", function(self, state, ply, mv)
	if (ply.ForcePos) then
		mv:SetOrigin(ply.ForcePos)
		ply.ForcePos = nil
	end
end)

function ROUND:Spawn(state, ply)
	if (state.players and state.players[ply]) then
		ply:SetHealth(100)
		ply:SetMaxHealth(100)
	end
	if (state.lastactive) then
		state.lastactive[ply] = CurTime()
	end
	ply.LastBannaAttacker = nil
end

ROUND:Hook("PlayerSpawn", ROUND.Spawn)

local hull_mins, hull_maxs = Vector(-22, -22, 0), Vector(22, 22, 90)

function ROUND:ResetPosition(state, ply)
	return pluto.currency.randompos(hull_mins, hull_maxs)
end

ROUND:Hook("PlayerSelectSpawnPosition", ROUND.ResetPosition)

function ROUND:TTTEndRound(state)
	for _, ent in pairs(state.bananas) do
		if (IsValid(ent)) then
			ent:Remove()
		end
	end

	self:ChooseLeader(state)

	for ply, score in pairs(state.playerscores) do
		if (state.rewarded[ply]) then
			pluto.db.instance(function(db)
				pluto.inv.addcurrency(db, ply, self.Reward, 1)
				pluto.rounds.Notify("Me get brain egg for havd " .. tostring(self.BananasForEgg) .. "!", pluto.currency.byname._banna.Color, ply)
			end)
		end
	end

	if (IsValid(state.leader)) then
		pluto.rounds.Notify(state.leader:Nick() .. " banna king!", ttt.roles["Banna Boss"].Color)
		pluto.db.instance(function(db)
			pluto.inv.addcurrency(db, state.leader, self.Reward, self.WinnerBonus)
			pluto.rounds.Notify("Me get " .. tostring(self.WinnerBonus) .. " extra brain egg for win banna king!", pluto.currency.byname[self.Reward].Color, state.leader)
		end)
	else
		pluto.rounds.Notify("All monke suk")
	end

	GetConVar("ttt_karma"):Revert()

	timer.UnPause("tttrw_afk")
end

function ROUND:SendUpdateBananas(state)
	local left = -1
	for _, ent in ipairs(state.bananas) do
		if (IsValid(ent)) then
			left = left + 1
		end
	end

	WriteRoundData("left", left)
end

ROUND:Hook("PlutoBannaPickup", function(self, state, ply)
	self:SendUpdateBananas(state)
	self:UpdateScore(state, ply, 1)
end)

ROUND:Hook("PlayerCanPickupWeapon", function(self, state, ply, wep)
	return wep:GetClass() == "tfa_cso_ruyi" or wep:GetClass() == "weapon_ttt_unarmed"
end)

ROUND:Hook("TTTHasRoundBeenWon", function(self, state)
	if (#round.GetActivePlayersByRole "Monke" == 0) then
		return true, "traitor", false
	end

	return false
end)

ROUND:Hook("EntityTakeDamage", function(self, state, targ, dmg)
	local atk = dmg:GetAttacker()
	if (not IsValid(targ) or not targ:IsPlayer()) then
		return
	end
	if (not IsValid(atk) or not atk:IsPlayer()) then
		return
	end

	state.lastactive[atk] = CurTime()

	targ.LastBannaAttacker = atk
end)

ROUND:Hook("PlayerDisconnected", function(self, state, ply)
	if (not state.playerscores or not state.playerscores[ply]) then
		return
	end

	local amt = state.playerscores[ply]

	for i = 1, amt do
		table.insert(state.bananas, pluto.currency.spawnfor(player.GetAll()[1], "_banna", nil, true))
	end
	self:SendUpdateBananas(state)
	state.playerscores[ply] = nil
end)

ROUND:Hook("PlayerDeath", function(self, state, vic, inf, atk)
	if (not IsValid(vic) or not state.playerscores or not state.playerscores[vic]) then
		return
	end

	local amt = state.playerscores[vic] > self.KillSteal and self.KillSteal or 0

	if ((vic == atk or not IsValid(atk)) and IsValid(vic.LastBannaAttacker)) then
		atk = vic.LastBannaAttacker
	end

	if (not IsValid(atk) or not atk:IsPlayer() or vic == atk) then
		self:UpdateScore(state, vic, -amt)
		for i = 1, amt do
			table.insert(state.bananas, pluto.currency.spawnfor(vic, "_banna", nil, true))
		end
	
		pluto.rounds.Notify("Me drop banna!", ttt.roles.Traitor.Color, vic, true)
		return
	end

	self:UpdateScore(state, vic, -amt)
	self:UpdateScore(state, atk, amt)

	if (amt > 0) then
		pluto.rounds.Notify(atk:Nick() .. " steal " .. tostring(amt) .. " banna!", ttt.roles.Traitor.Color, vic, true)
		pluto.rounds.Notify("Me steal " .. tostring(amt) .. " banna from " .. vic:Nick() .. "!", ttt.roles.Monke.Color, atk, true)
	end

	self:SendUpdateBananas(state)
end)

ROUND:Hook("PlayerRagdollCreated", function(self, state, ply, rag, atk, dmg)
	timer.Simple(5, function()
		if (IsValid(rag)) then
			rag:Remove()
		end
	end)
end)

function ROUND:PlayerSetModel(state, ply)
	ply:SetModel(pluto.models["chimp"].Model)

	return true
end