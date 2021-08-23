--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
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
	SubDescription = "Everyone has something to fear.\nSuggested by DJ Diamond Bear (STEAM_0:1:110260122)",
	HitboxOverride = HitboxOverride
}


c "darkwraith" {
	Name = "Darkwraith",
	Model = "models/dwdarksouls/models/darkwraith.mdl",
	Hands = "models/dwdarksouls/models/darkwraithfp.mdl",
	Color = ColorRand(),
	SubDescription = "Be still. Entrust thine flesh to me.\nSuggested by Sηεαкү (STEAM_0:0:419473092)"
}

c "joker_2019" { -- bodygroups
	Name = "Joker 2019",
	Model = "models/kemot44/Models/Joker_PM.mdl",
	Hands = "models/kemot44/Models/Joker_cArm.mdl",
	Color = ColorRand(),
	SubDescription = "People are starting to notice\nSuggested by Gayboi 2019 (STEAM_0:1:63007893)",
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
	Name = "Painted Death",
	Model = "models/dawson/death_a_grim_bundle_pms/death_painted/death_painted.mdl",
	Hands = "models/dawson/death_a_grim_bundle_pms/death_painted/death_painted_arms.mdl",
	Color = ColorRand(),
	SubDescription = "Death is inevitable\nSuggested by Topz (STEAM_0:0:149180748)",
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
	Name = "Classic Death",
	Model = "models/dawson/death_a_grim_bundle_pms/death_classic/death_classic.mdl",
	Hands = "models/dawson/death_a_grim_bundle_pms/death_classic/death_classic_arms.mdl",
	Color = ColorRand(),
	SubDescription = "Death is inevitable\nSuggested by Topz (STEAM_0:0:149180748)",
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
	SubDescription = "Death is inevitable\nSuggested by Topz (STEAM_0:0:149180748)",
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
	SubDescription = "Sorry, all out of mercy.\nSuggested by Eppen (STEAM_0:0:119244900)",
}

c "frogshit" {
	Name = "Halloween Miku",
	Model = "models/carrot/vocaloid/halloween_miku.mdl",
	Hands = "models/carrot/vocaloid/c_arms/halloween_miku.mdl",
	Color = ColorRand(),
	SubDescription = "Froggy is 100% gayboi",
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
	SubDescription = "Tch tch tch tch tcha ah ah ah\nSuggested by DJ Diamond Bear (STEAM_0:1:110260122)",
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
	SubDescription = "Ch ch ch ha ha ha\nSuggested by DJ Diamond Bear (STEAM_0:1:110260122)",
	HitboxOverride = HitboxOverride,
	GenerateBodygroups = function(item)
		local bg = {
			[2] = 1
		}

		return bg
	end,
}
--[[
c "terminator" {
	Name = "Terminator",
	Model = "models/kemot44/Models/MK11/characters/Terminator_PM.mdl",
	Hands = "models/kemot44/Models/MK11/characters/Terminator_cArm.mdl",
	Color = ColorRand(),
	SubDescription = "Skynet: Online\nSuggested by Limeinade (STEAM_0:0:160185749)",
	GenerateBodygroups = function(item)
		local bg = BodyGroupRand({
			["[Right] Arm"] = 2,
			["[Left] Arm"] = 2,
			["[Right] Leg"] = 2,
		}, item.RowID or item.ID)

		return bg
	end,
}]]

c "terminator" {
	Name = "Terrorist",
	Model = "models/player/phoenix.mdl"
}

c "husk" {
	Name = "Husk",
	Model = "models/player/husk/slow.mdl",
	Hands = nil,
	Color = ColorRand(),
	SubDescription = "You exist because we allow it.\nSuggested by DJ Diamond Bear (STEAM_0:1:110260122)"
}

c "hunk" {
	Name = "Hunk",
	Model = "models/player/lordvipes/rerc_hunk/hunk_cvp.mdl",
	Hands = "models/player/lordvipes/rerc_hunk/arms/hunkarms_cvp.mdl",
	Hands = nil,
	Color = ColorRand(),
	SubDescription = "Hunk"
}

c "markus_1" {
	Name = "Detroit - Markus 1",
	Model = "models/konnie/isa/detroit/markus_1.mdl",
	Hands = "models/weapons/arms/v_arms_markus_1.mdl",
	Color = ColorRand(),
	SubDescription = "Detroit - Markus 1"
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

c "ghostface" {
	Name = "Ghostface",
	Model = "models/player/screamplayermodel/scream/scream.mdl",
	Hands = nil,
	Color = ColorRand(),
	SubDescription = "Idea suggested by Eppen\nAddon suggested by Froggo"
}

c "ghostface006" {
	Name = "Ghostface (006)",
	Model = "models/error/ghostface/the_ghost006_pm.mdl",
	Hands = "models/error/ghostface/the_ghost006_arms.mdl",
	Color = ColorRand(),
	SubDescription = "Idea suggested by Eppen\nAddon suggested by Froggo"
}

c "takeo" {
	Name = "Takeo",
	Model = "models/jessev92/player/ww2/nz-hero/takeo.mdl",
	Hands = nil,
	Color = ColorRand(),
	SubDescription = "\"You know, Takeo could be a zombie, I mean, how could we even tell?\"\nSuggested by Froggo"
}

c "nikolai" {
	Name = "Nikolai",
	Model = "models/jessev92/player/ww2/nz-hero/nikolai.mdl",
	Hands = nil,
	Color = ColorRand(),
	SubDescription = "YOU CANNOT RUN FROM NIKOLAI!\nSuggested by Froggo"
}

c "ghostfaceclassic" {
	Name = "Ghostface (Classic)",
	Model = "models/error/ghostface/classic_ghostface_pm.mdl",
	Hands = "models/error/ghostface/classic_ghostface_arms.mdl",
	Color = ColorRand(),
	SubDescription = "Idea suggested by Eppen\nAddon suggested by Froggo"
}

c "ghostfacetheghos" {
	Name = "Ghostface (The Ghost)",
	Model = "models/error/ghostface/the_ghost_pm.mdl",
	Hands = "models/error/ghostface/the_ghost_arms.mdl",
	Color = ColorRand(),
	SubDescription = "Ghostface (The Ghost)",
	GenerateBodygroups = function(item)
		local bg = BodyGroupRand({
			["Masks"] = 2,
		}, item.RowID or item.ID)

		return bg
	end,
}

c "blackmask" {
	Name = "Arkham Origins Blackmask",
	Model = "models/player/bobert/AOBlackmask.mdl",
	Hands = nil,
	Color = ColorRand(),
	SubDescription = "There were too many edgy quotes to choose from so I wrote this instead\nSuggested by Sηεαкү"
}

c "ghostfacereddevi" {
	Name = "Ghostface (Red Devil)",
	Model = "models/error/ghostface/the_ghost_reddevil_pm.mdl",
	Hands = "models/error/ghostface/the_ghost_reddevil_arms.mdl",
	Color = ColorRand(),
	SubDescription = "Idea suggested by Eppen\nAddon suggested by Froggo"
}

c "dempsey" {
	Name = "Dempsey",
	Model = "models/jessev92/player/ww2/nz-hero/dempsey.mdl",
	Hands = nil,
	Color = ColorRand(),
	SubDescription = "I hope you choke meatsack!\nSuggested by Froggo"
}

c "richtofen" {
	Name = "Richtofen",
	Model = "models/jessev92/player/ww2/nz-hero/richtofen.mdl",
	Hands = nil,
	Color = ColorRand(),
	SubDescription = "DO YOU LIKE MY GLOWING GREEN BALLS?!\nSuggested by Froggo"
}