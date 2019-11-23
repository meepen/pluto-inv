local c = pluto.model

local rare = Color(190, 0, 0)
local min = Color(203, 212, 36)
local max = Color(156, 39, 0)

local function COL(g)
	local nr, ng, nb = min.r, min.g, min.b
	local xr, xg, xb = max.r, max.g, max.b

	return Color(nr + (xr - nr) * g, ng + (xg - ng) * g, nb + (xb - nb) * g)
end

local function rand(seed)
	seed = (1103515245 * seed + 12345) % (2^31)
	return seed
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
		t.Skirt = id % 2
		id = math.floor(id / 2)
		t.Headband = id % 2
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
			Cloth = item.Owner == "76561198050165746" and rand(item.RowID or item.ID) % 2 or 0
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
	Color = rare
}

c "wick2" {
	Name = "John Wick",
	Model = "models/wick_chapter2/wick_chapter2.mdl",
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
	Model = "models/player/hv5/hev_helmet.mdl",
	Hands = "models/player/hv5/arms/v_hev.mdl",
	Color = COL(0.2),
	SubDescription = "...\nSuggested by Prismatic on the November 2019 Forum Thread"
}

c "jacket" {
	Name = "Jacket",
	Model = "models/splinks/hotline_miami/jacket/player_jacket.mdl",
	Hands = "models/splinks/hotline_miami/jacket/arms_jacket.md",
	Color = COL(0.38),
	SubDescription = "\nSuggested by johnny2by4 on the November 2019 Forum Thread",
	GenerateBodygroups = function(item)
		return {
			Mask = rand(item.RowID or item.ID) % 19
		}
	end,
}

function pluto.updatemodel(ent, item)
	PrintTable(ent:GetBodyGroups())
	if (not item or not item.Model or not item.Model.GenerateBodygroups) then
		return
	end

	local bg = item.Model.GenerateBodygroups(item)

	for name, id in pairs(bg or {}) do
		local bgid = ent:FindBodygroupByName(name)
		if (bgid == -1) then
			pwarnf("Couldn't find %s on %s", name, item.Model.Model)
			continue
		end

		ent:SetBodygroup(bgid, id)

		print(bgid, id)
	end
end