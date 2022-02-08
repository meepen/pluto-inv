--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
local PANEL = {}

function PANEL:Init()
	local canvas = self:GetCanvas()

	self:SetSize(300, 150)

	self:MakePopup()
	self:SetKeyboardInputEnabled(false)
	self:SetMouseInputEnabled(false)

	self.Description = canvas:Add "pluto_label"
	self.Description:SetRenderSystem(pluto.fonts.systems.shadow)
	self.Description:SetFont "pluto_showcase_small"
	self.Description:SetText(text)
	self.Description:SetContentAlignment(5)
	self.Description:Dock(TOP)
	self.Description:SetTextColor(Color(255, 255, 255))
	self.Description:SetText "HI"
	self.Description:SizeToContentsY()
	self.Description:DockMargin(0, 2, 0, 0)

	self.TextContainer = canvas:Add "EditablePanel"
	self.TextContainer:Dock(TOP)
	function self.TextContainer.PerformLayout(_, w, h)
		self.Text:SetWide(w)
	end
	self.TextContainer.Position = 0
	self.TextContainer.GoingDown = true

	function self.TextContainer.Think(s)
		local height = s:GetTall()
		local oheight = self.Text:GetTall()
		if (height < oheight) then
			local from, target = s.Position, s.GoingDown and height - oheight or 0
			s.Position = math.Clamp(from + (target > from and 1 or -1) * FrameTime() * 30, height - oheight, 0)
			if (s.Position == 0 or s.Position == height - oheight) then
				s.GoingDown = not s.GoingDown
			end
			self.Text:SetPos(0, s.Position)
		end
	end

	self.Text = self.TextContainer:Add "pluto_text_inner"
	self.Text:SetShouldCenterText(true)
	self.Text:SetDefaultFont "pluto_inventory_font_s"
	self.Text:SetDefaultTextColor(Color(255, 255, 255))
	self.Text:SetDefaultRenderSystem(pluto.fonts.systems.shadow)
end

function PANEL:SetItem(item)
	self:InvalidateLayout(true)
	for _, child in pairs(self:GetCanvas():GetChildren()) do
		child:InvalidateParent(true)
		child:InvalidateLayout(true)
	end
	self.NameContainer:SetColor(item:GetColor())
	self.Name:SetText(item:GetPrintName())


	if (item.Contents) then
		local total_shares = 0
		local list = {}
		for name, data in pairs(item.Contents) do
			local fake = setmetatable({Type = pluto.inv.itemtype(name), ClassName = name}, pluto.inv.item_mt)
			if (fake.Type == "Weapon") then
				fake.Tier = pluto.tiers.byname[istable(data) and data.Tier or item.DefaultTier or "unique"]
			elseif (fake.Type == "Model") then
				fake.Model = pluto.models[name:match "model_(.+)"]
			end
			table.insert(list, {
				Color = fake:GetColor(),
				Name = fake:GetPrintName(),
				Shares = istable(data) and data.Shares or data
			})
			total_shares = total_shares + (istable(data) and data.Shares or data)
		end

		table.sort(list, function(a, b)
			return a.Shares < b.Shares
		end)

		for i, item in ipairs(list) do
			self.Text:AppendText(item.Color, item.Name)
			self.Text:SetCurrentTextColor()
			self.Text:AppendText(" (" .. string.format("%.02f%%", item.Shares / total_shares * 100) .. ")\n")
		end
		self.Text:SizeToContentsY()
		self.TextContainer:SetTall(math.min(150, self.Text:GetTall()))
	else
		self.TextContainer:Remove()
		self:SetTall(150)
	end
	
	if (item.Description) then
		self.Description:SetText(item.Description)
	end


	if (item.SubDescription) then
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

		local subdesc = item.SubDescription
		for _, splitpart in ipairs(subdesc:Split " ") do
			for part, newline in (splitpart .. " "):gmatch("([^\n]+)(.?)") do
				curw = curw + surface.GetTextSize(part)
				if (curw > self:GetCanvas():GetWide() * 0.9) then
					createnewline()
				end

				text = text .. part

				if (newline == "\n" and text ~= "") then
					createnewline()
				end
			end
		end
		finalizeline()

		self.Text:SetScrollOffset(0) -- hack to enable centering lol
	end

	self.Currency = item

	self:InvalidateLayout(true)
	for _, child in pairs(self:GetCanvas():GetChildren()) do
		child:InvalidateParent(true)
		child:InvalidateLayout(true)
	end
	self:GetCanvas():SizeToChildren(false, true)
	self:SizeToChildren(false, true)
	self:SetTall(self:GetTall() + 5)
end


vgui.Register("pluto_showcase_currency", PANEL, "pluto_showcase_base")