pluto.rounds = pluto.rounds or {}

pluto.rounds.files = pluto.rounds.files or {}

pluto.rounds.byname = pluto.rounds.byname or {}

pluto.rounds.minis = pluto.rounds.minis or {}

pluto.rounds.infobyname = {
	-- Event Rounds
	posteaster = {
		Type = "Event",
		MinPlayers = 8,
		Shares = 1,
		Disabled = true,
	},
	chimp = {
		Type = "Event",
		MinPlayers = 6,
		Shares = 1,
	},
	cheer = {
		Type = "Event",
		MinPlayers = 8,
		Shares = 1,
	},

	-- Random Rounds
	hotshot = {
		Type = "Random",
		MinPlayers = 4,
		Shares = 1,
	},
	blackmarket = {
		Type = "Random",
		MinPlayers = 6,
		Shares = 1,
	},
	boom = {
		Type = "Random",
		MinPlayers = 6,
		Shares = 1,
	},
	kingofthehill = {
		Type = "Random",
		MinPlayers = 4,
		Shares = 1,
	},

	-- Mini Events
	aprilfools = {
		Type = "Mini",
		MinPlayers = 2,
		Shares = 1,
		Odds = 1 / 16,
		Disabled = true,
	},
	raining = {
		Type = "Mini",
		MinPlayers = 3,
		Shares = 1,
		Odds = 1 / 32,
	},
	dice = {
		Type = "Mini",
		MinPlayers = 3,
		Shares = 1,
		Odds = 1 / 32,
	},
	stars = {
		Type = "Mini",
		MinPlayers = 3,
		Shares = 1,
		Odds = 1 / 32,
	},
	dash = {
		Type = "Mini",
		MinPlayers = 4,
		Shares = 1,
		Odds = 1 / 48,
	},
	hops = {
		Type = "Mini",
		MinPlayers = 2,
		Shares = 1,
		Odds = 1 / 48,
	},
	panic = {
		Type = "Mini",
		MinPlayers = 2,
		Shares = 1,
		Odds = 1 / 48,
	},
	leak = {
		Type = "Mini",
		MinPlayers = 4,
		Shares = 1,
		Odds = 1 / 48,
	},
	jugg = {
		Type = "Mini",
		MinPlayers = 2,
		Shares = 1,
		Odds = 1 / 48,
	},
	luck = {
		Type = "Mini",
		MinPlayers = 4,
		Shares = 1,
		Odds = 1 / 48,
	},
	rise = {
		Type = "Mini",
		MinPlayers = 4,
		Shares = 1,
		Odds = 1 / 48,
	},
	saber = {
		Type = "Mini",
		MinPlayers = 2,
		Shares = 1,
		Odds = 1 / 48,
	},
}

for name, event in pairs(pluto.rounds.infobyname) do
	if (event.Type and event.Type == "Mini") then
		local fname = "pluto/events/minis/sh_" .. name .. ".lua"
		if (not file.Exists (fname, "LUA")) then
			continue
		end

		if (SERVER) then
			AddCSLuaFile(fname)
		end
		include(fname)
	else
		local folder = "pluto/events/rounds/" .. name .. "/"

		pluto.rounds.files[name] = {}
		
		for _, extra in ipairs {
			"sh_init",
			"sv_init",
			"cl_init",
		} do
			fname = folder .. extra .. ".lua"
			if (file.Exists(fname, "LUA")) then
				if (SERVER and extra ~= "sv_init") then
					AddCSLuaFile(fname)
				end
				if (SERVER and extra == "sv_init" or CLIENT and extra == "cl_init" or extra == "sh_init") then
					local fn = CompileFile(fname)
					if (not fn) then
						continue
					end
					table.insert(pluto.rounds.files[name], fn)
				end
			end
		end
	end
end

--- Rounds ---

local ROUND_DATA = {}
pluto.rounds.mt = pluto.rounds.mt or {}
pluto.rounds.mt.__index = ROUND_DATA

function ROUND_DATA:Hook(event, func)
	self.Hooks = self.Hooks or {}
	self.Hooks[event] = func
end

local function Initialize()
	for event, init in pairs(pluto.rounds.files) do
		ROUND = setmetatable(pluto.rounds.byname[event] or {}, pluto.rounds.mt)

		pluto.rounds.byname[event] = ROUND

		for _, fn in ipairs(init) do
			fn()
		end
	end
end

hook.Add("TTTPrepareRoles", "pluto_events_roles", function(Team, Role)
	for _, event in pairs(pluto.rounds.byname) do
		if (event.TTTPrepareRoles) then
			event:TTTPrepareRoles(Team, Role)
		end
	end
	
	Role("Fighter", "traitor")
		:SetCalculateAmountFunc(function(total_players)
			return 0
		end)
		:SetCanUseBuyMenu(false)
		:SetCanSeeThroughWalls(false)
end)

if (gmod.GetGamemode()) then
	Initialize()
else
	hook.Add("Initialize", "pluto_rounds", Initialize)
end

function pluto.rounds.run(hook, ...)
	local event = pluto.rounds.get(ttt.GetCurrentRoundEvent())
	if (event and event[hook]) then
		return event[hook](event, pluto.rounds.state, ...)
	end
end

function pluto.rounds.getcurrent()
	return pluto.rounds.get(ttt.GetCurrentRoundEvent())
end

function pluto.rounds.get(name)
	return pluto.rounds.byname[name]
end

hook.Add("TTTPrepareNetworkingVariables", "pluto_event", function(vars)
	table.insert(vars, {
		Name = "NextRoundEvent",
		Type = "String",
		Default = ""
	})
	table.insert(vars, {
		Name = "CurrentRoundEvent",
		Type = "String",
		Default = ""
	})
end)

hook.Add("TTTGetHiddenPlayerVariables", "pluto_event", function(vars)
	table.insert(vars, {
		Name = "NextEventRole",
		Type = "String",
		Default = nil
	})
end)

hook.Add("OnNextRoundEventChange", "pluto_event", function(old, new)
	local event = pluto.rounds.get(new)
	if (event and event.NotifyPrepare) then
		event:NotifyPrepare()
	end

	local event = pluto.rounds.get(old)
	if (event and event.NotifyCancel) then
		event:NotifyCancel()
	end
end)

hook.Add("OnCurrentRoundEventChange", "pluto_event", function(old, new)
	if (new == "" and old ~= "") then
		local event = pluto.rounds.get(old)
		if (event) then
			if (event.Finish) then
				event:Finish(pluto.rounds.state)
			end
	
			for event, fn in pairs(event.Hooks or {}) do
				hook.Remove(event, "pluto_event")
			end
		end
		return
	end

	local event = pluto.rounds.get(new)

	if (not event) then
		pwarnf("No event %s", new)
		return
	end

	pluto.rounds.state = {}

	if (event) then
		if (event.Prepare) then
			event:Prepare(pluto.rounds.state)
		end

		for hookevent, fn in pairs(event.Hooks or {}) do
			hook.Add(hookevent, "pluto_event", function(...)
				return fn(event, pluto.rounds.state, ...)
			end)
		end
	end
end)

hook.Add("TTTPrepareRound", "pluto_event_manager", function()
	local event = pluto.rounds.get(ttt.GetNextRoundEvent())

	ttt.SetCurrentRoundEvent(ttt.GetNextRoundEvent())
	ttt.SetNextRoundEvent ""
end)

hook.Add("TTTEndRound", "pluto_event_manager", function()
	local current = pluto.rounds.getcurrent()
	if (current and current.TTTEndRound) then
		current:TTTEndRound(pluto.rounds.state)
	end

	ttt.SetCurrentRoundEvent ""
end)

--- Minis ---

pluto.rounds.speeds = {}

hook.Add("TTTUpdatePlayerSpeed", "pluto_mini_speeds", function(ply, data)
	data.mini = pluto.rounds.speeds[ply] or 1
end)

hook.Add("TTTEndRound", "pluto_remove_minis", function()
	pluto.rounds.speeds = {}
end)