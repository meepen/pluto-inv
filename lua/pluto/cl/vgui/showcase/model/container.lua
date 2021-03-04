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
end

function PANEL:SetItem(item)
	self:InvalidateLayout(true)
	self:InvalidateChildren(true)
	self.NameContainer:SetColor(item.Model.Color)
	
	self.PlayerModel:SetPlutoModel(item.Model, item)
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

	local subdesc = item.Model.SubDescription
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