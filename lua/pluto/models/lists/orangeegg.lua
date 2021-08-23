--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
local crate_2 = {
	min = Color(38, 13, 224),
	max = Color(199, 30, 55)
}

local function CRATE2_COL(frac)
	local min, max = crate_2.min, crate_2.max

	local nr, ng, nb = min.r, min.g, min.b
	local xr, xg, xb = max.r, max.g, max.b

	return Color(nr + (xr - nr) * frac, ng + (xg - ng) * frac, nb + (xb - nb) * frac)
end

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