ROUND.Reward = "quill"
ROUND.WinnerEarnings = 1

ROUND.Boss = true

local WriteRoundData = pluto.rounds.WriteRoundData

function ROUND:Prepare(state)
	timer.Create("pluto_event_timer", 5, 0, function()
		if (not state.scores) then
			return
		end
		for ply, count in pairs(state.scores) do
			if (IsValid(ply) and not ply:Alive()) then
				ttt.ForcePlayerSpawn(ply)
			end
		end
	end)

	timer.Pause "tttrw_afk"
end

function ROUND:Finish()
	timer.Remove "pluto_event_timer"
	timer.Remove "pluto_koth_timer"
	--timer.Remove "pluto_quill_timer"
end

function ROUND:Loadout(ply)
	pluto.rounds.GiveDefaults(ply, true)
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
	state.scores = {}

	for k, ply in pairs(fighters) do
		state.scores[ply] = 0
		WriteRoundData("score", 0, ply)
		if (ply:Alive()) then
			self:Initialize(state, ply)
		end
		ply:SetMaxHealth(100)
		ply:SetHealth(100)

		if (not IsValid(state.quill)) then
			state.quill = pluto.currency.spawnfor(ply, "_quill", nil, true)
		end
	end

	self:ChooseLeader(state)

	timer.Create("pluto_koth_timer", 1, 0, function()
		if (IsValid(state.holder) and state.holder:Alive()) then
			self:UpdateScore(state, state.holder)
		end
	end)

	--[[timer.Create("pluto_quill_timer", 20, 0, function()
		if not IsValid(state.holder) and IsValid(state.leader)) then
			if (IsValid(state.quill)) then
				state.quill:Remove()
			end

			state.quill = pluto.currency.spawnfor(state.leader, "_quill", nil, true)

			pluto.rounds.Notify("The quill has been moved!", nil, nil, true)
		end
	end)--]]

	GetConVar("ttt_karma"):SetBool(false)
	
	timer.Simple(1, function()
		round.SetRoundEndTime(CurTime() + 210)
		ttt.SetVisibleRoundEndTime(CurTime() + 210)
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

	for ply, score in pairs(state.scores) do
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
			pluto.rounds.Notify(string.format("%s has become the new leader!", new:Nick()), pluto.currency.byname.quill.Color, nil, true)
		end
	end
	
	state.leader = new
	WriteRoundData("leader", new:Nick())
	WriteRoundData("leaderscore", state.scores[new])
end

function ROUND:UpdateScore(state, ply)
	if (not state.scores) then
		return
	end

	state.scores[ply] = (state.scores[ply] or 0) + 1

	WriteRoundData("score", state.scores[ply], ply)

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

	if (IsValid(state.quill)) then
		state.quill:Remove()
	end

	if (pluto.rounds.forfun) then
		pluto.rounds.forfun = nil
		pluto.rounds.Notify("This round was for fun only, thanks for playing!")
		return
	end
	
	self:ChooseLeader(state)

	if (IsValid(state.leader)) then
		pluto.rounds.Notify(state.leader:Nick() .. " is the King of the Quill!", pluto.currency.byname._quill.Color)
		hook.Run("PlutoSpecialWon", {state.leader})
		pluto.db.instance(function(db)
			pluto.inv.addcurrency(db, state.leader, self.Reward, self.WinnerEarnings)
			pluto.rounds.Notify(string.format("You get %i Glass Quill for winning!", self.WinnerEarnings), pluto.currency.byname[self.Reward].Color, state.leader)
		end)
	else
		pluto.rounds.Notify("No kings here...")
	end
end

--[[ROUND:Hook("PlayerCanPickupWeapon", function(self, state, ply, wep)
	return
end)--]]

ROUND:Hook("TTTHasRoundBeenWon", function(self, state)
	if (#round.GetActivePlayersByRole "Fighter" == 0) then
		return true, "traitor", false
	end

	return false
end)

ROUND:Hook("PlayerDisconnected", function(self, state, ply)
	if (not state.scores or not state.scores[ply]) then
		return
	end

	state.scores[ply] = nil
end)

ROUND:Hook("PlayerDeath", function(self, state, vic, inf, atk)
	if (not IsValid(vic)) then
		return
	end

	if (not IsValid(state.holder) or state.holder ~= vic) then
		return
	end

	state.holder:SetRole "Fighter"
	state.holder = nil
	pluto.rounds.Notify("The gold quill has been dropped! Fight for it!", pluto.currency.byname._quill.Color, nil, true)

	if (IsValid(state.quill)) then
		state.quill:Remove()
	end

	state.quill = pluto.currency.spawnfor(vic, "_quill", vic:GetPos(), true)
end)

ROUND:Hook("PlayerShouldTakeDamage", function(self, state, ply, atk)
	if (IsValid(ply) and IsValid(atk) and atk:IsPlayer() and ply:IsPlayer()) then
		return (ply:GetRole() ~= atk:GetRole())
	end
end)

ROUND:Hook("PlayerRagdollCreated", function(self, state, ply, rag, atk, dmg)
	timer.Simple(5, function()
		if (IsValid(rag)) then
			rag:Remove()
		end
	end)
end)

ROUND:Hook("PlutoQuillPickup", function(self, state, ply)
	if (IsValid(state.holder)) then
		return
	end

	if (IsValid(state.quill)) then
		state.quill:Remove()
	end

	state.holder = ply
	ply:SetMaxHealth(250)
	ply:SetHealth(250)
	ply:SetRole "Quill Holder"
	ply.ForcePos = self:ResetPosition(state, ply)

	pluto.rounds.Notify(string.format("%s has picked up the gold quill! Work together to kill them!", ply:Nick()), pluto.currency.byname._quill.Color, nil, true)
end)

--[[function ROUND:PlayerSetModel(state, ply)

end--]]