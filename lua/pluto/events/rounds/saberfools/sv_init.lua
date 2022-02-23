--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
ROUND.Reward = "tp"
ROUND.WinnerEarnings = 10
ROUND.EachDecrease = 2

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
	local wep = ply:Give "weapon_lightsaber_dual"
	wep.AllowDrop = false
		
	for bone = 0, ply:GetBoneCount() - 1 do
		ply:ManipulateBoneJiggle(bone, 1)
	end

	ply:ChatPrint "Press your reload key to pull out your saber!"
end

ROUND:Hook("TTTSelectRoles", function(self, state, plys)
	plys = table.shuffle(plys)

	for i, ply in ipairs(plys) do
		pluto.NextWeaponSpawn = false
		local wep = ply:Give "weapon_lightsaber_dual"
		wep.AllowDrop = false

		pluto.rounds.LoadAmmo(ply)
		
		for bone = 0, ply:GetBoneCount() - 1 do
			ply:ManipulateBoneJiggle(bone, 1)
		end

		round.Players[i] = {
			Player = ply,
			SteamID = ply:SteamID(),
			Nick = ply:Nick(),
			Role = ttt.roles.Fighter
		}
	end

	pluto.rounds.Notify("Press your reload key to pull out your saber")

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
		ply:SetMaxHealth(250)
		ply:SetHealth(250)
	end

	self:ChooseLeader(state)

	GetConVar("ttt_karma"):SetBool(false)
	
	timer.Simple(1, function()
		round.SetRoundEndTime(CurTime() + 150)
		ttt.SetVisibleRoundEndTime(CurTime() + 150)
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
			Score = kills / (math.max(1, state.deaths[ply] or 1)),
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
			pluto.rounds.Notify(string.format("The council takes notice of %s!", new:Nick()), Color(0, 230, 80), nil, true)
		end
	end
	
	state.leader = new
	WriteRoundData("leader", new:Nick())
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
	ply:SetMaxHealth(250)
	ply:SetHealth(250)
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

	for ply, kills in pairs(state.kills) do
		table.insert(sorted, {
			Player = ply,
			Score = kills / (math.max(1, state.deaths[ply] or 1)),
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
		pluto.rounds.Notify(state.leader:Nick() .. " has been granted the rank of master! (Best K/D)", Color(0, 230, 80))
		hook.Run("PlutoSpecialWon", {state.leader})
	else
		pluto.rounds.Notify("No winners here...")
	end
end

ROUND:Hook("PlayerCanPickupWeapon", function(self, state, ply, wep)
	return wep:GetClass() == "weapon_lightsaber_dual"
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

--[[function ROUND:PlayerSetModel(state, ply)

end--]]