local PANEL = {}

function PANEL:Init()
	self:AddTab "Hourly"
	self:AddTab "Daily"
	self:AddTab "Weekly"
	self:AddTab "Unique"

	hook.Add("PlutoUpdateQuests", self, self.UpdateQuests)
	self:UpdateQuests()

	self.QuestList = {}
end

function PANEL:AddQuest(quest)
	local tabname = pluto.quests.bypool[quest.Tier].Name
	local tab = self:GetTab(tabname)
	if (not IsValid(tab)) then
		error("no tab " .. tabname)
	end
	
	local questpnl = tab:Add "pluto_inventory_quest"
	questpnl:Dock(TOP)
	questpnl:DockMargin(0, 0, 0, 4)
	questpnl:SetQuestOnLayout(quest)
end

function PANEL:UpdateQuests()
	for _, quest in ipairs(pluto.quests.current) do
		self:AddQuest(quest)
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

	self.Description = self.Inner:Add "pluto_text"
	self.Description:Dock(TOP)
	self.Description:SetDefaultTextColor(Color(255, 255, 255))
	self.Description:SetDefaultRenderSystem(pluto.fonts.systems.shadow)
	self.Description:SetDefaultFont "pluto_inventory_font"
	self.Description:SetTall(100)
	self.Description:SetMouseInputEnabled(false)
end

function PANEL:SetQuestOnLayout(quest)
	self.LayoutQuest = quest
end

function PANEL:PerformLayout(w, h)
	timer.Simple(0, function()
		if (not IsValid(self)) then
			return
		end
		if (not self.LayoutQuest) then
			return
		end
		self:SetQuest(self.LayoutQuest)
		self.LayoutQuest = nil
	end)
end

function PANEL:SetQuest(quest)
	self.Name:SetText(quest.Name)
	self.Name:SetTextColor(quest.Color)

	self.Description:AppendText(quest.Description .. "\n")
	self.Description:SizeToContentsY()
end

vgui.Register("pluto_inventory_quest", PANEL, "ttt_curved_panel")