function pluto.inv.writequeueevent(event)
	net.WriteString(event)
end

function pluto.inv.writegeteventqueue() end

local PANEL = {}

function PANEL:Init()
	self:Dock(FILL)
	self:InvalidateParent(true)

	self.Left = self:Add("pluto_inventory_component")
	self.Left:SetCurve(4)
	self.Left:Dock(LEFT)
	self.Left:SetColor(pluto.ui.theme("InnerColor"))
	self.Left:SetWide(self:GetWide()* .33)
	self.Left:InvalidateLayout(true)

	self.QueueLabel = self.Left:Add("pluto_label")
	self.QueueLabel:SetFont("pluto_inventory_font_xlg")
	self.QueueLabel:SetRenderSystem(pluto.fonts.systems.shadow)
	self.QueueLabel:SetTextColor(pluto.ui.theme "TextActive")
	self.QueueLabel:SetText("Queued Events")
	self.QueueLabel:SizeToContents()
	self.QueueLabel:Dock(TOP)
	self.QueueLabel:DockMargin(0, 12, 0, 12)

	self.QueuedEvents = self.Left:Add("DListView")
	self.QueuedEvents:Dock(FILL)
	self.QueuedEvents:InvalidateParent(true)
	self.QueuedEvents:SetMultiSelect(false)
	self.QueuedEvents:AddColumn("Name"):SetWidth(self.QueuedEvents:GetWide()*.6)
	self.QueuedEvents:AddColumn("Added By")
	self.QueuedEvents:SetSortable(false)

	self.Right = self:Add("pluto_inventory_component")
	self.Right:SetCurve(4)
	self.Right:Dock(FILL)
	self.Right:SetColor(pluto.ui.theme("InnerColor"))
	self.Right:DockMargin(12, 0, 0, 0)
	self.Right:InvalidateParent(true)
	
	self.EventList = self.Right:Add("DListView")
	self.EventList:Dock(RIGHT)
	self.EventList:SetWide(self.Right:GetWide()* .7)
	self.EventList:InvalidateParent(true)
	self.EventList:SetMultiSelect(false)

	local w = self.EventList:GetWide()
	self.EventList:AddColumn("Event Name"):SetWidth(w*.45)
	self.EventList:AddColumn("Players Needed"):SetWidth(w*.25)
	self.EventList:AddColumn("Type"):SetWidth(w*.2)
	self.EventList:AddColumn("Cost"):SetWidth(w*.1 + 1)
	-- hidden row 5 - event internal name
	self.EventList.OnRowSelected = function(_, rowIndex, row)
		self.QueueButton:SetEnabled(true)
		self.Selected = row:GetValue(5)
	end
	
	for k,v in pairs(pluto.rounds.infobyname) do
		if (v.NoBuy) then
			continue
		end

		local plycountmsg = "1 or more"
		if (v.MinPlayers) then
			if (v.MaxPlayers) then
				plycountmsg = string.format("%i - %i", v.MinPlayers, v.MaxPlayers)
			else
				plycountmsg = string.format("%i or more", v.MinPlayers)
			end
		elseif (v.MaxPlayers) then
			plycountmsg = string.format("1 - %i", v.MaxPlayers)
		end

		self.EventList:AddLine(v.PrintName, plycountmsg, v.Type, pluto.rounds.cost[v.Type] or 5, k)
	end
	
	self.EventList:SortByColumns(4, false, 1)
	self.EventList:SetSortable(false)

	self.SpacingContainer = self.Right:Add("EditablePanel")
	self.SpacingContainer:Dock(FILL)
	self.SpacingContainer:InvalidateParent(true)

	self.ButtonContainer = self.SpacingContainer:Add("EditablePanel")
	self.ButtonContainer:Dock(TOP)
	self.ButtonContainer:DockPadding(5, 5, 5, 5)
	self.ButtonContainer:InvalidateParent(true)

	self.QueueButton = self.ButtonContainer:Add("pluto_inventory_button")
	self.QueueButton:DockMargin(5, 10, 10, 10)
	self.QueueButton:Dock(FILL)
	self.QueueButton:SetColor(Color(41, 150, 39), Color(67, 195, 50))
	self.QueueButton:SetCurve(4)
	self.QueueButton:SetText("<---")
	self.QueueButton:SetEnabled(false)

	self.QueueButton.DoClick = function(_)
		self:QueueEvent(self.Selected)
		self.QueueButton:SetEnabled(false)
	end

	self.Currency = self.ButtonContainer:Add("pluto_inventory_currency_item")
	self.Currency:Dock(RIGHT)
	self.Currency:SetCurrency(pluto.currency.byname.ticket)
	self.ButtonContainer:SetTall(self.Currency:GetTall())
	self.Currency:InvalidateParent(true)

	self.SpacingContainer:DockMargin(0, self.SpacingContainer:GetTall()/2 - self.ButtonContainer:GetTall()/2, 0, 0)

	self.Selected = nil

	self:UpdateEvents()
end

function PANEL:UpdateEvents()
	pluto.inv.readeventqueue = function()
		if not IsValid(self) then return end

		self.QueuedEvents:Clear()

		local count = net.ReadInt(8)

		for i = 1, count do
			local x = net.ReadString()
			local y = net.ReadString()
			--self.QueuedEvents:AddLine(net.ReadString(), net.ReadString())
			x = pluto.rounds.infobyname[x] and pluto.rounds.infobyname[x].PrintName or x
			self.QueuedEvents:AddLine(x, y)
		end

		self.EventList:ClearSelection()
	end

	pluto.inv.message()
		:write("geteventqueue")
	:send()
end

function PANEL:QueueEvent(name)
	if (not name) then
		return
	end

	pluto.inv.message()
		:write("queueevent", name)
	:send()
end

vgui.Register("pluto_inventory_events", PANEL, "EditablePanel")