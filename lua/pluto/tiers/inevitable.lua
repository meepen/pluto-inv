

local aw, ah = 16, 16
local speed = 1.5
local function DrawArrow(x, y, w, h)
	surface.DrawPoly {
		{ x = x, y = y },
		{ x = x + w, y = y + h * 0.5 },
		{ x = x + w * 0.2, y = y + h * 0.5 },
	}
	surface.DrawPoly {
		{ x = x + w, y = y + h * 0.5 },
		{ x = x, y = y + h },
		{ x = x + w * 0.2, y = y + h * 0.5 },
	}
end

return {
	Name = "Inevitable",
	affixes = 3,
	guaranteed = {
		firerate = 1,
	},
	guaranteeddraw = function(x, y, sx, sy, w, h, rand)
		surface.SetDrawColor(0, 0, 255, 128)
		draw.NoTexture()

		DrawArrow(x + (CurTime() % speed) / speed * w, y + h * 0.1, aw, ah)
		DrawArrow(x - w + (CurTime() % speed) / speed * w, y + h * 0.1, aw, ah)

		DrawArrow(x + ((speed / 2 + CurTime()) % speed) / speed * w, y + h - ah - h * 0.1, aw, ah)
		DrawArrow(x - w + ((speed / 2 + CurTime()) % speed) / speed * w, y + h - ah - h * 0.1, aw, ah)
	end,
	SubDescription = {
		guaranteed = "This always rolls RPM I",
		why = "Everything is a mystery. Except this gun"
	},
	Color = Color(175, 47, 36),
	CraftChance = 0.2, -- 20%
}