
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

		t.Skirt = id % (item.Owner == "76561198050165746" and 3 or 2)

		t["Virtuous Contract"] = 0
		t["Beastlord"] = 0
		return t
	end,
	Gender = "Female",
}

c "academy_ahri" {
	Name = "Academy Ahri",
	Model = "models/player/aileri_academy_ahri.mdl",
	Hands = "models/weapons/aileri_academy_ahri_arms.mdl",
	SubDescription = "memes",
	Color = rare,
	GenerateBodygroups = function(item)
		local bg = BodyGroupRand({
			Skin = {
				0, 1, 2, 3, 4
			},
			Ears = {
				0, 1
			},
			Tails = {
				0, 1
			},
			Backpack = {
				0, 1
			}
		}, item.RowID or item.ID)
		
		return bg
	end,
}

c "kat_2" {
	Name = "KAT WHY",
	Model = "models/player/dewobedil/vocaloid/yowane_haku/palmer_p.mdl",
	Hands = "models/player/dewobedil/vocaloid/yowane_haku/c_arms/palmer_p.mdl",
	SubDescription = "why",
	Color = rare,	
}