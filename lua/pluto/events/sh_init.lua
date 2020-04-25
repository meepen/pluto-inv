pluto.rounds = pluto.rounds or {}

pluto.rounds.files = pluto.rounds.files or {}

pluto.rounds.byname = pluto.rounds.byname or {}

for _, event in pairs {
	"posteaster"
} do
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
				table.insert(pluto.rounds.files[event], CompileFile(fname))
			end
		end
	end
end

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

		pprintf("Registered %s event round", event)
	end
end

hook.Add("TTTPrepareRoles", "pluto_events_roles", function(Team, Role)
	for _, event in pairs(pluto.rounds.byname) do
		if (event.TTTPrepareRoles) then
			event:TTTPrepareRoles(Team, Role)
		end
	end
end)

if (gmod.GetGamemode()) then
	Initialize()
else
	hook.Add("Initialize", "pluto_rounds", Initialize)
end

function pluto.rounds.run(hook, ...)
	if (pluto.rounds.current and pluto.rounds.current[hook]) then
		return pluto.rounds.current[hook](pluto.rounds.current, pluto.rounds.state, ...)
	end
end

function pluto.rounds.prepare(name)
	local event = pluto.rounds.byname[name]

	if (not event) then
		return false, "Event does not exist"
	end

	if (pluto.rounds.next) then
		return false, "Event already prepared"
	end

	if (GetConVar "ttt_round_limit":GetInt() <= ttt.GetRoundNumber() + 1) then
		return false, "Round limit"
	end

	pluto.rounds.next = event

	return true
end

function pluto.rounds.cancel()
	local event = pluto.rounds.next
	if (event and event.Cancel) then
		event:Cancel()
		pluto.rounds.next = nil
		return true
	end

	return false, "No ability to cancel"
end

hook.Add("TTTPrepareRound", "pluto_event_manager", function()
	local event = pluto.rounds.next

	pluto.rounds.current = event
	pluto.rounds.state = {}
	pluto.rounds.next = nil

	if (event) then
		if (event.Prepare) then
			event:Prepare(pluto.rounds.state)
		end

		for hookevent, fn in pairs(event.Hooks) do
			hook.Add(hookevent, "pluto_event", function(...)
				return fn(event, pluto.rounds.state, ...)
			end)
		end
	end
end)

hook.Add("TTTEndRound", "pluto_event_manager", function()
	local event = pluto.rounds.current

	pluto.rounds.current = nil

	if (event) then
		if (event.Finish) then
			event:Finish(pluto.rounds.state)
		end

		for event, fn in pairs(event.Hooks) do
			hook.Remove(event, "pluto_event")
		end
	end
end)