--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
local PANEL = {}

function PANEL:Init()
	self:SetColor(Color(84, 86, 90, 255))
	self:SetCurve(4)
	self:DockPadding(1, 1, 1, 1)

	self:Think()
	self:CreateInners()

	self:MakePopup()
	self:SetKeyboardInputEnabled(false)
	self:SetMouseInputEnabled(false)
end

function PANEL:GetControlState()
	return PLUTO_OVERRIDE_CONTROL_STATUS or input.IsKeyDown(KEY_LCONTROL)
end

function PANEL:Think()
	if (self.LastControlState == nil) then
		self.LastControlState = self:GetControlState()
		return
	end

	if (self.LastControlState == self:GetControlState()) then
		return
	end

	self.LastControlState = self:GetControlState()

	self:CreateInners()
end

function PANEL:CreateInners()
	for _, child in pairs(self:GetChildren()) do
		child:Remove()
	end

	self:SetSize(320, 56 + 12 + 18)
	self.NameContainer = self:Add "ttt_curved_panel"
	self.NameContainer:Dock(TOP)
	self.NameContainer:SetTall(30)
	self.NameContainer:SetCurveBottomLeft(false)
	self.NameContainer:SetCurveBottomRight(false)
	self.NameContainer:SetCurve(4)

	self.NameLabel = self.NameContainer:Add "pluto_label"
	self.NameLabel:SetRenderSystem(pluto.fonts.systems.shadow)
	self.NameLabel:SetFont "pluto_showcase_name"
	self.NameLabel:SetTextColor(pluto.ui.theme "TextActive")
	self.NameLabel:SetText "TEST"
	self.NameLabel:Dock(FILL)
	self.NameLabel:SetContentAlignment(5)

	self.NameSeperator = self.NameContainer:Add "EditablePanel"
	self.NameSeperator:SetTall(1)
	self.NameSeperator:Dock(BOTTOM)
	function self.NameSeperator:Paint(w, h)
		surface.SetDrawColor(21, 21, 21)
		surface.DrawRect(0, 0, w, h)
	end

	self.RealNameLabel = self.NameContainer:Add "pluto_label"
	self.RealNameLabel:SetRenderSystem(pluto.fonts.systems.shadow)
	self.RealNameLabel:SetFont "pluto_showcase_name_real"
	self.RealNameLabel:SetTextColor(pluto.ui.theme "TextActive")
	self.RealNameLabel:SetText ""
	self.RealNameLabel:Dock(BOTTOM)
	self.RealNameLabel:SetContentAlignment(8)
	self.RealNameLabel:SetTall(0)


	self.InfoContainer = self:Add "EditablePanel"
	self.InfoContainer:Dock(FILL)
	self.InfoContainer:DockPadding(7, 0, 7, 0)

	self.BottomLine = self.InfoContainer:Add "EditablePanel"
	self.BottomLine:Dock(BOTTOM)
	self.BottomLine:SetTall(18)

	self.BottomLine2 = self.InfoContainer:Add "EditablePanel"
	self.BottomLine2:Dock(BOTTOM)
	self.BottomLine2:SetTall(18)

	self.EXPLabel = self.BottomLine2:Add "pluto_label"
	self.EXPLabel:SetRenderSystem(pluto.fonts.systems.shadow)
	self.EXPLabel:SetFont "pluto_showcase_small"
	self.EXPLabel:SetTextColor(Color(255, 255, 255))
	self.EXPLabel:Dock(RIGHT)
	self.EXPLabel:SetContentAlignment(6)
	self.EXPLabel:SetTall(0)
	self.EXPLabel:SetText ""
	self.EXPLabel:SizeToContentsX()


	self.StatArea = self.InfoContainer:Add "EditablePanel"
	self.StatArea:SetTall(0)
	AccessorFunc(self.StatArea, "RealTall", "RealTall")
	self.StatArea:Dock(BOTTOM)

	self.IDLabel = self.BottomLine:Add "pluto_label"
	self.IDLabel:SetFont "pluto_showcase_small"
	self.IDLabel:SetRenderSystem(pluto.fonts.systems.shadow)
	self.IDLabel:SetTextColor(Color(174, 174, 174, 200))
	self.IDLabel:SetText ""
	self.IDLabel:Dock(LEFT)
	self.IDLabel:SizeToContentsX()
	self.IDLabel:SetContentAlignment(5)

	self.CreatedLabel = self.BottomLine:Add "pluto_label"
	self.CreatedLabel:SetFont "pluto_showcase_small"
	self.CreatedLabel:SetRenderSystem(pluto.fonts.systems.shadow)
	self.CreatedLabel:SetTextColor(Color(255, 255, 255))
	self.CreatedLabel:SetText ""
	self.CreatedLabel:Dock(RIGHT)
	self.CreatedLabel:SizeToContentsX()
	self.CreatedLabel:SetContentAlignment(5)

	self.TierInfo = self:Add "EditablePanel"
	self.TierInfo:Dock(TOP)
	self.TierInfo:SetTall(0)
	self.TierInfo:DockMargin(7, 0, 7, 0)

	self.Implicits = self:Add "EditablePanel"
	self.Implicits:Dock(TOP)
	self.Implicits:SetTall(0)
	self.Implicits:DockMargin(7, 0, 7, 0)

	self.PrefixContainer = self:Add "EditablePanel"
	self.PrefixContainer:Dock(TOP)
	self.PrefixContainer:SetTall(12)

	self.ItemInformationLine = self:Add "EditablePanel"
	self.ItemInformationLine:Dock(TOP)
	self.ItemInformationLine:SetTall(0)
	self.ItemInformationLine:DockPadding(7, 0, 7, 0)


	self:InvalidateLayout(true)

	if (self.Item) then
		self.HasPrefix = false
		self.HasSuffix = false
		self.HasImplicit = false
		self:SetItem(self.Item)
	end
end

function PANEL:AddImplicit(implicit, item)
	local MOD = pluto.mods.byname[implicit.Mod]
	
	local label = self.Implicits:Add "pluto_text_inner"
	label:SetWide(self:GetWide() - 14)
	label:Dock(TOP)
	label:SetDefaultRenderSystem(pluto.fonts.systems.shadow)
	label:SetDefaultTextColor(MOD.Color)
	label:SetDefaultFont "pluto_inventory_font_lg"
	label:AppendText(MOD.Color, MOD.Name, Color(255, 255, 255), " - ", MOD.Description .. "\n")
	label:SizeToContentsY()

	if (not self.HasImplicit) then
		self.Implicits:DockPadding(0, 7, 0, 0)
		self.HasImplicit = true
		self.ImplicitsLine = self.Implicits:Add "ttt_curved_panel"
		self.ImplicitsLine:Dock(BOTTOM)
		self.ImplicitsLine:SetTall(1)
		self.ImplicitsLine:SetColor(Color(90, 91, 95))
		self:SetTall(self:GetTall() + 11)
		self.Implicits:SetTall(self.Implicits:GetTall() + 11 + 7)
	end

	self.Implicits:SetTall(self.Implicits:GetTall() + label:GetTall())
	self:SetTall(self:GetTall() + label:GetTall() + 7)
end

local function value(a)
	if (type(a) == "Vector") then
		a = a:Length()
	elseif (type(a) == "Angle") then
		a = math.AngleDifference(a.p, 0) + math.AngleDifference(a.y, 0)
	end

	return a
end

local function GetMinMax(compared, statmod)
	if (istable(statmod)) then
		statmod = statmod[1]
	end

	local min, max = math.huge, -math.huge
	for _, class in pairs(pluto.weapons.guns) do
		class = baseclass.Get(class)
		if (class ~= compared and (class.Slot ~= compared.Slot or not not compared.Primary ~= not not class.Primary or class.Primary and class.Primary.Ammo ~= compared.Primary.Ammo)) then
			continue
		end
		local num = pluto.mods.getrawvalue(class, statmod) or 0
		if (value(num) < value(min)) then
			min = num
		end
		if (value(num) > value(max)) then
			max = num
		end
	end

	if (statmod == "Spread") then
		return max, min
	else
		return min, max
	end
end

function PANEL:AddPrefix(prefix, item)
	local MOD = pluto.mods.byname[prefix.Mod]
	local added_size = 0
	if (not self.HasPrefix) then
		self.PrefixContainer:DockPadding(7, 12, 7, 12)
		added_size = added_size + 12
	end
	self.HasPrefix = true

	local container = self.PrefixContainer:Add "EditablePanel"
	container:SetTall(23)
	container:Dock(TOP)

	local name = container:Add "pluto_label"
	name:Dock(TOP)
	name:SetFont "pluto_showcase_suffix_text"
	name:SetRenderSystem(pluto.fonts.systems.shadow)
	name:SetText ""
	name:SetTextColor(Color(255, 255, 255))
	name:SetText(MOD:GetTierName(prefix.Tier))
	name:SizeToContentsY(2)
	name:SetContentAlignment(4)

	local rolls = pluto.mods.getrolls(MOD, prefix.Tier, prefix.Roll)
	local num = pluto.mods.getrawvalue(baseclass.Get(item.ClassName), MOD.StatModifier)
	local mins, maxs = GetMinMax(baseclass.Get(item.ClassName), MOD.StatModifier)
	local frac_base = (not num or not mins or not maxs or mins == maxs) and 0.35 or 0.35 * ((value(num) - value(mins)) / (value(maxs) - value(mins)))
	local left = 1 - frac_base - 0.2
	local txt = MOD:FormatModifier(1, rolls[1])
	local min, max = MOD:GetMinMax()
	local tier_min = 0.2 + left * (MOD.Tiers[prefix.Tier][1] - min) / (max - min)
	local cur_value = 0.2 + left * (rolls[1] - min) / (max - min)
	local tier_max = 0.2 + left * (MOD.Tiers[prefix.Tier][2] - min) / (max - min)

	local text = txt
	if (self.LastControlState) then
		text = string.format("%s (%s to %s)", txt, MOD:FormatModifier(1, MOD.Tiers[prefix.Tier][1]), MOD:FormatModifier(1, MOD.Tiers[prefix.Tier][2]))
	end

	local numberlabel = name:Add "pluto_label"
	numberlabel:Dock(RIGHT)
	numberlabel:SetFont "pluto_showcase_suffix_text"
	numberlabel:SetRenderSystem(pluto.fonts.systems.shadow)
	numberlabel:SetText(text)
	numberlabel:SetTextColor(Color(255, 255, 255))
	numberlabel:SetContentAlignment(6)
	numberlabel:SizeToContentsX(2)

	local bar = container:Add "pluto_showcase_bar"
	bar:Dock(FILL)
	bar:AddFilling(frac_base, num, Color(109, 147, 232))

	bar:AddFilling(tier_min, "", Color(37, 225, 68))
	bar:AddFilling(cur_value - tier_min, txt:sub(1, 1) == "-" and txt or "+" .. txt, Color(37, 225, 68))
	bar:AddFilling(tier_max - cur_value, "", Color(169, 169, 169, 0))


	if (IsValid(self.LastAddedPrefix)) then
		self.LastAddedPrefix:DockMargin(0, 0, 0, 5)
		added_size = added_size + 5
	end
	self.LastAddedPrefix = container

	added_size = added_size + container:GetTall()

	self.PrefixContainer:SetTall(self.PrefixContainer:GetTall() + added_size)
	self:SetTall(self:GetTall() + added_size)
end

function PANEL:AddSuffix(suffix, item)
	local MOD = pluto.mods.byname[suffix.Mod]
	local fmt = pluto.mods.format(suffix, item)
	local minmaxs = pluto.mods.getminmaxs(suffix, item)

	if (self.LastControlState) then
		for i = 1, #fmt do
			fmt[i] = string.format("%s (%s to %s)", fmt[i], minmaxs[i].Mins, minmaxs[i].Maxs)
		end
	end

	local size = 0

	if (self.HasSuffix) then
		local seperator = self.InfoContainer:Add "EditablePanel"
		seperator:SetTall(1)
		seperator:Dock(TOP)
		seperator:DockMargin(0, 8, 0, 0)

		size = size + 9
	else
		self.BottomLine2:DockMargin(0, 13, 0, 0)
		size = size + 13
	end

	local modname = self.InfoContainer:Add "pluto_label"
	modname:Dock(TOP)
	modname:SetFont "pluto_showcase_suffix_text"
	modname:SetTextColor(MOD.Color or Color(222, 111, 3))
	modname:SetRenderSystem(pluto.fonts.systems.shadow)
	modname:SetContentAlignment(4)
	modname:SetText(MOD:GetTierName(suffix.Tier))
	modname:SizeToContentsY(2)
	modname:DockMargin(0, 2, 0, 0)
	size = size + 2

	local curtext
	local desc = pluto.mods.formatdescription(suffix, item, fmt)
	surface.SetFont "pluto_showcase_suffix_text"

	local function addtext()
		local modtext = self.InfoContainer:Add "pluto_label"
		modtext:Dock(TOP)
		modtext:SetFont "pluto_showcase_suffix_text"
		modtext:SetTextColor(Color(255, 255, 255))
		modtext:SetRenderSystem(pluto.fonts.systems.shadow)
		modtext:SetContentAlignment(4)
		modtext:SetText(curtext)
		modtext:SizeToContentsY(2)

		size = size + modtext:GetTall()
	end

	for m in desc:gmatch "%S+" do
		local nexttext = curtext
		if (curtext) then
			nexttext = curtext .. " " .. m
			local tw, th = surface.GetTextSize(nexttext)
			if (tw > self:GetWide() - 20) then
				addtext()
				curtext = m
			else
				curtext = nexttext
			end
		else
			curtext = m
		end
	end

	if (curtext) then
		addtext()
	end

	self.HasSuffix = true
	self:SetTall(self:GetTall() + modname:GetTall() + size)
end

local function TextColorizer(t)
	return Color(0, 255, 0)
end

function PANEL:SetItem(item)
	self.Item = item
	self.NameContainer:SetColor(item:GetColor())

	if (item.SubDescription and item.SubDescription ~= "") then
		self.SubDescription = self.TierInfo:Add "pluto_text_inner"
		self.SubDescription:SetWide(self:GetWide() - 14)
		self.SubDescription:Dock(TOP)
		self.SubDescription:SetDefaultRenderSystem(pluto.fonts.systems.shadow)
		self.SubDescription:SetDefaultTextColor(Color(255, 255, 255))
		self.SubDescription:SetDefaultFont "pluto_inventory_font"
		self.SubDescription:AppendText(item.SubDescription .. "\n")
		self.SubDescription:SizeToContentsY()
		self:SetTall(self:GetTall() + self.SubDescription:GetTall() + 5)
		self.TierInfo:SetTall(self.SubDescription:GetTall())
		self.TierInfo:DockMargin(7, 5, 7, 0)
	end

	self.NameLabel:SetText(item:GetPrintName())
	do
		local surface = self.NameLabel:GetRenderSystem()
		surface.SetFont(self.NameLabel:GetFont())
		self:SetWide(math.max(surface.GetTextSize(item:GetPrintName()) + 20, self:GetWide()))
	end

	if (item:GetPrintName() ~= item:GetRawName()) then
		self.RealNameLabel:SetTall(18)
		self.RealNameLabel:SetText(item:GetRawName())
		self.NameContainer:SetTall(self.NameContainer:GetTall() + self.RealNameLabel:GetTall())
		self:SetTall(self:GetTall() + self.RealNameLabel:GetTall())
	end

	if (item.ID) then
		self.IDLabel:SetText(item.ID)
		self.IDLabel:SizeToContentsX()
	end

	if (item.Experience) then
		self.EXPLabel:SetText("EXP: " .. item.Experience)
		self.EXPLabel:SizeToContentsX()
	end

	if (item:GetMaxAffixes() > 0) then
		local num_mods = 0
		if (item.Mods) then
			for type, tbl in pairs(item.Mods) do
				if (type == "implicit") then
					continue
				end

				num_mods = num_mods + #tbl
			end
		end
		--[[
		self.ModLabel:SetText(num_mods .. " / " .. item:GetMaxAffixes() .. " mods")
		self.ModLabel:SizeToContentsX()]]
	end

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
			BOUGHT = "Bought by %s",
		})[item.CreationMethod] or item.CreationMethod .. " %s"
		self.CreatedLabel:SetText(fmt:format(item.OriginalOwnerName))
		self.CreatedLabel:SizeToContentsX()
	end

	if (item.Mods) then
		self.ItemInformationLine:DockMargin(0, 0, 0, 4)
		self:SetTall(self:GetTall() + 4)
		self.ModLabel = self.ItemInformationLine:Add "pluto_label"
		self.ModLabel:Dock(RIGHT)
		self.ModLabel:SetFont "pluto_showcase_suffix_text"
		self.ModLabel:SetTextColor(Color(255, 255, 255))
		self.ModLabel:SetText(string.format("%i/%i mods", #(item.Mods.suffix or {}) + #(item.Mods.prefix or {}), item:GetMaxAffixes()))
		self.ModLabel:DockMargin(7, 0, 0, 0)
		self.ModLabel:SizeToContents()

		self.SuffixLabel = self.ItemInformationLine:Add "pluto_label"
		self.SuffixLabel:Dock(LEFT)
		self.SuffixLabel:SetFont "pluto_showcase_suffix_text"
		self.SuffixLabel:SetTextColor(Color(255, 255, 255))
		self.SuffixLabel:SetText(string.format("%i/%i suffixes", #(item.Mods.suffix or {}), math.min(item:GetMaxAffixes(), 3)))
		self.SuffixLabel:DockMargin(0, 0, 7, 0)
		self.SuffixLabel:SizeToContents()

		local height = math.max(self.SuffixLabel:GetTall(), self.ModLabel:GetTall())

		self.ItemInformationLine:SetTall(height)

		self.ModLine = self.ItemInformationLine:Add "EditablePanel"
		self.ModLine:Dock(FILL)
		function self.ModLine:Paint(w, h)
			surface.SetDrawColor(85, 85, 85)
			surface.DrawLine(0, h / 2, w, h / 2)
		end

		if (item.Mods) then
			if (item.Mods.implicit) then
				for _, implicit in ipairs(item.Mods.implicit) do
					self:AddImplicit(implicit, item)
				end
			end
			if (item.Mods.prefix) then
				for _, prefix in ipairs(item.Mods.prefix) do
					self:AddPrefix(prefix, item)
				end
			end
			if (item.Mods.suffix) then
				for _, suffix in ipairs(item.Mods.suffix) do
					self:AddSuffix(suffix, item)
				end
			end
		end
	end

	local inspect = self.StatArea:Add "pluto_label"
	inspect:Dock(TOP)
	inspect:SetText "Hold LCTRL to inspect"
	inspect:SetFont "pluto_showcase_suffix_text"
	inspect:SetTextColor(Color(255, 255, 255))
	inspect:SetRenderSystem(pluto.fonts.systems.shadow)
	inspect:SizeToContents()
	inspect:SetContentAlignment(5)
	inspect:DockMargin(0, 0, 0, 7)

	function inspect:PaintOver(w, h)
		local surface = self:GetRenderSystem() or surface
		surface.SetFont(self:GetFont())
		local tw, th = surface.GetTextSize(self:GetText())

		surface.SetDrawColor(90, 91, 95)
		surface.DrawLine(0, h / 2, w / 2 - tw / 2 - 7, h / 2)
		surface.DrawLine(w / 2 + tw / 2 + 7, h / 2, w, h / 2)
	end

	self.StatArea:SetTall(self.StatArea:GetTall() + inspect:GetTall() + 7)
	self.StatArea:SetRealTall(self.StatArea:GetTall())

	if (item.Type == "Weapon") then
		local dmg_text = pluto.mods.getitemvalue(item, "Damage")
		local dmg, pellets = tostring(dmg_text):match "^([%d%.]+)%*?(%d*)$"
		dmg, pellets = dmg or 0, pellets or 0
		pellets = pellets == "" and 1 or pellets
		local rpm = tonumber((pluto.mods.getitemvalue(item, "Delay"))) or 1

		local stats = {
			{
				Abbreviation = "DPS",
				Value = math.Round(dmg * pellets * rpm / 60, 1)
			},
			{
				Abbreviation = "DMG",
				Value = dmg_text,
				Colorize = function(num)
					if (dmg * pellets > 95) then
						return Color(255, 0, 0)
					elseif (dmg * pellets >= 45) then
						return Color(255, 156, 0)
					else
						return Color(234, 255, 0)
					end
				end,
			},
			{
				Abbreviation = "RPM",
				Value = rpm
			},
			{
				Abbreviation = "HS*",
				Value = math.Round(baseclass.Get(item.ClassName).HeadshotMultiplier or "1", 1)
			},
			{
				Abbreviation = "MAG",
				Value = pluto.mods.getitemvalue(item, "ClipSize"),
				NewLine = true
			},
			{
				Abbreviation = "RANGE",
				Value = {
					pluto.mods.getitemvalue(item, "DamageDropoffRange"),
					pluto.mods.getitemvalue(item, "DamageDropoffRangeMax"),
				},
			},
		}
		surface.SetFont "pluto_showcase_suffix_text"
		local _, th = surface.GetTextSize "|A"
		local curline

		local function finalizeline(nonew)
			if (IsValid(curline)) then
				-- resize things
			end
			if (nonew) then
				return
			end
			curline = self.StatArea:Add "EditablePanel"
			curline:SetTall(th + 3 + 4)
			curline:DockPadding(0, 0, 0, 4)
			curline:Dock(TOP)
			self.StatArea:SetRealTall(self.StatArea:GetRealTall() + curline:GetTall())
		end

		for _, statdata in ipairs(stats) do
			if (not IsValid(curline) or statdata.NewLine) then
				finalizeline()
			end
			local stat = curline:Add "EditablePanel"
			stat:SetWide(9)
			stat:DockMargin(0, 0, 4, 0)
			stat:Dock(LEFT)
			function stat:Paint(w, h)
				surface.SetDrawColor(90, 91, 95)
				ttt.DrawCurvedRect(0, 0, w, h, 4)
				surface.SetDrawColor(38, 38, 38)
				ttt.DrawCurvedRect(1, 1, w - 2, h - 2, 2)
			end

			local abbrev = stat:Add "pluto_label"
			abbrev:SetText(statdata.Abbreviation .. " ")
			abbrev:SetFont "pluto_showcase_suffix_text"
			abbrev:SetTextColor(Color(255, 255, 255))
			abbrev:SetRenderSystem(pluto.fonts.systems.shadow)
			abbrev:SizeToContentsX()
			abbrev:DockMargin(4, 0, 0, 0)
			abbrev:Dock(LEFT)
			abbrev:SetContentAlignment(5)
			stat:SetWide(stat:GetWide() + abbrev:GetWide())

			if (istable(statdata.Value)) then
				local min = stat:Add "pluto_label"
				min:SetText(statdata.Value[1])
				min:SetFont "pluto_showcase_suffix_text"
				min:SetTextColor(Color(255, 255, 255))
				min:SetRenderSystem(pluto.fonts.systems.shadow)
				min:SizeToContentsX()
				min:Dock(LEFT)
				min:SetContentAlignment(5)
				min:SetTextColor((statdata.Colorize or TextColorizer)(statdata.Value))
				stat:SetWide(stat:GetWide() + min:GetWide())

				local totext = stat:Add "pluto_label"
				totext:SetText "-"
				totext:SetFont "pluto_showcase_suffix_text"
				totext:SetTextColor(Color(255, 255, 255))
				totext:SetRenderSystem(pluto.fonts.systems.shadow)
				totext:SizeToContentsX()
				totext:Dock(LEFT)
				totext:SetContentAlignment(5)
				stat:SetWide(stat:GetWide() + totext:GetWide())

				local max = stat:Add "pluto_label"
				max:SetText(statdata.Value[2])
				max:SetFont "pluto_showcase_suffix_text"
				max:SetTextColor(Color(255, 255, 255))
				max:SetRenderSystem(pluto.fonts.systems.shadow)
				max:SizeToContentsX()
				max:Dock(LEFT)
				max:SetContentAlignment(5)
				max:SetTextColor((statdata.Colorize or TextColorizer)(statdata.Value))
				stat:SetWide(stat:GetWide() + max:GetWide())
			else
				local min = stat:Add "pluto_label"
				min:SetText(statdata.Value)
				min:SetFont "pluto_showcase_suffix_text"
				min:SetTextColor(Color(255, 255, 255))
				min:SetRenderSystem(pluto.fonts.systems.shadow)
				min:SizeToContentsX()
				min:Dock(LEFT)
				min:SetContentAlignment(5)
				min:SetTextColor((statdata.Colorize or TextColorizer)(statdata.Value))
				min:DockMargin(0, 0, 4, 0)
				stat:SetWide(stat:GetWide() + min:GetWide())
			end
		end

		finalizeline(true)

		local class = baseclass.Get(self.Item.ClassName)

		if (self.LastControlState and pluto.inv.itemtype(self.Item) == "Weapon" and (class.Slot == 1 or class.Slot == 2)) then
			self.StatArea:SetTall(self.StatArea:GetRealTall() + 9)
		end
		self:SetTall(self:GetTall() + self.StatArea:GetTall() + 11)
	end
end

DEFINE_BASECLASS "ttt_curved_panel"

function PANEL:Paint(w, h)
	BaseClass.Paint(self, w, h)

	surface.SetDrawColor(38, 38, 38)
	ttt.DrawCurvedRect(1, 1, w - 2, h - 2, self:GetCurve() / 2)
	
	surface.SetDrawColor(36, 36, 36)
	local scrx, scry = self:LocalToScreen(1, 1)
	local scrx2, scry2 = self:LocalToScreen(w - 1, h - 1)
	render.SetScissorRect(scrx, scry, scrx2, scry2, true)
	local step = 11
	for y = 0, h + w + step, step do
		surface.DrawLine(1, y, w - 2, y - w - 2)
	end
	render.SetScissorRect(scrx, scry, scrx2, scry2, false)
end

vgui.Register("pluto_showcase_weapon", PANEL, "ttt_curved_panel")