local PANEL = {}

function PANEL:Init()
	self:SetSize(48, 48)

	self.CurrencyArea = self:Add "EditablePanel"
	self.CurrencyArea:Dock(TOP)

	self.CurrencyArea:SetTall(48)

	self.InputArea = self:Add "ttt_curved_panel_outline"
	self.InputArea:Dock(FILL)
	self.InputArea:SetCurve(2)
	self.InputArea:SetColor(Color(95, 96, 102))
	self.InputArea:Dock(BOTTOM)
	self.InputArea:SetTall(16)

	self.InputAmount = self.InputArea:Add "pluto_label"
	self.InputAmount:SetContentAlignment(5)
	self.InputAmount:SetRenderSystem(pluto.fonts.systems.shadow)
	self.InputAmount:SetFont "pluto_inventory_font"
	self.InputAmount:SetText "?"
	self.InputAmount:SetTextColor(Color(255, 255, 255))
	self.InputAmount:Dock(FILL)
	self.InputAmount:DockMargin(2, 2, 3, 2)

	function self.InputArea.OnMousePressed()
		if (not self.AcceptingAmount) then
			return
		end
		
		local input = self.InputArea:Add "DTextEntry"
		input:Dock(FILL)
		pluto.ui.pnl:SetKeyboardInputEnabled(true)
		input:RequestFocus()
		input:SetUpdateOnType(true)

		function input.OnEnter()
			self.InputAmount:SetText(input:GetText())
			input:Remove()
			pluto.ui.pnl:SetKeyboardInputEnabled(false)
		end

		function input.OnFocusChanged(gained)
			if (not gained) then
				self.InputAmount:SetText(input:GetText())
				input:Remove()
				pluto.ui.pnl:SetKeyboardInputEnabled(false)
			end
		end
	end

	self:SetCursor "hand"

	self.InputArea:SetMouseInputEnabled(true)
	self.CurrencyArea:SetMouseInputEnabled(false)

	self.InputArea:SetCursor "beam"
end

function PANEL:ShowAmount(b)
	if (b) then
		self:SetTall(self:GetWide() + 16)
	else
		self:SetTall(self:GetWide())
	end
	self.ShowingAmount = b
end

function PANEL:AcceptAmount(b)
	self.AcceptingAmount = b
	if (b) then
		self:ShowAmount(true)
	end
end


function PANEL:AcceptInput(b)
	self.AllowInput = b
	self:SetCursor(b and "hand" or "arrow")
end

local circles = include "pluto/thirdparty/circles.lua"

function PANEL:Paint(w, h)
	h = (self.ShowingAmount and -16 or 0) + h

	local Circle = circles.New(CIRCLE_FILLED, {h / 3, 4}, w / 2, h - 7)
	Circle:SetDistance(3)

	surface.SetDrawColor(45, 47, 53)
	draw.NoTexture()
	Circle()

	self:PaintInner(self, w, h, 0, 0)
end

local question = Material "pluto/currencies/questionmark.png"

function PANEL:PaintInner(pnl, w, h, x, y)
	local pad = 6
	local size = math.min(w, h) - pad * 2

	surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial(self.Currency and self.Currency:GetMaterial() or question)
	if (IsValid(pnl) and self == vgui.GetHoveredPanel()) then
		local wait = 1.5
		local timing = 1 - ((wait + CurTime()) % wait) / wait * 2
		local up_offset = (math.sin(timing * math.pi) + 1) / 2 * 15 * 0.25
		y = y + up_offset
	end
	local rx, ry = x + w / 2 - size / 2, y + h / 2 - size / 2
	surface.DrawTexturedRect(rx, ry, size, size)

	return rx, ry, size
end

function PANEL:OnMousePressed(m)
	if (not self.AllowInput) then
		return
	end

	if (m == MOUSE_LEFT) then
		pluto.ui.currencyselect(self.Message, function(cur)
			if (not IsValid(self)) then
				return
			end

			self:SetCurrency(cur)
		end)
	elseif (m == MOUSE_RIGHT) then
		self.Currency = nil
		self.InputAmount:SetText "?"
		self:OnCurrencyChanged()
		self:OnCurrencyUpdated()
	end
end

function PANEL:SetMinMax(min, max)
end

function PANEL:SetAmount(amt)
	self.InputAmount:SetText(amt)
end

function PANEL:SetCurrency(cur)
	self.Currency = cur
	self:OnCurrencyChanged(cur)

	-- can change before this, so get amount here

	local amt = math.min(1, not self.Currency and 0 or (pluto.cl_currency[self.Currency.InternalName] or 0))
	self:SetAmount(amt)

	self:OnCurrencyUpdated()
end

function PANEL:GetCurrency()
	return self.Currency, tonumber(self.InputAmount:GetText()) or 0
end

function PANEL:OnCurrencyChanged(currency)
end

function PANEL:OnCurrencyUpdated()
end

vgui.Register("pluto_inventory_currency_selector", PANEL, "EditablePanel")
