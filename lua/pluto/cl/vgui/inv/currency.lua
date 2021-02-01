local circles = include "pluto/thirdparty/circles.lua"

local inactive_color = Color(58, 60, 68)
local active_color   = Color(64, 66, 74)

local padding_x = 23
local padding_y = 5

local PANEL = {}

function PANEL:Init()
	self.UpperArea = self:Add "EditablePanel"
	self.UpperArea:Dock(TOP)
	self.UpperArea:SetTall(22)

	self.Inner = self:Add "pluto_inventory_component"
	self.Inner:Dock(FILL)
	self.Inner:SetCurveTopLeft(false)

	local old_layout = self.Inner.PerformLayout
	function self.Inner.PerformLayout(s, w, h)
		if (old_layout) then
			old_layout(s, w, h)
		end

		for _, tab in pairs(self.Tabs) do
			tab:SetSize(padding_x * 3 + 48 * 4, h - 24)
			tab:SetPos(w / 2 - tab:GetWide() / 2, 12)
		end
	end

	self.Tabs = {}

	self.CurrencyDone = {}

	self:AddTab "Modify"
	self:AddTab("Item Boxes", false, true)
	self:AddTab("Misc.", true)
end

function PANEL:AddTab(text, add_rest, buffer)
	local curve = self.UpperArea:Add "ttt_curved_panel"
	curve:Dock(LEFT)
	curve:SetWide(100)
	curve:DockPadding(0, 4, 0, 3)
	curve:SetCurveBottomRight(false)
	curve:SetCurveBottomLeft(false)
	curve:SetMouseInputEnabled(true)

	curve.Label = curve:Add "pluto_label"
	curve.Label:SetFont "pluto_inventory_font"
	curve.Label:SetRenderSystem(pluto.fonts.systems.shadow)
	curve.Label:SetTextColor(Color(255, 255, 255))
	curve.Label:SetText(text)
	curve.Label:SetContentAlignment(5)
	curve.Label:SizeToContentsX()
	curve:SetWide(curve.Label:GetWide() + 24)
	curve.Label:Dock(FILL)

	curve:SetCursor "hand"
	curve:DockMargin(0, 0, 8, 0)

	self.Tabs[curve] = self.Inner:Add "EditablePanel"
	if (not self.ActiveTab) then
		curve:SetColor(active_color)
		self.ActiveTab = curve
		self.Tabs[curve]:SetVisible(true)
	else
		curve:SetColor(inactive_color)
		self.Tabs[curve]:SetVisible(false)
	end

	function curve.OnMousePressed(s, m)
		if (m == MOUSE_LEFT) then
			if (IsValid(self.ActiveTab)) then
				self.ActiveTab:SetColor(inactive_color)
				self.Tabs[self.ActiveTab]:SetVisible(false)
			end
			self.Storage:SwapToBuffer(buffer)
			s:SetColor(active_color)
			self.Tabs[s]:SetVisible(true)
			self.ActiveTab = s
		end
	end

	local current = self.Tabs[curve]

	local current_row
	local function createrow()
		current_row = current:Add "EditablePanel"
		current_row:Dock(TOP)
		current_row:SetTall(64)
		current_row:DockMargin(0, 0, 0, 12)
		current_row.Count = 0
	end
	createrow()

	local amount = 0

	for _, cur in ipairs(pluto.currency.list) do
		if (cur.Fake) then
			continue
		end

		if (add_rest and not self.CurrencyDone[cur.InternalName] or cur.Category == text) then
			self.CurrencyDone[cur.InternalName] = true
			current_row.Count = current_row.Count + 1
			local item = current_row:Add "pluto_inventory_currency_item"
			item:Dock(LEFT)
			item:DockMargin(0, 0, padding_x, 0)
			item:SetCurrency(cur)

			if (current_row.Count >= 4) then
				createrow()
			end
		end
	end
end

function PANEL:SetCurve(curve)
	self.Inner:SetCurve(curve)

	for tab in pairs(self.Tabs) do
		tab:SetCurve(curve)
	end
end

function PANEL:SetColor(col)
	self.Inner:SetColor(col)
end

function PANEL:OnRemove()
	if (not IsValid(self.Storage)) then
		return
	end

	self.Storage:SwapToBuffer(false)
end

vgui.Register("pluto_inventory_currency", PANEL, "EditablePanel")

local PANEL = {}

function PANEL:Init()
	self:SetSize(48, 64)
	self.Container = self:Add "ttt_curved_panel_outline"
	self.Container:SetCurve(2)
	self.Container:SetColor(Color(95, 96, 102))
	self.Container:Dock(BOTTOM)
	self.Container:SetTall(16)
	self:SetCursor "hand"
end

function PANEL:SetCurrency(cur)
	self.Material = cur:GetMaterial()
	self.Currency = cur
end

local Circle = circles.New(CIRCLE_FILLED, {18, 4}, 24, 41)
Circle:SetDistance(3)

function PANEL:Paint(w, h)
	surface.SetDrawColor(45, 47, 53)
	draw.NoTexture()
	Circle()
	self:PaintInner(self, w, h, 0, 0)

	local x, y = self:ScreenToLocal(self.Container:LocalToScreen(self.Container:GetWide() / 2, self.Container:GetTall() / 2))
	local surface = pluto.fonts.systems.shadow

	local text = tostring(pluto.cl_currency[self.Currency.InternalName] or 0)
	surface.SetFont "pluto_inventory_font"
	surface.SetTextColor(255, 255, 255)
	local tw, th = surface.GetTextSize(text)
	surface.SetTextPos(x - tw / 2, y - th / 2)
	surface.DrawText(text)
end

function PANEL:PaintInner(pnl, w, h, x, y)
	surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial(self.Material)
	local pad = 6
	surface.DrawTexturedRect(x + pad, y, w - pad * 2, w - pad * 2)
end

function PANEL:GetPickupSize()
	return 48, 48
end

function PANEL:ItemSelected(item)
	if (not item) then
		return
	end

	if (self.Currency.ClientsideUse) then
		self.Currency.ClientsideUse(item)
	else
		pluto.inv.message()
			:write("currencyuse", self.Currency.InternalName, item)
			:send()
	end
end

function PANEL:OnMousePressed(m)
	if (m == MOUSE_LEFT) then
		local curtype = self.Currency
		if ((pluto.cl_currency[curtype.InternalName] or 0) <= 0) then
			return
		end
		if (curtype and curtype.NoTarget) then
			if (curtype.ClientsideUse) then
				curtype.ClientsideUse(self.Item)
			else
				Derma_Query("Really use " .. curtype.Name .. "? " .. curtype.Description, "Confirm use", "Yes", function()
					pluto.inv.message()
						:write("currencyuse", self.Currency.InternalName)
						:send()
				end, "No", function() end)
			end
		else
			pluto.ui.pickupcurrency(self.Currency)
		end
	end
end

vgui.Register("pluto_inventory_currency_item", PANEL, "EditablePanel")

function pluto.ui.pickupcurrency(item)
	pluto.ui.unsetpickup()

	pluto.ui.pickedupitem = vgui.Create "pluto_inventory_currency_item"
	pluto.ui.pickedupitem:SetPaintedManually(true)
	pluto.ui.pickedupitem:SetCurrency(item)
end


if (true) then
	return
end

for i = 1, 16 do
	surface.CreateFont("pluto_inventory_font" .. i, {
		font = "Roboto Lt",
		size = i,
		weight = 100,
	})
end

hook.Remove("DrawOverlay", "test", function()
	surface.SetDrawColor(0, 0, 0)
	surface.SetTextColor(255, 255, 255)
	surface.DrawRect(0, 0, ScrW() / 2, ScrH() / 2)
	local y = 2
	for i = 1, 16 do
		surface.SetFont("pluto_inventory_font" .. i)
		surface.SetTextPos(4, y)
		surface.DrawText(string.format("(%i): The quick brown fox jumps over the lazy dog", i))
		y = y + i + 4
	end
end)