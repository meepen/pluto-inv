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
local light_color = Color(84, 89, 89)

local count = 6

local PANEL = {}

local colour = Material "models/debug/debugwhite"
DEFINE_BASECLASS "DImage"

function PANEL:OnRemove()
	BaseClass.OnRemove(self)

	if (IsValid(self.Model)) then
		self.Model:Remove()
	end
end

local function ColorToHSL(col)
	local r = col.r / 255
	local g = col.g / 255
	local b = col.b / 255
	local max = math.max(r, g, b)
	local min = math.min(r, g, b)
	local d = max - min

	local h
	if (d == 0) then 
		h = 0
	elseif (max == r) then
		h = (g - b) / d % 6
	elseif (max == g) then
		h = (b - r) / d + 2
	elseif (max == b) then
		h = (r - g) / d + 4
	end
	local l = (min + max) / 2
	local s = d == 0 and 0 or d / (1 - math.abs(2 * l - 1))

	return h * 60, s, l
end

local function hue2rgb(p, q, t)
	if (t < 0) then
		t = t + 1
	elseif (t > 1) then
		t = t - 1
	end

	if (t < 1 / 6) then
		return p + (q - p) * 6 * t
	end

	if (t < 0.5) then
		return q
	end

	if (t < 2 / 3) then
		return p + (q - p) * (2 / 3 - t) * 6
	end

	return p
end

local function HSLToColor(h, s, l)
	local c = (1 - math.abs(2 * l - 1)) * s
	local hp = h / 60.0
	local x = c * (1 - math.abs((hp % 2) - 1))
	local rgb1;
	if (h ~= h) then
		rgb1 = {[0] = 0, 0, 0}
	elseif (hp <= 1) then
		rgb1 = {[0] = c, x, 0}
	elseif (hp <= 2) then
		rgb1 = {[0] = x, c, 0}
	elseif (hp <= 3) then
		rgb1 = {[0] = 0, c, x}
	elseif (hp <= 4) then
		rgb1 = {[0] = 0, x, c}
	elseif (hp <= 5) then
		rgb1 = {[0] = x, 0, c}
	elseif (hp <= 6) then
		rgb1 = {[0] = c, 0, x}
	end
	local m = l - c * 0.5;
	return Color(
		math.Round(255 * (rgb1[0] + m)),
		math.Round(255 * (rgb1[1] + m)),
		math.Round(255 * (rgb1[2] + m))
	)
end

local function Brightness(col)
	local r, g, b = col.r / 255, col.g / 255, col.b / 255

	return math.sqrt(r * r * 0.241 + g * g * 0.691 + b * b * 0.068)
end

function PANEL:Init()
	self.Random = math.random()
	self:SetKeyboardInputEnabled(false)
	self:SetMouseInputEnabled(false)

	self:SetCurve(curve(0))
	self:SetColor(Color(0,0,0,0))

	self.Material = Material "pluto/item_bg_real.png"
end

function PANEL:SetItem(item)
	if (not item) then
		if (IsValid(self.Model)) then
			self.Model:Remove()
		end
		self:SetColor(Color(0,0,0,0))
		return
	end

	self.Item = item
	self:SetWeapon(weapons.GetStored(item.ClassName))

	local _h, s, l = ColorToHSL(item.Color)
	s = math.Clamp(s, 0, 0.6)
	l = 0.5
	local col = HSLToColor(_h, s, l)
	self:SetColor(col)

	_h, s, l = ColorToHSL(col)
	local num = (math.Clamp(Brightness(col), 0.25, 0.75) - 0.25) * 2
	col = HSLToColor(_h, s + num * 0.3, l + 0.3)
	self.MaterialColor = col:ToVector()
end

function PANEL:SetWeapon(w)
	if (IsValid(self.Model)) then
		self.Model:Remove()
	end
	self.Model = ClientsideModel(w.WorldModel, RENDERGROUP_OTHER)
	self.Model:SetNoDraw(true)
	self.HoldType = w.HoldType
end

DEFINE_BASECLASS "ttt_curved_panel"

function PANEL:Paint(w, h)
	if (pluto.ui.ghost == self:GetParent() and not pluto.ui.ghost.paintover) then
		return
	end

	render.SetStencilWriteMask(1)
	render.SetStencilTestMask(1)
	render.SetStencilReferenceValue(1)
	render.SetStencilCompareFunction(STENCIL_ALWAYS)
	render.SetStencilPassOperation(STENCIL_REPLACE)
	render.SetStencilFailOperation(STENCIL_KEEP)
	render.SetStencilZFailOperation(STENCIL_KEEP)
	render.ClearStencil()

	render.SetStencilEnable(true)
		BaseClass.Paint(self, w, h)

		render.SetStencilPassOperation(STENCIL_KEEP)
		render.SetStencilCompareFunction(STENCIL_EQUAL)
		local r, g, b = render.GetColorModulation()
		render.SetColorModulation(1, 1, 1)
		local err = self.Model
		local holdtype = self.HoldType
		if (not IsValid(err)) then
			err = self.DefaultModel
			holdtype = self.DefaultHoldType
			
			if (not IsValid(err)) then
				return
			end

			render.SetBlend(0.5)
		end

		if (self.Material and self.Item) then
			self.Material:SetVector("$color", self.MaterialColor)
			surface.SetMaterial(self.Material)
			surface.SetDrawColor(255, 255, 255, err ~= self.DefaultModel and 255 or 1)
			surface.DrawTexturedRect(0, 0, w, h)
		end

		local x, y = self:LocalToScreen(0, 0)
		local mins, maxs = err:GetModelBounds()
		local mul = mins:Distance(maxs) / 45
		local offset 
		if (holdtype == "pistol") then
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
		render.SetColorModulation(r, g, b)
		render.SetBlend(1)
	render.SetStencilEnable(false)
end

function PANEL:SetDefault(str)
	local w = weapons.GetStored(str)
	if (IsValid(self.DefaultModel)) then
		self.DefaultModel:Remove()
	end
	self.DefaultModel = ClientsideModel(w.WorldModel, RENDERGROUP_OTHER)
	self.DefaultModel:SetNoDraw(true)
	self.DefaultHoldType = w.HoldType
end

function PANEL:OnRemove()
	if (IsValid(self.Model)) then
		self.Model:Remove()
	end
	if (IsValid(self.DefaultModel)) then
		self.DefaultModel:Remove()
	end
end

function PANEL:GetScissor()
	return self:GetParent():GetScissor()
end

vgui.Register("pluto_weapon", PANEL, "ttt_curved_panel")

local PANEL = {}
DEFINE_BASECLASS "ttt_curved_panel"

function PANEL:Init()
	self:SetColor(Color(84, 89, 89, 255))

	self.Image = self:Add "pluto_weapon"
	self.Image:Dock(FILL)
	self.Image:SetVisible(false)

	self:SetCursor "arrow"

	hook.Add("PlutoTabUpdate", self, self.PlutoTabUpdate)
end

function PANEL:SetDefault(str)
	self.Image:SetDefault(str)
end

function PANEL:PlutoTabUpdate(tabid, tabindex, item)
	if (self.Tab and self.Tab.ID == tabid and self.TabIndex == tabindex) then
		self:SetItem(item)
	end
end

function PANEL:Paint(w, h)
	if (not self.Tab.Active) then
		return
	end

	BaseClass.Paint(self, w, h)
end

function PANEL:Showcase(item)
	self.showcasepnl = pluto.ui.showcase(item)
	self.showcasepnl:SetPos(self:LocalToScreen(self:GetWide() + 3, 0))
	self.showcase_version = item.Version
end

function PANEL:OnRemove()
	if (IsValid(self.showcasepnl)) then
		self.showcasepnl:Remove()
	end
end

function PANEL:SetItem(item, tab)
	if (tab) then
		self.TabID = tab.ID
		self.Tab = tab
	end

	self.Item = item
	self.Image:SetItem(item)

	if (not item) then
		self:SetCursor "arrow"
		self.Image:SetVisible(self.Image.DefaultModel)
		return
	end

	self:SetCursor "hand"
	self.Image:SetVisible(true)
	self.Image:SetItem(item)

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
	if (self.Item and not IsValid(pluto.ui.ghost)) then
		if (code == MOUSE_LEFT) then
			pluto.ui.ghost = self
		elseif (code == MOUSE_RIGHT) then
			local tabele, t
			for _, tab in pairs(pluto.cl_inv) do
				if (tab.Type == "equip" and IsValid(tab.CurrentElement)) then
					tabele = tab.CurrentElement
					t = tab
					break
				end
			end

			local tabtype = pluto.tabs.equip
			if (not IsValid(tabele) or not tabtype) then
				return
			end

			local thistab = pluto.tabs[self.Tab.Type]

			for i = 1, tabtype.size do
				if (tabtype.canaccept(i, self.Item) and (not t.Items[self.TabIndex] or thistab.canaccept(self.TabIndex, t.Items[self.TabIndex]))) then
					self:SwitchWith(tabele.Items[i])
				end
			end
		end
	end
end

function PANEL:SwitchWith(other)
	local i = self.Item
	local o = other.Item
	self:SetItem(o)
	other:SetItem(i)

	pluto.inv.message()
		:write("tabswitch", self.Tab.ID, self.TabIndex, other.Tab.ID, other.TabIndex)
		:send()
end

function PANEL:GhostClick(p, m)
	if (m == MOUSE_LEFT and p.ClassName == "pluto_inventory_garbage") then
		if (self.Tab.ID == 0) then
			local p = vgui.Create "pluto_falling_text"
			p:SetText "You cannot delete the buffer items on the bottom row! They will delete themselves"
			p:SetPos(gui.MousePos())
		end
		return self.Tab.ID ~= 0
	end

	if (m == MOUSE_LEFT and p.ClassName == "pluto_inventory_item" and self.Tab) then
		local parent = self
		local gparent = p

		local can, err = pluto.canswitchtabs(parent.Tab, gparent.Tab, parent.TabIndex, gparent.TabIndex)

		if (not can) then
			pwarnf("err: %s", err)
			return false
		end

		if (self.Tab.ID == 0 and gparent.Tab.Items) then
			local oi = gparent.Tab.Items[gparent.TabIndex]

			if (oi) then
				return
			end

			pluto.inv.message()
				:write("claimbuffer", parent.Item.BufferID, gparent.Tab.ID, gparent.TabIndex)
				:send()

			table.remove(pluto.buffer, parent.TabIndex)

			for i = parent.TabIndex, 5 do
				self:GetParent().Items[i]:SetItem(pluto.buffer[i])
			end
		elseif (gparent.Tab.ID ~= 0) then
			self:SwitchWith(gparent)
		end
	end
	pluto.ui.ghost = nil

	return false
end

function PANEL:PerformLayout(w, h)
	self:SetCurve(curve(0))
	local p = curve(0) / 2
	--self:DockPadding(p, p, p, p)
end

function PANEL:Think()
	if (self.Item and self.Item.Version ~= self.showcase_version and IsValid(self.showcasepnl)) then
		self:Showcase(self.Item)
	end
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
		self.Items[i]:SetItem(tab.Items[i], tab)
	end
end

vgui.Register("pluto_inventory_items", PANEL, "pluto_inventory_base")

local PANEL = {}
DEFINE_BASECLASS "pluto_inventory_base"
function PANEL:Init()
	BaseClass.Init(self)

	self.Items = {}

	self.Left = self:Add "EditablePanel"
	self.Left:Dock(LEFT)
	self.Right = self:Add "EditablePanel"
	self.Right:Dock(RIGHT)

	for i = 1, 12, 2 do
		local p = self.Left:Add "pluto_inventory_item"
		p.TabIndex = i
		self.Items[i] = p
		p:Dock(TOP)
	end

	for i = 2, 12, 2 do
		local p = self.Right:Add "pluto_inventory_item"
		p.TabIndex = i
		self.Items[i] = p
		p:Dock(TOP)
	end

	self.PlayerModel = self:Add "ttt_curved_panel"
	self.PlayerModel:SetColor(Color(0,0,0,100))

	self.Items[1]:SetDefault "weapon_ttt_m4a1"

	self.Items[2]:SetDefault "weapon_ttt_pistol"
end

function PANEL:PerformLayout(w, h)
	local size = math.Round(w / (count + 2))
	local divide = (w - size * count) / (count + 2)
	self.PlayerModel:SetTall(h - divide * 3)
	self.PlayerModel:SetWide(size * 3)
	self.PlayerModel:Center()

	for i, item in ipairs(self.Items) do
		item:SetSize(size, size)
		item:DockMargin(0,  i <= 2 and 0 or divide / 2, 0, divide / 2)
	end

	self.Left:SetWide(size)
	self.Right:SetWide(size)


	self:DockPadding(divide * 1.5, divide * 1.5, divide * 1.5, divide * 1.5)
end

function PANEL:SetTab(tab)
	for i, item in ipairs(self.Items) do
		item:SetItem(tab.Items[i], tab)
	end
end

vgui.Register("pluto_inventory_equip", PANEL, "pluto_inventory_base")

local PANEL = {}
DEFINE_BASECLASS "ttt_curved_panel_outline"

function PANEL:Init()
	self.Image = self:Add "DImage"
	--self.Image:Dock(FILL)
	local paint = self.Image.Paint
	self.Image.Paint = function(self, w, h)
		if (self:GetParent() ~= pluto.ui.ghost or self:GetParent().paintover) then
			paint(self, w, h)
		end
	end
	-- self:SetColor(ColorAlpha(light_color, 200))
	self.Image:SetImage "pluto/currencies/goldenhand.png"
	self:SetCursor "hand"
	self.HoverAnim = 0.05
	self.HoverTime = SysTime() - self.HoverAnim
	self.Hovered = true -- idk whatever
end

function PANEL:OnMousePressed(mouse)
	if (pluto.cl_currency[self.Currency] > 0) then
		local curtype = pluto.currency.byname[self.Currency]
		if (curtype and curtype.NoTarget) then
			Derma_Query("Really use " .. curtype.Name .. "? " .. curtype.Description, "Confirm use", "Yes", function()
				pluto.inv.message()
					:write("currencyuse", self.Currency)
					:send()
			end, "No", function() end)
		else
			pluto.ui.ghost = self
		end
	end
end

function PANEL:ToggleHover()
	self.HoverTime = SysTime() - self.HoverAnim * (1 - math.Clamp((SysTime() - self.HoverTime) / self.HoverAnim, 0, 1))
	self.Hovered = not self.Hovered
end

function PANEL:GetHoverPercent()
	if (self == pluto.ui.ghost and pluto.ui.ghost.paintover) then
		return 1
	end

	local pct = math.Clamp((SysTime() - self.HoverTime) / self.HoverAnim, 0, 1)
	if (self.Hovered) then
		pct = 1 - pct
	end

	return pct
end

function PANEL:OnCursorExited()
	self:ToggleHover()
	self:OnRemove()
end

function PANEL:OnCursorEntered()
	self:Showcase()
	self:ToggleHover()
end

function PANEL:Think()
	local width_biggening = self:GetWide() / 5
	local size = self:GetWide() - width_biggening + width_biggening * (pluto.cl_currency[self.Currency] <= 0 and 0 or self:GetHoverPercent())

	self.Image:SetSize(size, size)
	self.Image:Center()
end

function PANEL:SetCurrency(cur)
	self.Currency = cur
	self.Image:SetImage(pluto.currency.byname[cur].Icon)
end

function PANEL:GhostClick(p)
	if (p.Item) then
		if (not p.Item.ID) then
			-- TODO(meep): popup thingy
			return
		end
		pluto.inv.message()
			:write("currencyuse", self.Currency, p.Item)
			:send()
	end
	if (not input.IsKeyDown(KEY_LSHIFT)) then
		pluto.ui.ghost = nil
	end
	return false
end

function PANEL:PaintAt(x, y)
	self.Image:PaintAt(x, y)
end

function PANEL:Showcase()
	self.showcasepnl = pluto.ui.showcase(pluto.currency.byname[self.Currency])
	self.showcasepnl:SetPos(self:LocalToScreen(self:GetWide(), 0))
end

function PANEL:OnRemove()
	if (IsValid(self.showcasepnl)) then
		self.showcasepnl:Remove()
	end
end

vgui.Register("pluto_inventory_currency_image", PANEL, "EditablePanel")

local PANEL = {}

function PANEL:Init()
	self.Background = self:Add "ttt_curved_panel"

	self.Image = self:Add "pluto_inventory_currency_image"

	self.Background:Dock(BOTTOM)
	local pad = curve(0)
	self.Background:DockPadding(pad / 2, pad / 2, pad / 2, pad / 2)
	self.Background:SetCurve(pad)
	self.Background:SetColor(light_color)

	self.Text = self.Background:Add "DLabel"

	self.Text:Dock(FILL)
	self.Text:SetContentAlignment(3)
	self.Text:SetText "0"
end

function PANEL:Think()
	self.Text:SetText(tostring(pluto.cl_currency[self.Currency] or 0))
end

local LastHeight = 0

function PANEL:PerformLayout(w, h)
	self.Background:SetTall(h * 0.7)

	if (LastHeight ~= h) then
		surface.CreateFont("pluto_inventory_currency", {
			font = "Roboto",
			size = math.floor(math.max(h * 0.45, 16) / 2) * 2,
		})
	end

	self.Text:SetFont "pluto_inventory_currency"

	local edge = 0.02
	h = h
	self.Image:SetSize(h * (1 - edge * 2), h * (1 - edge * 2))
	self.Image:SetPos(h * (edge + 0.1), h * edge)
end

function PANEL:SetCurrency(cur)
	self.Currency = cur
	self.Image:SetCurrency(cur)
end

vgui.Register("pluto_inventory_currency", PANEL, "EditablePanel")

local PANEL = {}

DEFINE_BASECLASS "pluto_inventory_base"
function PANEL:Init()
	BaseClass.Init(self)
	
	self.Layout = self:Add "DIconLayout"
	self.Layout:Dock(FILL)

	self.Currencies = {}

	for _, item in ipairs(pluto.currency.list) do
		local p = self.Layout:Add "pluto_inventory_currency"
		p:SetCurrency(item.InternalName)
		self.Currencies[item.InternalName] = p
	end
end

function PANEL:PerformLayout(w, h)
	local count = 3
	local d = 1
	local size = math.floor(w / (count + d) / count) * count
	local divide = size / (count + 2)

	for _, item in pairs(self.Currencies) do
		item:SetSize(size, size * 0.4)
	end

	self.Layout:SetSpaceX(divide)
	self.Layout:SetSpaceY(divide)

	self:DockPadding(divide * 1.5, divide * 1.5, divide * 1.5, divide * 1.5)
end

function PANEL:SetTab(tab)
end

vgui.Register("pluto_inventory_currencies", PANEL, "pluto_inventory_base")

local PANEL = {}

function PANEL:Init()
	self:SetCurve(curve(2))
	self:SetColor(bg_color)
end

vgui.Register("pluto_inventory_base", PANEL, "ttt_curved_panel")

local PANEL = {}
function PANEL:Init()
	self.Tab = self:GetParent().Tab

	self:SetText(self.Tab.Name)
	self:SetFont "pluto_inventory_tab"
	self:SetSkin "tttrw"
	self:DockMargin(pad - 4, 0, pad - 4, 0)

	pluto.ui.pnl:SetKeyboardInputEnabled(true)
end

function PANEL:AllowInput(t)
	local t = self:GetText() .. t
	if (utf8.len(t) > 16) then
		return true
	end
	self:GetParent():SetText(t)
	return false
end

function PANEL:OnFocusChanged(gained)
	if (not gained) then
		self:GetParent():SetText(self:GetText())
		pluto.inv.message()
			:write("tabrename", self.Tab.ID, self:GetText())
			:send()

		local p = self:GetParent()
		self:Remove()
		pluto.ui.pnl:SetKeyboardInputEnabled(false)
	end
end

vgui.Register("pluto_inventory_rename_tab", PANEL, "DTextEntry")

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
	self.Text:SetZPos(0)
end
function PANEL:SetText(t)
	self.Text:SetText(t)
	surface.SetFont(self.Text:GetFont())
	local w = surface.GetTextSize(t)
	self.Text:SetWide(w + pad * 2)
end
function PANEL:OnMousePressed(key)
	self:DoClick()
	if (key == MOUSE_RIGHT) then
		self.Entry = self:Add "pluto_inventory_rename_tab"
		self.Entry:Dock(FILL)
		self.Entry:SetZPos(1)
		self.Entry:RequestFocus()
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

	local tabtype = pluto.tabs[tab.Type] or {element = "pluto_invalid_tab"}

	pprintf("Creating tab %s (%s)...", tab.Type, tabtype.element)

	self.Items = self:Add(tabtype.element)
	self.Items:SetVisible(false)
	if (not IsValid(self.Items)) then
		self.Items = self:Add "pluto_invalid_tab"
	end
	self.Items:Dock(TOP)
	self.Items:SetZPos(1)
	self.Items:SetTab(tab)

	tab.CurrentElement = self.Items
	tab.CurrentParent = self

	self.Tab = tab
end

vgui.Register("pluto_inventory_tab", PANEL, "pluto_inventory_base")

local PANEL = {}

function PANEL:Init()
	self.Tabs = {}
	self.CurPos = 0
end

function PANEL:SetTab(tab)
	self:GetParent():SetTab(tab)
end

function PANEL:SetTabs(tabs)
	for _, tab in SortedPairsByMemberValue(tabs, "ID") do
		self:AddTab("pluto_inventory_tab", tab)
	end
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

function PANEL:AddTab(class, tabt)
	local tab = self:Add(class)
	tab:SetTab(tabt)
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

	--self.Controller = self:Add "pluto_inventory_tab_selector"
	--self.Controller:Dock(RIGHT)
	--self.Controller:DockMargin(pad / 2, 0, 0, 0)

	self:DockMargin(curve(2), 0, curve(2), 0)
end

function PANEL:SetTab(tab)
	self:GetParent():SetTab(tab)
end

function PANEL:SetTabs(tabs)
	self.Tabs:SetTabs(tabs)
end

vgui.Register("pluto_inventory_tab_controller", PANEL, "EditablePanel")

local PANEL = {}
function PANEL:Init()
	self.Label = self:Add "DLabel"
	self.Label:Dock(FILL)
	self.Label:SetFont "BudgetLabel"
	self.Label:SetText "INVALID TAB"
	self.Label:SetContentAlignment(5)
end

function PANEL:SetTab(tab)
	self.Label:SetText("INVALID TAB: " .. tab.Type)
end

vgui.Register("pluto_invalid_tab", PANEL, "pluto_inventory_base")

local PANEL = {}
DEFINE_BASECLASS "DImage"

function PANEL:OnMousePressed(mouse)
	if (IsValid(pluto.ui.ghost)) then
		-- assume is inventory item
		self.Deleting = {
			TabID = pluto.ui.ghost.TabID,
			TabIndex = pluto.ui.ghost.TabIndex,
			Item = pluto.ui.ghost.Item.ID,
			Time = CurTime(),
			EndTime = CurTime() + 2,
		}
	else
		local p = vgui.Create "pluto_falling_text"
		p:SetText "Hold an item on this to delete it!"
		p:SetPos(gui.MousePos())
	end
end

function PANEL:Think()
	if (IsValid(pluto.ui.ghost) and self.Deleting) then
		if (self.Deleting.EndTime < CurTime()) then

			pluto.inv.message()
				:write("itemdelete", self.Deleting.TabID, self.Deleting.TabIndex, self.Deleting.Item)
				:send()

			pluto.cl_inv[self.Deleting.TabID].Items[self.Deleting.TabIndex] = nil

			pluto.ui.ghost:SetItem(nil)

			self:StopIfDeleting()
		end
	end
end
function PANEL:StopIfDeleting()
	if (self.Deleting) then
		local pct = (CurTime() - self.Deleting.Time) / (self.Deleting.EndTime - self.Deleting.Time)

		if (pct <= 0.1) then
			local p = vgui.Create "pluto_falling_text"
			p:SetText "Hold the item down to delete it!"
			p:SetPos(gui.MousePos())
		end

		pluto.ui.ghost = nil
		self.Deleting = nil
	end
end

function PANEL:GhostMove(p, x, y, w, h)

	if (self.Deleting) then
		local pct = (CurTime() - self.Deleting.Time) / (self.Deleting.EndTime - self.Deleting.Time)

		x = x + (math.random() - 0.5) * pct * w * 0.25
		y = y + (math.random() - 0.5) * pct * h * 0.25
	end

	return x, y
end

function PANEL:GhostPaint(p, x, y, w, h)
	if (self.Deleting) then
		local pct = (CurTime() - self.Deleting.Time) / (self.Deleting.EndTime - self.Deleting.Time)

		local midx, midy = x + w / 2, y + h / 2

		render.SetScissorRect(midx - w / 2 * pct, midy - h / 2 * pct, midx + w / 2 * pct, midy + h / 2 * pct, true)
		surface.SetDrawColor(255,0,0,200)
		surface.DrawRect(x, y, w, h)
		render.SetScissorRect(0, 0, 0, 0, false)
	end
end

function PANEL:OnMouseReleased(mouse)
	self:StopIfDeleting()
end
function PANEL:OnCursorExited()
	self:StopIfDeleting()
end

function PANEL:Paint(w, h)
	local x, y = 8, 8

	w = w - x * 2
	h = h - y * 2

	local ow, oh = w, h
	local im_w, im_h = self.Image:GetInt "$realwidth", self.Image:GetInt "$realheight"

	if (not im_w) then
		surface.SetDrawColor(0, 255, 0, 255)
		surface.DrawRect(0, 0, w, h)
		return
	end

	if (im_w > im_h) then
		h = h * (im_h / im_w)
		y = y + (oh - h) / 2
	elseif (im_h > im_w) then
		w = w * (im_w / im_h)
		x = x + (ow - w) / 2
	end

	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(self.Image)

	surface.DrawTexturedRect(x, y, w, h)
end

function PANEL:Init()
	self.Image = Material "materials/pluto/trashcan_128.png"
end

vgui.Register("pluto_inventory_garbage", PANEL, "EditablePanel")

local PANEL = {}

function PANEL:Init()
	self.Garbage = self:Add "pluto_inventory_garbage"
	self.Garbage:Dock(RIGHT)

	self.Items = {}

	self.FakeTab = {
		ID = 0,
		Active = true,
		Items = pluto.buffer,
	}

	for i = 1, 5 do
		local t = self:Add "pluto_inventory_item"
		t:Dock(RIGHT)
		t.TabIndex = i
		t:SetItem(pluto.buffer[i], self.FakeTab)

		self.Items[i] = t
	end

	self.Items[6] = self.Garbage
end

function PANEL:PerformLayout(w, h)
	local size = math.Round(w / (count + 2))
	local divide = (w - size * count) / (count + 2)

	for i, item in ipairs(self.Items) do
		item:SetSize(size, size)
		local left, right = divide / 2, divide / 2
		if (i == 0) then
			left = 0
		elseif (i == 6) then
			right = 0
		end
		item:DockMargin(left, 0, right, 0)
	end

	self:DockPadding(divide * 1.5, (h - size) / 2, divide * 1.5, (h - size) / 2)
end

vgui.Register("pluto_inventory_bar", PANEL, "pluto_inventory_base")

local PANEL = {}

function PANEL:Init()
	self.Tabs = self:Add "pluto_inventory_tab_controller"
	self.Tabs:Dock(TOP)
	self.Tabs:SetZPos(0)
	self.Close = self:Add "ttt_close_button"
	self.Close:SetSize(24, 24)
	self.Close:SetColor(Color(37, 173, 125))
end

function PANEL:SetTab(tab)
	if (IsValid(self.Items)) then
		self.Items:SetParent(self.Tab.CurrentParent)
		self.Items:SetVisible(false)
		self.Tab.Active = false
	end

	self.Items = tab.CurrentElement
	self.Items:SetParent(self)
	self.Items:SetVisible(true)

	self.Tab = tab
	tab.Active = true
end

function PANEL:SetTabs(tabs)
	self.Tabs:SetTabs(tabs)
end

function PANEL:SetWhere(leftright)
	self.Where = leftright

	if (not self.Where) then
		self.Close:Remove()
	end
end

function PANEL:PerformLayout(w, h)
	local real_h = h
	w = w - w * 0.07
	h = h - w * 0.07

	self.Items:SetTall(w)

	self.Tabs:SetTall(real_h - h)

	pad = w * 0.05
	local smol_pad = pad * 2 / 3
	if (self.Where ~= nil) then
		self:DockPadding(self.Where and smol_pad or pad, smol_pad, self.Where and pad or smol_pad, 0)
	else
		self:DockPadding(pad, smol_pad, pad, 0)
	end

	if (IsValid(self.Close)) then
		self.Close:SetPos(self:GetWide() - self.Close:GetWide() * 1.5, self.Close:GetWide() * 0.5)
	end
end

vgui.Register("pluto_inventory_control", PANEL, "EditablePanel")

local PANEL = {}
function PANEL:Init()
	self:SetColor(Color(13, 12, 12, 220))
	self:SetCurve(curve(3))

	self.Control1 = self:Add "pluto_inventory_control"
	self.Control1:Dock(FILL)
	self.Control1:SetZPos(0)

	local w = math.floor(math.min(500, math.max(400, ScrW() / 3)) / 2) * 2
	local real_w = w
	local h = w * 1.2

	if (ScrW() >= 800) then
		w = math.min(w * 2, ScrW())
		self.Control2 = self:Add "pluto_inventory_control"
		self.Control1:SetWhere(true)
		self.Control2:SetWhere(false)

		local tabs1, tabs2 = {}, {}

		for k, tab in pairs(pluto.cl_inv) do
			local d = tabs1
			if (tab.Type == "equip" or tab.Type == "currency") then
				d = tabs2
			end

			d[#d + 1] = tab
		end

		self.Control1:SetTabs(tabs1)
		self.Control2:SetTabs(tabs2)

		self.Control2:Dock(LEFT)
		self.Control2:SetWide(w / 2)
		self.Control2:SetZPos(2)
	else
		self.Control1:SetTabs(pluto.cl_inv)
	end

	self:SetSize(w, h)
	self:Center()
	self:InvalidateChildren(true)

	self:MakePopup()
	self:SetPopupStayAtBack(true)
	self:SetKeyboardInputEnabled(false)

	self.Bottom = self:Add "EditablePanel"
	self.Bottom:Dock(BOTTOM)
	self.Bottom:SetTall(h * 0.15)
	self.Bottom:InvalidateParent(true)

	self.ControlBar = self.Bottom:Add "pluto_inventory_bar"
	self.ControlBar:SetZPos(1)
	pad = real_w * 0.05
	local smol_pad = pad * 2 / 3
	self.ControlBar:SetTall(self.Bottom:GetTall() - smol_pad)
	self.ControlBar:SetWide(real_w - pad - smol_pad)
	self.ControlBar:Center()
end

vgui.Register("pluto_inventory", PANEL, "ttt_curved_panel")


if (IsValid(pluto.ui.pnl)) then
	pluto.ui.pnl:Remove()
	pluto.ui.pnl = vgui.Create "pluto_inventory"
end

hook.Add("PlayerButtonDown", "pluto_inventory_ui", function(_, key)
	if (IsFirstTimePredicted() and key == KEY_I) then
		if (IsValid(pluto.ui.pnl)) then
			pluto.ui.pnl:Remove()
		else
			pluto.ui.pnl = vgui.Create "pluto_inventory"
		end
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

function PANEL:PerformLayout(w, h)
	self:DoLayout(w, h)
end

function PANEL:DoLayout(_w, _h)
	local text = self.Text or "Label"
	if (self.LastText == text and self.LastWide == _w) then
		return
	end
	self.LastText = text
	self.LastWide = _w
	for _, child in pairs(self.Children) do
		child:Remove()
	end

	self.Children = {}

	local cur = {}
	surface.SetFont(self.Font)
	self.Tall = 0

	for word in text:gmatch("([^%s]+)%s*") do
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
	self:DoLayout(self:GetSize())
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

function PANEL:AddMod(mod)
	local z = self.ZPos or 3

	local pnl = self:Add "EditablePanel"
	pnl:SetZPos(z)
	pnl:Dock(TOP)

	local p = pnl:Add "DLabel"
	p:SetFont "pluto_item_showcase_smol"
	p:SetText(mod.Name .. " " .. ToRomanNumerals(mod.Tier))
	p:SetTextColor(white_text)
	p:Dock(LEFT)
	p:SetContentAlignment(7)
	p:SetZPos(0)

	pnl.Label = p

	local p = pnl:Add "DLabel"
	p:SetFont "pluto_item_showcase_desc"
	p:SetTextColor(white_text)
	p:SetWrap(true)
	p:SetAutoStretchVertical(true)
	p:Dock(RIGHT)
	p:SetZPos(1)
	p:SetText(mod.Desc)

	pnl.Desc = p

	function pnl.Desc:PerformLayout(w, h)
		self:GetParent():SetTall(h)
		self:GetParent():GetParent():Resize()
	end

	function pnl:PerformLayout(w, h)
		self.Label:SetWide(w / 4)
		self.Desc:SetWide(math.Round(w * 3 / 5))
	end

	self.ZPos = z + 1
	self.Last = pnl

	return pnl
end

function PANEL:SetItem(item)
	self.ItemName:SetTextColor(color_black)
	if (item.ClassName) then -- item
		self.ItemName:SetText(item.Tier .. " " .. weapons.GetStored(item.ClassName).PrintName)
		self.ItemName:SetContentAlignment(4)
	else -- currency???
		self.ItemName:SetText(item.Name)
		self.ItemName:SetContentAlignment(5)
	end

	self.ItemName:SizeToContentsY()
	self.ItemBackground:SetTall(self.ItemName:GetTall() * 1.5)
	local pad = self.ItemName:GetTall() * 0.25
	self.ItemBackground:DockPadding(pad, pad, pad, pad)
	self.ItemBackground:SetColor(item.Color)

	self.ItemDesc:SetText(item.Description or "")
	self.ItemDesc:DockMargin(0, pad, 0, pad / 2)

	self.ItemSubDesc:SetText(item.SubDescription or "")
	if (self.ItemSubDesc:GetText() ~= "") then
		self.ItemSubDesc:DockMargin(0, pad / 2, 0, pad)
	end

	self.Last = self.ItemSubDesc

	if (item.Mods and item.Mods.prefix) then
		for _, mod in ipairs(item.Mods.prefix) do
			self:AddMod(mod):DockMargin(pad, pad / 2, pad, pad / 2)
		end
	end

	if (item.Mods and item.Mods.suffix) then
		for _, mod in ipairs(item.Mods.suffix) do
			self:AddMod(mod):DockMargin(pad, pad / 2, pad, pad / 2)
		end
	end

	self:InvalidateLayout(true)
	self:InvalidateChildren(true)

	self:Resize()
end

function PANEL:Resize()
	self:SizeToChildren(true, true)
	self:SetTall(self:GetTall() + pad / 2)
	self:GetParent():SizeToChildren(true, true)
end

local h = 720

surface.CreateFont("pluto_item_showcase_header", {
	font = "Lato",
	extended = true,
	size = math.max(30, h / 28),
	weight = 1000,
})

surface.CreateFont("pluto_item_showcase_desc", {
	font = "Roboto",
	extended = true,
	size = math.max(20, h / 35)
})

surface.CreateFont("pluto_item_showcase_smol", {
	font = "Roboto",
	extended = true,
	size = math.max(h / 50, 16),
	italic = true,
})

function PANEL:Init()
	local w = math.min(500, math.max(400, ScrW() / 3))
	pad = w * 0.05

	self:SetColor(bg_color)
	self.ItemBackground = self:Add "ttt_curved_panel"
	self.ItemBackground:SetCurve(curve(0))
	self.ItemBackground:Dock(TOP)

	self.ItemName = self.ItemBackground:Add "DLabel"
	self.ItemName:Dock(FILL)
	self.ItemName:SetFont "pluto_item_showcase_header"

	self.ItemDesc = self:Add "pluto_centered_wrap"
	self.ItemDesc:SetFont "pluto_item_showcase_desc"
	self.ItemDesc:Dock(TOP)

	self.ItemSubDesc = self:Add "pluto_centered_wrap"
	self.ItemSubDesc:SetFont "pluto_item_showcase_smol"
	self.ItemSubDesc:Dock(TOP)
end

vgui.Register("pluto_item_showcase_inner", PANEL, "ttt_curved_panel")

local PANEL = {}

function PANEL:Init()
	self.Inner = self:Add "pluto_item_showcase_inner"
	self.Inner:Dock(FILL)
	self:SetCurve(curve(0))
	self:SetColor(color_black)
	local pad = curve(0) / 2
	self.Inner:SetCurve(pad)
	self:DockPadding(pad, pad, pad, pad)
end

function PANEL:SetItem(item)
	self:SetWide(math.max(300, math.min(600, ScrW() / 3)))
	self.Inner:SetWide(math.max(300, math.min(500, ScrW() / 3)))
	self.Inner:SetItem(item)
end

vgui.Register("pluto_item_showcase", PANEL, "ttt_curved_panel_outline")

function pluto.ui.showcase(item)
	if (IsValid(pluto.ui.showcasepnl)) then
		pluto.ui.showcasepnl:Remove()
	end

	pluto.ui.showcasepnl = vgui.Create "pluto_item_showcase"
	pluto.ui.showcasepnl:MakePopup()
	pluto.ui.showcasepnl:SetKeyboardInputEnabled(false)
	pluto.ui.showcasepnl:SetMouseInputEnabled(false)

	pluto.ui.showcasepnl:SetItem(item)

	return pluto.ui.showcasepnl
end

local PANEL = {}

function PANEL:Init()
	self.Text = self:Add "pluto_centered_wrap"
	self.Text:SetFont "pluto_item_showcase_desc"
	self.Text:Dock(TOP)
	self.Text:SetTextColor(color_white)
	local pad = pad / 2
	self:DockPadding(pad, pad, pad, pad)
	self:SetWide(200)
	function self.Text:PerformLayout(w, h)
		self:SetWide(self:GetParent():GetWide() - pad * 2)
		self:GetParent():SetTall(h + pad * 2)
		self:DoLayout(self:GetSize())
	end
	self.Start = CurTime()
	self.Ends = CurTime() + 2
	self:SetCurve(4)

	self:MakePopup()
	self:SetKeyboardInputEnabled(false)
	self:SetMouseInputEnabled(false)
end

function PANEL:SetText(t)
	self.Text:SetText(t)
end

function PANEL:Think()
	self.OriginalY = self.OriginalY or select(2, self:GetPos())
	local frac = (self.Ends - CurTime()) / (self.Ends - self.Start)
	if (frac <= 0) then
		self:Remove()
	end
	local x, y = self:GetPos()
	self:SetPos(x, self.OriginalY + 100 * (1 - frac))
	self:SetColor(Color(17, 15, 13, frac * 255))
	self.Text:SetTextColor(ColorAlpha(white_text, frac * 255))
end

vgui.Register("pluto_falling_text", PANEL, "ttt_curved_panel")

hook.Add("PostRenderVGUI", "pluto_ghost", function()
	if (IsValid(pluto.ui.ghost)) then
		local p = pluto.ui.ghost

		if ((input.IsMouseDown(MOUSE_RIGHT) or input.IsMouseDown(MOUSE_LEFT)) and not IsValid(vgui.GetHoveredPanel())) then
			pluto.ui.ghost = nil
			return
		end

		local hover = vgui.GetHoveredPanel()

		local w, h = p:GetSize()
		local x, y = gui.MousePos()
		x = x - w / 2
		y = y - h / 2

		if (IsValid(hover) and hover.GhostMove) then
			x, y = hover:GhostMove(p, x, y, w, h)
		end

		local b

		if (p.SetScissor) then
			b = p:GetScissor()
			p:SetScissor(false)
		end

		local mi, ki = p:IsMouseInputEnabled(), p:IsKeyboardInputEnabled()

		pluto.ui.ghost.paintover = true
		p:PaintAt(x, y) -- this resets mouseinput / keyboardinput???
		pluto.ui.ghost.paintover = false
		p:SetMouseInputEnabled(mi)
		p:SetKeyboardInputEnabled(ki)

		if (IsValid(hover) and hover.GhostPaint) then
			hover:GhostPaint(p, x, y, w, h)
		end

		if (p.SetScissor) then
			p:SetScissor(b)
		end
	end
end)

hook.Add("VGUIMousePressAllowed", "pluto_ghost", function(mouse)
	if (IsValid(pluto.ui.ghost)) then
		local g = pluto.ui.ghost

		local hover = vgui.GetHoveredPanel()

		if (g.GhostClick and hover.ClassName ~= "pluto_inventory_tab") then
			return not g:GhostClick(hover, mouse)
		end
	end
end)