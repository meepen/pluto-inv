--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
pluto.highscores = pluto.highscores or {}
pluto.highscores.byname = pluto.highscores.byname or {}

local list = {
    -- Kills
    {
        InternalName = "totalkills",
        Name = "Total Kills",
        Description = "Total number of players killed rightfully",
        Category = "Kills",
        MinPlayers = 5,
    },
    {
        InternalName = "detectivekills",
        Name = "Detective Kills",
        Description = "Detectives killed rightfully",
        Category = "Kills",
    },
    {
        InternalName = "traitorkills",
        Name = "Traitor Kills",
        Description = "Traitors killed rightfully",
        Category = "Kills",
        MinPlayers = 5,
    },
    {
        InternalName = "innocentkills",
        Name = "Innocent Kills",
        Description = "Innocents killed rightfully",
        Category = "Kills",
        MinPlayers = 5,
    },
    {
        InternalName = "uniquekills",
        Name = "Unique Kills",
        Description = "Rightful kills with unique weapons",
        Category = "Kills",
        MinPlayers = 5,
    },
    {
        InternalName = "confusedkills",
        Name = "Confused Kills",
        Description = "Rightful kills with confused weapons",
        Category = "Kills",
        MinPlayers = 5,
    },
    {
        InternalName = "meleekills",
        Name = "Melee Kills",
        Description = "Rightful kills with melee weapons",
        Category = "Kills",
        MinPlayers = 5,
    },
    {
        InternalName = "secondarykills",
        Name = "Secondary Kills",
        Description = "Rightful kills with secondary weapons",
        Category = "Kills",
        MinPlayers = 5,
    },
    {
        InternalName = "primarykills",
        Name = "Primary Kills",
        Description = "Rightful kills with primary weapons",
        Category = "Kills",
        MinPlayers = 5,
    },
    --[[{
        InternalName = "grenadekills",
        Name = "Grenade Kills",
        Description = "Rightful kills with grenades",
        Category = "Kills",
        MinPlayers = 5,
    },--]]
    {
        InternalName = "tweaponkills",
        Name = "Traitor Weapon Kills",
        Description = "Rightful kills with traitor weapons",
        Category = "Kills",
        MinPlayers = 5,
    },
    --[[{
        InternalName = "headshotkills",
        Name = "Headshot Kills",
        Description = "Rightful kills via headshots",
        Category = "Kills",
        MinPlayers = 5,
    },--]]
    {
        InternalName = "postmortemkills",
        Name = "Postmortem Kills",
        Description = "Rightful kills while dead",
        Category = "Kills",
        MinPlayers = 5,
    },
    {
        InternalName = "specialkills",
        Name = "Special Round Kills",
        Description = "Kills during random/event rounds", -- Limit 10 per round?
        Category = "Kills",
    },
    -- Performance
    {
        InternalName = "creditsspent",
        Name = "Credits Spent",
        Description = "Number of equipment credits spent",
        Category = "Performance",
        MinPlayers = 5,
    },
    {
        InternalName = "roundswon",
        Name = "Rounds Won",
        Description = "Rounds won, living or dead",
        Category = "Performance",
        MinPlayers = 5,
    },
    {
        InternalName = "roundssurvived",
        Name = "Rounds Survived",
        Description = "Rounds survived, win or loss",
        Category = "Performance",
        MinPlayers = 5,
    },
    {
        InternalName = "totalhealing",
        Name = "Total Healing",
        Description = "Amount of healing done",
        Category = "Performance",
        MinPlayers = 5,
    },
    {
        InternalName = "timesurvived",
        Name = "Time Survived",
        Description = "Round time spent alive",
        Category = "Performance",
        MinPlayers = 5,
    },
    {
        InternalName = "specialswon",
        Name = "Special Rounds Won",
        Description = "Random and event rounds won",
        Category = "Performance",
    },
    {
        InternalName = "bodiesidentified",
        Name = "Bodies Identified",
        Description = "Number of bodies identified",
        Category = "Performance",
        MinPlayers = 5,
    },
    {
        InternalName = "dnatracks",
        Name = "DNA Tracks",
        Description = "Traitors tracked via body DNA",
        Category = "Performance",
    },
    -- Quests
    {
        InternalName = "hourlyquests",
        Name = "Hourlies Completed",
        Description = "Number of hourly quests completed",
        Category = "Quests",
    },
    {
        InternalName = "dailyquests",
        Name = "Dailies Completed",
        Description = "Number of daily quests completed",
        Category = "Quests",
    },
    {
        InternalName = "weeklyquests",
        Name = "Weeklies Completed",
        Description = "Number of weekly quests completed",
        Category = "Quests",
    },
    {
        InternalName = "uniquequests",
        Name = "Uniques Completed",
        Description = "Number of unique quests completed",
        Category = "Quests",
    },
    -- Crafting
    {
        InternalName = "totalcrafts",
        Name = "Total Weapons Crafted",
        Description = "Number of weapons crafted",
        Category = "Crafting",
    },
    {
        InternalName = "twomodcrafts",
        Name = "Two-Mod Weapons Crafted",
        Description = "Number of two-mod weapons crafted",
        Category = "Crafting",
    },
    {
        InternalName = "threemodcrafts",
        Name = "Three-Mod Weapons Crafted",
        Description = "Number of three-mod weapons crafted",
        Category = "Crafting",
    },
    {
        InternalName = "fourmodcrafts",
        Name = "Four-Mod Weapons Crafted",
        Description = "Number of four-mod weapons crafted",
        Category = "Crafting",
    },
    {
        InternalName = "fivemodcrafts",
        Name = "Five-Mod Weapons Crafted",
        Description = "Number of five-mod weapons crafted",
        Category = "Crafting",
    },
    {
        InternalName = "sixmodcrafts",
        Name = "Six-Mod Weapons Crafted",
        Description = "Number of six-mod weapons crafted",
        Category = "Crafting",
    },
    {
        InternalName = "sevenmodcrafts",
        Name = "Seven-Mod Weapons Crafted",
        Description = "Number of seven-mod weapons crafted",
        Category = "Crafting",
    },
    {
        InternalName = "currencycrafts",
        Name = "Currency Crafts",
        Description = "Number of currency-modded crafts",
        Category = "Crafting",
    },
    {
        InternalName = "wepssacrificed",
        Name = "Weapons Sacrificed",
        Description = "Number of weapons sacrificed in crafts",
        Category = "Crafting",
    },
    -- Currency
    {
        InternalName = "currencyused",
        Name = "Currency Used",
        Description = "Amount of modifier currency used",
        Category = "Currency",
    },
    {
        InternalName = "unboxablesopened",
        Name = "Unboxables Opened",
        Description = "Number of unboxable currency opened",
        Category = "Currency",
    },
    {
        InternalName = "stardustspent",
        Name = "Stardust Spent",
        Description = "Amount of stardust spent",
        Category = "Currency",
    },
    {
        InternalName = "refiniumspent",
        Name = "Refinium Vials Spent",
        Description = "Number of refinium vials spent",
        Category = "Currency",
    },
    {
        InternalName = "specialsstarted",
        Name = "Special Rounds Started",
        Description = "Random and event rounds started",
        Category = "Currency",
    },
    -- Drops
    {
        InternalName = "rareshards",
        Name = "Rare Shards Dropped",
        Description = "Number of rare shards sharded",
        Category = "Drops",
    },
    {
        InternalName = "rareweapons",
        Name = "Rare Weapons Dropped",
        Description = "Number of rare weapons unboxed",
        Category = "Drops",
    },
    {
        InternalName = "raremodels",
        Name = "Rare Models Dropped",
        Description = "Number of rare models unboxed",
        Category = "Drops",
    },
}

for _, highscore in ipairs(list) do
	local old = pluto.highscores.byname[highscore.InternalName]
	if (old) then
		highscore, old = old, highscore
		table.Merge(highscore, old)
	end

    pluto.highscores.byname[highscore.InternalName] = highscore
end

if (CLIENT) then
    concommand.Add("pluto_list_highscores", function(ply, cmd, args)
        for _, highscore in ipairs(list) do
            print(string.format("%s: %s", highscore.Name, highscore.Description))
        end
    end)
end