local ENT = FindMetaTable "Entity"
local mt0 = {
	__index = function(self, k)
		local ret = {}
		self[k] = ret
		return ret
	end
}
pluto.hitbox_overrides = setmetatable({}, {
	__index = function(self, k)
		local ret = setmetatable({}, mt0)
		self[k] = ret
		return ret
	end
})

ENT.RealGetHitBoxHitGroup = ENT.RealGetHitBoxHitGroup or ENT.GetHitBoxHitGroup
function ENT:GetHitBoxHitGroup(hitbox, hitboxset)
	local data = pluto.hitbox_overrides[self:GetModel()][hitboxset][hitbox]

	return data or self:RealGetHitBoxHitGroup(hitbox, hitboxset)
end

local c = function(name)
	return function(data)
		if (data.HitboxOverride) then
			for hitboxset, setchanges in pairs(data.HitboxOverride) do
				for hitbox, changes in pairs(setchanges) do
					pluto.hitbox_overrides[data.Model][hitboxset][hitbox] = changes.HitGroup
				end
			end
		end
		pluto.model(name)(data)
	end
end

local rare = Color(190, 0, 0)
local crate_0 = {
	min = Color(203, 212, 36),
	max = Color(156, 39, 0)
}
local crate_2 = {
	min = Color(38, 13, 224),
	max = Color(199, 30, 55)
}
local xmas_rare = Color(140, 38, 50)

local function COL(g)
	local min, max = crate_0.min, crate_0.max

	local nr, ng, nb = min.r, min.g, min.b
	local xr, xg, xb = max.r, max.g, max.b

	return Color(nr + (xr - nr) * g, ng + (xg - ng) * g, nb + (xb - nb) * g)
end

local function CRATE2_COL(frac)
	local min, max = crate_2.min, crate_2.max

	local nr, ng, nb = min.r, min.g, min.b
	local xr, xg, xb = max.r, max.g, max.b

	return Color(nr + (xr - nr) * frac, ng + (xg - ng) * frac, nb + (xb - nb) * frac)
end

local function CHRISTMAS(g)
	return Color(0x33, 0x67, 0x39)
end

local function rand(seed)
	seed = (1103515245 * seed + 12345) % (2^31)
	return seed
end

local function BodyGroupRand(data, seed)
	local ret = {}
	for bodygroup, allowed in SortedPairs(data) do
		seed = rand(seed)
		local randf = seed / (2^31 + 1)
		ret[bodygroup] = istable(allowed) and allowed[math.floor(randf * #allowed) + 1] or math.floor(randf * allowed)
	end
	return ret
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
	end,
	Gender = "Female",
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
	Gender = "Female",
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
	Gender = "Female",
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
	Gender = "Female",
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
	Gender = "Female",
}

c "zerosamus" {
	Name = "Zero Suit Samus",
	Model = "models/player_zsssamusu.mdl",
	Hands = "models/zssu_arms.mdl",
	SubDescription = "n the vast universe, the history of humanity is but a flash of light from a lone star.",
	Color = rare,
	Gender = "Female",
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
	Gender = "Female",
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
	Gender = "Female",
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
	end,
	Gender = "Female",
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

-- BOX 2 (2020 March)

c "violet_spa" {
	Name = "Violet Spartan",
	Model = "models/halo2/spartan_violet.mdl",
	Hands = "models/weapons/c_arms_masterchief_h2.mdl",
	Color = CRATE2_COL(0.1),
	SubDescription = "Stand out in the haze of combat\nSuggested by DarkonZZ on the March 2020 Forum Thread"
}

c "gold_spart" {
	Name = "Gold Spartan",
	Model = "models/halo2/spartan_gold.mdl",
	Hands = "models/weapons/c_arms_masterchief_h2.mdl",
	Color = CRATE2_COL(0.1),
	SubDescription = "Deep pockets and thick armor\nSuggested by DarkonZZ on the March 2020 Forum Thread"
}

c "pink_spart" {
	Name = "Pink Spartan",
	Model = "models/halo2/spartan_pink.mdl",
	Hands = "models/weapons/c_arms_masterchief_h2.mdl",
	Color = CRATE2_COL(0.1),
	SubDescription = "Tough guys wear pink\nSuggested by DarkonZZ on the March 2020 Forum Thread"
}

c "green_spar" {
	Name = "Green Spartan",
	Model = "models/halo2/spartan_green.mdl",
	Hands = "models/weapons/c_arms_masterchief_h2.mdl",
	Color = CRATE2_COL(0.1),
	SubDescription = "Not quite, Chief\nSuggested by DarkonZZ on the March 2020 Forum Thread"
}

c "orange_spa" {
	Name = "Orange Spartan",
	Model = "models/halo2/spartan_orange.mdl",
	Hands = "models/weapons/c_arms_masterchief_h2.mdl",
	Color = CRATE2_COL(0.1),
	SubDescription = "Are you sure it isn't tangerine?\nSuggested by DarkonZZ on the March 2020 Forum Thread"
}

c "steel_spar" {
	Name = "Steel Spartan",
	Model = "models/halo2/spartan_steel.mdl",
	Hands = "models/weapons/c_arms_masterchief_h2.mdl",
	Color = CRATE2_COL(0.1),
	SubDescription = "Who needs armor paint?\nSuggested by DarkonZZ on the March 2020 Forum Thread"
}

c "tan_sparta" {
	Name = "Tan Spartan",
	Model = "models/halo2/spartan_tan.mdl",
	Hands = "models/weapons/c_arms_masterchief_h2.mdl",
	Color = CRATE2_COL(0.1),
	SubDescription = "Coarse and gets everywhere\nSuggested by DarkonZZ on the March 2020 Forum Thread"
}

c "blue_spart" {
	Name = "Blue Spartan",
	Model = "models/halo2/spartan_blue.mdl",
	Hands = "models/weapons/c_arms_masterchief_h2.mdl",
	Color = CRATE2_COL(0.1),
	SubDescription = "I hate babies!\nSuggested by DarkonZZ on the March 2020 Forum Thread"
}

c "master_chi" {
	Name = "Master Chief",
	Model = "models/halo2/spartan_mc.mdl",
	Hands = "models/weapons/c_arms_masterchief_h2.mdl",
	Color = CRATE2_COL(0.1),
	SubDescription = "I need a weapon.\nSuggested by Froggy on the March 2020 Forum Thread"
}

c "sage_spart" {
	Name = "Sage Spartan",
	Model = "models/halo2/spartan_sage.mdl",
	Hands = "models/weapons/c_arms_masterchief_h2.mdl",
	Color = CRATE2_COL(0.1),
	SubDescription = "It takes a wise man to discover a wise man / The fool wonders, the wise man asks\nSuggested by DarkonZZ on the March 2020 Forum Thread"
}

c "crimson_sp" {
	Name = "Crimson Spartan",
	Model = "models/halo2/spartan_crimson.mdl",
	Hands = "models/weapons/c_arms_masterchief_h2.mdl",
	Color = CRATE2_COL(0.1),
	SubDescription = "Crimson, just like your blood\nSuggested by DarkonZZ on the March 2020 Forum Thread"
}

c "cobalt_spa" {
	Name = "Cobalt Spartan",
	Model = "models/halo2/spartan_cobalt.mdl",
	Hands = "models/weapons/c_arms_masterchief_h2.mdl",
	Color = CRATE2_COL(0.1),
	SubDescription = "Decent Powertools\nSuggested by DarkonZZ on the March 2020 Forum Thread"
}

c "cyan_spart" {
	Name = "Cyan Spartan",
	Model = "models/halo2/spartan_cyan.mdl",
	Hands = "models/weapons/c_arms_masterchief_h2.mdl",
	Color = CRATE2_COL(0.1),
	SubDescription = "The bright color will confuse the enemy\nSuggested by DarkonZZ on the March 2020 Forum Thread"
}

c "olive_spar" {
	Name = "Olive Spartan",
	Model = "models/halo2/spartan_olive.mdl",
	Hands = "models/weapons/c_arms_masterchief_h2.mdl",
	Color = CRATE2_COL(0.1),
	SubDescription = "Unlimited Breadsticks, or Bombshells?\nSuggested by DarkonZZ on the March 2020 Forum Thread"
}

c "purple_spa" {
	Name = "Purple Spartan",
	Model = "models/halo2/spartan_purple.mdl",
	Hands = "models/weapons/c_arms_masterchief_h2.mdl",
	Color = CRATE2_COL(0.1),
	SubDescription = "It's not violet!\nSuggested by DarkonZZ on the March 2020 Forum Thread"
}

c "red_sparta" {
	Name = "Red Spartan",
	Model = "models/halo2/spartan_red.mdl",
	Hands = "models/weapons/c_arms_masterchief_h2.mdl",
	Color = CRATE2_COL(0.1),
	SubDescription = "Ah, damn it, I messed up my one-liner.\nSuggested by DarkonZZ on the March 2020 Forum Thread"
}

c "teal_spart" {
	Name = "Teal Spartan",
	Model = "models/halo2/spartan_teal.mdl",
	Hands = "models/weapons/c_arms_masterchief_h2.mdl",
	Color = CRATE2_COL(0.1),
	SubDescription = "It's not cyan.\nSuggested by DarkonZZ on the March 2020 Forum Thread"
}

c "white_spar" {
	Name = "White Spartan",
	Model = "models/halo2/spartan_white.mdl",
	Hands = "models/weapons/c_arms_masterchief_h2.mdl",
	Color = CRATE2_COL(0.1),
	SubDescription = "Cold weather never scared me.\nSuggested by DarkonZZ on the March 2020 Forum Thread"
}

c "brown_spar" {
	Name = "Brown Spartan",
	Model = "models/halo2/spartan_brown.mdl",
	Hands = "models/weapons/c_arms_masterchief_h2.mdl",
	Color = CRATE2_COL(0.1),
	SubDescription = "Good to wear for jumpscares.\nSuggested by DarkonZZ on the March 2020 Forum Thread"
}

c "captain" {
	Name = "Captain",
	Model = "models/player/red/captain.mdl",
	Color = CRATE2_COL(0.32),
	SubDescription = "The war left its scars on all of us."
}

c "sergeant" {
	Name = "Sergeant",
	Model = "models/player/green/sergeant.mdl",
	Color = CRATE2_COL(0.3),
	SubDescription = "Look around. We’re one and the same. Same heart, same blood. "
}

c "general" {
	Name = "General",
	Model = "models/player/black/general.mdl",
	Color = CRATE2_COL(0.29),
	SubDescription = "We’re just clones, sir. We’re meant to be expendable. "
}

c "commander" {
	Name = "Commander",
	Model = "models/player/yellow/commander.mdl",
	Color = CRATE2_COL(0.27),
	SubDescription = "You have to learn to make your own decisions."
}

c "clone" {
	Name = "Clone",
	Model = "models/player/swrcc/new clone.mdl",
	Color = CRATE2_COL(0.25),
	SubDescription = "Just like the simulations. "
}

c "lieutenant" {
	Name = "Lieutenant",
	Model = "models/player/blue/lieutenant.mdl",
	Color = CRATE2_COL(0.23),
	SubDescription = "Today we fight for more than the Republic. Today we fight for all our brothers back home."
}

c "bomb_squad" {
	Name = "Bomb Squad",
	Model = "models/player/orange/bomb squad.mdl",
	Color = CRATE2_COL(0.2),
	SubDescription = "Well looks like the bomb room."
}

c "phoenix_lo" {
	Name = "Low-Poly Phoenix",
	Model = "models/player/phoenix_low.mdl",
	Hands = "models/weapons/c_arms_leet_low.mdl",
	Color = CRATE2_COL(0.1),
	SubDescription = "Phoenix_Low"
}


-- posteaster
c "wild_rabbit" {
	Name = "Wild Rabbit",
	Model = "models/pipann/wild_rabbit.mdl",
	Color = ColorRand(),
	SubDescription = "",
	Fake = true,
}

c "dom_rabbit" {
	Name = "Wild Rabbit",
	Model = "models/pipann/domestic_rabbit.mdl",
	Color = ColorRand(),
	SubDescription = "",
	Fake = true,
}

c "miku_cupid" {
	Name = "Miku Cupid",
	Model = "models/player/dewobedil/vocaloid/appearance_miku/cupid_p.mdl",
	Hands = "models/player/dewobedil/vocaloid/appearance_miku/c_arms/cupid_p.mdl",
	Color = ColorRand(),
	SubDescription = "no",
	Gender = "Female",
	Fake = true,
}

c "chimp" {
	Name = "Chimp",
	Model = "models/player/chimp/chimp.mdl",
	Color = ColorRand(),
	SubDescription = "ook ook",
	Fake = true,
}

c "clank" {
	Name = "Clank",
	Model = "models/rc/clank_pm.mdl",
	Color = ColorRand(),
	SubDescription = "Where's Ratchet?",
	Fake = true,
}

c "revenant" {
	Name = "Revenant",
	Model = "Models/player/pizzaroll/revenant.mdl",
	Hands = "Models/weapons/revenantarms.mdl",
	Color = ColorRand(),
	SubDescription = "",
	Fake = true,
}

c "hank" {
	Name = "Hank",
	Model = "models/hellinspector/koth/hank_pm.mdl",
	Color = ColorRand(),
	SubDescription = "",
	Fake = true,
}

c "male_child" {
	Name = "Male Child",
	Model = "models/player/child_worker_m1.mdl",
	Color = ColorRand(),
	SubDescription = "",
	Fake = true,
}

c "female_child" {
	Name = "Female Child",
	Model = "models/player/child_worker_f1.mdl",
	Color = ColorRand(),
	SubDescription = "",
	Gender = "Female",
	Fake = true,
}

c "kanna" {
	Name = "Kanna Kamui",
	Model = "models/player/dewobedil/maid_dragon/kanna/default_p.mdl",
	Hands = "models/player/dewobedil/maid_dragon/kanna/c_arms/default_p.mdl",
	Color = ColorRand(),
	SubDescription = "",
	Gender = "Female",
	Fake = true,
}

c "lara_croft_lo" {
	Name = "Lara Croft Low-Poly",
	Model = "models/tombraider2/lara_croft_classic.mdl",
	Color = ColorRand(),
	SubDescription = "",
	Gender = "Female",
	Fake = true,
}

c "lara_croft_lo_anim" {
	Name = "Lara Croft Low-Poly",
	Model = "models/tombraider2/lara_croft_classic_anims.mdl",
	Color = ColorRand(),
	SubDescription = "",
	Gender = "Female",
	Fake = true,
}

c "low_croft_lo_robe_anim" {
	Name = "Lara Croft Low-Poly Robe",
	Model = "models/tombraider2/lara_croft_classic_home_anim.mdl",
	Color = ColorRand(),
	SubDescription = "",
	Gender = "Female",
	Fake = true,
}

c "low_croft_lo_robe" {
	Name = "Lara Croft Low-Poly Robe",
	Model = "models/tombraider2/lara_croft_classic_home.mdl",
	Color = ColorRand(),
	SubDescription = "",
	Gender = "Female",
	Fake = true,
}


-- reserved
c "leet_low" {
	Name = "Low-Poly Leet",
	Model = "models/player/zurdo.mdl",
	Hands = "models/weapons/c_arms_leet_low.mdl",
	Color = CRATE2_COL(0.1),
	SubDescription = "Leet_Low"
}

c "guerilla_l" {
	Name = "Low-Poly Guerilla",
	Model = "models/player/guerilla_low.mdl",
	Hands = "models/weapons/c_arms_leet_low.mdl",
	Color = CRATE2_COL(0.1),
	SubDescription = "Guerilla_Low"
}

c "arctic_low" {
	Name = "Low-Poly Arctic",
	Model = "models/player/arctic_low.mdl",
	Hands = "models/weapons/c_arms_leet_low.mdl",
	Color = CRATE2_COL(0.1),
	SubDescription = "Arctic_Low"
}

c "deadpool" {
	Name = "Deadpool",
	Model = "models/player/valley/deadpool.mdl",
	Color = CRATE2_COL(1),
	SubDescription = "Where the fuck is Francis?!\nSuggested by Daffiestsky703 on the March 2020 Forum Thread"
}

c "ciri" {
	Name = "Ciri",
	Model = "models/player/RatedR4Ryan/Ciri_TW3.mdl",
	Hands = "models/player/RatedR4Ryan/Ciri_hands.mdl",
	Color = CRATE2_COL(1),
	SubDescription = "Well yes, but that book was horribly dull.\nSuggested by Eppen on the March 2020 Forum Thread",
	Gender = "Female",
}

c "spacesuit" {
	Name = "Spacesuit",
	Model = "models/player/pluto_spacesuit.mdl",
	Color = CRATE2_COL(1),
	SubDescription = "We're not in Kansas anymore...\nSuggested by Eppen on the March 2020 Forum Thread"
}

c "zer0" {
	Name = "Zer0",
	Model = "models/kuma96/borderlands3/characters/zero/zero_resized_pm.mdl",
	Hands = "models/kuma96/borderlands3/characters/zero/c_arms_zero.mdl",
	Color = CRATE2_COL(1),
	SubDescription = "How hilarious, you just set off my trap card. Your death approaches.\nSuggested by Bullet on the March 2020 Forum Thread"
}

c "yuno_gasai" {
	Name = "Yuno Gasai",
	Model = "models/player/yuno_gasai.mdl",
	Hands = "models/arms/yuno_gasai_arms.mdl",
	Color = Color(131, 222, 247),
	SubDescription = "Shootr is Omega Gay:tm:",
	Gender = "Female",
}

c "tachanka" {
	Name = "Tachanka",
	Model = "models/auditor/r6s/spetsnaz/tachanka/chr_spetsnaz_turret3.mdl",
	Hands = "models/auditor/r6s/spetsnaz/tachanka/chr_spetsnaz_turret3_arms.mdl",
	Color = CRATE2_COL(0.85),
	SubDescription = "The lord himself.\nSuggested by YaBoiNathan on the March 2020 Forum Thread"
}

c "noob_saibo" {
	Name = "Noob Saibot",
	Model = "models/dizcordum/mk11/nub.mdl",
	Hands = "models/dizcordum/mk11/nub_hands.mdl",
	Color = CRATE2_COL(0.82),
	SubDescription = "Dream of nightmares.\nSuggested by DJ Diamond Bear on the March 2020 Forum Thread"
}

c "raincoat" {
	Name = "Raincoat",
	Model = "models/human/raincoat.mdl",
	--Hands = "models/human/c_hands.mdl", Hand don't work on this model
 	Color = CRATE2_COL(0.8),
	SubDescription = "The most dangerous enemy in the Otherworld.\nSuggested by Froggy on the March 2020 Forum Thread"
}

c "psycho" {
	Name = "Psycho",
	Model = "models/kuma96/borderlands3/characters/psychomale/psychomale_pm.mdl",
	Hands = "models/kuma96/borderlands3/characters/psychomale/c_arms_psychomale.mdl",
	Color = CRATE2_COL(0.77),
	SubDescription = "YOU'RE GOING TO BE MY NEW MEAT BICYCLE!!\nSuggested by Froggy on the March 2020 Forum Thread"
}

c "wolffe" {
	Name = "Wolffe",
	Model = "models/player/104th/wolffe.mdl",
	Color = CRATE2_COL(0.2),
	SubDescription = "Just like the simulations.\nSuggested by Froggy on the March 2020 Forum Thread"
}

c "tron_anon" {
	Name = "Tron Anon",
	Model = "models/player/anon/anon.mdl",
	Hands = "models/weapons/arms/anon_arms.mdl",
	Color = CRATE2_COL(0.26),
	SubDescription = "\nSuggested by Sηεαкү on the March 2020 Forum Thread"
}

c "spy" {
	Name = "Spy",
	Model = "models/player/spyplayer/spy.mdl",
	Hands = "models/player/spyplayer/spy_hands.mdl",
	Color = Color(219, 11, 181),
	SubDescription = "Well, off to visit your mother!\nSuggested by BURNSY (and Phrot) on the March 2020 Forum Thread"
}

-- needs hitbox fixer
c "ror2_commando" {
	Name = "Risk Of Rain 2 - Commando",
	Model = "models/player/RiskOfRain2/Survivors/Commando/Commando_pm.mdl",
	Hands = "models/player/RiskOfRain2/Survivors/Commando/Commando_hands.mdl",
	Color = CRATE2_COL(0.1),
	SubDescription = "\nSuggested by Obfuscate on the March 2020 Forum Thread"
}


--halloween 2020

c "mythra" {
	Name = "Mythra",
	Model = "models/kaesar/mythra/mythra.mdl",
	Hands = "models/kaesar/mythra/c_arms_mythra.mdl",
	Color = ColorRand(),
	SubDescription = "Mythra"
}


local HitboxOverride = {
	[0] = {
		[6] = {
			HitGroup = HITGROUP_HEAD,
		},
	},
}

for i = 7, 33 do HitboxOverride[0][i] = {HitGroup = HITGROUP_RIGHTARM } end

c "houndmodel" {
	Name = "Shadowscale Acolyte",
	Model = "models/dizcordum/shadowscale_acolyte.mdl",
	Hands = "models/dizcordum/shadowscale_acolyte_hands.mdl",
	Color = ColorRand(),
	SubDescription = "Shadowscale Acolyte",
	HitboxOverride = HitboxOverride
}

c "ghostface" { -- fix textures
	Name = "Ghostface",
	Model = "models/player/screamplayermodel/scream/scream.mdl",
	Hands = nil,
	Color = ColorRand(),
	SubDescription = "Ghostface"
}

local HitboxOverride = {
	[0] = {
		[6] = {
			HitGroup = HITGROUP_HEAD
		},
	},
}

for i = 28, 57 do HitboxOverride[0][i] = {HitGroup = HITGROUP_RIGHTARM } end

c "scarecrow" { -- fix hitboxes
	Name = "Scarecrow",
	Model = "models/dc/injustice2/pm_scarecrow.mdl",
	Hands = nil,
	Color = ColorRand(),
	SubDescription = "Scarecrow",
	HitboxOverride = HitboxOverride
}


c "darkwraith" {
	Name = "Darkwraith",
	Model = "models/dwdarksouls/models/darkwraith.mdl",
	Hands = "models/dwdarksouls/models/darkwraithfp.mdl",
	Color = ColorRand(),
	SubDescription = "Darkwraith"
}

c "joker_2019" { -- bodygroups
	Name = "Joker 2019",
	Model = "models/kemot44/Models/Joker_PM.mdl",
	Hands = "models/kemot44/Models/Joker_cArm.mdl",
	Color = ColorRand(),
	SubDescription = "Joker 2019",
	GenerateBodygroups = function(item)
		local bg = BodyGroupRand({
			Top = {
				0, 1, 2
			},
		}, item.RowID or item.ID)
		
		return bg
	end,
	GenerateSkin = function(item)
		return rand(item.RowID or item.ID) % 2 + 1
	end,
}

c "detr_connor" { -- hitboxes fix
	Name = "Detroit - Connor",
	Model = "models/konnie/isa/detroit/connor.mdl",
	Hands = "models/weapons/arms/v_arms_connor.mdl",
	Color = ColorRand(),
	SubDescription = "Detroit - Connor"
}

local HitboxOverride = {
	[0] = {
		[0] = {
			HitGroup = HITGROUP_GEAR,
		},
		[6] = {
			HitGroup = HITGROUP_HEAD,
		},
		[24] = {
			HitGroup = HITGROUP_GEAR,
		},
		[25] = {
			HitGroup = HITGROUP_GEAR,
		},
	},
}

for i = 7, 22 do HitboxOverride[0][i] = {HitGroup = HITGROUP_RIGHTARM } end

c "death_paint" { -- resize 24 25 and 0
	Name = "Death (Painted)",
	Model = "models/dawson/death_a_grim_bundle_pms/death_painted/death_painted.mdl",
	Hands = "models/dawson/death_a_grim_bundle_pms/death_painted/death_painted_arms.mdl",
	Color = ColorRand(),
	SubDescription = "Death (Painted)",
	HitboxOverride = HitboxOverride,
	GenerateBodygroups = function(item)
		local bg = BodyGroupRand({
			Hood = 2,
			Skull = 3,
			Jaw = {0, 2},
			Eyes = 11,
			Belt = 3,
			["Skull Trinket 1"] = 2,
			["Skull Trinket 2"] = 2
		}, item.RowID or item.ID)
		
		return bg
	end,
}

c "death_class" {
	Name = "Death (Classic)",
	Model = "models/dawson/death_a_grim_bundle_pms/death_classic/death_classic.mdl",
	Hands = "models/dawson/death_a_grim_bundle_pms/death_classic/death_classic_arms.mdl",
	Color = ColorRand(),
	SubDescription = "Death (Classic)",
	HitboxOverride = HitboxOverride,
	GenerateBodygroups = function(item)
		local bg = BodyGroupRand({
			Hood = 2,
			Skull = 3,
			Jaw = {0, 2},
			Eyes = 11,
			Belt = 3,
			["Skull Trinket 1"] = 2,
			["Skull Trinket 2"] = 2
		}, item.RowID or item.ID)
		
		return bg
	end,
}

c "death" {
	Name = "Death",
	Model = "models/dawson/death_a_grim_bundle_pms/death/death.mdl",
	Hands = "models/dawson/death_a_grim_bundle_pms/death/death_arms.mdl",
	Color = ColorRand(),
	SubDescription = "Death",
	HitboxOverride = HitboxOverride,
	GenerateBodygroups = function(item)
		local bg = BodyGroupRand({
			Hood = 2,
			Skull = 3,
			Jaw = {0, 2},
			Eyes = 11,
			Belt = 3,
			["Skull Trinket 1"] = 2,
			["Skull Trinket 2"] = 2
		}, item.RowID or item.ID)
		
		return bg
	end,
}

c "ghost_rider" {
	Name = "Ghost Rider",
	Model = "models/player/ghostrider/ghostrider.mdl",
	Hands = "models/weapons/arms/ghostrider_arms.mdl",
	Color = ColorRand(),
	SubDescription = "Ghost Rider"
}

c "markus_3" {
	Name = "Detroit - Markus 3",
	Model = "models/konnie/isa/detroit/markus_3.mdl",
	Hands = "models/weapons/arms/v_arms_markus_3.mdl",
	Color = ColorRand(),
	SubDescription = "Detroit - Markus 3"
}

c "markus_2" {
	Name = "Detroit - Markus 2",
	Model = "models/konnie/isa/detroit/markus_2.mdl",
	Hands = "models/weapons/arms/v_arms_markus_2.mdl",
	Color = ColorRand(),
	SubDescription = "Detroit - Markus 2"
}

c "frogshit" {
	Name = "Halloween Miku",
	Model = "models/carrot/vocaloid/halloween_miku.mdl",
	Hands = "models/carrot/vocaloid/c_arms/halloween_miku.mdl",
	Color = ColorRand(),
	SubDescription = "Halloween Miku",
	HitboxOverride = {
		[0] = {
			[10] = {
				HitGroup = HITGROUP_HEAD
			},
		},
	},
}

local HitboxOverride = {
	[0] = {
		[6] = {
			HitGroup = HITGROUP_HEAD,
		},
	},
}

for i = 7, 24 do HitboxOverride[0][i] = {HitGroup = HITGROUP_RIGHTARM } end

c "jason" { -- hitgroups
	Name = "Jason",
	Model = "models/models/konnie/savini/savini.mdl",
	Hands = "models/weapons/arms/v_arms_savini.mdl",
	Color = ColorRand(),
	SubDescription = "Savini Jason",
	HitboxOverride = HitboxOverride,
	GenerateBodygroups = function(item)
		local bg = {
			[2] = 0
		}

		return bg
	end,
}

c "jason_unmask" { -- hitgroups
	Name = "Jason Unmasked",
	Model = "models/models/konnie/savini/savini.mdl",
	Hands = "models/weapons/arms/v_arms_savini.mdl",
	Color = ColorRand(),
	SubDescription = "Savini Jason",
	HitboxOverride = HitboxOverride,
	GenerateBodygroups = function(item)
		local bg = {
			[2] = 1
		}

		return bg
	end,
}

c "terminator" {
	Name = "M11 Terminator",
	Model = "models/kemot44/Models/MK11/characters/Terminator_PM.mdl",
	Hands = "models/kemot44/Models/MK11/characters/Terminator_cArm.mdl",
	Color = ColorRand(),
	SubDescription = "M11 Terminator",
	GenerateBodygroups = function(item)
		local bg = BodyGroupRand({
			["[Right] Arm"] = 2,
			["[Left] Arm"] = 2,
			["[Right] Leg"] = 2,
		}, item.RowID or item.ID)

		return bg
	end,
}

c "markus_1" {
	Name = "Detroit - Markus 1",
	Model = "models/konnie/isa/detroit/markus_1.mdl",
	Hands = "models/weapons/arms/v_arms_markus_1.mdl",
	Color = ColorRand(),
	SubDescription = "Detroit - Markus 1"
}

c "husk" {
	Name = "Husk",
	Model = "models/player/husk/slow.mdl",
	Hands = nil,
	Color = ColorRand(),
	SubDescription = "Husk"
}

c "hunk" {
	Name = "Hunk",
	Model = "models/player/lordvipes/rerc_hunk/hunk_cvp.mdl",
	Hands = "models/player/lordvipes/rerc_hunk/arms/hunkarms_cvp.mdl",
	Hands = nil,
	Color = ColorRand(),
	SubDescription = "Hunk"
}



function pluto.updatemodel(ent, item)
	if (not item or not item.Model) then
		return
	end


	if (item.Model.GenerateSkin) then
		ent:SetSkin(item.Model.GenerateSkin(item))
	else
		ent:SetSkin(0)
	end

	if (item.Model.GenerateBodygroups) then
		local bg = item.Model.GenerateBodygroups(item)

		for _, d in pairs(ent:GetBodyGroups()) do
			ent:SetBodygroup(d.id, 0)
		end

		for name, id in pairs(bg or {}) do
			local bgid = isnumber(name) and name or ent:FindBodygroupByName(name)
			if (bgid == -1) then
				pwarnf("Couldn't find %s on %s", name, item.Model.Model)
				continue
			end

			ent:SetBodygroup(bgid, id)
		end
	end
end