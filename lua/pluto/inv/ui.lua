pluto.ui = pluto.ui or {}

local pad = 0

local active_text = Color(205, 203, 203)
local inactive_text = Color(130, 130, 136)

local function curve(level)
	return math.ceil((8 + level * 2) / 2)
end
pluto.ui.curve = curve

local bg_color = Color(36, 36, 37)
local light_color = Color(84, 89, 89)

local count = 6


local function ColorToHSL(col)
	local r = col.r / 255
	local g = col.g / 255
	local b = col.b / 255
	local max = math.max(r, g, b)
	local min = math.min(r, g, b)
	local d = max - min

	local h
	if (d == 0) then 
		h = 0
	elseif (max == r) then
		h = (g - b) / d % 6
	elseif (max == g) then
		h = (b - r) / d + 2
	elseif (max == b) then
		h = (r - g) / d + 4
	end
	local l = (min + max) / 2
	local s = d == 0 and 0 or d / (1 - math.abs(2 * l - 1))

	return h * 60, s, l
end

local function hue2rgb(p, q, t)
	if (t < 0) then
		t = t + 1
	elseif (t > 1) then
		t = t - 1
	end

	if (t < 1 / 6) then
		return p + (q - p) * 6 * t
	end

	if (t < 0.5) then
		return q
	end

	if (t < 2 / 3) then
		return p + (q - p) * (2 / 3 - t) * 6
	end

	return p
end

local function HSLToColor(h, s, l)
	local c = (1 - math.abs(2 * l - 1)) * s
	local hp = h / 60.0
	local x = c * (1 - math.abs((hp % 2) - 1))
	local rgb1;
	if (h ~= h) then
		rgb1 = {[0] = 0, 0, 0}
	elseif (hp <= 1) then
		rgb1 = {[0] = c, x, 0}
	elseif (hp <= 2) then
		rgb1 = {[0] = x, c, 0}
	elseif (hp <= 3) then
		rgb1 = {[0] = 0, c, x}
	elseif (hp <= 4) then
		rgb1 = {[0] = 0, x, c}
	elseif (hp <= 5) then
		rgb1 = {[0] = x, 0, c}
	elseif (hp <= 6) then
		rgb1 = {[0] = c, 0, x}
	end
	local m = l - c * 0.5;
	return Color(
		math.Round(255 * (rgb1[0] + m)),
		math.Round(255 * (rgb1[1] + m)),
		math.Round(255 * (rgb1[2] + m))
	)
end

local function Brightness(col)
	local r, g, b = col.r / 255, col.g / 255, col.b / 255

	return math.sqrt(r * r * 0.241 + g * g * 0.691 + b * b * 0.068)
end

function pluto.inv.colors(col)
	local _h, s, l = ColorToHSL(col)
	s = math.Clamp(s, 0, 0.6)
	l = 0.5
	local col = HSLToColor(_h, s, l)

	_h, s, l = ColorToHSL(col)
	local num = (math.Clamp(Brightness(col), 0.25, 0.75) - 0.25) * 2
	return col, HSLToColor(_h, s + num * 0.3, l + 0.3)
end
pluto.ui_cache = pluto.ui_cache or {}

local spent = 0
local error_model = ClientsideModel("models/error.mdl")
error_model:SetNoDraw(true)

function pluto.cached_model(mdl, type)
	local m = pluto.ui_cache[mdl]
	if (not m or not IsValid(m)) then
		if (spent > 1 / 60) then
			return error_model
		end
		local t = SysTime()
		m = ClientsideModel(mdl)
		m:SetNoDraw(true)
		pluto.ui_cache[mdl] = m
		spent = spent + SysTime() - t
		if (IsValid(m) and type == "Model") then
			m:ResetSequence(m:LookupSequence "idle_all_01")
		end
	end
	return m
end

hook.Add("Think", "pluto_slow_load_models", function()
	spent = 0
end)

hook.Add("PlayerButtonDown", "pluto_inventory_ui", function(_, key)
	if (IsFirstTimePredicted() and key == KEY_I and pluto.inv.status == "ready") then
		pluto.ui.toggle()
	end
end)

--[[
	item showcase
	shows an item (lol)
]]

local PANEL = {}

function PANEL:Init()
	self.Text = "Label"
	self.Font = "DermaDefault"
	self.Children = {}
	self.Color = white_text
end

function PANEL:AddLine(line)
	local pnl = self:Add "DLabel"
	pnl:SetFont(self.Font)
	pnl:SetTextColor(self.Color)
	pnl:SetText(line)
	pnl:SetContentAlignment(5)
	pnl:Dock(TOP)
	pnl:SetZPos(#self.Children)
	local _, h = surface.GetTextSize(line)
	pnl:SetTall(h)
	self.Tall = self.Tall + h
	table.insert(self.Children, pnl)
end

function PANEL:PerformLayout(w, h)
	self:DoLayout(w, h)
end

function PANEL:DoLayout(_w, _h)
	local text = self.Text or "Label"
	if (self.LastText == text and self.LastWide == _w) then
		return
	end
	self.LastText = text
	self.LastWide = _w
	for _, child in pairs(self.Children) do
		child:Remove()
	end

	self.Children = {}

	local cur = {}
	surface.SetFont(self.Font)
	self.Tall = 0

	local last_newline = false
	for word, spaces in text:gmatch("([^%s]+)(%s*)") do
		cur[#cur + 1] = word
		local w, h = surface.GetTextSize(table.concat(cur, " "))
		if (w > _w or last_newline) then
			if (#cur == 1) then
				self:AddLine(word)
				cur = {}
			else
				cur[#cur] = nil
				self:AddLine(table.concat(cur, " "))
				local w, h = surface.GetTextSize(word)
				if (w > _w) then
					self:AddLine(word)
					cur = {}
				else
					cur = {word}
				end
			end
		end
		last_newline = spaces:find "\n"
	end

	if (#cur > 0) then
		self:AddLine(table.concat(cur, " "))
	end

	self:SetTall(self.Tall)
end

function PANEL:SetTextColor(col)
	self.Color = col
	for _, child in pairs(self.Children) do
		child:SetTextColor(col)
	end
end

function PANEL:SetFont(font)
	self.Font = font
	self:InvalidateLayout(true)
end

function PANEL:SetText(text)
	self.Text = text
	self:DoLayout(self:GetSize())
end

vgui.Register("pluto_centered_wrap", PANEL, "EditablePanel")

local PANEL = {}


function PANEL:AddImplicit(mod_data, item)
	local mod = pluto.mods.byname[mod_data.Mod]

	local z = self.ZPos or 3

	local p = self:Add "DLabel"
	p:SetContentAlignment(5)
	p:SetFont "pluto_item_showcase_impl"
	p:SetZPos(z)
	p:Dock(TOP)

	p:SetTextColor(mod.Color or white_text)
	p:SetText(pluto.mods.formatdescription(mod_data, item))

	self.ZPos = z + 1
	self.Last = pnl

	return p
end

function PANEL:AddMod(mod_data, item)
	local mod = pluto.mods.byname[mod_data.Mod]
	local z = self.ZPos or 3

	local pnl = self:Add "EditablePanel"
	pnl:SetZPos(z)
	pnl:Dock(TOP)

	local p = pnl:Add "DLabel"
	p:SetFont "pluto_item_showcase_smol"
	p:SetText(mod:GetTierName(mod_data.Tier))
	p:SetTextColor(white_text)
	p:Dock(LEFT)
	p:SetContentAlignment(7)
	p:SetZPos(0)

	pnl.Label = p

	local p = pnl:Add "DLabel"
	p:SetFont "pluto_item_showcase_desc"
	p:SetTextColor(white_text)
	p:SetWrap(true)
	p:SetAutoStretchVertical(true)
	p:Dock(RIGHT)
	p:SetZPos(1)

	DEFINE_BASECLASS "DLabel"

	function p:Think()
		local fmt
		if ((OVERRIDE_DETAILED or LocalPlayer():KeyDown(IN_DUCK))) then
			fmt = pluto.mods.format(mod_data, item)
			local minmaxs = pluto.mods.getminmaxs(mod_data, item)

			for i = 1, #fmt do
				fmt[i] = string.format("%s (%s to %s)", fmt[i], minmaxs[i].Mins, minmaxs[i].Maxs)
			end
		end

		local desc = pluto.mods.formatdescription(mod_data, item, fmt)

		if (self.LastDesc ~= desc) then
			self:SetText(desc)
			self:SizeToContentsY()
			self:InvalidateLayout(true)
		end

		BaseClass.Think(self)

		if (self.LastDesc ~= desc) then
			local p = self:GetParent():GetParent()

			p:Resize()
			self.LastDesc = desc
		end
	end

	pnl.Desc = p

	function pnl.Desc:PerformLayout(w, h)
		self:GetParent():SetTall(h)
		--self:GetParent():GetParent():Resize()
	end

	function pnl:PerformLayout(w, h)
		self.Label:SetWide(w / 4)
		self.Desc:SetWide(math.Round(w * 3 / 5))
	end

	self.ZPos = z + 1
	self.Last = pnl

	return pnl
end

function PANEL:SetItem(item)
	self.ItemName:SetTextColor(color_black)
	self.OriginalOwner:SetTextColor(color_black)
	self.Untradeable:SetTextColor(Color(240, 20, 30))
	self.ItemID:SetTextColor(color_black)
	self.Experience:SetTextColor(color_black)
	if (item.GetPrintName) then -- item
		self.ItemName:SetText(item:GetPrintName())
		if (item.Nickname) then
			self.ItemName:SetFont "pluto_item_showcase_header_italic"
		end
		if (item.Type == "Weapon") then
			self.ItemName:SetContentAlignment(4)
		else
			self.ItemName:SetContentAlignment(5)
		end
	else -- currency???
		self.ItemName:SetText(item.Name)
		self.ItemName:SetContentAlignment(5)
	end

	if (item.Untradeable) then
		surface.SetFont(self.Untradeable:GetFont())
		local w, h = surface.GetTextSize "A"
		self.UntradeableBackground:SetTall(h * 1.8)
		self.Untradeable:SetText("Not able to be traded")
		self.Untradeable:SizeToContentsY()
	else
		self.UntradeableBackground:SetTall(0)
	end

	if (item.OriginalOwnerName) then
		surface.SetFont(self.OriginalOwner:GetFont())
		local w, h = surface.GetTextSize "A"
		self.OriginalOwnerBackground:SetTall(h * 1.8)
		if (item.CreationMethod) then
			local fmt = ({
				UNBOXED = "Unboxed by %s",
				SPAWNED = "Created by %s",
				FOUND = "Found by %s",
				DELETE = "Sharded by %s",
				REWARD = "Rewarded to %s",
				QUEST = "Quest Reward given to %s",
				DROPPED = "Dropped by %s",
				MIRROR = "Mirrored by %s",
				CRAFT = "Crafted by %s",
				BOUGHT = "Bought in the Divine Shop by %s",
			})[item.CreationMethod] or item.CreationMethod .. " %s"
			self.OriginalOwner:SetText(fmt:format(item.OriginalOwnerName))
		else
			self.OriginalOwner:SetText("Originally " .. (item.Crafted and "crafted" or "found") .. " by " .. item.OriginalOwnerName)
		end
		self.OriginalOwner:SizeToContentsY()

		local h, s, l = ColorToHSL(item.Color or item:GetColor())
		l = l * 0.85

		self.OriginalOwnerBackground:SetColor(HSLToColor(h, s, l))
	else
		self.OriginalOwnerBackground:SetTall(0)
	end

	if (item.ID) then
		self.ItemID:SetText(item.ID)
	else
		self.ItemID:SetText ""
	end
	self.ItemID:SizeToContentsY()

	if (item.Experience) then
		self.Experience:SetText("EXP: " .. item.Experience)
	else
		self.Experience:SetText ""
	end
	self.Experience:SizeToContentsY()

	self.ItemName:SizeToContentsY()
	self.ItemBackground:SetTall(self.ItemName:GetTall() * 1.5)
	local pad = self.ItemName:GetTall() * 0.25
	self.ItemBackground:DockPadding(pad, pad, pad, pad)
	self.ItemBackground:SetColor(item.Color or item:GetColor())

	self.ItemDesc:SetText(item.Description or "")
	local subdesc = item.SubDescription or ""
	if (item.AffixMax) then
		subdesc = subdesc .. "\n" .. "You can get up to " .. item.AffixMax .. " modifiers on this item."
	end

	if (item.ClassName) then
		self.ItemDesc:DockMargin(0, pad, 0, 0)
	else
		self.ItemDesc:DockMargin(0, pad, 0, pad / 2)
	end

	self.ItemSubDesc:SetText(subdesc)
	if (self.ItemSubDesc:GetText() ~= "") then
		self.ItemSubDesc:DockMargin(0, pad / 2, 0, pad)
	end

	self.Last = self.ItemSubDesc

	if (item.Mods and item.Mods.implicit) then
		for _, mod in ipairs(item.Mods.implicit) do
			self:AddImplicit(mod, item):DockMargin(pad, pad / 2, pad, pad / 2)
		end
	end

	if (item.Mods and item.Mods.prefix) then
		for _, mod in ipairs(item.Mods.prefix) do
			self:AddMod(mod, item):DockMargin(pad, pad / 2, pad, pad / 2)
		end
	end

	if (item.Mods and item.Mods.suffix) then
		for _, mod in ipairs(item.Mods.suffix) do
			self:AddMod(mod, item):DockMargin(pad, pad / 2, pad, pad / 2)
		end
	end

	self:Resize()
end

function PANEL:Resize()
	self:InvalidateLayout(true)
	self:InvalidateChildren(true)
	self:SizeToChildren(true, true)
	self:SetTall(self:GetTall() + pad / 2)
	self:GetParent():SizeToChildren(true, true)
end

local h = 720

surface.CreateFont("pluto_item_showcase_header", {
	font = "Lato",
	extended = true,
	size = math.max(30, h / 28),
	weight = 1000,
})

surface.CreateFont("pluto_item_showcase_header_italic", {
	font = "Lato",
	extended = true,
	italic = true,
	size = math.max(30, h / 28),
	weight = 1000,
})

surface.CreateFont("pluto_item_showcase_id", {
	font = "Roboto",
	extended = true,
	size = math.max(10, h / 50),
	weight = 1000,
})

surface.CreateFont("pluto_item_owner_font", {
	font = "Roboto",
	extended = true,
	size = math.max(10, h / 50),
	weight = 1000,
})

surface.CreateFont("pluto_item_showcase_desc", {
	font = "Roboto",
	extended = true,
	size = math.max(20, h / 35)
})

surface.CreateFont("pluto_item_showcase_impl", {
	font = "Roboto",
	extended = true,
	italic = true,
	size = math.max(20, h / 35)
})

surface.CreateFont("pluto_item_showcase_smol", {
	font = "Roboto",
	extended = true,
	size = math.max(h / 50, 16),
	italic = true,
})

surface.CreateFont("pluto_item_chat_smol", {
	font = "Roboto",
	extended = true,
	size = math.max(h / 50, 16),
	italic = true,
})

function PANEL:Init()
	local w = math.min(500, math.max(400, ScrW() / 3))
	pad = w * 0.05
	pluto.ui.pad = pad

	self:SetColor(solid_color)
	self.ItemBackground = self:Add "ttt_curved_panel"
	self.ItemBackground:SetCurve(2)
	self.ItemBackground:Dock(TOP)
	self.ItemBackground:SetCurveBottomLeft(false)
	self.ItemBackground:SetCurveBottomRight(false)

	self.ItemName = self.ItemBackground:Add "DLabel"
	self.ItemName:Dock(FILL)
	self.ItemName:SetFont "pluto_item_showcase_header"

	self.OriginalOwnerBackground = self:Add "ttt_curved_panel"
	self.OriginalOwnerBackground:Dock(TOP)

	self.OriginalOwner = self.OriginalOwnerBackground:Add "DLabel"
	self.OriginalOwner:Dock(FILL)
	self.OriginalOwner:SetFont "pluto_item_owner_font"
	self.OriginalOwner:SetContentAlignment(5)

	self.UntradeableBackground = self:Add "EditablePanel"
	self.UntradeableBackground:Dock(TOP)
	self.UntradeableBackground.Material = stripes

	self.Untradeable = self.UntradeableBackground:Add "DLabel"
	self.Untradeable:Dock(FILL)
	self.Untradeable:SetFont "pluto_item_owner_font"
	self.Untradeable:SetContentAlignment(5)

	self.ItemID = self.ItemName:Add "DLabel"
	self.ItemID:Dock(FILL)
	self.ItemID:SetContentAlignment(3)
	self.ItemID:SetFont "pluto_item_showcase_id"

	self.Experience = self.ItemName:Add "DLabel"
	self.Experience:Dock(TOP)
	self.Experience:SetContentAlignment(9)
	self.Experience:SetFont "pluto_item_showcase_id"

	self.ItemDesc = self:Add "pluto_centered_wrap"
	self.ItemDesc:SetFont "pluto_item_showcase_desc"
	self.ItemDesc:Dock(TOP)

	self.ItemSubDesc = self:Add "pluto_centered_wrap"
	self.ItemSubDesc:SetFont "pluto_item_showcase_smol"
	self.ItemSubDesc:Dock(TOP)
end

vgui.Register("pluto_item_showcase_inner", PANEL, "ttt_curved_panel")

local PANEL = {}

function PANEL:Init()
	self.Inner = self:Add "pluto_item_showcase_inner"
	self.Inner:Dock(FILL)
	self:SetCurve(4)
	self:SetColor(color_black)
	local pad = curve(0) / 2
	self.Inner:SetCurve(pad)
end

function PANEL:SetItem(item)
	self:SetWide(math.max(300, math.min(600, ScrW() / 3)))
	self.Inner:SetWide(math.max(300, math.min(500, ScrW() / 3)))
	self.Inner:SetItem(item)
end

vgui.Register("pluto_item_showcase", PANEL, "ttt_curved_panel_outline")

function pluto.ui.oldshowcase(item)
	if (IsValid(pluto.ui.showcasepnl)) then
		pluto.ui.showcasepnl:Remove()
	end

	pluto.ui.showcasepnl = vgui.Create "pluto_item_showcase"
	pluto.ui.showcasepnl:MakePopup()
	pluto.ui.showcasepnl:SetKeyboardInputEnabled(false)
	pluto.ui.showcasepnl:SetMouseInputEnabled(false)

	pluto.ui.showcasepnl:SetItem(item)

	return pluto.ui.showcasepnl
end

local PANEL = {}

function PANEL:Init()
	self.Text = self:Add "pluto_centered_wrap"
	self.Text:SetFont "pluto_item_showcase_desc"
	self.Text:Dock(TOP)
	self.Text:SetTextColor(color_white)
	local pad = pad / 2
	self:DockPadding(pad, pad, pad, pad)
	self:SetWide(200)
	function self.Text:PerformLayout(w, h)
		self:SetWide(self:GetParent():GetWide() - pad * 2)
		self:GetParent():SetTall(h + pad * 2)
		self:DoLayout(self:GetSize())
	end
	self.Start = CurTime()
	self.Ends = CurTime() + 2
	self:SetCurve(4)

	self:MakePopup()
	self:SetKeyboardInputEnabled(false)
	self:SetMouseInputEnabled(false)
end

function PANEL:SetText(t)
	self.Text:SetText(t)
end

function PANEL:Think()
	self.OriginalY = self.OriginalY or select(2, self:GetPos())
	local frac = (self.Ends - CurTime()) / (self.Ends - self.Start)
	if (frac <= 0) then
		self:Remove()
	end
	local x, y = self:GetPos()
	self:SetPos(x, self.OriginalY + 100 * (1 - frac))
	self:SetColor(Color(17, 15, 13, frac * 255))
	self.Text:SetTextColor(ColorAlpha(white_text, frac * 255))
end

vgui.Register("pluto_falling_text", PANEL, "ttt_curved_panel")

local PANEL = {}

local alpha = 220
function PANEL:Init()
	self:SetCurve(4)
	self:SetSize(100, 40)
	self:SetColor(Color(95, 96, 102, alpha))
	self.Inner = self:Add "ttt_curved_panel"
	self.Inner:Dock(FILL)
	self.Inner:SetCurve(4)
	self.Inner:SetColor(Color(53, 53, 53, alpha))

	self.Label = self.Inner:Add "pluto_label"
	self.Label:Dock(FILL)
	self.Label:SetRenderSystem(pluto.fonts.systems.shadow)
	self.Label:SetTextColor(Color(255, 255, 255))
	self.Label:SetText "This server was coded for x86-64. You may notice performance issues."
	self.Label:SetFont "pluto_inventory_font_xlg"
	self.Label:SetContentAlignment(5)
	self.Label:SizeToContents()

	self:SetSize(self.Label:GetSize())
	self:SetTall(self:GetTall() + 8)
	self:SetWide(self:GetWide() + 14)
end

vgui.Register("pluto_branch_popup", PANEL, "ttt_curved_panel_outline")


if (IsValid(pluto_pop)) then
	pluto_pop:Remove()
end

if (not tonumber("0b1")) then
	pluto_pop = vgui.Create "pluto_branch_popup"
	pluto_pop:ParentToHUD()
	pluto_pop:SetPos(0, ScrH() - pluto_pop:GetTall() - 30)
	pluto_pop:CenterHorizontal()
end
