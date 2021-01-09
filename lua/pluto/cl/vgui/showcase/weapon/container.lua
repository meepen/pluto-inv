local PANEL = {}

function PANEL:Init()
	self:SetColor(Color(84, 86, 90, 255))
	self:SetSize(315, 61)
	self:SetCurve(4)
	self:DockPadding(1, 1, 1, 1)

	self.NameContainer = self:Add "ttt_curved_panel"
	self.NameContainer:Dock(TOP)
	self.NameContainer:SetTall(28)
	self.NameContainer:SetCurveBottomLeft(false)
	self.NameContainer:SetCurveBottomRight(false)
	self.NameContainer:SetCurve(4)

	self.NameLabel = self.NameContainer:Add "pluto_label"
	self.NameLabel:SetRenderSystem(pluto.fonts.systems.shadow)
	self.NameLabel:SetFont "pluto_showcase_name"
	self.NameLabel:SetTextColor(Color(255, 255, 255))
	self.NameLabel:SetText "TEST"
	self.NameLabel:Dock(FILL)
	self.NameLabel:SetContentAlignment(5)

	self.NameSeperator = self.NameContainer:Add "EditablePanel"
	self.NameSeperator:SetTall(1)
	self.NameSeperator:Dock(BOTTOM)
	AccessorFunc(self.NameSeperator, "Color", "Color")
	function self.NameSeperator:Paint(w, h)
		surface.SetDrawColor(self:GetColor())
		surface.DrawRect(0, 0, w, h)
	end

	self.InfoContainer = self:Add "ttt_curved_panel"
	self.InfoContainer:Dock(FILL)
	self.InfoContainer:SetCurve(4)
	self.InfoContainer:SetColor(Color(38, 38, 38))
	self.InfoContainer:SetCurveTopRight(false)
	self.InfoContainer:SetCurveTopLeft(false)
	self.InfoContainer:DockPadding(7, 0, 7, 0)

	self.BottomLine = self.InfoContainer:Add "EditablePanel"
	self.BottomLine:Dock(BOTTOM)
	self.BottomLine:SetTall(18)
	self.TopLine = self.InfoContainer:Add "EditablePanel"
	self.TopLine:Dock(BOTTOM)
	self.TopLine:SetTall(10)

	self.IDLabel = self.TopLine:Add "pluto_label"
	self.IDLabel:SetFont "pluto_showcase_small"
	self.IDLabel:SetRenderSystem(pluto.fonts.systems.shadow)
	self.IDLabel:SetTextColor(Color(174, 174, 174))
	self.IDLabel:SetText ""
	self.IDLabel:Dock(RIGHT)
	self.IDLabel:SizeToContentsX()
	self.IDLabel:SetContentAlignment(5)

	self.ModLabel = self.TopLine:Add "pluto_label"
	self.ModLabel:SetFont "pluto_showcase_small"
	self.ModLabel:SetRenderSystem(pluto.fonts.systems.shadow)
	self.ModLabel:SetTextColor(Color(174, 174, 174))
	self.ModLabel:SetText ""
	self.ModLabel:Dock(LEFT)
	self.ModLabel:SizeToContentsX()
	self.ModLabel:SetContentAlignment(5)

	self.CreatedLabel = self.BottomLine:Add "pluto_label"
	self.CreatedLabel:SetFont "pluto_showcase_small"
	self.CreatedLabel:SetRenderSystem(pluto.fonts.systems.shadow)
	self.CreatedLabel:SetTextColor(Color(174, 174, 174))
	self.CreatedLabel:SetText ""
	self.CreatedLabel:Dock(RIGHT)
	self.CreatedLabel:SizeToContentsX()
	self.CreatedLabel:SetContentAlignment(5)

	self.EXPLabel = self.BottomLine:Add "pluto_label"
	self.EXPLabel:SetFont "pluto_showcase_small"
	self.EXPLabel:SetRenderSystem(pluto.fonts.systems.shadow)
	self.EXPLabel:SetTextColor(Color(174, 174, 174))
	self.EXPLabel:SetText ""
	self.EXPLabel:Dock(LEFT)
	self.EXPLabel:SizeToContentsX()
	self.EXPLabel:SetContentAlignment(5)

	self.ModContainer = self:Add "EditablePanel"
	self.ModContainer:Dock(TOP)
	self.ModContainer:SetTall(0)


	function self.ModContainer:Paint(w, h)
		surface.SetDrawColor(30, 30, 30)
		surface.DrawRect(0, 0, w, h - 1)
		surface.SetDrawColor(20, 20, 20)
		surface.DrawRect(0, h - 1, w, 1)
	end


	self:MakePopup()
	self:SetKeyboardInputEnabled(false)
	self:SetMouseInputEnabled(false)
end

function PANEL:AddPrefix(prefix, item)
	local MOD = pluto.mods.byname[prefix.Mod]
	local added_size = 0
	if (not self.HasPrefix) then
		self.ModContainer:DockPadding(7, 12, 7, 12)
		added_size = added_size + 24
	end
	self.HasPrefix = true

	local container = self.ModContainer:Add "EditablePanel"
	container:SetTall(28)
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

	local bar = container:Add "pluto_showcase_bar"
	bar:Dock(FILL)
	local rolls = pluto.mods.getrolls(MOD, prefix.Tier, prefix.Roll)
	bar:AddFilling(0.35, pluto.mods.getstatvalue(baseclass.Get(item.ClassName), MOD.StatModifier), Color(128, 128, 120)) -- MOD:FormatModifier(1, rolls[1])
	local left = 1 - 0.35 - 0.2
	local txt = MOD:FormatModifier(1, rolls[1])
	local min, max = MOD:GetMinMax()
	local tier_min = 0.2 + left * (MOD.Tiers[prefix.Tier][1] - min) / (max - min)
	local cur_value = 0.2 + left * (rolls[1] - min) / (max - min)
	local tier_max = 0.2 + left * (MOD.Tiers[prefix.Tier][2] - min) / (max - min)

	bar:AddFilling(tier_min, "", Color(59, 200, 64))
	bar:AddFilling(cur_value - tier_min, txt:sub(1, 1) == "-" and txt or "+" .. txt, Color(59, 255, 64))
	bar:AddFilling(tier_max - cur_value, "", Color(169, 169, 169, 0))


	if (IsValid(self.LastAddedPrefix)) then
		self.LastAddedPrefix:DockMargin(0, 0, 0, 5)
		added_size = added_size + 5
	end
	self.LastAddedPrefix = container

	added_size = added_size + container:GetTall()

	self.ModContainer:SetTall(self.ModContainer:GetTall() + added_size)
	self:SetTall(self:GetTall() + added_size)
end

function PANEL:AddSuffix(suffix, item)
	local MOD = pluto.mods.byname[suffix.Mod]
	local fmt = pluto.mods.format(suffix, item)
	local minmaxs = pluto.mods.getminmaxs(suffix, item)

	for i = 1, #fmt do
		fmt[i] = string.format("%s (%s to %s)", fmt[i], minmaxs[i].Mins, minmaxs[i].Maxs)
	end

	local size = 0

	if (self.HasSuffix) then
		local seperator = self.InfoContainer:Add "EditablePanel"
		seperator:SetTall(1)
		seperator:Dock(TOP)
		seperator:DockMargin(0, 8, 0, 0)
		function seperator:Paint(w, h)
			surface.SetDrawColor(104, 104, 104)
			surface.DrawRect(0.2 * w, 0, w * 0.6, h)
		end

		size = size + 9
	else
		self.TopLine:DockMargin(0, 13, 0, 0)
		size = size + 13
	end

	local modname = self.InfoContainer:Add "pluto_label"
	modname:Dock(TOP)
	modname:SetFont "pluto_showcase_suffix_text"
	modname:SetTextColor(MOD.Color or Color(222, 111, 3))
	modname:SetRenderSystem(pluto.fonts.systems.shadow)
	modname:SetContentAlignment(5)
	modname:SetText(MOD:GetTierName(suffix.Tier))
	modname:SizeToContentsY(2)
	if (self.HasSuffix) then
		modname:DockMargin(0, 5, 0, 5)
		size = size + 10
	else
		modname:DockMargin(0, 10, 0, 5)
		size = size + 10
	end

	local curtext
	local desc = pluto.mods.formatdescription(suffix, item, fmt)
	surface.SetFont "pluto_showcase_suffix_text"

	local function addtext()
		local modtext = self.InfoContainer:Add "pluto_label"
		modtext:Dock(TOP)
		modtext:SetFont "pluto_showcase_suffix_text"
		modtext:SetTextColor(Color(255, 255, 255))
		modtext:SetRenderSystem(pluto.fonts.systems.shadow)
		modtext:SetContentAlignment(5)
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

function PANEL:SetItem(item)
	self.NameContainer:SetColor(item:GetColor())
	
	local h, s, v = ColorToHSV(item:GetColor())
	local col = HSVToColor(
		h,
		math.max(0, s - 0.13),
		math.max(0, v + 0.1)
	)

	self.NameSeperator:SetColor(col)

	self.NameLabel:SetText(item:GetPrintName())

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
		for type, tbl in pairs(item.Mods) do
			if (type == "implicit") then
				continue
			end

			num_mods = num_mods + #tbl
		end
		self.ModLabel:SetText(num_mods .. " / " .. item:GetMaxAffixes() .. " mods")
		self.ModLabel:SizeToContentsX()
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
			BOUGHT = "Bought in the Divine Shop by %s",
		})[item.CreationMethod] or item.CreationMethod .. " %s"
		self.CreatedLabel:SetText(fmt:format(item.OriginalOwnerName))
		self.CreatedLabel:SizeToContentsX()
	end

	if (item.Mods) then
		for _, suffix in ipairs(item.Mods.suffix) do
			self:AddSuffix(suffix, item)
		end
		for _, prefix in ipairs(item.Mods.prefix) do
			self:AddPrefix(prefix, item)
		end
	end
end

vgui.Register("pluto_showcase_weapon", PANEL, "ttt_curved_panel")