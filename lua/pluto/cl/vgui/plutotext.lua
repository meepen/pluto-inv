local PANEL = {}

AccessorFunc(PANEL, "DefaultFont", "DefaultFont")
AccessorFunc(PANEL, "DefaultTextColor", "DefaultTextColor")
AccessorFunc(PANEL, "DefaultRenderSystem", "DefaultRenderSystem")

function PANEL:SetCurrentTextColor(col)
	if (col ~= self:GetCurrentTextColor()) then
		self:FinalizeLabel()
	end
	self.TextColor = col
end
function PANEL:GetCurrentTextColor()
	return self.TextColor or self:GetDefaultTextColor()
end

function PANEL:SetCurrentRenderSystem(system)
	if (isstring(system)) then
		system = pluto.fonts.systems[system]
	end

	if (system ~= self:GetCurrentRenderSystem()) then
		self:FinalizeLabel()
	end

	self.surface = system
end
function PANEL:GetCurrentRenderSystem()
	return self.surface or pluto.fonts.systems[self:GetDefaultRenderSystem() or "default"]
end

function PANEL:SetCurrentFont(font)
	if (self:GetCurrentFont() ~= font) then
		self:FinalizeLabel()
	end
	self.Font = font
end
function PANEL:GetCurrentFont()
	return self.Font or self:GetDefaultFont()
end

function PANEL:ResetTextSettings()
	self:FinalizeLabel()
	self:SetCurrentTextColor()
	self:SetCurrentFont()
	self:SetCurrentRenderSystem()
end

function PANEL:Init()
	self.CurPos = {x = 0, y = 0}
	self.Lines = {}
	self:NewLine()
end

function PANEL:LayoutText()
	local w, h = self:GetSize()
end

function PANEL:AppendText(...)
	local t = {n = select("#", ...), ...}

	for i = 1, t.n do
		local data = t[i]

		if (IsColor(data)) then
			self:SetCurrentTextColor(data)
		elseif (istable(data)) then
			local mt = getmetatable(data)
			if (mt.__colorprint) then
				print "TODO(meepen): mt.__colorprint"
			end
		elseif (isstring(data)) then
			self:AddText(data)
		end
	end
end

function PANEL:FetchLabel()
	if (not IsValid(self.LastLabel)) then
		self.LastLabel = self:Add "pluto_label"
		self.LastLabel:SetPos(self.CurPos.x, self.CurPos.y)
		self.LastLabel:SetFont(self:GetCurrentFont())
		self.LastLabel:SetTextColor(self:GetCurrentTextColor())
		self.LastLabel:SetContentAlignment(2)
		self.LastLabel:SetText ""

		self.LastLabel:SetClickable(self.Clickable)
		self.LastLabel:SetRenderSystem(self:GetCurrentRenderSystem())
	end

	return self.LastLabel
end

function PANEL:InsertClickableTextStart(fn, cursor)
	self:FinalizeLabel()
	if (fn) then
		self.Clickable = {
			Run = fn,
			Cursor = cursor or "hand"
		}
	else
		self.Clickable = nil
	end
end

function PANEL:InsertClickableTextEnd()
	self:InsertClickableTextStart()
end

function PANEL:FinalizeLabel()
	local cur = self.LastLabel
	if (not IsValid(cur)) then
		return
	end

	self.LastLabel = nil

	local pos = self.CurPos
	cur:SizeToContentsX()
	pos.x = pos.x + cur:GetWide()

	self:EnsureLineHeight(cur)

	return cur
end

function PANEL:NewLine()
	if (not self.CurrentLine) then
		self.CurrentLine = {y = self.CurPos.y, Height = 0}
		return
	end
	
	self:FinalizeLabel()

	local pos = self.CurPos
	local line = self.CurrentLine

	print ("line height", line.Height)
	self.CurPos = {x = 0, y = self.CurPos.y + line.Height}
	self.CurrentLine = {y = self.CurPos.y, Height = 0}
end

function PANEL:AddText(what)
	local has_newlined = false
	surface.SetFont(self:GetCurrentFont())

	for m in what:gmatch "([^\r\n]+)" do
		if (has_newlined) then
			self:NewLine()
		end
		local lbl = self:FetchLabel()

		for n, i in m:gmatch "([^ ]+)()" do
			local tw, th = surface.GetTextSize(n)

			local newposx = lbl:GetWide() + self.CurPos.x + tw
			if (newposx > self:GetWide() and tw < self:GetWide() * 0.25) then
				self:NewLine()
				lbl = self:FetchLabel()
			end

			lbl:SetText(lbl:GetText() .. n)

			local space = m:sub(i, i)
			if (space ~= "") then
				lbl:SetText(lbl:GetText() .. space)
				-- check if overwhelmed now?
			end
			lbl:SizeToContentsX()
		end
		has_newlined = true
	end
end

function PANEL:AddImage(img, w, h)
	self:FinalizeLabel()
	local rw, rh = img:GetInt "$realwidth", img:GetInt "$realheight"
	if (rw and rh and not w and not h) then
		w, h = rw, rh
	end

	local pnl = self:Add "pluto_image"
	pnl:SetPos(self.CurPos.x, self.CurPos.y)
	pnl:SetMaterial(img)
	pnl:SetImageSize(w, h)
	pnl:SetClickable(self.Clickable)
	pnl:SetTextColor(self:GetCurrentTextColor())
	pnl:SetTall(math.max(h, self.CurrentLine.Height))

	self:EnsureLineHeight(pnl)

	self.CurPos.x = self.CurPos.x + w
end

function PANEL:EnsureLineHeight(pnl)
	local height = pnl:GetTall()
	local line = self.CurrentLine
	if (line.Height < height) then
		for _, ele in ipairs(self.CurrentLine) do
			ele:SetTall(height)
		end
		line.Height = height
	else
		pnl:SetTall(line.Height)
	end

	table.insert(line, pnl)
end


vgui.Register("pluto_text", PANEL, "EditablePanel")
