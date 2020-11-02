local function CHRISTMAS(g)
	return Color(0x33, 0x67, 0x39)
end

c "cayde6" {
	Name = "Cayde 6",
	Model = "models/cayde_6_pm/cayde_6_pm.mdl",
	Hands = "models/cayde6_arms/cayde6_arms.mdl",
	SubDescription = "Nightstalkers have many friends. It’s the bow. Everyone loves the bow.\nSuggested by MindbenderJ [Pluto.gg] on the December 2019 Forum Thread",
	Color = xmas_rare,
}

c "nigt1" {
	Name = "Sentinel 1",
	Model = "models/demons/nigt_sentinel_1.mdl",
	--Hands = "models/nigt_sentinel_1_arm.mdl",
	Color = CHRISTMAS(0.4),
	SubDescription = "Suggested by NukeBeta on the December 2019 Forum Thread",
}

c "nigt2" {
	Name = "Sentinel 2",
	Model = "models/demons/nigt_sentinel_2.mdl",
	--Hands = "models/nigt_sentinel_2_arm.mdl",
	Color = CHRISTMAS(0.4),
	SubDescription = "Suggested by NukeBeta on the December 2019 Forum Thread",
}

c "warmor" {
	Name = "Winterized Combat Armor",
	Model = "models/kuma96/winterizedarmor/winterizedarmor_pm.mdl",
	Hands = "models/kuma96/winterizedarmor/winterizedarmor_carms.mdl",
	Color = CHRISTMAS(0.6),
	SubDescription = "\nSuggested by Mia Fey! on the December 2019 Forum Thread",
}


local metro_descs = {
	"Humans had always been better at killing than any other living thing.",
	"There's only one thing that can save a man from madness and that's uncertainty.",
	"The number of places in paradise is limited; only in hell is entry open to all.",
	"Never discuss the rights of the strong. You are too weak to do that.",
}
local function metro_desc(i) return metro_descs[((i + 1) % #metro_descs) + 1] .. "\nSuggested by CheeseJuggernaut on the December 2019 Forum Thread" end
local function metro() return Color(255,0,0) end

local generic_male = GenerateBodygroups {
	{
		"Gloves", 3
	},
	{
		"Headgear", 9
	},
	{
		"Legs", 6
	},
	{
		"Torso", 6
	},
}
local generic_female = GenerateBodygroups {
	{
		"Hands", 3
	},
	{
		"Headgear", 2
	},
	{
		"Body", 3
	},
}
local generic_female_hands = GenerateBodygroups {
	{
		"Hands", 3
	},
	{
		"Headgear", 9
	},
	{
		"Body", 3
	},
}

-- metro
c "metro_male_2" {
	Name = "Metro Male 2",
	Model = "models/half-dead/metroll/m2b1.mdl",
	Hands = "models/half-dead/metroll/c_arms_male1.mdl",
	SubDescription = metro_desc(1),
	Color = CHRISTMAS(0),
	GenerateBodygroups = generic_male,
}
c "metro_male_1" {
	Name = "Metro Male 1",
	Model = "models/half-dead/metroll/m1b1.mdl",
	Hands = "models/half-dead/metroll/c_arms_male1.mdl",
	SubDescription = metro_desc(2),
	Color = CHRISTMAS(0),
	GenerateBodygroups = generic_male,
}
c "metro1" {
	Name = "Metro Extra 1",
	Model = "models/half-dead/metroll/a1b1.mdl",
	Hands = "models/half-dead/metroll/c_arms_male1.mdl",
	SubDescription = metro_desc(3),
	Color = CHRISTMAS(0),
	GenerateBodygroups = generic_male,
}
c "metro6" {
	Name = "Metro Extra 6",
	Model = "models/half-dead/metroll/a6b1.mdl",
	Hands = "models/half-dead/metroll/c_arms_male1.mdl",
	SubDescription = metro_desc(4),
	Color = CHRISTMAS(0),
	GenerateBodygroups = generic_male,
}
c "metro_male_6" {
	Name = "Metro Male 6",
	Model = "models/half-dead/metroll/m7b1.mdl",
	Hands = "models/half-dead/metroll/c_arms_male1.mdl",
	SubDescription = metro_desc(5),
	Color = CHRISTMAS(0),
	GenerateBodygroups = generic_male,
}
c "metro_male_5" {
	Name = "Metro Male 5",
	Model = "models/half-dead/metroll/m6b1.mdl",
	Hands = "models/half-dead/metroll/c_arms_male1.mdl",
	SubDescription = metro_desc(6),
	Color = CHRISTMAS(0),
	GenerateBodygroups = generic_male,
}
c "metro_female_6" {
	Name = "Metro Female 6",
	Model = "models/half-dead/metroll/f7b1.mdl",
	Hands = "models/half-dead/metroll/c_arms_male1.mdl",
	SubDescription = metro_desc(7),
	Color = CHRISTMAS(0),
	GenerateBodygroups = generic_female,
	Gender = "Female",
}
c "metro_male_4" {
	Name = "Metro Male 4",
	Model = "models/half-dead/metroll/m5b1.mdl",
	Hands = "models/half-dead/metroll/c_arms_male1.mdl",
	SubDescription = metro_desc(8),
	Color = CHRISTMAS(0),
	GenerateBodygroups = generic_male,
}
c "metro_male_3" {
	Name = "Metro Male 3",
	Model = "models/half-dead/metroll/m4b1.mdl",
	Hands = "models/half-dead/metroll/c_arms_male1.mdl",
	SubDescription = metro_desc(9),
	Color = CHRISTMAS(0),
	GenerateBodygroups = generic_male,
}
c "metro_female_4" {
	Name = "Metro Female 4",
	Model = "models/half-dead/metroll/f4b1.mdl",
	Hands = "models/half-dead/metroll/c_arms_male1.mdl",
	SubDescription = metro_desc(10),
	Color = CHRISTMAS(0),
	GenerateBodygroups = generic_male,
	Gender = "Female",
}
c "metro3" {
	Name = "Metro Extra 3",
	Model = "models/half-dead/metroll/a3b1.mdl",
	Hands = "models/half-dead/metroll/c_arms_male1.mdl",
	SubDescription = metro_desc(11),
	Color = CHRISTMAS(0),
	GenerateBodygroups = generic_male,
}
c "metro_male_9" {
	Name = "Metro Male 9",
	Model = "models/half-dead/metroll/m1b1.mdl",
	Hands = "models/half-dead/metroll/c_arms_male1.mdl",
	SubDescription = metro_desc(12),
	Color = CHRISTMAS(0),
	GenerateBodygroups = generic_male,
}
c "metro_female_2" {
	Name = "Metro Female 2",
	Model = "models/half-dead/metroll/f2b1.mdl",
	Hands = "models/half-dead/metroll/c_arms_male1.mdl",
	SubDescription = metro_desc(13),
	Color = CHRISTMAS(0),
	GenerateBodygroups = generic_female_hands,
	Gender = "Female",
}
c "metro_male_8" {
	Name = "Metro Male 8",
	Model = "models/half-dead/metroll/m9b1.mdl",
	Hands = "models/half-dead/metroll/c_arms_male1.mdl",
	SubDescription = metro_desc(14),
	Color = CHRISTMAS(0),
	GenerateBodygroups = generic_male,
}
c "metro_male_7" {
	Name = "Metro Male 7",
	Model = "models/half-dead/metroll/m8b1.mdl",
	Hands = "models/half-dead/metroll/c_arms_male1.mdl",
	SubDescription = metro_desc(15),
	Color = CHRISTMAS(0),
	GenerateBodygroups = generic_male,
}
c "metro_female_3" {
	Name = "Metro Female 3",
	Model = "models/half-dead/metroll/f3b1.mdl",
	Hands = "models/half-dead/metroll/c_arms_male1.mdl",
	SubDescription = metro_desc(16),
	Color = CHRISTMAS(0),
	GenerateBodygroups = generic_female,
	Gender = "Female",
}
c "metro4" {
	Name = "Metro Extra 4",
	Model = "models/half-dead/metroll/a4b1.mdl",
	Hands = "models/half-dead/metroll/c_arms_male1.mdl",
	SubDescription = metro_desc(17),
	Color = CHRISTMAS(0),
	GenerateBodygroups = generic_male,
}
c "metro2" {
	Name = "Metro Extra 2",
	Model = "models/half-dead/metroll/a2b1.mdl",
	Hands = "models/half-dead/metroll/c_arms_male1.mdl",
	SubDescription = metro_desc(18),
	Color = CHRISTMAS(0),
	GenerateBodygroups = generic_male,
}
c "metro5" {
	Name = "Metro Extra 5",
	Model = "models/half-dead/metroll/a5b1.mdl",
	Hands = "models/half-dead/metroll/c_arms_male1.mdl",
	SubDescription = metro_desc(19),
	Color = CHRISTMAS(0),
	GenerateBodygroups = generic_male,
}
c "metro_female_1" {
	Name = "Metro Female 1",
	Model = "models/half-dead/metroll/f1b1.mdl",
	Hands = "models/half-dead/metroll/c_arms_male1.mdl",
	SubDescription = metro_desc(20),
	Color = CHRISTMAS(0),
	GenerateBodygroups = generic_male,
	Gender = "Female",
}
c "metro_female_5" {
	Name = "Metro Female 5",
	Model = "models/half-dead/metroll/f6b1.mdl",
	Hands = "models/half-dead/metroll/c_arms_male1.mdl",
	SubDescription = metro_desc(21),
	Color = CHRISTMAS(0),
	GenerateBodygroups = generic_male,
	Gender = "Female",
}

c "osrsbob" {
	Name = "Bob",
	Model = "models/player/runescape/player_bob.mdl",
	--Hands = "models/player/runescape/player_bob.mdl",
	Color = CHRISTMAS(0.5),
	SubDescription = "\nSuggested by CheeseJuggernaut on the December 2019 Forum Thread",
}

c "puggamax" {
	Name = "PuggaMaximus",
	Model = "models/player/puggamaximus.mdl",
	Hands = "models/weapons/c_arms_puggamaximus.mdl",
	Color = xmas_rare,
	SubDescription = "WORF!\nSuggested by FishCake on the December 2019 Forum Thread",
}

c "santa" {
	Name = "Santa Claus",
	Model = "models/player/christmas/santa.mdl",
	Hands = "models/player/christmas/santa_arms.mdl",
	Color = xmas_rare,
	SubDescription = "Ho ho ho! Merry Christmas!\nSuggested by Eppen on the December 2019 Forum Thread",
}

c "weebshit" {
	Name = "Christmas Hatsune Miku",
	Model = "models/captainbigbutt/vocaloid/christmas_miku.mdl",
	Hands = "models/captainbigbutt/vocaloid/c_arms/christmas_miku.mdl",
	Color = xmas_rare,
	SubDescription = "Weeb.\nSuggested by DJ Diamond Bear on the December 2019 Forum Thread",
	GenerateSkin = function(item)
		return rand(item.RowID or item.ID) % 3
	end,
	Gender = "Female",
}

c "tomb" {
	Name = "Lara Croft",
	Model = "models/player/lara_croft.mdl",
	Hands = "models/player/lara_croft_hands.mdl",
	Color = xmas_rare,
	SubDescription = "\nSuggested by Squibble",
	Gender = "Female",
}