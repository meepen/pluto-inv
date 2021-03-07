return {
	Name = "Inevitable",
	affixes = 3,
	guaranteed = {
		firerate = 1,
	},
	guaranteeddraw = function(x, y, sx, sy, w, h)
		surface.SetDrawColor(1, 255, 255)
		for i = 1, 2 do
			surface.DrawLine(math.random() * w + x, y, x + math.random() * w, y + h)
		end
	end,
	SubDescription = {
		guaranteed = "This always rolls Cycle I",
		why = "Everything is a mystery. Except this gun"
	},
	Color = Color(175, 47, 36),
	CraftChance = 0.2, -- 20%
}