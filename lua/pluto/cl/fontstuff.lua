pluto.fonts = pluto.fonts or {
	systems = {}
}

function pluto.fonts.registersystem(name, system)
	pluto.fonts.systems[name] = system
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

local shadow_col = Color(12, 13, 14)
pluto.fonts.registersystem("shadow", bind {
	GetTextSize = function(self, text)
		return surface.GetTextSize(text)
	end,
	DrawText = function(self, text)
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

if (IsValid(RICHTEXT)) then
	RICHTEXT:Remove()
end

RICHTEXT = vgui.Create "DFrame"
local rt = RICHTEXT:Add "pluto_text"
rt:Dock(FILL)
RICHTEXT:SetSize(800, 600)
RICHTEXT:Center()
RICHTEXT:MakePopup()
RICHTEXT:InvalidateLayout(true)

rt:SetDefaultFont "BudgetLabel"
rt:SetDefaultTextColor(Color(0, 255, 255))
rt:SetDefaultRenderSystem "default"

rt:AppendText("Hello, this i-")
rt:NewLine()
rt:AppendText(white_text, "Hello, this " .. string.rep("a ", 100) .. "\nis a ")
rt:SetCurrentFont "pluto_chat_font"
rt:SetCurrentRenderSystem "bouncy"
rt:InsertClickableTextStart(function()
	print "yes u clik"
end)
rt:AppendText(Color(255, 0, 0), "CLICKABLE TEST")
rt:AddImage(Material "icon16/cross.png", 64, 64)
rt:InsertClickableTextEnd()
rt:ResetTextSettings()
rt:AppendText(" of tests")
rt:AppendText(string.rep("ha", 64) .. " ha that was jheok")
rt:NewLine()