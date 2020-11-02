
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