--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
ROUND.Reward = "tp"
ROUND.WinnerEarnings = 20
ROUND.EachDecrease = 5
ROUND.DamagePerSecond = 0.8
ROUND.ResistancePerKill = 20
ROUND.ResistancePerDamage = 0.05
ROUND.MaxResistance = 80

ROUND.Boss = true

local WriteRoundData = pluto.rounds.WriteRoundData

function ROUND:Prepare(state)
	timer.Pause "tttrw_afk"
end

function ROUND:Finish()
	timer.Remove "pluto_boom_timer"
end

function ROUND:Loadout(ply)
	ply:StripWeapons()
	pluto.NextWeaponSpawn = false
	local wep = ply:Give "tfa_cso_stinger"
    wep.Primary.Delay = 1.5
    wep:SetClip1(200)
	wep.AllowDrop = false
	pluto.NextWeaponSpawn = false
	local wep = ply:Give "weapon_ttt_molotov"
	wep.AllowDrop = false
end

ROUND:Hook("TTTSelectRoles", function(self, state, plys)
	plys = table.shuffle(plys)

	for i, ply in ipairs(plys) do
		ply:StripWeapons()
		pluto.NextWeaponSpawn = false
		local wep = ply:Give "tfa_cso_stinger"
		wep.Primary.Delay = 1.5
		wep:SetClip1(200)
		wep.AllowDrop = false
		pluto.NextWeaponSpawn = false
		local wep = ply:Give "weapon_ttt_molotov"
		wep.AllowDrop = false

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
	state.resistance = {}
	state.living = {}
	state.dead = {}

	for k, ply in pairs(fighters) do
		state.resistance[ply] = 0
		state.living[ply] = true
		WriteRoundData("resistance", 0, ply)
		if (ply:Alive()) then
			self:Initialize(state, ply)
		end
		ply:SetMaxHealth(1000)
		ply:SetHealth(1000)
	end

	WriteRoundData("living", table.Count(state.living))

	state.start = CurTime()

	timer.Create("pluto_boom_timer", 5, 0, function()
		for ply, bool in pairs(state.living) do
			if (not IsValid(ply) or not ply:Alive() or not state.resistance)  then
				continue
			end

			state.resistance[ply] = state.resistance[ply] or 0

			local dmg = DamageInfo()
			dmg:SetDamage(math.ceil(((CurTime() - state.start) * self.DamagePerSecond) * (100 - state.resistance[ply]) / 100))
			dmg:SetDamageType(DMG_SLOWBURN)
			ply:TakeDamageInfo(dmg)

			pluto.NextWeaponSpawn = false
			local wep = ply:Give "weapon_ttt_molotov"
			wep.AllowDrop = false
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

function ROUND:UpdateResistance(state, ply, amt)
	if (not state.resistance or state.resistance[ply] == self.MaxResistance) then
		return
	end

	state.resistance[ply] = math.min(self.MaxResistance, (state.resistance[ply] or 0) + amt)

	if (state.resistance[ply] == self.MaxResistance) then
		pluto.rounds.Notify("You have reached maximum flame resistance!", nil, ply, true)
	end

	WriteRoundData("resistance", math.floor(state.resistance[ply]), ply)
end

ROUND:Hook("SetupMove", function(self, state, ply, mv)
	if (ply.ForcePos) then
		mv:SetOrigin(ply.ForcePos)
		ply.ForcePos = nil
	end
end)

function ROUND:Spawn(state, ply)
	ply:SetMaxHealth(1000)
	ply:SetHealth(1000)
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

	local winners = {}

	for ply, bool in pairs(state.living) do
		local amt = self.WinnerEarnings

		if (not IsValid(ply)) then
			continue 
		end

		table.insert(winners, ply)

		pluto.db.instance(function(db)
			pluto.inv.addcurrency(db, ply, self.Reward, amt)
			pluto.rounds.Notify(string.format("You earned %i Refinium Vials for surviving!", amt), pluto.currency.byname[self.Reward].Color, ply)
		end)
	end

	hook.Run("PlutoSpecialWon", winners)

	for k, ply in ipairs(state.dead) do
		local amt = self.WinnerEarnings - ((k - 1) * self.EachDecrease)

		if (not IsValid(ply) or amt <= 0) then
			continue
		end

		pluto.db.instance(function(db)
			pluto.inv.addcurrency(db, ply, self.Reward, amt)
			pluto.rounds.Notify(string.format("You earned %i Refinium Vials for placing #%i!", amt, k + 1), pluto.currency.byname[self.Reward].Color, ply)
		end)
	end
end

ROUND:Hook("PlayerCanPickupWeapon", function(self, state, ply, wep)
	return wep:GetClass() == "tfa_cso_stinger" or wep:GetClass() == "weapon_ttt_molotov"
end)

ROUND:Hook("TTTHasRoundBeenWon", function(self, state)
	if (#round.GetActivePlayersByRole "Fighter" == 0) then
		return true, "traitor", false
	end

	if (not state.living) then
		return
	end

	if (table.Count(state.living) <= 1) then
		return true, "innocent", false
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

	if (atk == targ) then
		return
	end

	self:UpdateResistance(atk, dmg:GetDamage() * self.ResistancePerDamage)
end)

ROUND:Hook("PlayerDisconnected", function(self, state, ply)
	if (not state.resistance or not state.living or not state.dead) then
		return
	end

	state.resistance[ply] = nil
	state.living[ply] = nil
	table.RemoveByValue(state.dead, ply)

	WriteRoundData("living", table.Count(state.living))

	ttt.CheckTeamWin()
end)

ROUND:Hook("PlayerDeath", function(self, state, vic, inf, atk)
	if (not IsValid(vic) or not state.resistance or not state.living or not state.dead) then
		return
	end

	table.insert(state.dead, 1, vic)
	state.living[vic] = nil

	WriteRoundData("living", table.Count(state.living))

	ttt.CheckTeamWin()

	if (not IsValid(atk) or not atk:IsPlayer() or vic == atk) then
		return
	end

	self:UpdateResistance(state, atk, self.ResistancePerKill)
end)

--[[function ROUND:PlayerSetModel(state, ply)

end--]]