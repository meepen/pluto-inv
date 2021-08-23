--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
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
	return self.surface or pluto.fonts.systems[self:GetDefaultRenderSystem() or "default"] or surface
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
	self.ScrollPos = {x = 0, y = 0}
	self.Lines = {}
	self:NewLine()
	self:SetCursor "beam"
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
				local prints = mt.__colorprint(data)
				local oldsystem
				if (prints.rendersystem) then
					oldsystem = self:GetCurrentRenderSystem()
					self:SetCurrentRenderSystem(prints.rendersystem)
				end	
				self:AppendText(unpack(prints))
				self:SetCurrentRenderSystem(oldsystem)
			end
		elseif (isstring(data)) then
			self:AddText(data)
		end
	end
end

function PANEL:InsertColorChange(r, g, b, a)
	self:SetCurrentTextColor(Color(r, g, b, a))
end

function PANEL:FetchLabel()
	if (not IsValid(self.LastLabel)) then
		self.LastLabel = self:Add "pluto_label"
		self.LastLabel:SetPos(self.CurPos.x, self.CurPos.y)
		self.LastLabel.CurPos = {
			x = self.CurPos.x,
			y = self.CurPos.y,
		}
		self.LastLabel:SetFont(self:GetCurrentFont())
		self.LastLabel:SetTextColor(self:GetCurrentTextColor())
		self.LastLabel:SetContentAlignment(2)
		self.LastLabel:SetText ""

		self.LastLabel:SetClickable(self.Clickable)
		self.LastLabel:SetRenderSystem(self:GetCurrentRenderSystem())
		if (self.Fade) then
			self.LastLabel:SetFade(self.Fade.Sustain, self.Fade.Length)
		end
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
	cur:SizeToContents()
	pos.x = pos.x + cur:GetWide()

	self:EnsureLineHeight(cur)

	return cur
end

function PANEL:NewLine()
	if (not self.CurrentLine) then
		self.CurrentLine = {y = self.CurPos.y, Height = 0, LineNumber = 1}
		return
	end
	
	self:FinalizeLabel()

	local pos = self.CurPos
	local line = self.CurrentLine
	table.insert(self.Lines, line)

	self.CurPos = {x = 0, y = self.CurPos.y + line.Height}
	self.CurrentLine = {y = self.CurPos.y, Height = 0, LineNumber = #self.Lines + 1}
end

function PANEL:AddText(what)
	local surface = self:GetCurrentRenderSystem()
	surface.SetFont(self:GetCurrentFont())

	for nl1, m, nl2, npos in what:gmatch "([\r\n]*)([^\r\n]*)([\r\n]*)()" do
		for i = 1, nl1:len() do
			self:NewLine()
		end

		local lbl = self:FetchLabel()

		for n, spaces in m:gmatch "( *[^ ]+)( *)" do
			local tw, th = surface.GetTextSize(n)

			local newposx = lbl:GetWide() + self.CurPos.x + tw
			if (newposx > self:GetWide() and tw < self:GetWide() * 0.8) then
				self:NewLine()
				lbl = self:FetchLabel()
			end

			lbl:SetText(lbl:GetText() .. n)

			if (spaces ~= "") then
				lbl:SetText(lbl:GetText() .. spaces)
				-- check if overwhelmed now?
			end
			lbl:SizeToContentsX()
		end

		for i = 1, nl2:len() do
			self:NewLine()
		end
	end
end

function PANEL:AddImage(img, w, h)
	self:FinalizeLabel()
	if (not w or not h) then
		local rw, rh = img:GetInt "$realwidth", img:GetInt "$realheight"
		if (rw and rh and not w and not h) then
			w, h = rw, rh
		end
	end

	local pnl = self:Add "pluto_image"
	pnl:SetPos(self.CurPos.x, self.CurPos.y)
	pnl.CurPos = {
		x = self.CurPos.x,
		y = self.CurPos.y,
	}
	pnl:SetMaterial(img)
	pnl:SetImageSize(w, h)
	pnl:SetClickable(self.Clickable)
	pnl:SetTextColor(self:GetCurrentTextColor())
	pnl:SetTall(math.max(h, self.CurrentLine.Height))

	self:EnsureLineHeight(pnl)

	self.CurPos.x = self.CurPos.x + w
end

function PANEL:AddImageFromURL(url, w, h)
	self:FinalizeLabel()

	local pnl = self:Add "pluto_image"
	pnl:SetPos(self.CurPos.x, self.CurPos.y)
	pnl.CurPos = {
		x = self.CurPos.x,
		y = self.CurPos.y,
	}
	pnl:SetFromURL(url)
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

	if (self.Fade) then
		pnl:SetFade(self.Fade.Sustain, self.Fade.Length, true)
	end

	pnl.PanelNumber = #line + 1

	table.insert(line, pnl)
end

function PANEL:GetLineAt(mx, my)
	for _, line in ipairs(self.Lines) do
		if (line.y <= my and my - line.y <= line.Height) then
			return line
		end
	end
end

function PANEL:GetHoveredElement()
	local mx, my = self:ScreenToLocal(gui.MousePos())
	my = my + (self.ScrollPosition or 0)
	local line = self:GetLineAt(mx, my)

	if (not line and my > 0) then
		line = self.Lines[#self.Lines]
		if (not line) then
			return
		end

		local pnl = line[#line]
		return pnl, line, utf8.force(pnl:GetText()):len()
	elseif (not line and my <= 0) then
		line = self.Lines[1]
		if (not line) then
			return
		end

		local pnl = line[#line]
		return pnl, line, 1
	end

	if (mx <= 0) then
		return line[1], line, 1
	end

	local x = 0
	for _, pnl in ipairs(line) do
		if (x < mx and mx - x <= pnl:GetWide()) then
			if (pnl:GetText() == "") then
				return pnl, line, 1
			end

			local txt = utf8.force(pnl:GetText())
			local tx = 0
			local ele = 1
			surface.SetFont(pnl:GetFont())
			for _, code in utf8.codes(txt) do
				local chr = utf8.char(code)
				local tw, th = surface.GetTextSize(chr)
				if (tx + x < mx and mx - tx - x <= tw) then

					return pnl, line, ele
				end
				ele = ele + 1
				tx = tx + tw
			end
		end
		x = x + pnl:GetWide()
	end

	return line[#line], line, utf8.force(line[#line]:GetText()):len()
end

function PANEL:OnMousePressed(m)
	if (IsValid(self.Showcase)) then
		self.Showcase:Remove()
	end

	if (m == MOUSE_LEFT) then
		self.StartDrag = {Time = SysTime(), self:GetHoveredElement()}
		self.EndDrag = nil

		hook.Add("Think", self, self.TestMouseRelease)
	elseif (m == MOUSE_RIGHT and self.EndDrag and self.StartDrag) then
		local startpnl, startline, startele, endpnl, endline, endele = self:GetDraggedElements()
		self.StartDrag, self.EndDrag = nil, nil

		local text
		if (endpnl == startpnl) then
			text = utf8.force(endpnl:GetText()):sub(startele, endele)
		else
			-- starting
			text = utf8.force(startpnl:GetText()):sub(startele)

			local found = false
			for _, ele in ipairs(startline) do
				if (ele == startpnl) then
					found = true
				elseif (ele == endpnl) then
					text = text .. utf8.force(ele:GetText()):sub(1, endele)
					break
				elseif (found) then
					text = text .. ele:GetText()
				end
			end
			text = text .. "\n"

			for i = startline.LineNumber + 1, endline.LineNumber - 1 do
				local curline = self.Lines[i]
				for _, ele in ipairs(curline) do
					text = text .. ele:GetText()
				end
				text = text .. "\n"
			end

			if (endline ~= startline) then
				for _, ele in ipairs(endline) do
					if (endpnl == ele) then
						text = text .. utf8.force(ele:GetText()):sub(1, endele)
						break
					else
						text = text .. ele:GetText()
					end
				end
			end
		end
		SetClipboardText(text)
	end
end

function PANEL:InsertPlayer(ply)
	self:InsertClickableTextStart(function()
		if (IsValid(pluto.opened_chat_player)) then
			pluto.opened_chat_player:Remove()
		end

		if (IsValid(pluto.opened_showcase)) then
			pluto.opened_showcase:Remove()
		end

		local showcase = pluto.ui.playercard(ply)
		pluto.opened_chat_player = showcase

		local posx, posy = self:LocalToScreen(self:GetWide(), 0)
		posx = posx + 50
		posy = posy - 50
		if (showcase:GetTall() + posy > ScrH()) then
			posy = ScrH() - showcase:GetTall()
		end
		if (showcase:GetWide() + posx > ScrW()) then
			posx = ScrW() - showcase:GetWide()
		end
		showcase:SetPos(posx, posy)
		self.Showcase = showcase
	end)

	self:AppendText(ply:Nick())

	self:InsertClickableTextEnd()
end

function PANEL:InsertShowcaseItem(item)
	self:InsertClickableTextStart(function()
		if (IsValid(pluto.opened_showcase)) then
			pluto.opened_showcase:Remove()
		end

		if (IsValid(pluto.opened_chat_player)) then
			pluto.opened_chat_player:Remove()
			print("yes")
		end

		local showcase = pluto.ui.showcase(item)
		pluto.opened_showcase = showcase
		local posx, posy = self:LocalToScreen(self:GetWide(), 0)
		posx = posx + 50
		posy = posy - 50
		if (showcase:GetTall() + posy > ScrH()) then
			posy = ScrH() - showcase:GetTall()
		end
		if (showcase:GetWide() + posx > ScrW()) then
			posx = ScrW() - showcase:GetWide()
		end
		showcase:SetPos(posx, posy)
		self.Showcase = showcase
	end)

	self:AppendText(item)

	self:InsertClickableTextEnd()
end

function PANEL:GetDraggedElements()
	local startpnl, startline, startele = unpack(self.StartDrag)
	local endpnl, endline, endele
	if (self.EndDrag) then
		endpnl, endline, endele = unpack(self.EndDrag)
	else
		endpnl, endline, endele = self:GetHoveredElement()
	end

	if (not endline) then
		return
	end

	if (endline.LineNumber < startline.LineNumber or endline == startline and endpnl.PanelNumber < startpnl.PanelNumber or endpnl == startpnl and endele < startele) then
		startpnl, startline, startele, endpnl, endline, endele = endpnl, endline, endele, startpnl, startline, startele
	end

	return startpnl, startline, startele, endpnl, endline, endele
end

function PANEL:TestMouseRelease()
	if (input.IsMouseDown(MOUSE_LEFT)) then
		return
	end

	hook.Remove("Think", self)
	if ((SysTime() - self.StartDrag.Time) < 0.2) then
		self.StartDrag = nil
		self.EndDrag = nil
		return
	end
	self.EndDrag = {self:GetHoveredElement()}
end

function PANEL:PaintOver(w, h)
	if (self.StartDrag) then
		surface.SetDrawColor(255, 0, 0, 100)
		local startpnl, startline, startele, endpnl, endline, endele = self:GetDraggedElements()
		if (not startpnl) then
			return
		end

		local sx, sy = startpnl:GetPos()
		local sw, sh = startpnl:GetSize()
		local ex, ey = endpnl:GetPos()
		local ew, eh = endpnl:GetSize()

		if (endpnl == startpnl) then
			if (endpnl:GetText() == "") then
				return
			end
			local surface = endpnl:GetRenderSystem()
			surface.SetFont(endpnl:GetFont())
			local txt = utf8.force(endpnl:GetText())
			local tsx = surface.GetTextSize(txt:sub(1, startele - 1)) + endpnl:GetPos()
			local tex = surface.GetTextSize(txt:sub(1, endele)) + endpnl:GetPos()
			surface.DrawRect(tsx, ey, tex - tsx, eh)
		else
			-- highlight start ele to end
			if (startpnl:GetText() ~= "") then
				local surface = startpnl:GetRenderSystem()
				surface.SetFont(startpnl:GetFont())
				local txt = utf8.force(startpnl:GetText())
				local tsx = surface.GetTextSize(txt:sub(1, startele - 1))
				surface.DrawRect(startpnl:GetPos() + tsx, sy, sw - tsx, sh)
			end

			-- highlight between

			local found = false
			for _, ele in ipairs(startline) do
				if (ele == startpnl) then
					found = true
				elseif (ele == endpnl) then
					break
				elseif (found) then
					local x, y = ele:GetPos()
					local w, h = ele:GetSize()
					surface.DrawRect(x, y, w, h)
				end
			end

			for i = startline.LineNumber + 1, endline.LineNumber - 1 do
				local curline = self.Lines[i]
				for _, ele in ipairs(curline) do
					local x, y = ele:GetPos()
					local w, h = ele:GetSize()
					surface.DrawRect(x, y, w, h)
				end
			end

			if (endline ~= startline) then
				for _, ele in ipairs(endline) do
					if (endpnl == ele) then
						break
					else
						local x, y = ele:GetPos()
						local w, h = ele:GetSize()
						surface.DrawRect(x, y, w, h)
					end
				end
			end

			-- highlight end ele from start
			if (endpnl:GetText() ~= "") then
				local surface = endpnl:GetRenderSystem()
				surface.SetFont(endpnl:GetFont())
				txt = utf8.force(endpnl:GetText())
				local tex = surface.GetTextSize(txt:sub(1, endele)) + endpnl:GetPos()
				surface.DrawRect(ex, ey, tex - ex, eh)
			end
		end
	end
end

function PANEL:SetScrollOffset(offset)
	for _, child in pairs(self:GetChildren()) do
		child:SetVisible(false)
	end

	self.ScrollPosition = offset

	local startline = self:GetLineAt(0, offset)

	local found = false
	for _, line in ipairs(self.Lines) do
		if (line ~= startline and not found) then
			continue
		end

		found = true

		for _, pnl in ipairs(line) do
			pnl:SetVisible(true)
			pnl:SetPos(pnl.CurPos.x, pnl.CurPos.y - offset)
		end

		if (line.y - self:GetTall() > offset) then
			break
		end
	end
end

function PANEL:InsertFade(sustain, length)
	self.Fade = {
		Sustain = sustain,
		Length = length
	}
end

function PANEL:SignalClose()
	self.StartDrag = nil
	self.EndDrag = nil
	if (IsValid(self.Showcase)) then
		self.Showcase:Remove()
		hook.Remove("Think", self)
	end
end

function PANEL:ResetAllFades(hold, expiredOnly, newSustain)
	for _, pnl in ipairs(self:GetChildren()) do
		local fade = pnl.Fade
		if (fade and expiredOnly and (pnl.Creation + fade.Sustain + fade.Length) < CurTime()) then
			continue
		end

		if (hold) then
			pnl:ResetFade()
		end

		if (newSustain) then
			pnl:SetFade(newSustain, pnl:GetFadeLength(), true)
		end
	end
end

function PANEL:SizeToContentsY()
	self:SetTall(self.CurrentLine.y + self.CurrentLine.Height)
end

vgui.Register("pluto_text_inner", PANEL, "EditablePanel")

local PANEL = {}
local function Proxy(what)
	PANEL[what] = function(self, ...)
		return self.Inner[what](self.Inner, ...)
	end
end
Proxy "SetDefaultFont"
Proxy "GetDefaultFont"

Proxy "SetDefaultTextColor"
Proxy "GetDefaultTextColor"

Proxy "SetDefaultRenderSystem"
Proxy "GetDefaultRenderSystem"

Proxy "SetCurrentTextColor"
Proxy "GetCurrentTextColor"

Proxy "SetCurrentRenderSystem"
Proxy "GetCurrentRenderSystem"

Proxy "SetCurrentFont"
Proxy "GetCurrentFont"

Proxy "ResetTextSettings"
Proxy "InsertColorChange"
Proxy "InsertClickableTextStart"
Proxy "InsertClickableTextEnd"

Proxy "NewLine"

Proxy "InsertFade"
Proxy "ResetAllFades"

local function pack(...)
	return {n = select("#", ...), ...}
end
function Proxy(what)
	PANEL[what] = function(self, ...)
		local t = pack(self.Inner[what](self.Inner, ...))
		self:RedoScroll()
		if (self.AtBottom) then
			self.Scrollbar:SetScroll(self.Inner.CurrentLine.y + self.Inner.CurrentLine.Height)
		end
		return unpack(t, 1, t.n)
	end
end
Proxy "AppendText"
Proxy "AddImage"
Proxy "AddImageFromURL"
Proxy "InsertPlayer"
Proxy "InsertShowcaseItem"


function PANEL:Init()
	self.Inner = self:Add "pluto_text_inner"
	self.Inner:Dock(FILL)

	self.Scrollbar = self:Add "DVScrollBar"
	self.Scrollbar:Dock(RIGHT)
	self.Scrollbar:SetWide(12)

	self.Padding = self:Add "EditablePanel"
	self.Padding:Dock(BOTTOM)
	self.Padding:SetTall(16)

	self.AtBottom = true
	self:RedoScroll()
end
function PANEL:SignalClose()
	self.Inner:SignalClose()
end

function PANEL:OnMouseWheeled(delta)
	self.Scrollbar:OnMouseWheeled(delta)
end

function PANEL:RedoScroll()
	self.Scrollbar:SetUp(self.Inner:GetTall(), self.Inner.CurrentLine.y + self.Inner.CurrentLine.Height)
end

function PANEL:ScrollToBottom()
	self.Scrollbar:SetScroll(self.Inner.CurrentLine.y + self.Inner.CurrentLine.Height - self.Inner:GetTall())
end

function PANEL:OnVScroll(offset)
	self.Inner:SetScrollOffset(-offset)
	self.AtBottom = (self.Inner.CurrentLine.y + self.Inner.CurrentLine.Height - self.Inner:GetTall()) == -offset
end

function PANEL:SizeToContents()
	self:SizeToContentsY()
end

vgui.Register("pluto_text", PANEL, "EditablePanel")