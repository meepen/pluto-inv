local c = pluto.model

local rare = Color(190, 0, 0)
local min = Color(203, 212, 36)
local max = Color(156, 39, 0)
local xmas_rare = Color(140, 38, 50)

local function COL(g)
	local nr, ng, nb = min.r, min.g, min.b
	local xr, xg, xb = max.r, max.g, max.b

	return Color(nr + (xr - nr) * g, ng + (xg - ng) * g, nb + (xb - nb) * g)
end

local function CHRISTMAS(g)
	return Color(0x33, 0x67, 0x39)
end

local function rand(seed)
	seed = (1103515245 * seed + 12345) % (2^31)
	return seed
end

local function own(i)
	return CLIENT and LocalPlayer():SteamID64() or i.Owner or "0"
end

local function GenerateBodygroups(max)
	return function(item)
		local id = rand(item.RowID or item.ID)
		local t = {}

		for i = 1, #max do
			local name = max[i][1]
			local amt = max[i][2]
			t[name] = id % amt
			id = math.floor(id / amt)
		end

		return t
	end
end

c "2b" {
	Name = "2B",
	Model = "models/kuma96/2b/2b_pm.mdl",
	Hands = "models/kuma96/2b/2b_carms.mdl",
	SubDescription = "Everything that lives is designed to end. We are perpetually trapped... in a never-ending spiral of life and death.",
	Color = rare,
	GenerateBodygroups = function(item)
		local id = rand(item.RowID or item.ID)
		local t = {}
		t.Headband = id % 2
		id = math.floor(id / 2)

		t.Skirt = id % (own(item) == "76561198050165746" and 3 or 2)

		t["Virtuous Contract"] = 0
		t["Beastlord"] = 0
		return t
	end
}

c "a2lh" {
	Name = "A2",
	Model = "models/kuma96/a2/a2lh_pm.mdl",
	Hands = "models/kuma96/a2/a2_carms.mdl",
	SubDescription = "I never quite realized... how beautiful this world is.",
	Color = COL(1),
	GenerateBodygroups = function(item)
		return {
			Cloth = own(item) == "76561198050165746" and rand(item.RowID or item.ID) % 2 or 0
		}
	end,
}

c "a2" {
	Name = "A2 Short Hair",
	Model = "models/kuma96/a2/a2sh_pm.mdl",
	Hands = "models/kuma96/a2/a2_carms.mdl",
	SubDescription = "I never quite realized... how beautiful this world is.",
	Color = COL(0.75),
	GenerateBodygroups = function(item)
		return {
			Cloth = item.Owner == "76561198050165746" and rand(item.RowID or item.ID) % 2 or 0
		}
	end,
}

c "plague" {
	Name = "Plague Doctor",
	Model = "models/player/plague_doktor/player_plague_doktor.mdl",
	Hands = "models/player/plague_doktor/viewmodel.mdl",
	SubDescription = "I have no idea what's awaiting me, or what will happen when this all ends. For the moment I know this: there are sick people and they need curing.",
	Color = COL(0.8),
	GenerateBodygroups = function(item)
		return {
			Legs = rand(item.RowID or item.ID) % 2
		}
	end,
}

c "daedric" {
	Name = "Daedric",
	Model = "models/player/daedric.mdl",
	Hands = "models/player/daedric_hands.mdl",
	SubDescription = "I can only tell you tales of how to make Daedric armor. I have never seen it myself, nor do I know anyone that has. The stories say that it should always be worked on at night... ideally under a new or full moon, and never during an eclipse. A red harvest moon is best. Ebony is the principle material, but at the right moment a daedra heart must be thrown into the fire.",
	Color = COL(0.7),
}

c "wonderw" {
	Name = "Wonder Woman",
	Model = "models/player/bobert/ww600.mdl",
	SubDescription = "What one does when faced with the truth is more difficult than you'd think.",
	Color = COL(0.5),
	GenerateBodygroups = function(item)
		return {
			Lasso = rand(item.RowID or item.ID) % 2
		}
	end,
}

c "doomguy" {
	Name = "DOOM Slayer",
	Model = "models/pechenko_121/doomslayer.mdl",
	Hands = "models/weapons/doomslayer_viewmodel.mdl",
	SubDescription = "**heavy metal music intensifies**\nSuggested by Hound (STEAM_0:0:30028117)",
	Color = rare,
}

c "sauron" {
	Name = "Sauron",
	Model = "models/auditor/lotr/sauron_alter2_pm.mdl",
	SubDescription = "Build me an army, worthy of Mordor.",
	Color = COL(0.2),
	GenerateBodygroups = function(item)
		return {
			Weapon = (rand(item.RowID or item.ID) % 2) * 4
		}
	end,
}

c "helga" {
	Name = "Helga",
	Model = "models/player/ct_helga/ct_helga.mdl",
	Hands = "models/weapons/tfa_cso2/arms/ct_helga.mdl",
	SubDescription = "Any Mission, Any Time, Any Place",
	Color = COL(0),
}

c "zerosamus" {
	Name = "Zero Suit Samus",
	Model = "models/player_zsssamusu.mdl",
	Hands = "models/zssu_arms.mdl",
	SubDescription = "n the vast universe, the history of humanity is but a flash of light from a lone star.",
	Color = rare,
}

c "hansolo" {
	Name = "Han Solo",
	Model = "models/player/han_solo.mdl",
	Hands = "models/player/han_solo_hands.mdl",
	SubDescription = "Hokey religions and ancient weapons are no match for a good blaster at your side, kid.",
	Color = COL(0.4),
}

c "chewie" {
	Name = "Chewbacca",
	Model = "models/player/chewie.mdl",
	Hands = "models/player/chewie_hands.mdl",
	SubDescription = "GGWWWRGHH",
	Color = COL(0.6),
}

c "default" {
	Name = "Terrorist",
	Model = "models/player/phoenix.mdl"
}

c "moxxi" {
	Name = "Mad Moxxi",
	Model = "models/player_moxxi.mdl",
	Hands = "models/arms_moxxi.mdl",
	Color = rare,
}

c "wick2" {
	Name = "John Wick",
	Model = "models/wick_chapter2.mdl",
	Hands = "models/wick_chapter2/wick_chapter2_c_arms.mdl",
	SubDescription = "John wasn't exactly the boogeyman... he was the one you sent to kill the fucking boogeyman\n\nSuggested by Danger on the November 2019 Forum Thread",
	Color = COL(0.9),
}

c "lilith" {
	Name = "Lilith",
	Model = "models/kuma96/borderlands3/characters/lilith/lilith_pm.mdl",
	Hands = "models/kuma96/borderlands3/characters/lilith/c_arms_lilith.mdl",
	SubDescription = "Ever seen a siren in action? Here's your chance.\nSuggested by FishCake on the November 2019 Forum Thread",
	Color = COL(0.85),
	GenerateBodygroups = function(item)
		return {
			Belt = rand(item.RowID or item.ID) % 2
		}
	end,
}

c "odst" {
	Name = "ODST Armor",
	Model = "models/voxelzero/player/odst.mdl",
	SubDescription = "\nSuggested by shadow on the November 2019 Forum Thread",
	Color = COL(0.4),
}

c "bigboss" {
	Name = "Big Boss",
	Model = "models/player/big_boss.mdl",
	Hands = "models/player/big_boss_hands.mdl",
	Color = COL(0.55),
	SubDescription = "Kept you waiting, huh?\nSuggested by Linus just the tips on the November 2019 Forum Thread",
	GenerateBodygroups = function(item)
		local id = rand(item.RowID or item.ID or 0)

		local t = {}

		t.eyepatch = id % 2
		id = math.floor(id / 2)

		t.facepaint = id % 21
		id = math.floor(id / 21)

		t.camouflage = id % 8

		return t
	end
}

c "hevsuit" {
	Name = "HEV Mark V",
	Model = "models/player/sgg/hev_helmet.mdl",
	Hands = "models/player/sgg/arms/v_hev.mdl",
	Color = COL(0.2),
	SubDescription = "...\nSuggested by Prismatic on the November 2019 Forum Thread"
}

c "jacket" {
	Name = "Jacket",
	Model = "models/splinks/hotline_miami/jacket/player_jacket.mdl",
	Hands = "models/splinks/hotline_miami/jacket/arms_jacket.mdl",
	Color = COL(0.38),
	SubDescription = "\nSuggested by johnny2by4 on the November 2019 Forum Thread",
	GenerateBodygroups = function(item)
		return {
			Mask = rand(item.RowID or item.ID) % 19
		}
	end,
}

c "maya" {
	Name = "Maya",
	Model = "models/kuma96/borderlands3/characters/maya/maya_pm.mdl",
	Hands = "models/kuma96/borderlands3/characters/maya/c_arms_maya.mdl",
	SubDescription = "<3",
	Color = rare,
	GenerateBodygroups = function(item)
		return {
			Coat = rand(item.RowID or item.ID) % 2
		}
	end
}


-- crate1 (christmas)

c "cayde6" {
	Name = "Cayde 6",
	Model = "models/cayde_6_pm/cayde_6_pm.mdl",
	Hands = "models/cayde6_arms/cayde6_arms.mdl",
	SubDescription = "Nightstalkers have many friends. It’s the bow. Everyone loves the bow.\nSuggested by MindbenderJ [Pluto.gg] on the December 2019 Forum Thread",
	Color = xmas_rare,
}

c "nigt1" {
	Name = "Sentinel 1",
	Model = "models/nigt_sentinel_1.mdl",
	Hands = "models/nigt_sentinel_1_arm.mdl",
	Color = CHRISTMAS(0.4),
	SubDescription = "Suggested by NukeBeta on the December 2019 Forum Thread",
}

c "nigt2" {
	Name = "Sentinel 2",
	Model = "models/nigt_sentinel_2.mdl",
	Hands = "models/nigt_sentinel_2_arm.mdl",
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
}
c "metro_female_5" {
	Name = "Metro Female 5",
	Model = "models/half-dead/metroll/f6b1.mdl",
	Hands = "models/half-dead/metroll/c_arms_male1.mdl",
	SubDescription = metro_desc(21),
	Color = CHRISTMAS(0),
	GenerateBodygroups = generic_male,
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
	end
}

c "tomb" {
	Name = "Lara Croft",
	Model = "models/player/lara_croft.mdl",
	Hands = "models/player/lara_croft_hands.mdl",
	Color = xmas_rare,
	SubDescription = "\nSuggested by Squibble",
}

function pluto.updatemodel(ent, item)
	if (not item or not item.Model) then
		return
	end

	if (item.Model.GenerateSkin) then
		ent:SetSkin(item.Model.GenerateSkin(item))
	end

	if (item.Model.GenerateBodygroups) then
		local bg = item.Model.GenerateBodygroups(item)

		for _, d in pairs(ent:GetBodyGroups()) do
			ent:SetBodygroup(d.id, 0)
		end

		for name, id in pairs(bg or {}) do
			local bgid = ent:FindBodygroupByName(name)
			if (bgid == -1) then
				pwarnf("Couldn't find %s on %s", name, item.Model.Model)
				continue
			end

			ent:SetBodygroup(bgid, id)
		end
	end
end