pluto.rounds = pluto.rounds or {}

pluto.rounds.files = pluto.rounds.files or {}

pluto.rounds.byname = pluto.rounds.byname or {}

local random_rounds = {
	"hotshot",
	"blackmarket",
	"boom",
	"kingofthehill",
}

local event_rounds = {
	"posteaster",
	"chimp",
	"cheer",
}

table.Add(event_rounds, random_rounds)

for _, event in ipairs (event_rounds) do
	local folder = "pluto/events/rounds/" .. event .. "/"

	pluto.rounds.files[event] = {}
	
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
				table.insert(pluto.rounds.files[event], fn)
			end
		end
	end
end

for _, mini in ipairs {
	"aprilfools",
	"raining",
	"dice",
	"stars",
	"dash",
	"hops",
	"panic",
	"leak",
	"jugg",
	"luck",
	"rise",
} do
	local fname = "pluto/events/minis/sh_" .. mini .. ".lua"
	if (not file.Exists (fname, "LUA")) then
		continue
	end

	if (SERVER) then
		AddCSLuaFile(fname)
	end
	include(fname)
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

function pluto.rounds.prepare(name)
	if (not SERVER) then
		return false, "Server function only"
	end

	local event = pluto.rounds.byname[name]

	if (not event) then
		return false, "Event does not exist"
	end

	if (ttt.GetNextRoundEvent() ~= "") then
		return false, "Event already prepared"
	end

	if (GetConVar "ttt_round_limit":GetInt() <= ttt.GetRoundNumber()) then
		return false, "Round limit"
	end

	ttt.SetNextRoundEvent(name)

	return true, "NextRoundEvent set to " .. name
end

function pluto.rounds.clear()
	if (not SERVER) then
		return false, "Server function only"
	end

	ttt.SetNextRoundEvent("")

	return true, "NextRoundEvent cleared"
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