pluto.quests = pluto.quests or {}

-- #83F52C, Daily #FBDB0C, Weekly #FF3030, Unquie #68228B

pluto.quests.types = {
	[0] = {
		Name = "Unique",
		Time = 60 * 60 * 24 * 7, -- week
		Amount = 0,
		Cooldown = 60 * 60 * 24 * 7,
		Color = HexColor "a446d2",
	},
	[1] = {
		Name = "Hourly",
		Time = 60 * 60,
		Amount = 2,
		Cooldown = 60 * 7.5,
		-- #83F52C	
		Color = HexColor "7ef524",
	},
	[2] = {
		Name = "Daily",
		Time = 60 * 60 * 24, -- day
		Amount = 2,
		Cooldown = 60 * 60 * 6,
		Color = HexColor "fcde1d"
	},
	[3] = {
		Name = "Weekly",
		Time = 60 * 60 * 24 * 7, -- week
		Amount = 0,
		Cooldown = 0,
		Color = HexColor "ff1a1a"
	},
}
