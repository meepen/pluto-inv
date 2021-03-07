local function DrawArrow(x, y, w, h)
	surface.DrawPoly {
		{ x = x, y = y },
		{ x = x + w * 0.5, y = y + h * 0.2 },
		{ x = x + w * 0.5, y = y + h },
	}
	surface.DrawPoly {
		{ x = x + w * 0.5, y = y + h * 0.2 },
		{ x = x + w, y = y },
		{ x = x + w * 0.5, y = y + h },
	}
end

local aw, ah = 16, 16
local speed = 1.3

return {
	Name = "Confused",
	affixes = 6,
	rolltier = function(mod)
		return #mod.Tiers
	end,
	rolltierdraw = function(x, y, sx, sy, w, h, rand)
		surface.SetDrawColor(255, 0, 0, 128)
		draw.NoTexture()


		DrawArrow(x + w * 0.1, y + (CurTime() % speed) / speed * h, aw, ah)
		DrawArrow(x + w * 0.1, y - h + (CurTime() % speed) / speed * h, aw, ah)

		DrawArrow(x + w - aw - w * 0.1, y +     ((speed / 2 + CurTime()) % speed) / speed * h, aw, ah)
		DrawArrow(x + w - aw - w * 0.1, y - h + ((speed / 2 + CurTime()) % speed) / speed * h, aw, ah)
	end,
	tags = {
		texture = "blackhole",
		damage = 3,
		speed = 3,
		rpm = 3,
	},
	SubDescription = {
		tags = "This gun seems to roll Damage, Speed and RPM modifiers 3x as often",
		rolltier = "This gun seems to always roll the lowest tier possible"
	}
}