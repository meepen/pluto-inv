resource.AddFile("sound/pluto/cheersong.ogg")

ROUND.Name = "Operation Cheer"
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
end

function ROUND:Loadout(ply)
	ply:StripWeapons()
	pluto.NextWeaponSpawn = false
	ply:Give "weapon_ttt_unarmed"
end

ROUND:Hook("TTTSelectRoles", function(self, state, plys)
	for i, ply in ipairs(plys) do
		ply:StripWeapons()
		pluto.NextWeaponSpawn = false
		ply:Give "weapon_ttt_unarmed"

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
	for _, ent in pairs(ents.GetAll()) do
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

	state.speed = 1.1
	state.reward = 0
	state.rewards = {
		false,
		function(state)
			timer.Create("pluto_cheer_radar", 5, 0, function()
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
				net.WriteString "The cheer that's here is great combined; the toys this tool will help you find!"
				net.WriteBool(true)
			net.Broadcast()
		end,
		false,
		function(state)
			state.radar = true
			
			net.Start "cheer_data"
				net.WriteString "message"
				net.WriteString "To locate the player that you seek, use this radar to get a peek!"
				net.WriteBool(true)
			net.Broadcast()
		end,
		false,
		function(state)
			state.speed = 1.3

			net.Start "cheer_data"
				net.WriteString "message"
				net.WriteString "You've already got all you need, so here's a little boost of speed!"
				net.WriteBool(true)
			net.Broadcast()
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

		state.target[ply] = {
			Player = table.Random(targets),
			Color = table.Random(colors),
		}
		
		net.Start "cheer_data"
			net.WriteString "target"
			net.WriteString(state.target[ply].Player:Nick())
		net.Send(ply)
		
		net.Start "cheer_data"
			net.WriteString "color"
			net.WriteString(state.target[ply].Color)
		net.Send(ply)
	end

	net.Start "cheer_data"
		net.WriteString "cheer"
		net.WriteUInt(state.cheer, 32)
	net.Broadcast()

	net.Start "cheer_data"
		net.WriteString "collected"
		net.WriteBool(state.collected[ply] or false)
	net.Broadcast()

	net.Start "cheer_data"
		net.WriteString "bonus"
		net.WriteUInt(state.bonus, 32)
	net.Broadcast()

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
				
				net.Start "cheer_data"
					net.WriteString "target"
					net.WriteString(state.target[ply].Player:Nick())
				net.Send(ply)
				
				net.Start "cheer_data"
					net.WriteString "color"
					net.WriteString(state.target[ply].Color)
				net.Send(ply)
	
				net.Start "cheer_data"
					net.WriteString "found"
					net.WriteBool(false)
				net.Send(ply)
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

function ROUND:Initialize(state, ply)
	self:PlayerSetModel(state, ply)
	self:Spawn(state, ply)
	local pos = self:ResetPosition(state, ply)
	if (pos) then
		ply.ForcePos = pos
	end
end

function ROUND:UpdateScore(state, ply)
	state.cheer = state.cheer + 1
	state.bonus = state.bonus - 1

	if (state.bonus < 1) then
		state.bonus = self.BaseMilestone + math.floor((#state.players - self.MinPlayers) * self.MilestoneIncrement)
		if (state.rewards[1]) then
			state.rewards[1](state)
		else
			state.reward = state.reward + 1
			net.Start "cheer_data"
				net.WriteString "message"
				net.WriteString "Our spirits you have worked to lift, so at the end you get a gift!"
				net.WriteBool(true)
			net.Broadcast()
		end

		if (#state.rewards > 0) then
			table.remove(state.rewards, 1)
		end
	else
		net.Start "cheer_data"
			net.WriteString "message"
			net.WriteString "Because of your efforts, we've reason to revel, our cheer unmatched on a new level!"
			net.WriteBool(true)
		net.Send(ply)
	end

	net.Start "cheer_data"
		net.WriteString "cheer"
		net.WriteUInt(state.cheer, 32)
	net.Broadcast()

	net.Start "cheer_data"
		net.WriteString "bonus"
		net.WriteUInt(state.bonus, 32)
	net.Broadcast()

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
	return select(1, pluto.currency.randompos(hull_mins, hull_maxs))
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

	if (state.reward > 0) then
		for k, ply in ipairs(state.players) do
			ply:ChatPrint(white_text, "For the way your team did work, have a gift as a perk!")
			pluto.db.instance(function(db)
				pluto.inv.addcurrency(db, ply, self.Reward, state.reward)
				ply:ChatPrint(white_text, state.reward, " ", pluto.currency.byname[self.Reward], state.reward > 1 and "s" or "", white_text, state.reward > 1 and " are" or " is", " now yours for reaching such a level of scores")
			end)
		end
	end

	timer.Remove("pluto_cheer_checker")
	timer.Remove("pluto_cheer_finder")
	timer.Remove("pluto_cheer_radar")

	GetConVar("ttt_karma"):Revert()
	timer.UnPause("tttrw_afk")
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

	if (state.target[ply] and state.target[ply].Color == color) then
		if (state.collected[ply] == true) then
			net.Start "cheer_data"
				net.WriteString "message"
				net.WriteString "You have got a toy already, fix your eyes and keep them steady!"
				net.WriteBool(false)
			net.Send(ply)
			return
		end

		state.collected[ply] = true
		
		net.Start "cheer_data"
			net.WriteString "found"
			net.WriteBool(true)
		net.Send(ply)

		net.Start "cheer_data"
			net.WriteString "message"
			net.WriteString "Your findings here I do commend, now take this toy right to your friend!"
		net.Send(ply)
	else
		net.Start "cheer_data"
			net.WriteString "message"
			net.WriteString "Are you sure you're not too chilly? That's the wrong color, please don't be silly!"
			net.WriteBool(false)
		net.Send(ply)
	end
end)

ROUND:Hook("PlayerCanPickupWeapon", function(self, state, ply, wep)
	return wep:GetClass() == "weapon_ttt_unarmed"
end)

ROUND:Hook("TTTHasRoundBeenWon", function(self, state)
	return false
end)

ROUND:Hook("PlayerDisconnected", function(self, state, ply)
	table.RemoveByValue(state.players, ply)

	for k, _ply in ipairs(state.players) do
		if (state.target[ply] and state.target[ply].Player == _ply) then
			local targets = table.Copy(state.players)
			table.remove(targets, k)

			state.target[ply] = {
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

	state.collected[vic] = nil
	
	net.Start "cheer_data"
		net.WriteString "found"
		net.WriteBool(false)
	net.Send(vic)

	net.Start "cheer_data"
		net.WriteString "message"
		net.WriteString "It seems that as your life has flopped, so too the toy you had was dropped."
		net.WriteBool(false)
	net.Send(vic)
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

	return true
end

concommand.Add("pluto_test_cheer", function(ply, cmd, args)
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
end)