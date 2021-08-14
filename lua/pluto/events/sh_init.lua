pluto.rounds = pluto.rounds or {}

pluto.rounds.files = pluto.rounds.files or {}

pluto.rounds.byname = pluto.rounds.byname or {}

pluto.rounds.minis = pluto.rounds.minis or {}

pluto.rounds.cost = {
	Event = 5,
	Random = 3,
	Mini = 1
}

pluto.rounds.infobyname = {
	-- Event Rounds
	posteaster = {
		PrintName = "Bunny Attack",
		Type = "Event",
		MinPlayers = 8,
		Shares = 1,
		NoRandom = true,
		NoBuy = true,
	},
	chimp = {
		PrintName = "Monke Mania",
		Type = "Event",
		MinPlayers = 6,
		Shares = 1,
	},
	cheer = {
		PrintName = "Operation Cheer",
		Type = "Event",
		MinPlayers = 8,
		Shares = 1,
	},

	-- Random Rounds
	hotshot = {
		PrintName = "Hotshot",
		Type = "Random",
		MinPlayers = 4,
		Shares = 1,
	},
	blackmarket = {
		PrintName = "Black Market Brawl",
		Type = "Random",
		MinPlayers = 4,
		Shares = 1,
	},
	boom = {
		PrintName = "Boomer Time",
		Type = "Random",
		MinPlayers = 4,
		Shares = 1,
	},
	kingofthequill = {
		PrintName = "King of the Quill",
		Type = "Random",
		MinPlayers = 6,
		Shares = 1,
	},
	hitlist = {
		PrintName = "Hit List",
		Type = "Random",
		MinPlayers = 4,
		Shares = 1,
	},
	phantom = {
		PrintName = "Phantom Fight",
		Type = "Random",
		MinPlayers = 8,
		Shares = 1,
	},
	trifight = {
		PrintName = "Tri-Fight",
		Type = "Random",
		MinPlayers = 9,
		Shares = 1,
	},
	infection = {
		PrintName = "Infection",
		Type = "Random",
		MinPlayers = 4,
		Shares = 1,
	},
	soulhoarders = {
		PrintName = "Soul Hoarders",
		Type = "Random",
		MinPlayers = 4,
		Shares = 1,
	},

	-- Small Randoms
	saberfools = {
		PrintName = "Saber Fools",
		Type = "Random",
		MaxPlayers = 8,
		Shares = 1,
		NoRandom = true,
		NoBuy = true,
		Small = true,
	},
	unnested = {
		PrintName = "Fighters Unnested",
		Type = "Random",
		MaxPlayers = 8,
		Shares = 1,
		NoRandom = true,
		NoBuy = true,
		Small = true,
	},

	-- Mini Events
	aprilfools = {
		PrintName = "April Fools",
		Type = "Mini",
		Shares = 1,
		Odds = 1 / 16,
		NoRandom = true,
		NoBuy = true,
	},
	raining = {
		PrintName = "Droplet Rain",
		Type = "Mini",
		MinPlayers = 3,
		Shares = 1,
		Odds = 1 / 32,
	},
	dice = {
		PrintName = "Chance Dice",
		Type = "Mini",
		MinPlayers = 3,
		Shares = 1,
		Odds = 1 / 32,
	},
	stars = {
		PrintName = "Shooting Stars",
		Type = "Mini",
		MinPlayers = 3,
		Shares = 1,
		Odds = 1 / 32,
	},
	dash = {
		PrintName = "Dasher",
		Type = "Mini",
		MinPlayers = 4,
		Shares = 1,
		Odds = 1 / 48,
	},
	hops = {
		PrintName = "Leg Day",
		Type = "Mini",
		MaxPlayers = 10,
		Shares = 1,
		Odds = 1 / 48,
	},
	panic = {
		PrintName = "Panic",
		Type = "Mini",
		Shares = 1,
		Odds = 1 / 48,
	},
	leak = {
		PrintName = "Intel Leak",
		Type = "Mini",
		MinPlayers = 4,
		Shares = 1,
		Odds = 1 / 48,
	},
	jugg = {
		PrintName = "Operation JUGG",
		Type = "Mini",
		Shares = 1,
		Odds = 1 / 48,
	},
	luck = {
		PrintName = "Press Your Luck",
		Type = "Mini",
		MinPlayers = 4,
		Shares = 1,
		Odds = 1 / 48,
	},
	rise = {
		PrintName = "Rise, Dead",
		Type = "Mini",
		MinPlayers = 4,
		MaxPlayers = 10,
		Shares = 1,
		Odds = 1 / 48,
	},
	saber = {
		PrintName = "Saber Round",
		Type = "Mini",
		MaxPlayers = 10,
		Shares = 1,
		Odds = 1 / 48,
	},
	ticket = {
		PrintName = "Ticket Round",
		Type = "Mini",
		MinPlayers = 5,
		Shares = 1,
		Odds = 1 / 16,
		NoBuy = true,
	},
	wink = {
		PrintName = "Wink Round",
		Type = "Mini",
		MaxPlayers = 7,
		Shares = 1,
		Odds = 1 / 24,
		NoBuy = true,
	},
	overflow = {
		PrintName = "Equipment Overflow",
		Type = "Mini",
		Shares = 1,
		Odds = 1 / 48,
	},
	ttv = {
		PrintName = "TTVillage",
		Type = "Mini",
		MinPlayers = 6,
		Shares = 1,
		Odds = 1 / 24,
	},
	lime = {
		PrintName = "RDM Limeinade Round",
		Type = "Mini",
		Shares = 1,
		Odds = 1 / 128,
		NoBuy = true,
	},
	wave = {
		PrintName = "Wave Speed",
		Type = "Mini",
		MaxPlayers = 7,
		Shares = 1,
		Odds = 1 / 24,
		NoBuy = true,
	},
	smalls = {
		PrintName = "Smalls Activator",
		Type = "Mini",
		MaxPlayers = 7,
		Shares = 1,
		Odds = 0.3 / 16, -- TODO(Addi) Remove once there are more
		NoBuy = true,
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

local colors = {
	red = Color(255, 0, 0),
	green = Color(0, 255, 0),
	blue = Color(0, 0, 255),
	--[[
	yellow = Color(255, 255, 0),
	pink = Color(255, 0, 255),
	cyan = Color(0, 255, 255),
	white = Color(255, 255, 255),
	black = Color(0, 0, 0),
	]]--
}

--[[for name, color in pairs(colors) do -- REMOVE?
	resource.AddFile("materials/pluto/roles/" .. name .. ".png")
end--]]

local function capitalize(name)
	return (string.upper(string.sub(name, 1, 1)) .. string.sub(name, 2))
end

hook.Add("TTTPrepareRoles", "pluto_events_roles", function(Team, Role)
	for name, color in pairs(colors) do
		Team(name)
			:SetColor(color)
			:TeamChatSeenBy(name)
			:SetVoiceChannel(name)
			:SetDeathIcon("materials/pluto/roles/" .. name .. ".png")
			:SetSeeTeammateOutlines(true)

		Role(capitalize(name), name)
			:SeenByAll()
			:SetCalculateAmountFunc(function(total_players)
				return 0
			end)
	end
	
	Role("Fighter", "traitor")
		:SetCalculateAmountFunc(function(total_players)
			return 0
		end)
		:SetCanUseBuyMenu(false)
		:SetCanSeeThroughWalls(false)

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

------- TESTING -------
--[[for k, ply in ipairs(player.GetAll()) do
	if (SERVER) then
		ply:StripWeapons()
		ply:Give("weapon_ttt_knife")
		ply:SetModel("models/player/skeleton.mdl")
		ply:SetupHands()
		ply:SetRenderMode(RENDERMODE_TRANSCOLOR)
		ply:SetColor(Color(0, 0, 0, 50))
	else
		-- Add darkness
	end
end--]]