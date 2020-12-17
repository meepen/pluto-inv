c "kspidermanpunk" {
	Name = "[K] Spiderman Punk",
	Model = "models/kryptonite/spiderman_punk/spiderman_punk.mdl",
	Hands = nil,
	Color = ColorRand(),
	SubDescription = "[K] Spiderman Punk"
}

c "ktoxin" {
	Name = "[K] Toxin",
	Model = "models/kryptonite/toxin/toxin.mdl",
	Hands = nil,
	Color = ColorRand(),
	SubDescription = "[K] Toxin"
}

c "kspidermanbagman" {
	Name = "[K] Spiderman Bag Man",
	Model = "models/kryptonite/spiderman_bombastic/spiderman_bombastic.mdl",
	Hands = nil,
	Color = ColorRand(),
	SubDescription = "[K] Spiderman Bag Man"
}

c "kspidermanlaststand" {
	Name = "[K] Spiderman Last Stand",
	Model = "models/kryptonite/spiderman_laststand/spiderman_laststand.mdl",
	Hands = nil,
	Color = ColorRand(),
	SubDescription = "[K] Spiderman Last Stand"
}

c "kspidermannoir" {
	Name = "[K] Spiderman Noir",
	Model = "models/kryptonite/spiderman_noir/spiderman_noir.mdl",
	Hands = nil,
	Color = ColorRand(),
	SubDescription = "[K] Spiderman Noir"
}

c "grinch" {
	Name = "Grinch",
	Model = "models/PolyCapN/Grinch.mdl",
	Hands = nil,
	Color = ColorRand(),
	SubDescription = "Grinch"
}

c "kvenom2099" {
	Name = "[K] Venom 2099",
	Model = "models/kryptonite/venom_2099/venom_2099.mdl",
	Hands = nil,
	Color = ColorRand(),
	SubDescription = "[K] Venom 2099"
}

c "tfacso2natalie" {
	Name = "TFA-CSO2-Natalie",
	Model = "models/player/tfa_cso2/tr_natary.mdl",
	Hands = "models/weapons/tfa_cso2/arms/tr_natary.mdl",
	Color = ColorRand(),
	SubDescription = "TFA-CSO2-Natalie"
}

c "kspidermancyborg" {
	Name = "[K] Spiderman Cyborg",
	Model = "models/kryptonite/spiderman_cyborg/spiderman_cyborg.mdl",
	Hands = nil,
	Color = ColorRand(),
	SubDescription = "[K] Spiderman Cyborg"
}

c "kspiderman2099" {
	Name = "[K] Spiderman 2099",
	Model = "models/kryptonite/spiderman_2099/spiderman_2099.mdl",
	Hands = nil,
	Color = ColorRand(),
	SubDescription = "[K] Spiderman 2099"
}

c "kspiderman" {
	Name = "[K] Spiderman",
	Model = "models/kryptonite/spiderman/spiderman.mdl",
	Hands = nil,
	Color = ColorRand(),
	SubDescription = "[K] Spiderman"
}


c "kspiderman1602" {
	Name = "[K] Spiderman 1602",
	Model = "models/kryptonite/spiderman_1602/spiderman_1602.mdl",
	Hands = nil,
	Color = ColorRand(),
	SubDescription = "[K] Spiderman 1602"
}


c "kspidermanhomecoming" {
	Name = "[K] Spiderman Homecoming",
	Model = "models/kryptonite/spiderman_homecoming/spiderman_homecoming.mdl",
	Hands = nil,
	Color = ColorRand(),
	SubDescription = "[K] Spiderman Homecoming"
}

-- in box

c "santatrooper" {
	Name = "Santa Trooper",
	Model = "models/player/bunny/zephyr_christmas_2019/santa/santa_trooper.mdl",
	Hands = "models/player/bunny/zephyr_christmas_2019/santa/santa_hands.mdl",
	Color = ColorRand(),
	SubDescription = "Santa Trooper"
}
c "elftrooper" {
	Name = "Elf Trooper",
	Model = "models/player/bunny/zephyr_christmas_2019/elf/elf_trooper.mdl",
	Hands = "models/player/bunny/zephyr_christmas_2019/elf/elf_hands.mdl",
	Color = ColorRand(),
	SubDescription = "Elf Trooper"
}
c "reindeertrooper" {
	Name = "Reindeer Trooper",
	Model = "models/player/bunny/zephyr_christmas_2019/reindeer/reindeer_trooper.mdl",
	Hands = "models/player/bunny/zephyr_christmas_2019/reindeer/reindeer_hands.mdl",
	Color = ColorRand(),
	SubDescription = "Reindeer Trooper"
}
c "hannukahtrooper" {
	Name = "Hannukah Trooper",
	Model = "models/player/bunny/zephyr_christmas_2019/hannukah/hannukah_trooper.mdl",
	Hands = "models/player/bunny/zephyr_christmas_2019/hannukah/hannukah_hands.mdl",
	Color = ColorRand(),
	SubDescription = "Hannukah Trooper"
}
c "snowmantrooper" {
	Name = "Snowman Trooper",
	Model = "models/player/bunny/zephyr_christmas_2019/snowman/snowman_trooper.mdl",
	Hands = "models/player/bunny/zephyr_christmas_2019/snowman/snowman_hands.mdl",
	Color = ColorRand(),
	SubDescription = "Snowman Trooper"
}
c "treetrooper" {
	Name = "Tree Trooper",
	Model = "models/player/bunny/zephyr_christmas_2019/tree/tree_trooper.mdl",
	Hands = "models/player/bunny/zephyr_christmas_2019/tree/tree_hands.mdl",
	Color = ColorRand(),
	SubDescription = "Tree Trooper"
}

c "ghilliewinter01" {
	Name = "Ghillie Winter 01",
	Model = "models/player/joheskiller/ghilliesuit_winter.mdl",
	Hands = "models/weapons/c_arms_cstrike.mdl",
	Color = ColorRand(),
	SubDescription = "Ghillie Winter 01"
}

c "snow1" {
	Name = "Snow_1",
	Model = "models/player/portal/Male_02_Snow.mdl",
	Hands = nil,
	Color = ColorRand(),
	SubDescription = "Snow_1",
	GenerateBodygroups = function(item)
		local bg = BodyGroupRand({
			hats = {
				0, 1, 2, 3, 4
			},
			body = {
				0, 1, 2
			},
		}, item.RowID or item.ID)
		
		return bg
	end,
}
c "snow2" {
	Name = "Snow_2",
	Model = "models/player/portal/Male_04_Snow.mdl",
	Hands = nil,
	Color = ColorRand(),
	SubDescription = "Snow_2",
	GenerateBodygroups = function(item)
		local bg = BodyGroupRand({
			hats = {
				0, 1, 2, 3, 4
			},
			body = {
				0, 1, 2
			},
		}, item.RowID or item.ID)
		
		return bg
	end,
}
c "snow3" {
	Name = "Snow_3",
	Model = "models/player/portal/Male_05_Snow.mdl",
	Hands = nil,
	Color = ColorRand(),
	SubDescription = "Snow_3",
	GenerateBodygroups = function(item)
		local bg = BodyGroupRand({
			hats = {
				0, 1, 2, 3, 4
			},
			body = {
				0, 1, 2
			},
		}, item.RowID or item.ID)
		
		return bg
	end,
}
c "snow4" {
	Name = "Snow_4",
	Model = "models/player/portal/Male_06_Snow.mdl",
	Hands = nil,
	Color = ColorRand(),
	SubDescription = "Snow_4",
	GenerateBodygroups = function(item)
		local bg = BodyGroupRand({
			hats = {
				0, 1, 2, 3, 4
			},
			body = {
				0, 1, 2
			},
		}, item.RowID or item.ID)
		
		return bg
	end,
}
c "snow5" {
	Name = "Snow_5",
	Model = "models/player/portal/Male_07_Snow.mdl",
	Hands = nil,
	Color = ColorRand(),
	SubDescription = "Snow_5",
	GenerateBodygroups = function(item)
		local bg = BodyGroupRand({
			hats = {
				0, 1, 2, 3, 4
			},
			body = {
				0, 1, 2
			},
		}, item.RowID or item.ID)
		
		return bg
	end,
}
c "snow6" {
	Name = "Snow_6",
	Model = "models/player/portal/Male_08_Snow.mdl",
	Hands = nil,
	Color = ColorRand(),
	SubDescription = "Snow_6",
	GenerateBodygroups = function(item)
		local bg = BodyGroupRand({
			hats = {
				0, 1, 2, 3, 4
			},
			body = {
				0, 1, 2
			},
		}, item.RowID or item.ID)
		
		return bg
	end,
}
c "snow7" {
	Name = "Snow_7",
	Model = "models/player/portal/Male_09_Snow.mdl",
	Hands = nil,
	Color = ColorRand(),
	SubDescription = "Snow_7",
	GenerateBodygroups = function(item)
		local bg = BodyGroupRand({
			hats = {
				0, 1, 2, 3, 4
			},
			body = {
				0, 1, 2
			},
		}, item.RowID or item.ID)
		
		return bg
	end,
}


c "imp" {
	Name = "imp",
	Model = "Models/player/pizzaroll/imp.mdl",
	Hands = "Models/weapons/imparms.mdl",
	Color = ColorRand(),
	SubDescription = "imp",
	GenerateBodygroups = function(item)
		local bg = BodyGroupRand({
			Santa_Hat = {
				0
			},
		}, item.RowID or item.ID)
		
		return bg
	end,
}

c "kleiaorgana" {
	Name = "[K] Leia Organa",
	Model = "models/kryptonite/sbf_leia/sbf_leia.mdl",
	Hands = nil,
	Color = ColorRand(),
	SubDescription = "[K] Leia Organa"
}

c "tfacso2natalie01" {
	Name = "TFA-CSO2-Natalie01",
	Model = "models/player/tfa_cso2/tr_natary01.mdl",
	Hands = "models/weapons/tfa_cso2/arms/tr_natary01.mdl",
	Color = ColorRand(),
	SubDescription = "TFA-CSO2-Natalie01",
	GenerateBodygroups = function(item)
		local bg = BodyGroupRand({
			hair = {
				1
			},
		}, item.RowID or item.ID)
		
		return bg
	end,
}

c "kspidermannewyear" {
	Name = "[K] Spiderman New Year",
	Model = "models/kryptonite/spiderman_new_year/spiderman_new_year.mdl",
	Hands = nil,
	Color = ColorRand(),
	SubDescription = "[K] Spiderman New Year",
	GenerateBodygroups = function(item)
		local bg = BodyGroupRand({
			Scarf = {
				0
			},
			Beanie = {
				0
			}
		}, item.RowID or item.ID)
		
		return bg
	end,
}