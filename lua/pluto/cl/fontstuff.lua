pluto.fonts = pluto.fonts or {
	systems = {},
	lookup = {}
}

function pluto.fonts.registersystem(name, system)
	pluto.fonts.systems[name] = system
	pluto.fonts.lookup[system] = name
end

pluto.fonts.registersystem("default", surface)

local function bind(metatbl)
	local obj = setmetatable({}, {__index = metatbl})
	local t = {}
	for k in pairs(metatbl) do
		t[k] = function(...)
			return obj[k](obj, ...)
		end
	end

	for k in pairs(surface) do
		if (not t[k]) then
			t[k] = surface[k]
		end
	end

	return t
end

local shadow_col = Color(12, 13, 14, 128)
pluto.fonts.registersystem("shadow", bind {
	GetTextSize = function(self, text)
		return surface.GetTextSize(text)
	end,
	DrawText = function(self, text)
		shadow_col.a = self.Color.a
		surface.SetTextColor(shadow_col)
		surface.SetTextPos(self.TextPosX + 1, self.TextPosY + 1)
		surface.DrawText(text)
		surface.SetTextPos(self.TextPosX, self.TextPosY)
		surface.SetTextColor(self.Color)
		surface.DrawText(text)
	end,
	SetFont = function(self, font)
		self.Font = font
		surface.SetFont(font)
	end,
	SetTextPos = function(self, x, y)
		self.TextPosX, self.TextPosY = x, y
		surface.SetTextPos(x, y)
	end,
	SetTextColor = function(self, r, ...)
		local col = r
		if (not istable(r)) then
			col = Color(r, ...)
		end
		self.Color = col
	end
})

pluto.fonts.registersystem("lightsaber_shadow", bind {
	GetTextSize = function(self, text)
		return surface.GetTextSize(text)
	end,
	DrawText = function(self, text)
		local w, h = surface.GetTextSize(text)
		surface.SetDrawColor(self.Color)
		local cx, cy = self.TextPosX + w / 2, self.TextPosY + h / 2
		local lifetime = 3

		local deg = ((CurTime() % lifetime) + util.CRC(text) / (2^32) * lifetime) * 360 % 360
		local s, c = math.sin(math.rad(deg)), math.cos(math.rad(deg))
		surface.DrawLine(cx, cy, cx + s * w / 2, cy + c * h / 2)



		shadow_col.a = self.Color.a
		surface.SetTextColor(shadow_col)
		surface.SetTextPos(self.TextPosX, self.TextPosY)
		surface.DrawText(text)
		surface.SetTextPos(self.TextPosX - 1, self.TextPosY - 1)
		surface.SetTextColor(self.Color)
		surface.DrawText(text)
	end,
	SetFont = function(self, font)
		self.Font = font
		surface.SetFont(font)
	end,
	SetTextPos = function(self, x, y)
		self.TextPosX, self.TextPosY = x, y
		surface.SetTextPos(x, y)
	end,
	SetTextColor = function(self, r, ...)
		local col = r
		if (not istable(r)) then
			col = Color(r, ...)
		end
		self.Color = col
	end
})

pluto.fonts.registersystem("bouncy", bind {
	Text = function(self, text)
		return utf8.force(text)
	end,
	GetTextSize = function(self, text)
		return surface.GetTextSize(self:Text(text))
	end,
	DrawText = function(self, text)
		text = self:Text(text)
		local speed = 1
		local interval = ((CurTime() % speed) / speed + util.CRC(text) / (2 ^ 32))
		local x = self.TextPosX
		for pos, code in utf8.codes(text) do
			local chr = utf8.char(code)
			local addend = math.sin(interval * math.pi * 2)
			surface.SetTextPos(x, self.TextPosY + addend * 3)
			interval = interval + 0.13
			surface.DrawText(chr)
			x = x + surface.GetTextSize(chr)
		end
	end,
	SetFont = function(self, font)
		self.Font = font
		surface.SetFont(font)
	end,
	SetTextPos = function(self, x, y)
		self.TextPosX, self.TextPosY = x, y
		surface.SetTextPos(x, y)
	end
})

pluto.fonts.registersystem("rainbow", bind {
	Text = function(self, text)
		return utf8.force(text)
	end,
	SetTextColor = function(self, col)
		self.Color = col
	end,
	DrawText = function(self, text)
		text = self:Text(text)
		local speed = 4
		local interval = ((CurTime() % speed) / speed + util.CRC(text) / (2 ^ 32))
		for pos, code in utf8.codes(text) do
			local chr = utf8.char(code)
			local col = HSVToColor(interval * 360, 1, 1)
			col.a = self.Color.a
			surface.SetTextColor(col)
			interval = interval + 0.13
			surface.DrawText(chr)
		end
	end,
})

surface.CreateFont("pluto_test_font", {
	font = "Roboto",
	size = 16,
	bold = true,
	weight = 800,
})
