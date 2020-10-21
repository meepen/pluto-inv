pluto.quests = pluto.quests or {}
pluto.quests.cache = pluto.quests.cache or {}

function pluto.inv.readquest()
	local id = net.ReadUInt(32)

	local quest = pluto.quests.cache[id] or {}

	pluto.quests.cache[id] = quest

	quest.ID = id

	quest.Name = net.ReadString()
	quest.Description = net.ReadString()
	quest.Color = net.ReadColor()
	quest.Tier = net.ReadUInt(8)
	if (net.ReadBool()) then
		quest.Credits = net.ReadString()
	end

	quest.Reward = net.ReadString()

	quest.EndTime = os.time() + net.ReadInt(32)
	quest.ProgressLeft = net.ReadUInt(32)
	quest.TotalProgress = net.ReadUInt(32)

	return quest
end

function pluto.inv.readquests()
	local quests = {}
	while (net.ReadBool()) do
		quests[#quests + 1] = pluto.inv.readquest()
	end

	pluto.quests.current = quests

	hook.Run("PlutoUpdateQuests", quests)
end

surface.CreateFont("pluto_quest_title", {
	font = "Lato",
	size = math.max(24, ScrH() / 80),
	weight = 400
})

surface.CreateFont("pluto_quest_desc", {
	font = "Roboto",
	size = math.max(8, ScrH() / 160) * 2,
	weight = 0,
})

surface.CreateFont("pluto_quest_progress", {
	font = "Roboto",
	size = math.max(16, ScrH() / 80),
	weight = 0
})

surface.CreateFont("pluto_quest_reward", {
	font = "Roboto",
	size = math.max(14, ScrH() / 100),
	weight = 200,
	italic = true,
})

local PANEL = {}

function PANEL:Init()
	self:DockPadding(10, 10, 10, 10)
	self:SetCurve(4)
	self:SetColor(Color(25, 25, 26))

	self:SetTall(200)

	self.Left = self:Add "EditablePanel"
	self.Left:Dock(FILL)

	self.Right = self:Add "EditablePanel"
	self.Right:Dock(RIGHT)

	self.Bottom = self:Add "ttt_curved_panel"
	self.Bottom:Dock(BOTTOM)
	self.Bottom:SetColor(Color(43, 43, 44))
	self.Bottom:SetTall(20)
	self.Bottom:SetCurve(4)

	self.Overlay = self.Bottom:Add "ttt_curved_panel"
	self.Overlay:Dock(FILL)
	self.Overlay:SetCurve(self.Bottom:GetCurve())

	self.Overlay.Scissor = function(s)
		local frac = 1

		if (self.Quest) then
			local q = self.Quest
			frac = (q.TotalProgress - q.ProgressLeft) / q.TotalProgress
		end

		local x0, y0, x1, y1 = s:GetRenderBounds()
		local w = math.min(x1 - x0, s:GetWide() * frac)
		render.SetScissorRect(x0, y0, x0 + w, y1, true)
	end

	self.OverlayText = self.Overlay:Add "EditablePanel"
	self.OverlayText:Dock(FILL)

	self.OverlayText.Paint = function(s, w, h)
		local q = self.Quest
		local t = ""
		if (q) then
			if (q.ProgressLeft == 0) then
				t = string.format("Complete!", q.TotalProgress)
			else
				t = string.format("%i / %i", q.TotalProgress - q.ProgressLeft, q.TotalProgress)
			end
		end
		draw.SimpleTextOutlined(t, "pluto_quest_reward", w / 2, h / 2, white_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
	end

	self.RewardText = self:Add "DLabel"
	self.RewardText:Dock(BOTTOM)
	self.RewardText:SetTall(20)
	self.RewardText:SetContentAlignment(3)
	self.RewardText:SetFont "pluto_quest_reward"
	self.RewardText:SetTextColor(white_text)

	self.Bottom:SetZPos(1)
	self.Right:SetZPos(2)
	self.Left:SetZPos(3)

	self.QuestName = self.Left:Add "DLabel"
	self.QuestName:Dock(TOP)
	self.QuestName:SetFont "pluto_quest_title"
	self.QuestName:DockMargin(0, 0, 0, 6)
	self.QuestName:SetTextColor(white_text)

	self.Description = self.Left:Add "DLabel"
	self.Description:Dock(TOP)
	self.Description:SetFont "pluto_quest_desc"
	self.Description:SetWrap(true)
	self.Description:SetAutoStretchVertical(true)
	self.Description:DockMargin(0, 0, 0, 6)
	self.Description:SetTextColor(white_text)

	self.Remaining = self.Right:Add "DLabel"
	self.Remaining:Dock(TOP)
	self.Remaining:SetFont "pluto_quest_reward"
	self.Remaining:SetText "REMAIN"
	self.Remaining:SetContentAlignment(9)
	self.Remaining:SetTextColor(Color(70, 77, 77))

	self.Remaining.Think = function(s)
		local q = self.Quest
		local t = ""
		if (q) then
			local left = q.EndTime - os.time()
			if (left >= 1) then
				for _, what in ipairs {
					{
						Abbreviation = "s",
						Interval = 1,
						Name = "Second",
					},
					{
						Abbreviation = "m",
						Interval = 60,
						Name = "Minute",
					},
					{
						Abbreviation = "h",
						Interval = 60 * 60,
						Name = "Hour",
					},
					{
						Abbreviation = "d",
						Interval = 60 * 60 * 24,
						Name = "Day",
					},
					{
						Abbreviation = "w",
						Interval = 60 * 60 * 24 * 7,
						Name = "Week",
					}
				} do
					local amount = left / what.Interval
					if (amount >= 1) then
						t = string.format("%i %s", amount, what.Name) .. (amount < 2 and "  " or "s  ")
					end
				end
			else
				t = "Expired"
			end
		end
		s:SetText(t)
	end

	self.Description.OnSizeChanged = function()
		self:Resize()
	end

	self:DockMargin(0, 0, 0, 10)
end

function PANEL:Resize()
	local _, h = self:GetChildPosition(self.Description)
	h = h + self.Description:GetTall() + 6 + self.Bottom:GetTall() + self.RewardText:GetTall() + 12

	self:SetTall(h)
	
	self.Right:SetWide(self:GetWide() / 4)
end

function PANEL:SetQuest(quest)
	self.Quest = quest
	self.QuestName:SetText(quest.Name)
	self.Description:SetText(quest.Description)
	self.RewardText:SetText("Reward: " .. (startswithvowel(quest.Reward) and "An " or "A ") .. quest.Reward .. "  ")


	self.QuestName:SetTextColor(quest.Color)
	self.Overlay:SetColor(quest.Color)

	self:Resize()
end

function PANEL:Think()
	-- self.TimeRemaining:SetText()
end

vgui.Register("pluto_quest_item", PANEL, "ttt_curved_panel")

local PANEL = {}
DEFINE_BASECLASS "pluto_inventory_base"

function PANEL:Init()
	BaseClass.Init(self)

	local lp = LocalPlayer()
	if (IsValid(lp) and lp:GetNWString "pluto_questban" ~= "") then
		self.BanMessage = self:Add "DLabel"
		self.BanMessage:SetFont "BudgetLabel"
		self.BanMessage:SetText("You are quest banned: " .. lp:GetNWString "pluto_questban")
		self.BanMessage:Dock(FILL)
		self.BanMessage:SetContentAlignment(5)
		self.BanMessage:SetZPos(2)
		self.Image = self:Add "DHTML"
		self.Image:OpenURL "https://cdn.discordapp.com/emojis/624900639171805200.gif"
		self.Image:Dock(FILL)
		self.Image:SetZPos(1)
		self.Image:DockMargin(30, 30, 30, 30)
		return
	end

	self.List = self:Add "DCategoryList"
	self.List:Dock(FILL)
	self.List:SetSkin "tttrw"

	self.Categories = {}

	for i = 0, #pluto.quests.types do
		local type = pluto.quests.types[i]
		self.Categories[i] = {
			Panel = self.List:Add(type.Name),
			Contents = vgui.Create "EditablePanel"
		}

		self.Categories[i].Panel.Header:SetFont "pluto_quest_title"
		self.Categories[i].Panel.Header:SetContentAlignment(5)
		self.Categories[i].Panel.Header.UpdateColours = function() end
		self.Categories[i].Panel.Header:SetTextColor(type.Color or white_text)
		self.Categories[i].Panel.Header:SetTall(select(2, self.Categories[i].Panel.Header:GetTextSize()) + 2)

		self.Categories[i].Panel:SetContents(self.Categories[i].Contents)
		self.Categories[i].Panel:DockMargin(0, 0, 0, 3)
		self.Categories[i].Panel:DockPadding(0, 1, 0, 2)

		self.Categories[i].Contents:DockMargin(0, 4, 0, 0)
	end

	self.Quests = {}
	self:RefreshQuests()

	self:DockPadding(16, 20, 16, 20)

	hook.Add("PlutoUpdateQuests", self, self.RefreshQuests)
end

function PANEL:RefreshQuests()
	local needed = {}

	for _, quest in pairs(pluto.quests.current) do
		needed[quest.ID] = quest
	end

	for _, pnl in pairs(self.Quests) do
		if (not IsValid(pnl) or not pnl.Quest) then
			continue
		end

		local quest = pnl.Quest
		print(pnl)
		if (not needed[quest.ID]) then
			pnl:Remove()
		else
			needed[quest.ID] = nil
		end
	end

	for _, quest in pairs(needed) do
		local pnl = self.Categories[quest.Tier].Contents:Add "pluto_quest_item"
		pnl:Dock(TOP)
		pnl:SetQuest(quest)
		self.Quests[quest.ID] = pnl
	end
end

function PANEL:SetTab()
end

vgui.Register("pluto_quest", PANEL, "pluto_inventory_base")