local PANEL = {}

function PANEL:Init()
	local canvas = self:GetCanvas()

	self.PlayerModelContainer = canvas:Add "EditablePanel"
	self.PlayerModelContainer:Dock(FILL)
	self.PlayerModel = self.PlayerModelContainer:Add "pluto_inventory_playermodel"

	function self.PlayerModelContainer.PerformLayout(s, w, h)
		self.PlayerModel:SetSize(math.min(w, h), math.min(w, h))
		self.PlayerModel:Center()
	end

	self:SetSize(300, 350)

	self:MakePopup()
	self:SetKeyboardInputEnabled(false)
	self:SetMouseInputEnabled(false)

	self.BottomLine = canvas:Add "EditablePanel"
	self.BottomLine:Dock(BOTTOM)
	self.BottomLine:SetTall(18)
	self.BottomLine:DockMargin(7, 0, 7, 0)

	self.BottomLine2 = canvas:Add "EditablePanel"
	self.BottomLine2:Dock(BOTTOM)
	self.BottomLine2:SetTall(18)
	self.BottomLine2:DockMargin(7, 0, 7, 0)


	self.CreatedLabel = self.BottomLine:Add "pluto_label"
	self.CreatedLabel:SetFont "pluto_showcase_small"
	self.CreatedLabel:SetRenderSystem(pluto.fonts.systems.shadow)
	self.CreatedLabel:SetTextColor(pluto.ui.theme "TextActive")
	self.CreatedLabel:SetText ""
	self.CreatedLabel:Dock(RIGHT)
	self.CreatedLabel:SizeToContentsX()
	self.CreatedLabel:SetContentAlignment(5)

	self.IDLabel = self.BottomLine:Add "pluto_label"
	self.IDLabel:SetFont "pluto_showcase_small"
	self.IDLabel:SetRenderSystem(pluto.fonts.systems.shadow)
	self.IDLabel:SetTextColor(Color(174, 174, 174, 200))
	self.IDLabel:SetText ""
	self.IDLabel:Dock(LEFT)
	self.IDLabel:SizeToContentsX()
	self.IDLabel:SetContentAlignment(5)
	
	self.EXPLabel = self.BottomLine2:Add "pluto_label"
	self.EXPLabel:SetRenderSystem(pluto.fonts.systems.shadow)
	self.EXPLabel:SetFont "pluto_showcase_small"
	self.EXPLabel:SetTextColor(pluto.ui.theme "TextActive")
	self.EXPLabel:Dock(RIGHT)
	self.EXPLabel:SetContentAlignment(6)
	self.EXPLabel:SetTall(0)
	self.EXPLabel:SetText ""
	self.EXPLabel:SizeToContentsX()
end

function PANEL:SetItem(item)
	self.IDLabel:SetText(item.ID)
	self.IDLabel:SizeToContentsX()

	if (item.Experience) then
		self.EXPLabel:SetText("EXP: " .. item.Experience)
		self.EXPLabel:SizeToContentsX()
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


	self:InvalidateLayout(true)
	self:InvalidateChildren(true)
	self.NameContainer:SetColor(item.Model.Color)
	
	self.PlayerModel:SetPlutoModel(item.Model or pluto.models.default, item)
	self.Name:SetText(item:GetPrintName())

	local curline
	local text
	local curw = 0
	local function finalizeline()
		if (text == "") then
			return
		end

		local lbl = self:GetCanvas():Add "pluto_label"
		lbl:SetRenderSystem(pluto.fonts.systems.shadow)
		lbl:SetFont "pluto_showcase_xsmall"
		lbl:SetText(text)
		lbl:SetContentAlignment(5)
		lbl:Dock(TOP)
		lbl:SetTextColor(Color(255, 255, 255))
		lbl:SizeToContentsY()
		lbl:DockMargin(0, 2, 0, 0)

		first = false
	end
	local function createnewline()
		if (text) then
			finalizeline()
		end

		text = ""
		curw = 0
	end

	createnewline()

	local subdesc = item.Model.SubDescription or ""
	for _, splitpart in ipairs(subdesc:Split " ") do
		for part, newline in (splitpart .. " "):gmatch("([^\n]+)(.?)") do
			curw = curw + surface.GetTextSize(part)
			if (curw > self:GetWide() * 0.9) then
				createnewline()
			end

			text = text .. part

			if (newline == "\n" and text ~= "") then
				createnewline()
			end
		end
	end

	finalizeline()
end

vgui.Register("pluto_showcase_model", PANEL, "pluto_showcase_base")