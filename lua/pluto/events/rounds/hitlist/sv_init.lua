--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
ROUND.Reward = "tp"
ROUND.EarningsPerScore = 2

util.AddNetworkString "hitlist_data"

ROUND.Boss = true

local WriteRoundData = pluto.rounds.WriteRoundData

function ROUND:Prepare(state)
	timer.Pause "tttrw_afk"
end

function ROUND:Finish()
	timer.Remove("pluto_hitlist_timer")	
end

function ROUND:Loadout(ply)
	pluto.rounds.GiveDefaults(ply)
end

ROUND:Hook("TTTSelectRoles", function(self, state, plys)
	plys = table.shuffle(plys)

	for i, ply in ipairs(plys) do
		pluto.rounds.GiveDefaults(ply)

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
	state.scores = {}
	state.targets = {}
	state.attacked = {}
	state.endtime = CurTime() + 90
	state.left = 1

	WriteRoundData("left", state.left)
	WriteRoundData("score", 0)

	for k, ply in pairs(fighters) do
		state.scores[ply] = 0
		if (ply:Alive()) then
			self:Initialize(state, ply)
		end
		ply:SetMaxHealth(150)
		ply:SetHealth(150)
	end

	self:ShuffleTargets(state)

	timer.Create("pluto_hitlist_timer", 1, 0, function()
		for ply, target in pairs(state.targets) do
			net.Start "hitlist_data"
				net.WriteFloat(target:GetPos().x)
				net.WriteFloat(target:GetPos().y)
				net.WriteFloat(target:GetPos().z)
			net.Send(ply)
		end

		if (state.endtime > CurTime() and not IsValid(state.winner)) then
			return 
		end
		
		state.left = state.left - 1

		if (IsValid(state.winner)) then
			self:UpdateScore(state, state.winner, 3)
			pluto.rounds.Notify("You gained 3 points for winning the round!", Color(38, 0, 77), state.winner)
			state.winner = nil
		end

		--[[if (state.endtime <= CurTime()) then
			pluto.rounds.Notify("Ran out of time, moving on!")
		end--]]

		if (state.left <= -1) then
			ttt.CheckTeamWin()
			return 
		else
			WriteRoundData("left", state.left)

			state.endtime = CurTime() + 90

			pluto.rounds.Notify("Respawning everyone for round 2!", Color(34, 102, 0))

			for ply, count in pairs(state.scores) do
				if (IsValid(ply)) then
					if (ply:Alive()) then
						ply:SetHealth(ply:GetMaxHealth())
					else
						ttt.ForcePlayerSpawn(ply)
					end
				end
			end

			self:ShuffleTargets(state)
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

function ROUND:UpdateScore(state, ply, amt)
	if (not state.scores) then
		return
	end

	state.scores[ply] = (state.scores[ply] or 0) + amt

	WriteRoundData("score", state.scores[ply], ply)
end

function ROUND:ShuffleTargets(state)
	local plys = {}

	state.targets = {}
	state.attacked = {}

	for ply, score in pairs(state.scores) do
		if (IsValid(ply)) then
			table.insert(plys, ply)
		end
	end

	table.shuffle(plys)

	for k, ply in ipairs(plys) do
		if (k == #plys) then
			state.targets[ply] = plys[1]
		else
			state.targets[ply] = plys[k + 1]
		end
		WriteRoundData("target", state.targets[ply]:Nick(), ply)
		pluto.rounds.Notify(string.format("Your new target is: %s", state.targets[ply]:Nick()), nil, ply, true)
	end

	WriteRoundData("living", table.Count(state.targets))
end

ROUND:Hook("SetupMove", function(self, state, ply, mv)
	if (ply.ForcePos) then
		mv:SetOrigin(ply.ForcePos)
		ply.ForcePos = nil
	end
end)

function ROUND:Spawn(state, ply)
	ply:SetMaxHealth(150)
	ply:SetHealth(150)
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
	
	local max_score = 0
	local winner

	for ply, score in pairs(state.scores) do
		if (score == 0) then
			continue
		end

		if (score > max_score) then
			max_score = score
			winner = ply
		end

		pluto.db.instance(function(db)
			pluto.inv.addcurrency(db, ply, self.Reward, self.EarningsPerScore * score)
			pluto.rounds.Notify(string.format("You get %i Refinium Vials for having a score of %i!", self.EarningsPerScore * score, score), pluto.currency.byname[self.Reward].Color, ply)
		end)
	end

	if (IsValid(winner)) then
		pluto.rounds.Notify(winner:Nick() .. " is the superior hitman!", Color(38, 0, 77))
		hook.Run("PlutoSpecialWon", {winner})
	end
end

--[[ROUND:Hook("PlayerCanPickupWeapon", function(self, state, ply, wep)
	return
end)--]]

ROUND:Hook("TTTHasRoundBeenWon", function(self, state)
	if (#round.GetActivePlayersByRole "Fighter" == 0) then
		return true, "traitor", false
	end

	if (state.left and state.left <= -1) then
		return true, "traitor", false
	end

	return false
end)

ROUND:Hook("PlayerDisconnected", function(self, state, ply)
	if (not IsValid(ply) or not state.scores or not state.scores[ply]) then
		return
	end

	if (not state.targets or not state.targets[ply]) then
		return 
	end

	local ply_target = state.targets[ply]
	local ply_targeter = table.KeyFromValue(state.targets, ply)
	state.targets[ply] = nil

	if (not IsValid(ply_target) or not IsValid(ply_targeter)) then
		return
	end

	if (ply_target == ply_targeter) then
		state.winner = ply_targeter
		state.targets[ply_targeter] = nil
		WriteRoundData("target", "", ply_targeter)
		return 
	end

	state.targets[ply_targeter] = ply_target
	WriteRoundData("target", ply_target:Nick(), ply_targeter)
	pluto.rounds.Notify(string.format("Your new target is: %s", ply_target:Nick()), Color(34, 102, 0), ply_targeter, true)

	state.scores[ply] = nil

	WriteRoundData("living", table.Count(state.targets))
end)

ROUND:Hook("PlayerDeath", function(self, state, vic, inf, atk)
	if (not IsValid(vic) or not state.targets) then
		return
	end

	if (IsValid(atk) and atk:IsPlayer() and state.targets[atk] == vic) then
		self:UpdateScore(state, atk, 1)
	end

	local vic_target = state.targets[vic]
	local vic_targeter = table.KeyFromValue(state.targets, vic)
	state.targets[vic] = nil

	if (vic_target == vic_targeter) then
		state.winner = vic_targeter
		state.targets[vic_targeter] = nil
		WriteRoundData("target", "", vic_targeter)
		return 
	end

	if (not IsValid(vic_target) or not IsValid(vic_targeter)) then
		return
	end

	WriteRoundData("target", "", vic)
	state.targets[vic_targeter] = vic_target
	WriteRoundData("target", vic_target:Nick(), vic_targeter)
	pluto.rounds.Notify(string.format("Your new target is: %s", vic_target:Nick()), Color(34, 102, 0), vic_targeter, true)

	WriteRoundData("living", table.Count(state.targets))
end)

ROUND:Hook("PlayerShouldTakeDamage", function(self, state, ply, atk)
	if (not state.targets or not state.attacked) then
		return
	end

	if (IsValid(ply) and IsValid(atk)) then
		if (state.targets[atk] == ply) then
			state.attacked[atk] = ply
			return true
		end

		return (atk == ply) or (state.attacked[ply] == atk)
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