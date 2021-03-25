local PANEL = {}

function PANEL:Init()
	self:SetCursor "hand"
	self:SetColor(Color(54, 54, 54))
	self:SetCurve(4)
	self.TextLabel = self:Add "pluto_label"
	self.TextLabel:SetText "Unknown"
	self.TextLabel:SetFont "pluto_inventory_font"
	self.TextLabel:SetTextColor(pluto.ui.theme "TextActive")
	self.TextLabel:SetContentAlignment(5)
	self.TextLabel:Dock(FILL)
	self.TextLabel:SetRenderSystem(pluto.fonts.systems.shadow)

	self.Options = {}
end

function PANEL:AddOption(name, fn)
	table.insert(self.Options, {
		Name = name,
		Func = fn
	})

	if (not self.CurrentOption) then
		self.TextLabel:SetText(name)
		self.CurrentOption = #self.Options
	end
end

function PANEL:ChooseOption(option)
	self.CurrentOption = option
	option = self.Options[option]
	self.TextLabel:SetText(option.Name)
	if (option.Func) then
		option.Func()
	end
end

function PANEL:OnMousePressed(m)
	if (m == MOUSE_LEFT) then
		self:DoClick()
	end
end

function PANEL:DoClick()
	self.Popover = vgui.Create "pluto_dropdown_popup"
	self.Popover:SetPos(2, 3)
	self.Popover:PopulateFrom(self)
	self.Popover:MakePopup()
	self.Popover:SetKeyboardInputEnabled(false)
end

function PANEL:OnRemove()
	if (IsValid(self.Popover)) then
		self.Popover:Remove()
	end
end

vgui.Register("pluto_dropdown", PANEL, "ttt_curved_panel")

local PANEL = {}

function PANEL:Init()
	self:SetColor(Color(54, 55, 61))
	self:DockPadding(1, 1, 1, 1)
	self.Inner = self:Add "ttt_curved_panel"
	self.Inner:SetColor(Color(85, 85, 85))
	self.Inner:Dock(FILL)

	self:SetCurve(4)
	self.Inner:SetCurve(4)

	self.HoveredPanel = self.Inner:Add "ttt_curved_panel"
	self.HoveredPanel:SetPos(0, 0)

	self.Choices = {}

	self:SetMouseInputEnabled(true)

	hook.Add("VGUIMousePressed", self, self.VGUIMousePressed)
end

function PANEL:PopulateFrom(original)
	self:SetWide(original:GetWide() + 2)
	self:SetTall(original:GetTall() * #original.Options + 2)

	local x, y = original:LocalToScreen(0, 0)
	self:SetPos(x - 1, y - 1)

	self.HoveredPanel:SetSize(original:GetSize())
	self.HoveredPanel:SetColor(original:GetColor())
	self.HoveredPanel:SetCurve(4)

	function self.HoveredPanel:Approach(x, y)
		self.ApproachPosition = {x, y}
	end

	local old_think = self.HoveredPanel.Think
	function self.HoveredPanel:Think()

		if (self.ApproachPosition) then
			local x, y
			if (self.RealPosition) then
				x, y = self.RealPosition[1], self.RealPosition[2]
			else
				x, y = self:GetPos()
			end
			
			local tox, toy = self.ApproachPosition[1], self.ApproachPosition[2]
			local dx, dy = tox - x, toy - y
			local speed
			local total_dist = math.sqrt(dx * dx + dy * dy)
			if (total_dist > 20) then
				speed = 500
			elseif (total_dist > 10) then
				speed = 200
			else
				speed = 150
			end
			self.RealPosition = {
				x + math.min(math.abs(dx), speed * FrameTime()) * (dx < 0 and -1 or 1),
				y + math.min(math.abs(dy), speed * FrameTime()) * (dy < 0 and -1 or 1),
			}
			self:SetPos(self.RealPosition[1], self.RealPosition[2])
		end


		if (old_think) then
			return old_think(self)
		end
	end

	self:SetCurveTopLeft(original:GetCurveTopLeft())
	self:SetCurveTopRight(original:GetCurveTopRight())
	self:SetCurveBottomLeft(original:GetCurveBottomLeft())
	self:SetCurveBottomRight(original:GetCurveBottomRight())

	for id, option in ipairs(original.Options) do
		local choice = self.Inner:Add "pluto_label"
		choice:SetText(option.Name)
		choice:SetTextColor(original.TextLabel:GetTextColor())
		choice:SetFont(original.TextLabel:GetFont())
		choice:SetContentAlignment(5)
		choice:Dock(TOP)
		choice:SetSize(original:GetSize())

		choice:SetCursor "hand"
		choice:SetMouseInputEnabled(true)
		choice.ID = id

		function choice.OnCursorEntered(s)
			self:ChoiceHovered(s)
		end

		function choice.OnMousePressed(s, m)
			if (m == MOUSE_LEFT) then
				self:ChoiceSelected(s)
			end
		end
	end

	self.Original = original
end

function PANEL:ChoiceHovered(what)
	self.HoveredPanel:Approach(what:GetPos())
end

function PANEL:ChoiceSelected(choice)
	self.Original:ChooseOption(choice.ID)
	self:Remove()
end

function PANEL:VGUIMousePressed(p, m)
	while (IsValid(p)) do
		if (p == self) then
			return
		end

		p = p:GetParent()
	end

	self:Remove()
end


vgui.Register("pluto_dropdown_popup", PANEL, "ttt_curved_panel")