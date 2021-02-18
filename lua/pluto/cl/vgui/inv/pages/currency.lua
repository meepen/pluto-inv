local last_active_tab = CreateConVar("pluto_last_currency_tab", "", FCVAR_ARCHIVE)
local circles = include "pluto/thirdparty/circles.lua"

local inactive_color = Color(35, 36, 43)
local active_color   = Color(64, 66, 74)

local active_text = Color(255, 255, 255)
local inactive_text = Color(128, 128, 128)

local padding_x = 23
local padding_y = 5

local PANEL = {}

DEFINE_BASECLASS "pluto_inventory_component_tabbed"
function PANEL:Init()
	self.CurrencyDone = {}

	self:AddTab(HexColor "ff1a1a", "Modify")
	self:AddTab(HexColor "7ef524", "Item Boxes", false, true)
	self:AddTab(HexColor "fcde1d", "Misc.", true)

	timer.Simple(0, function()
		if (not IsValid(self)) then
			return
		end
		self:SelectTab(last_active_tab:GetString())
	end)
end

function PANEL:AddTab(col, category, add_rest, buffer)
	local current = BaseClass.AddTab(self, category, function()
		if (buffer) then
			self.Storage:SwapToBuffer(true)
		end
		last_active_tab:SetString(category)
	end, col)

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

		if (not self.CurrencyDone[cur.InternalName] and (add_rest or cur.Category == category)) then
			self.CurrencyDone[cur.InternalName] = true
			current_row.Count = current_row.Count + 1
			local item = current_row:Add "pluto_inventory_currency_item"
			item:Dock(LEFT)
			item:DockMargin(0, 0, padding_x, 0)
			item:SetCurrency(cur)

			function item.SelectItemBox(_, cur)
				self:SelectItemBox(cur)
			end

			if (current_row.Count >= 4) then
				createrow()
			end
		end
	end

	if (buffer) then
		local opener = current:Add "EditablePanel"
		opener:Dock(BOTTOM)
		opener:SetTall(110)
		opener:DockPadding(14, 0, 14, 3)

		local image_container = opener:Add "EditablePanel"
		image_container:Dock(TOP)
		image_container:SetTall(56)
		image_container:DockPadding(0, 0, 0, 4)

		local image = image_container:Add "DImage"
		image:SetSize(56, 56)
		function image_container:PerformLayout(w, h)
			image:Center()
		end

		local open = opener:Add "ttt_curved_button"
		open:SetText ""
		open:Dock(BOTTOM)
		open:SetCurve(4)
		open:SetColor(Color(0, 0, 0))
		local text = open:Add "pluto_label"
		text:SetRenderSystem(pluto.fonts.systems.shadow)
		text:SetFont "pluto_inventory_font"
		text:SetText "Open"
		text:SetTextColor(Color(255, 255, 255))
		text:SetContentAlignment(5)
		text:Dock(FILL)
	
		local slider = opener:Add "DSlider"
		slider:Dock(BOTTOM)
		slider:DockMargin(7, 0, 7, 4)

		function open:DoClick()
			if (not opener.Currency) then
				return
			end

			local msg = pluto.inv.message()
			for i = 1, open.Amount do
				msg:write("currencyuse", opener.Currency.InternalName)
			end

			msg:send()
		end

		function slider:TranslateValues(x, y)
			if (opener.Currency) then
				local amt = x * math.min(pluto.cl_currency[opener.Currency.InternalName] or 0, 36)
				open.Amount = math.Round(amt)
				text:SetText("Open " .. open.Amount .. " " .. opener.Currency.Name)
			end
			return x, y
		end

		function self:SelectItemBox(currency)
			image:SetImage(currency.Icon)
			slider:SetSlideX(0)
			open:SetColor(currency.Color)
			text:SetText("Open 1 " .. currency.Name)
			opener.Currency = currency
			open.Amount = 1
		end
	end
end

function PANEL:OnRemove()
	if (not IsValid(self.Storage)) then
		return
	end

	self.Storage:SwapToBuffer(false)
end

vgui.Register("pluto_inventory_currency", PANEL, "pluto_inventory_component_tabbed")

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
	if (IsValid(pnl) and self == vgui.GetHoveredPanel()) then
		local wait = 1.5
		local timing = 1 - ((wait + CurTime()) % wait) / wait * 2
		local up_offset = (math.sin(timing * math.pi) + 1) / 2 * 15 * 0.25
		y = y + up_offset
	end
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
		if (pluto.ui.selectorcallback) then
			return pluto.ui.selectorcallback(curtype)
		end

		if ((pluto.cl_currency[curtype.InternalName] or 0) <= 0) then
			return
		end
		if (curtype and curtype.NoTarget) then
			if (curtype.Category == "Item Boxes") then
				self:SelectItemBox(curtype)
			elseif (curtype.ClientsideUse) then
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

function PANEL:OnRemove()
	if (pluto.ui.selectorcallback) then
		pluto.ui.selectorcallback(nil)
	end
end

vgui.Register("pluto_inventory_currency_item", PANEL, "EditablePanel")

function pluto.ui.pickupcurrency(item)
	pluto.ui.unsetpickup()

	pluto.ui.pickedupitem = vgui.Create "pluto_inventory_currency_item"
	pluto.ui.pickedupitem:SetPaintedManually(true)
	pluto.ui.pickedupitem:SetCurrency(item)
end

function pluto.ui.currencyselect(msg, fn)
	if (not IsValid(pluto.ui.pnl)) then
		return fn and fn(false)
	end

	if (pluto.ui.selectorcallback) then
		pluto.ui.selectorcallback(false)
	end

	pluto.ui.selectorcallback = function(cur)
		pluto.ui.selectorcallback, pluto.ui.selectormessage = nil, nil
		return fn(cur)
	end
	pluto.ui.selectormessage = msg or "Choose a currency"

	pluto.ui.pnl:ChangeToTab "Currency"
end