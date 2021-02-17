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

	self:SetCursor "hand"

	self.InputArea:SetMouseInputEnabled(true)
	self.CurrencyArea:SetMouseInputEnabled(false)

	self.InputArea:SetCursor "beam"
end


function PANEL:AcceptInput(b)
	if (b) then
		self:SetSize(48, 64)
	else
		self:SetSize(48, 48)
	end
end

local circles = include "pluto/thirdparty/circles.lua"
	
local Circle = circles.New(CIRCLE_FILLED, {18, 4}, 24, 41)
Circle:SetDistance(3)

function PANEL:Paint(w, h)
	surface.SetDrawColor(45, 47, 53)
	draw.NoTexture()
	Circle()
	
	self:PaintInner(self, w, h, 0, 0)
end

local question = Material "pluto/currencies/questionmark.png"

function PANEL:PaintInner(pnl, w, h, x, y)
	surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial(self.Material or question)
	local pad = 6
	if (IsValid(pnl) and self == vgui.GetHoveredPanel()) then
		local wait = 1.5
		local timing = 1 - ((wait + CurTime()) % wait) / wait * 2
		local up_offset = (math.sin(timing * math.pi) + 1) / 2 * 15 * 0.25
		y = y + up_offset
	end
	surface.DrawTexturedRect(x + pad, y, w - pad * 2, w - pad * 2)
end

function PANEL:OnMousePressed(m)
	if (m == MOUSE_LEFT) then
		local OnSelected = self.OnCurrencySelected
		pluto.ui.currencyselect(self.Message, function(cur)
			OnSelected(self, cur)
		end)
	end
end


-- NO GUARANTEE SELF IS STILL ALIVE
function PANEL:OnCurrencySelected(currency)
	print("CURRENCY: ", currency)
end

vgui.Register("pluto_inventory_currency_selector", PANEL, "EditablePanel")
