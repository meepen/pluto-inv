pluto.quests = pluto.quests or {}

-- #83F52C, Daily #FBDB0C, Weekly #FF3030, Unquie #68228B

pluto.quests.types = {
	{
		Name = "Unique",
		RewardPool = "unique",
		Time = 60 * 60 * 24 * 16,
		Amount = 0,
		Cooldown = 60 * 60 * 24,
		Color = HexColor "a446d2",
	},
	{
		Name = "Hourly",
		RewardPool = "hourly",
		Time = 60 * 60,
		Amount = 3,
		Cooldown = 60 * 7.5,
		-- #83F52C	
		Color = HexColor "7ef524",
	},
	{
		Name = "Daily",
		RewardPool = "daily",
		Time = 60 * 60 * 24, -- day
		Amount = 3,
		Cooldown = 60 * 60 * 6,
		Color = HexColor "fcde1d"
	},
	{
		Name = "Weekly",
		RewardPool = "weekly",
		Time = 60 * 60 * 24 * 7, -- week
		Amount = 2,
		Cooldown = 60 * 60 * 24 * 2,
		Color = HexColor "ff1a1a"
	},
}

pluto.quests.bypool = {}

for _, type in ipairs(pluto.quests.types) do
	pluto.quests.bypool[type.RewardPool] = type
end