--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
resource.AddFile("sound/pluto/cheersong.ogg")

ROUND.MinPlayers = 6
ROUND.BaseToys = 3
ROUND.ToysIncrement = 0.2
ROUND.BaseMilestone = 5.5
ROUND.MilestoneIncrement = 0.75
ROUND.CollisionGroup = COLLISION_GROUP_DEBRIS_TRIGGER
ROUND.Reward = "xmas2020"

util.AddNetworkString "cheer_data"

ROUND.Boss = true

local colors = {"blue", "green", "red", "yellow"}
local WriteRoundData = pluto.rounds.WriteRoundData

function ROUND:Prepare(state)
	timer.Create("pluto_event_timer", 5, 0, function()
		if (not state.players) then
			return
		end
		for k, ply in ipairs(state.players) do
			if (IsValid(ply) and not ply:Alive()) then
				ttt.ForcePlayerSpawn(ply)
			end
		end
	end)

	timer.Pause "tttrw_afk"
end

function ROUND:Finish()
	timer.Remove "pluto_event_timer"
	timer.Remove "pluto_cheer_checker"
	timer.Remove "pluto_cheer_finder"
	timer.Remove "pluto_cheer_radar"
end

function ROUND:Loadout(ply)
	ply:StripWeapons()
	pluto.NextWeaponSpawn = false
	ply:Give "weapon_noise_nitro"
end

ROUND:Hook("TTTSelectRoles", function(self, state, plys)
	for i, ply in ipairs(plys) do
		ply:StripWeapons()
		pluto.NextWeaponSpawn = false
		ply:Give "weapon_noise_nitro"

		round.Players[i] = {
			Player = ply,
			SteamID = ply:SteamID(),
			Nick = ply:Nick(),
			Role = ttt.roles["S.A.N.T.A. Agent"]
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
	for _, ent in ipairs(ents.GetAll()) do
		if (Doors[ent:GetClass()]) then
			ent:Remove()
		end
	end

	state.players = round.GetActivePlayersByRole "S.A.N.T.A. Agent"
	state.cheer = 0
	state.bonus = self.BaseMilestone + math.floor((#state.players - self.MinPlayers) * self.MilestoneIncrement)
	state.needed = self.BaseToys + math.floor((#state.players - self.MinPlayers) * self.ToysIncrement)

	state.collected = {}
	state.target = {}
	state.scores = {}

	state.speed = 1.1
	state.reward = 0
	state.rewards = {
		function(state)
			timer.Create("pluto_cheer_radar", 1.5, 0, function()
				for k, ply in ipairs(state.players) do
					if (not state.target[ply]) then
						return
					end

					local send = {}

					if (not state.collected[ply]) then
						local color = state.target[ply].Color
						for i, toy in ipairs(state[color]) do
							if (IsValid(toy)) then
								send[#send + 1] = {
									Pos = toy:GetPos(),
									Color = pluto.currency.byname["_toy_" .. color].Color,
								}
							end
						end
					elseif (state.radar) then
						send[1] = {
							Pos = state.target[ply].Player:GetPos(),
							Color = ttt.roles["S.A.N.T.A. Agent"].Color,
						} 
					end

					net.Start "cheer_data"
						net.WriteString "radar"
						net.WriteUInt(#send, 32)
						for _, data in ipairs(send) do
							net.WriteFloat(data.Pos.x)
							net.WriteFloat(data.Pos.y)
							net.WriteFloat(data.Pos.z)
							net.WriteUInt(data.Color.r, 32)
							net.WriteUInt(data.Color.g, 32)
							net.WriteUInt(data.Color.b, 32)
						end
					net.Send(ply)
				end
			end)
			
			net.Start "cheer_data"
				net.WriteString "message"
				net.WriteBool(true)
			net.Broadcast()
			pluto.rounds.Notify("Toy radar unlocked!", ttt.roles.Innocent.Color)
		end,
		false,
		function(state)
			state.radar = true
			
			net.Start "cheer_data"
				net.WriteString "message"
				net.WriteBool(true)
			net.Broadcast()
			pluto.rounds.Notify("Friend finder unlocked!", ttt.roles["S.A.N.T.A. Agent"].Color)
		end,
		false,
		function(state)
			state.speed = 1.3

			net.Start "cheer_data"
				net.WriteString "message"
				net.WriteBool(true)
			net.Broadcast()
			pluto.rounds.Notify("Speed boost unlocked!", ttt.roles.Innocent.Color)
		end,
	}

	state.blue = {}
	state.green = {}
	state.red = {}
	state.yellow = {}

	for k, ply in ipairs(state.players) do
		if (not IsValid(ply)) then
			continue 
		end

		if (state.needed > 0) then
			state.needed = state.needed - 1
			table.insert(state.blue, pluto.currency.spawnfor(ply, "_toy_blue", nil, true))
			table.insert(state.green, pluto.currency.spawnfor(ply, "_toy_green", nil, true))
			table.insert(state.red, pluto.currency.spawnfor(ply, "_toy_red", nil, true))
			table.insert(state.yellow, pluto.currency.spawnfor(ply, "_toy_yellow", nil, true))
		end

		local targets = table.Copy(state.players)
		table.remove(targets, k)

		state.scores[ply] = 0

		state.target[ply] = {
			Player = table.Random(targets),
			Color = table.Random(colors),
		}
		
		WriteRoundData("target", state.target[ply].Player:Nick(), ply)
		WriteRoundData("color", state.target[ply].Color, ply)
	end

	WriteRoundData("reward", 0)
	WriteRoundData("collected", false)
	WriteRoundData("bonus", state.bonus)

	GetConVar("ttt_karma"):SetBool(false)

	timer.Create("pluto_cheer_checker", 0.5, 0, function()
		for k, ply in ipairs(state.players) do
			if (not IsValid(ply) or not state.collected[ply] or not state.target[ply] or not IsValid(state.target[ply].Player)) then
				continue
			end

			if (state.target[ply].Player:GetPos():DistToSqr(ply:GetPos()) <= 10000) then
				self:UpdateScore(state, ply)

				local targets = table.Copy(state.players)
				table.remove(targets, k)

				state.target[ply] = {
					Player = table.Random(targets),
					Color = table.Random(colors),
				}

				state.collected[ply] = nil

				WriteRoundData("target", state.target[ply].Player:Nick(), ply)
				WriteRoundData("color", state.target[ply].Color, ply)
	
				WriteRoundData("found", false, ply)
			end
		end
	end)
	
	timer.Simple(1, function()
		round.SetRoundEndTime(CurTime() + 170)
		ttt.SetVisibleRoundEndTime(CurTime() + 170)
	end)
end)

ROUND:Hook("PostPlayerDeath", function(self, state, ply)
	ply:Extinguish()
	return true
end)

function ROUND:UpdateScore(state, ply)
	state.cheer = state.cheer + 1
	state.bonus = state.bonus - 1

	state.scores[ply] = state.scores[ply] + 1

	if (state.bonus < 1) then
		state.bonus = self.BaseMilestone + math.floor((#state.players - self.MinPlayers) * self.MilestoneIncrement)
		if (state.rewards[1]) then
			state.rewards[1](state)
		else
			state.reward = state.reward + 1
			WriteRoundData("reward", state.reward)
			net.Start "cheer_data"
				net.WriteString "message"
				net.WriteBool(true)
			net.Broadcast()
			pluto.rounds.Notify("New present earned!", pluto.currency.byname.xmas2020.Color, nil)
		end

		if (#state.rewards > 0) then
			table.remove(state.rewards, 1)
		end
	else
		net.Start "cheer_data"
			net.WriteString "message"
			net.WriteBool(true)
		net.Send(ply)
			pluto.rounds.Notify("Great job, now look for another!", nil, ply, true)
	end

	WriteRoundData("cheer", state.cheer)
	WriteRoundData("bonus", state.bonus)

	hook.Run("PlutoToyDelivered", ply)
end

ROUND:Hook("SetupMove", function(self, state, ply, mv)
	if (ply.ForcePos) then
		mv:SetOrigin(ply.ForcePos)
		ply.ForcePos = nil
	end
end)

function ROUND:Spawn(state, ply)
	ply:SetCollisionGroup(self.CollisionGroup)
	if (state.players and state.players[ply]) then
		ply:SetHealth(100)
		ply:SetMaxHealth(100)
	end
end

ROUND:Hook("PlayerSpawn", ROUND.Spawn)

local hull_mins, hull_maxs = Vector(-22, -22, 0), Vector(22, 22, 90)

function ROUND:ResetPosition(state, ply)
	return pluto.currency.randompos(hull_mins, hull_maxs)
end

ROUND:Hook("PlayerSelectSpawnPosition", ROUND.ResetPosition)

function ROUND:TTTEndRound(state)
	for _, ent in pairs(state.blue) do
		if (IsValid(ent)) then
			ent:Remove()
		end
	end
	for _, ent in pairs(state.green) do
		if (IsValid(ent)) then
			ent:Remove()
		end
	end
	for _, ent in pairs(state.red) do
		if (IsValid(ent)) then
			ent:Remove()
		end
	end
	for _, ent in pairs(state.yellow) do
		if (IsValid(ent)) then
			ent:Remove()
		end
	end

	GetConVar("ttt_karma"):Revert()
	timer.UnPause("tttrw_afk")

	if (pluto.rounds.forfun) then
		pluto.rounds.forfun = nil
		pluto.rounds.Notify("This round was for fun only, thanks for playing!")
		return
	end
	

	if (state.reward > 0) then
		for k, ply in ipairs(state.players) do
			local togive = state.reward

			if (state.scores[ply] + math.random(0, 1) <= 4) then
				togive = math.min(state.scores[ply], state.reward)
			end

			pluto.db.instance(function(db)
				pluto.inv.addcurrency(db, ply, self.Reward, togive)
				pluto.rounds.Notify("Presents earned: " .. tostring(togive), pluto.currency.byname[self.Reward].Color, ply)
			end)
		end
	end
end

ROUND:Hook("PlutoToyPickup", function(self, state, ply, color, cur)
	if (not state or not state[color]) then
		return
	end

	table.insert(state[color], pluto.currency.spawnfor(ply, "_toy_" .. color, nil, true))

	if (cur and state[color]) then
		local key = table.KeyFromValue(state[color], cur)

		if (key) then
			table.remove(state[color], key)
		end
	end

	if (state.collected[ply] == true) then
		net.Start "cheer_data"
			net.WriteString "message"
			net.WriteBool(false)
		net.Send(ply)
		pluto.rounds.Notify("You already have a toy!", ttt.roles.Traitor.Color, ply, true)
	elseif (state.target[ply] and state.target[ply].Color == color) then
		state.collected[ply] = true
		
		WriteRoundData("found", true, ply)

		pluto.rounds.Notify("Got it, now find your friend!", nil, ply, true)
	else
		net.Start "cheer_data"
			net.WriteString "message"
			net.WriteBool(false)
		net.Send(ply)
		pluto.rounds.Notify("That's the wrong color!", ttt.roles.Traitor.Color, ply, true)
	end
end)

ROUND:Hook("PlayerCanPickupWeapon", function(self, state, ply, wep)
	return wep:GetClass() == "weapon_noise_nitro"
end)

ROUND:Hook("TTTHasRoundBeenWon", function(self, state)
	return false
end)

ROUND:Hook("PlayerDisconnected", function(self, state, ply)
	table.RemoveByValue(state.players, ply)

	for k, _ply in ipairs(state.players) do
		if (state.target[_ply] and state.target[_ply].Player == ply) then
			local targets = table.Copy(state.players)
			table.remove(targets, k)

			state.target[_ply] = {
				Player = table.Random(targets),
				Color = table.Random(colors),
			}
		end
	end
end)

ROUND:Hook("PlayerDeath", function(self, state, vic, inf, atk)
	if (not IsValid(vic) or not state.collected or not state.collected[vic]) then
		return
	end

	local targets = table.Copy(state.players)
	table.remove(targets, vic)

	state.target[vic] = {
		Player = table.Random(targets),
		Color = table.Random(colors),
	}

	state.collected[vic] = nil
	
	WriteRoundData("found", false, vic)

	net.Start "cheer_data"
		net.WriteString "message"
		net.WriteBool(false)
	net.Send(vic)
	pluto.rounds.Notify("You dropped your toy!", ttt.roles.Traitor.Color, vic, true)
end)

ROUND:Hook("PlayerRagdollCreated", function(self, state, ply, rag, atk, dmg)
	timer.Simple(5, function()
		if (IsValid(rag)) then
			rag:Remove()
		end
	end)
end)

function ROUND:PlayerSetModel(state, ply)
	ply:SetModel(pluto.models["santa"].Model)
	ply:SetupHands()

	return true
end

--[[concommand.Add("pluto_test_cheer", function(ply, cmd, args)
	if (not pluto.cancheat(ply) or not pluto.rounds.state) then
		return
	end

	local state = pluto.rounds.state
	local target = state.target[ply]

	if (not target) then
		return
	end

	if (state.collected) then
		state.collected[ply] = true
	end

	timer.Simple(0.1, function()
		if (IsValid(ply) and ply:Alive() and IsValid(target.Player) and target.Player:Alive()) then
			ply:SetPos(target.Player:GetPos())
		end
	end)
end)--]]