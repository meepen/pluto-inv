pluto.ui = pluto.ui or {}

local pad = 0
local accent = Color(0, 173, 123)

local active_text = Color(205, 203, 203)
local inactive_text = Color(130, 130, 136)

local function curve(level)
	return 4 + level
end

local bg_color = Color(36, 36, 37)
local inactive_color = Color(47, 47, 48)

local count = 6

local PANEL = {}

local colour = Material "models/debug/debugwhite"
DEFINE_BASECLASS "ttt_curved_panel"

function PANEL:OnRemove()
	BaseClass.OnRemove(self)

	if (IsValid(self.Model)) then
		self.Model:Remove()
	end
end

function PANEL:Init()
	self.Random = math.random()
	self:SetKeyboardInputEnabled(false)
	self:SetMouseInputEnabled(false)
	self:SetColor(Color(255,0,0))
	self:SetCurve(curve(0) / 2)
end

function PANEL:SetWeapon(w)
	if (IsValid(self.Model)) then
		self.Model:Remove()
	end
	self.Model = ClientsideModel(w.WorldModel, RENDERGROUP_OTHER)
	self.HoldType = w.HoldType
end

function PANEL:Paint(w, h)
	BaseClass.Paint(self, w, h)

	local err = self.Model
	if (not IsValid(err)) then
		return
	end

	local x, y = self:LocalToScreen(0, 0)
	local mins, maxs = err:GetModelBounds()
	local mul = mins:Distance(maxs) / 45
	local offset 
	if (self.HoldType == "pistol") then
		offset = -Vector((maxs.x - mins.x) * -1 / 3, 0, (maxs.z - mins.z) * 3 / 3)
	else
		offset = -Vector((maxs.x - mins.x) * -0.5 / 3, 0, (maxs.z - mins.z) * 1.5 / 3)
	end
	local angle = Angle(0, -90)
	cam.Start3D(angle:Forward() * mul * -56 - offset / 2, angle, 36, x, y, w, h)
		render.SuppressEngineLighting(true)
			err:SetAngles(Angle(-40, 10, 10))
			err:SetPos(vector_origin)
			render.PushFilterMin(TEXFILTER.ANISOTROPIC)
			render.PushFilterMag(TEXFILTER.ANISOTROPIC)
				err:DrawModel()
			render.PopFilterMag()
			render.PopFilterMin()
		render.SuppressEngineLighting(false)
	cam.End3D()
end

function PANEL:OnRemove()
	if (IsValid(self.Model)) then
		self.Model:Remove()
	end
end

function PANEL:GetScissor()
	return self:GetParent():GetScissor()
end

vgui.Register("pluto_weapon_inner", PANEL, "ttt_curved_panel")

local PANEL = {}

function PANEL:Init()
	self.Random = math.random()
	self:SetKeyboardInputEnabled(false)
	self:SetMouseInputEnabled(false)
	self:SetColor(inactive_color)
	self:SetCurve(curve(0))
	self.Inner = self:Add "pluto_weapon_inner"
	self.Inner:Dock(FILL)
	local pad = curve(0) / 2
	self:DockPadding(pad, pad, pad, pad)
end

function PANEL:SetWeapon(w)
	self.Inner:SetWeapon(w)
end

function PANEL:GhostClick(p, m)
	if (m == MOUSE_LEFT and p.ClassName == "pluto_inventory_item") then
		local parent = self:GetParent()
		local gparent = p

		local i = parent.Item
		local o = gparent.Item
		parent:SetItem(o)
		gparent:SetItem(i)

		pluto.inv.message()
			:write("tabswitch", pluto.ui.pnl.Tab.ID, parent.TabIndex, pluto.ui.pnl.Tab.ID, gparent.TabIndex)
			:send()
	end
	pluto.ui.ghost = nil
end

vgui.Register("pluto_weapon", PANEL, "ttt_curved_panel_outline")

local PANEL = {}
function PANEL:Init()
	self:SetColor(Color(84, 89, 89, 255))

	self.Image = self:Add "pluto_weapon"
	self.Image:Dock(FILL)
	self.Image:SetVisible(false)

	self:SetCursor "arrow"
end

function PANEL:Showcase(item)
	self.showcasepnl = pluto.ui.showcase(item)
	self.showcasepnl:MakePopup()
	self.showcasepnl:SetKeyboardInputEnabled(false)
	self.showcasepnl:SetMouseInputEnabled(false)
	self.showcasepnl:SetPos(self:LocalToScreen(self:GetWide(), 0))
end

function PANEL:OnRemove()
	if (IsValid(self.showcasepnl)) then
		self.showcasepnl:Remove()
	end
end

function PANEL:SetItem(item)
	self.Item = item

	if (not item) then
		self:SetCursor "arrow"
		self.Image:SetVisible(false)
		return
	end

	self:SetCursor "hand"
	self.Image:SetVisible(true)
	self.Image:SetWeapon(weapons.GetStored(item.ClassName))

	if (IsValid(self.showcasepnl)) then
		self:Showcase(item)
	end
end

function PANEL:OnCursorEntered()
	if (self.Item) then
		self:Showcase(self.Item)
	end
end

function PANEL:OnCursorExited()
	if (IsValid(self.showcasepnl)) then
		self.showcasepnl:Remove()
	end
end

function PANEL:OnMousePressed(code)
	if (code == MOUSE_LEFT and self.Item) then
		pluto.ui.ghost = self.Image
	end
end

function PANEL:PerformLayout(w, h)
	self:SetCurve(curve(0))
	local p = curve(0) / 2
	self:DockPadding(p, p, p, p)
end

vgui.Register("pluto_inventory_item", PANEL, "ttt_curved_panel")

local PANEL = {}
DEFINE_BASECLASS "pluto_inventory_base"
function PANEL:Init()
	BaseClass.Init(self)
	
	self.Layout = self:Add "DIconLayout"
	self.Layout:Dock(FILL)

	self.Items = {}

	for i = 1, count * count do
		local p = self.Layout:Add "pluto_inventory_item"
		p.TabIndex = i
		self.Items[i] = p
	end
end

function PANEL:PerformLayout(w, h)
	local size = math.Round(w / (count + 2))
	local divide = (w - size * count) / (count + 2)

	for _, item in ipairs(self.Items) do
		item:SetSize(size, size)
	end

	self.Layout:SetSpaceX(divide)
	self.Layout:SetSpaceY(divide)

	self:DockPadding(divide * 1.5, divide * 1.5, divide * 1.5, divide * 1.5)
end

function PANEL:SetTab(tab)
	for i = 1, count * count do
		self.Items[i]:SetItem(tab.Items[i], tab.ID)
	end
end

vgui.Register("pluto_inventory_items", PANEL, "pluto_inventory_base")

local PANEL = {}

function PANEL:Init()
	self:SetCurve(curve(2))
	self:SetColor(bg_color)
end

vgui.Register("pluto_inventory_base", PANEL, "ttt_curved_panel")

local PANEL = {}
DEFINE_BASECLASS "pluto_inventory_base"
function PANEL:Init()
	BaseClass.Init(self)
	self:SetCursor "hand"
	self:SetCurveBottomRight(false)
	self:SetCurveBottomLeft(false)

	self.Text = self:Add "DLabel"
	self.Text:Dock(FILL)
	self.Text:SetContentAlignment(5)
	self.Text:SetTextColor(inactive_text)
end
function PANEL:SetText(t)
	self.Text:SetText(t)
	surface.SetFont(self.Text:GetFont())
	local w = surface.GetTextSize(t)
	self.Text:SetWide(w + pad * 2)
end
function PANEL:OnMousePressed(key)
	if (key == MOUSE_LEFT) then
		self:DoClick()
	end
end

function PANEL:DoClick()
	self:GetParent():Select(self)
end

function PANEL:DoSelect()
	self.Text:SetTextColor(active_text)

	if (self.Tab) then
		self:GetParent():SetTab(self.Tab)
	end
end

function PANEL:Unselect()
	self.Text:SetTextColor(inactive_text)
end

local LastHeight = 0

function PANEL:PerformLayout(w, h)
	h = self:GetParent():GetTall()
	if (LastHeight ~= h) then
		LastHeight = h
		surface.CreateFont("pluto_inventory_tab", {
			font = "Lato",
			extended = true,
			size = h - pad / 2
		})
	end
	
	self.Text:SetFont "pluto_inventory_tab"

	surface.SetFont(self.Text:GetFont())
	local w = surface.GetTextSize(self.Text:GetText())
	self:SetWide(w + pad * 2)
	self:SetTall(h)
end

function PANEL:SetTab(tab)
	self.Tab = tab
	self:SetText(tab.Name)

	if (self:GetParent().Current == self and tab) then
		self:GetParent():SetTab(tab)
	end
end

vgui.Register("pluto_inventory_tab", PANEL, "pluto_inventory_base")

local PANEL = {}

function PANEL:Init()
	self.Tabs = {}
	self.CurPos = 0

	for _, tab in SortedPairsByMemberValue(pluto.cl_inv, "ID") do
		local pnl = self:AddTab "pluto_inventory_tab"
		pnl:SetTab(tab)
	end
end

function PANEL:SetTab(tab)
	self:GetParent():SetTab(tab)
end

local function PerformLayoutHack(self, w, h)
	if (self.OldPerformLayout) then
		self:OldPerformLayout(w, h)
	end

	if (IsValid(self.Before)) then
		self.Position = self.Before.Position + self.Before:GetWide() + pad / 2
	else
		self.Position = 0
	end

	self:GetParent():Recalculate(self)
end

function PANEL:Recalculate(tab)
	tab:SetPos(tab.Position - self.CurPos, 0)
	if (IsValid(tab.Next)) then
		tab.Next.Position = tab.Position + tab:GetWide() + pad / 2
		return self:Recalculate(tab.Next)
	end
end

function PANEL:Select(tab)
	if (IsValid(self.Current)) then
		self.Current:SetColor(inactive_color)
		self.Current:Unselect()
	end

	self.Current = tab
	if (tab.Position < self.CurPos) then
		self.CurPos = tab.Position
		self:Recalculate(tab)
	end

	if (tab.Position + tab:GetWide() > self.CurPos + self:GetWide()) then
		self.CurPos = self.CurPos + tab.Position + tab:GetWide() - (self.CurPos + self:GetWide())
		self:Recalculate(self.Next)
	end

	tab:SetColor(bg_color)

	tab:DoSelect()
end

function PANEL:AddTab(class)
	local tab = self:Add(class)
	tab:SetWide(100)

	table.insert(self.Tabs, tab)
	tab:SetZPos(#self.Tabs)

	tab.Before = self.Last
	if (IsValid(self.Last)) then
		self.Last.Next = tab
	end
	if (not IsValid(self.Next)) then
		self.Next = tab
	else
		tab:SetColor(inactive_color)
	end
	self.Last = tab

	tab.OldPerformLayout = tab.PerformLayout
	tab.PerformLayout = PerformLayoutHack

	tab:InvalidateLayout(true)

	if (not IsValid(self.Current)) then
		self.Current = tab
		self:Select(tab)
	end

	return tab
end

function PANEL:OnMouseWheeled(delta)
	local totalwide = self.Last.Position + self.Last:GetWide() - self:GetWide()
	if (totalwide < 0) then
		return
	end

	self.CurPos = math.Clamp(self.CurPos - delta * 30, 0, totalwide)

	self:Recalculate(self.Next)
end

function PANEL:PerformLayout()
	if (IsValid(self.Current)) then
		self:Select(self.Current)
	end
end

vgui.Register("pluto_inventory_tabs", PANEL, "EditablePanel")

local PANEL = {}

function PANEL:Init()
	self:SetCurveBottomLeft(false)
	self:SetCurveBottomRight(false)
	self:SetColor(inactive_color)
	self:SetWide(20)
end

vgui.Register("pluto_inventory_tab_selector", PANEL, "pluto_inventory_base")

local PANEL = {}

function PANEL:Init()
	self.Tabs = self:Add "pluto_inventory_tabs"
	self.Tabs:Dock(FILL)

	self.Controller = self:Add "pluto_inventory_tab_selector"
	self.Controller:Dock(RIGHT)
	self.Controller:DockMargin(pad / 2, 0, 0, 0)

	self:DockMargin(curve(2), 0, curve(2), 0)
end

function PANEL:SetTab(tab)
	self:GetParent():SetTab(tab)
end

vgui.Register("pluto_inventory_tab_controller", PANEL, "EditablePanel")

local PANEL = {}

function PANEL:Init()
	self:SetColor(Color(13, 12, 12, 220))
	self:SetCurve(curve(3))
	self:OnScreenSizeChanged()

	self.Items = self:Add "pluto_inventory_items"
	self.Items:Dock(TOP)
	self.Items:SetZPos(1)

	self.Tabs = self:Add "pluto_inventory_tab_controller"
	self.Tabs:Dock(TOP)
	self.Tabs:SetZPos(0)

	self:MakePopup()
	self:SetPopupStayAtBack(true)
end

function PANEL:OnScreenSizeChanged()
	local w = math.min(500, math.max(400, ScrW() / 3))
	self:SetSize(w, w * 1.2)
	pad = w * 0.05
	self:DockPadding(pad, pad, pad, pad)
	self:Center()
end

function PANEL:SetTab(tab)
	self.Tab = tab
	self.Items:SetTab(tab)
end

function PANEL:PerformLayout(w, h)
	w = w - w * 0.1
	h = h - w * 0.1

	self.Items:SetTall(w)

	h = h - w

	self.Tabs:SetTall(h * 1 / 3)
end

vgui.Register("pluto_inventory", PANEL, "ttt_curved_panel")


if (IsValid(pluto.ui.pnl)) then
	pluto.ui.pnl:Remove()
	pluto.ui.pnl = vgui.Create "pluto_inventory"
end

local function create()
	if (input.WasKeyPressed(KEY_I)) then
		if (IsValid(pluto.ui) and vgui.FocusedHasParent(pluto.ui.pnl)) then
			pluto.ui.pnl:Remove()
		elseif (not IsValid(pluto.ui.pnl)) then
			pluto.ui.pnl = vgui.Create "pluto_inventory"
		end
	end
end

hook.Add("InputMouseApply", "pluto_inventory_ui", function()
	if (input.WasKeyPressed(KEY_I) and not IsValid(pluto.ui.pnl)) then
		if (pluto.inv.status ~= "ready") then
			chat.AddText("wait for inventory!")
			return
		end
		pluto.ui.pnl = vgui.Create "pluto_inventory"
	end
end)
hook.Add("PlayerTick", "pluto_inventory_ui", function()
	if (input.WasKeyPressed(KEY_I) and IsValid(pluto.ui.pnl) and vgui.FocusedHasParent(pluto.ui.pnl)) then
		pluto.ui.pnl:Remove()
	end
end)

--[[
	item showcase
	shows an item (lol)
]]

local PANEL = {}

function PANEL:Init()
	self.Text = "Label"
	self.Font = "DermaDefault"
	self.Children = {}
	self.Color = white_text
end

function PANEL:AddLine(line)
	local pnl = self:Add "DLabel"
	pnl:SetFont(self.Font)
	pnl:SetTextColor(self.Color)
	pnl:SetText(line)
	pnl:SetContentAlignment(5)
	pnl:Dock(TOP)
	pnl:SetZPos(#self.Children)
	local _, h = surface.GetTextSize(line)
	pnl:SetTall(h)
	self.Tall = self.Tall + h
	table.insert(self.Children, pnl)
end

function PANEL:PerformLayout(_w, _h)
	if (self.LastText == self.Text and self.LastWide == _w) then
		return
	end
	self.LastText = self.Text
	self.LastWide = _w
	for _, child in pairs(self.Children) do
		child:Remove()
	end

	self.Children = {}

	local cur = {}
	surface.SetFont(self.Font)
	self.Tall = 0

	for word in self.Text:gmatch("([^%s]+)%s*") do
		cur[#cur + 1] = word
		local w, h = surface.GetTextSize(table.concat(cur, " "))
		if (w > _w) then
			if (#cur == 1) then
				self:AddLine(word)
				cur = {}
			else
				cur[#cur] = nil
				self:AddLine(table.concat(cur, " "))
				local w, h = surface.GetTextSize(word)
				if (w > _w) then
					self:AddLine(word)
					cur = {}
				else
					cur = {word}
				end
			end
		end
	end

	if (#cur > 0) then
		self:AddLine(table.concat(cur, " "))
	end

	self:SetTall(self.Tall)
end

function PANEL:SetTextColor(col)
	self.Color = col
	for _, child in pairs(self.Children) do
		child:SetTextColor(col)
	end
end

function PANEL:SetFont(font)
	self.Font = font
	self:InvalidateLayout(true)
end

function PANEL:SetText(text)
	self.Text = text
	self:InvalidateLayout(true)
end

vgui.Register("pluto_centered_wrap", PANEL, "EditablePanel")

local PANEL = {}

-- https://gist.github.com/efrederickson/4080372
local numbers = { 1, 5, 10, 50, 100, 500, 1000 }
local chars = { "I", "V", "X", "L", "C", "D", "M" }

local function ToRomanNumerals(s)
    --s = tostring(s)
    s = tonumber(s)
    if not s or s ~= s then error"Unable to convert to number" end
    if s == math.huge then error"Unable to convert infinity" end
    s = math.floor(s)
    if s <= 0 then return s end
	local ret = ""
        for i = #numbers, 1, -1 do
        local num = numbers[i]
        while s - num >= 0 and s > 0 do
            ret = ret .. chars[i]
            s = s - num
        end
        --for j = i - 1, 1, -1 do
        for j = 1, i - 1 do
            local n2 = numbers[j]
            if s - (num - n2) >= 0 and s < num and s > 0 and num - n2 ~= n2 then
                ret = ret .. chars[j] .. chars[i]
                s = s - (num - n2)
                break
            end
        end
    end
    return ret
end

function PANEL:SetItem(item)
	self:SetWide(math.max(300, math.min(600, ScrW() / 3)))
	self.ItemName:SetText(item.Tier .. " " .. weapons.GetStored(item.ClassName).PrintName)
	self.ItemName:SizeToContentsY()
	surface.SetFont(self.ItemName:GetFont())

	self.ItemDesc:SetFont "pluto_item_showcase_smol"
	self.ItemDesc:SetText("THIS IS A DESCRIPTION AHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH")
	self.ItemDesc:DockMargin(0, 0, 0, pad / 2)
	local z = 3

	if (item.Mods and item.Mods.prefix) then
		for _, mod in ipairs(item.Mods.prefix) do
			local p = self:Add "pluto_centered_wrap"
			p:SetFont "pluto_item_showcase_smol"
			p:SetText(mod.Name .. " " .. ToRomanNumerals(mod.Tier))
			p:Dock(TOP)
			p:SetZPos(z)
			z = z + 1

			local p = self:Add "pluto_centered_wrap"
			p:SetFont "pluto_item_showcase_desc"
			p:SetText(mod.Desc)
			p:Dock(TOP)
			p:SetZPos(z)
			z = z + 1
		end
	end

	if (item.Mods and item.Mods.suffix) then
		for _, mod in ipairs(item.Mods.suffix) do
			local p = self:Add "pluto_centered_wrap"
			p:SetFont "pluto_item_showcase_smol"
			p:SetText(mod.Name .. " " .. ToRomanNumerals(mod.Tier))
			p:Dock(TOP)
			p:SetZPos(z)
			z = z + 1

			local p = self:Add "pluto_centered_wrap"
			p:SetFont "pluto_item_showcase_desc"
			p:SetText(mod.Desc)
			p:Dock(TOP)
			p:SetZPos(z)
			z = z + 1
		end
	end


	self:DockPadding(pad, pad, pad, pad)
	self:InvalidateLayout(true)

	for _, child in pairs(self:GetChildren()) do
		child:InvalidateLayout(true)
	end
end

function PANEL:Init()
	local w = math.min(500, math.max(400, ScrW() / 3))
	pad = w * 0.05

	local h = 720

	surface.CreateFont("pluto_item_showcase_header", {
		font = "Lato",
		extended = true,
		size = math.max(30, h / 15)
	})

	surface.CreateFont("pluto_item_showcase_desc", {
		font = "Roboto",
		extended = true,
		size = math.max(20, h / 35)
	})


	surface.CreateFont("pluto_item_showcase_smol", {
		font = "Roboto",
		extended = true,
		size = math.max(h / 50, 16)
	})

	self:SetColor(ColorAlpha(bg_color, 230))
	self:SetCurve(curve(3))
	self.ItemName = self:Add "DLabel"
	self.ItemName:Dock(TOP)
	self.ItemName:SetContentAlignment(5)
	self.ItemName:SetFont "pluto_item_showcase_header"

	self.ItemDesc = self:Add "pluto_centered_wrap"
	self.ItemDesc:Dock(TOP)
end

vgui.Register("pluto_item_showcase", PANEL, "ttt_curved_panel")

function pluto.ui.showcase(item)
	if (IsValid(pluto.ui.showcasepnl)) then
		pluto.ui.showcasepnl:Remove()
	end

	pluto.ui.showcasepnl = vgui.Create "pluto_item_showcase"

	pluto.ui.showcasepnl:SetItem(item)
	pluto.ui.showcasepnl:InvalidateLayout(true)
	pluto.ui.showcasepnl:SizeToChildren(true, true)

	return pluto.ui.showcasepnl
end

hook.Add("PostRenderVGUI", "pluto_ghost", function()
	if (IsValid(pluto.ui.ghost)) then
		local p = pluto.ui.ghost

		if ((input.IsMouseDown(MOUSE_RIGHT) or input.IsMouseDown(MOUSE_LEFT)) and not IsValid(vgui.GetHoveredPanel())) then
			pluto.ui.ghost = nil
			return
		end

		local w, h = p:GetSize()
		local x, y = gui.MousePos()
		x = x - w / 2
		y = y - h / 2
		
		local b

		if (p.SetScissor) then
			b = p:GetScissor()
			p:SetScissor(false)
		end

		local mi, ki = p:IsMouseInputEnabled(), p:IsKeyboardInputEnabled()

		p:PaintAt(x, y) -- this resets mouseinput / keyboardinput???
		p:SetMouseInputEnabled(mi)
		p:SetKeyboardInputEnabled(ki)

		if (p.SetScissor) then
			p:SetScissor(b)
		end
	end
end)

hook.Add("VGUIMousePressAllowed", "pluto_ghost", function(mouse)
	if (IsValid(pluto.ui.ghost)) then
		local g = pluto.ui.ghost

		if (g.GhostClick) then
			return not g:GhostClick(vgui.GetHoveredPanel(), mouse)
		end
	end
end)