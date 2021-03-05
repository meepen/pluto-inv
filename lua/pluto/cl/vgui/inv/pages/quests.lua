local last_active_tab = CreateConVar("pluto_last_quest_tab", "", FCVAR_ARCHIVE)

local PANEL = {}

function PANEL:Init()
	local quests = table.Copy(pluto.quests.types)
	table.insert(quests, quests[1])
	table.remove(quests, 1)
	for _, quest in ipairs(quests) do
		self:AddTab(quest.Name, function()
			last_active_tab:SetString(quest.Name)
		end, quest.Color)
	end

	self:SelectTab(last_active_tab:GetString())

	self.QuestList = {}
	self.TabScrolls = {}

	hook.Add("PlutoActiveQuestsUpdated", self, self.PlutoActiveQuestsUpdated)
	self:PlutoActiveQuestsUpdated()
end

function PANEL:GetTabScroll(name)
	if (self.TabScrolls[name]) then
		return self.TabScrolls[name]
	end

	local scroll = self:GetTab(name):Add "DScrollPanel"
	self.TabScrolls[name] = scroll
	scroll:Dock(FILL)

	return scroll
end

function PANEL:AddQuest(quest)
	local tabname = pluto.quests.bypool[quest.Tier].Name
	local tab = self:GetTab(tabname)
	if (not IsValid(tab)) then
		error("no tab " .. tabname)
	end

	local scroll = self:GetTabScroll(tabname)

	local questpnl = self.QuestList[quest.ID]
	if (not IsValid(questpnl)) then
		questpnl = scroll:Add "pluto_inventory_quest"
		questpnl:Dock(TOP)
		questpnl:DockMargin(0, 0, 0, 4)
		self.QuestList[quest.ID] = questpnl
	end

	questpnl:SetQuestOnLayout(quest)
	questpnl:InvalidateLayout()
end

function PANEL:PlutoActiveQuestsUpdated()
	local currentlyhave = {}
	for _, quest in ipairs(pluto.quests.current) do
		self:AddQuest(quest)
		currentlyhave[quest.ID] = true
	end

	for id, pnl in pairs(self.QuestList) do
		if (not currentlyhave[id]) then
			pnl:Remove()
			self.QuestList[id] = nil
		end
	end
end

vgui.Register("pluto_inventory_quests", PANEL, "pluto_inventory_component_tabbed")

local PANEL = {}

function PANEL:Init()
	self:SetTall(100)
	self:SetCurve(4)
	self:SetColor(Color(95, 96, 102))
	self.Inner = self:Add "ttt_curved_panel"
	self.Inner:Dock(FILL)
	self:DockPadding(1, 1, 1, 1)
	self.Inner:SetColor(Color(53, 53, 60))
	self.Inner:SetCurve(2)
	self.Inner:DockPadding(4, 3, 4, 3)


	self.TopLine = self.Inner:Add "EditablePanel"
	self.TopLine:Dock(TOP)

	self.Name = self.TopLine:Add "pluto_label"
	self.Name:Dock(FILL)
	self.Name:SetText "HI"
	self.Name:SetTextColor(Color(255, 255, 255))
	self.Name:SetRenderSystem(pluto.fonts.systems.shadow)
	self.Name:SetFont "pluto_inventory_font_xlg"
	self.Name:SetContentAlignment(4)

	self.Name:SizeToContentsY()

	self.TopLine:SetTall(self.Name:GetTall())

	self.FavoriteButton = self.TopLine:Add "ttt_curved_panel_outline"
	self.FavoriteButton:SetCurve(2)
	self.FavoriteButton:SetColor(Color(95, 96, 102))
	self.FavoriteButton:Dock(RIGHT)
	self.FavoriteButton:SetWide(self.TopLine:GetTall())
	self.FavoriteButton:SetCursor "hand"

	self.FavoriteButton.Image = self.FavoriteButton:Add "DImage"
	self.FavoriteButton.Image:Dock(FILL)
	self.FavoriteButton.Image:DockMargin(1, 1, 1, 1)

	AccessorFunc(self.FavoriteButton, "Toggled", "Toggled")

	function self.FavoriteButton:OnMousePressed(m)
		self:SetToggled(not self:GetToggled())

		self:UpdateImage()
	end

	function self.FavoriteButton:OnCursorEntered()
		self.Image:SetAlpha(128)
		self.Image:SetVisible(true)
		self.Image:SetImage(self:GetToggled() and "icon16/heart_delete.png" or "icon16/heart_add.png")
	end
	function self.FavoriteButton:OnCursorExited()
		self:UpdateImage()
	end

	function self.FavoriteButton:UpdateImage()
		self.Image:SetAlpha(255)
		if (self:GetToggled()) then
			self.Image:SetVisible(true)
			self.Image:SetImage "icon16/heart.png"
		else
			self.Image:SetVisible(false)
		end
	end

	self.FavoriteButton:UpdateImage()

	self.Description = self.Inner:Add "pluto_text_inner"
	self.Description:Dock(TOP)
	self.Description:SetDefaultTextColor(Color(255, 255, 255))
	self.Description:SetDefaultRenderSystem(pluto.fonts.systems.shadow)
	self.Description:SetDefaultFont "pluto_inventory_font"
	self.Description:SetTall(100)
	self.Description:SetMouseInputEnabled(false)
	self.Description:DockMargin(0, 0, 0, 9)

	self.Progression = self.Inner:Add "ttt_curved_panel"
	self.Progression:Dock(TOP)
	self.Progression:SetTall(13)
	self.Progression:SetCurve(4)
	self.Progression:SetColor(Color(87, 88, 94))
	self.Progression:DockPadding(1, 1, 1, 1)
	self.Progression:DockMargin(12, 0, 12, 9)

	function self.Progression.PaintOver(s, w, h)
		local surface = pluto.fonts.systems.shadow
		surface.SetFont "pluto_inventory_font"
		local text = "UNKNOWN"
		if (self.Quest) then
			local quest = self.Quest
			local quest_progress = quest.TotalProgress - quest.ProgressLeft
			text = string.format("%i / %i", quest_progress, quest.TotalProgress)

			local pct = quest_progress / quest.TotalProgress

			surface.SetDrawColor(106, 123, 219)
			ttt.DrawCurvedRect(0, 0, w * pct, h, self:GetCurve())
			surface.SetDrawColor(109, 147, 232)
			ttt.DrawCurvedRect(1, 1, w * pct - 2, h, self:GetCurve() / 2)
		end
		local tw, th = surface.GetTextSize(text)
		surface.SetTextPos(w / 2 - tw / 2, h / 2 - th / 2 + 1)
		surface.SetTextColor(255, 255, 255, 255)
		surface.DrawText(text)
	end

	local inner = self.Progression:Add "ttt_curved_panel"
	inner:Dock(FILL)
	inner:SetCurve(self.Progression:GetCurve() / 2)
	inner:SetColor(Color(38, 38, 38))


	self.BottomLine = self.Inner:Add "EditablePanel"
	self.BottomLine:Dock(TOP)

	self.RewardText = self.BottomLine:Add "pluto_label"
	self.RewardText:Dock(RIGHT)
	self.RewardText:SetText "Reward text"
	self.RewardText:SetTextColor(Color(255, 255, 255))
	self.RewardText:SetRenderSystem(pluto.fonts.systems.shadow)
	self.RewardText:SetFont "pluto_inventory_font"
	self.RewardText:SetContentAlignment(5)
	self.RewardText:SizeToContents()

	self.TimeRemaining = self.BottomLine:Add "pluto_label"
	self.TimeRemaining:Dock(FILL)
	self.TimeRemaining:SetText ""
	self.TimeRemaining:SetTextColor(Color(128, 128, 128))
	self.TimeRemaining:SetRenderSystem(pluto.fonts.systems.shadow)
	self.TimeRemaining:SetFont "pluto_inventory_font"
	self.TimeRemaining:SetContentAlignment(4)
	self.TimeRemaining:SizeToContents()

	self.BottomLine:SetTall(self.RewardText:GetTall())

	hook.Add("PlutoQuestUpdated", self, self.PlutoQuestUpdated)
end

function PANEL:PlutoQuestUpdated(quest)
	if (quest == self.Quest) then
		self:SetQuestOnLayout(quest)
		self:InvalidateLayout()
	end
end

function PANEL:SetQuestOnLayout(quest)
	self.LayoutQuest = quest
end

function PANEL:PerformLayout(w, h)
	-- HACK(meep): why??
	timer.Simple(0, function()
		if (not IsValid(self)) then
			return
		end
		if (not self.LayoutQuest) then
			return
		end
		local q = self.LayoutQuest
		self.LayoutQuest = nil
		self:SetQuest(q)
	end)
end

function PANEL:SetQuest(quest)
	self.Quest = quest
	self.Name:SetText(quest.Name)
	self.Name:SetTextColor(quest.Color)

	if (not self.HasSet) then
		self.Description:AppendText(quest.Description .. "\n")
		self.Description:SizeToContentsY()
		self.HasSet = true
	end

	self.RewardText:SetText("Reward: " .. quest.Reward)
	self.RewardText:SizeToContentsX()
	self:SetTall(3 + self.TopLine:GetTall() + self.Description:GetTall() + 9 + self.Progression:GetTall() + 9 + self.BottomLine:GetTall() + 6)
end

function PANEL:Think()
	if (not self.Quest) then
		return
	end

	local time_remaining = self.Quest.EndTime - os.time()

	self.TimeRemaining:SetText(admin.nicetimeshort(time_remaining))
end

vgui.Register("pluto_inventory_quest", PANEL, "ttt_curved_panel")