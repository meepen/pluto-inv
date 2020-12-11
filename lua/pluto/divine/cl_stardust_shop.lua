surface.CreateFont("headline_font", {
	font = "Permanent Marker",
	size = 48,
	antialias = true,
	weight = 500
})
surface.CreateFont("special_offer_font", {
	font = "Roboto Bk",
	size = 18,
	weight = 500
})

local PANEL = {}

function PANEL:SetTab()
end

function PANEL:Init()
	self.TopLine = self:Add "EditablePanel"
	function self.TopLine:Paint(w, h)
		surface.SetDrawColor(white_text)
		surface.DrawRect(0, 0, w, h)
	end

	self.TopLine:Dock(TOP)
	self.TopLine:SetTall(3)

	self.SpecialLabel = self:Add "DLabel"
	self.SpecialLabel:Dock(TOP)
	self.SpecialLabel:SetText "Limited Time"
	self.SpecialLabel:SetFont "headline_font"
	self.SpecialLabel:SetContentAlignment(5)
	self.SpecialLabel:SizeToContents()
	self.SpecialLabel:SetTextColor(white_text)

	self.BottomLine = self:Add "EditablePanel"
	function self.BottomLine:Paint(w, h)
		surface.SetDrawColor(white_text)
		surface.DrawRect(0, 0, w, h)
	end

	self.Specials = self:Add "EditablePanel"
	self.Specials:Dock(TOP)
	self.Specials:SetTall(140)

	function self.Specials:OnChildAdded(c)
		timer.Simple(0, function()
			local children = self:GetChildren()
			local w, h = self:GetSize()
			local totalw = #children * 10

			for _, child in ipairs(children) do
				totalw = totalw + child:GetWide()
			end


			local cw = 0
			for _, child in ipairs(children) do
				child:SetPos(w / 2 - totalw / 2 + cw, h / 2 - child:GetTall() / 2)
				cw = cw + 10 + child:GetWide()
			end
		end)
	end

	self.BottomLine:Dock(TOP)
	self.BottomLine:SetTall(3)

	self.TopLine2 = self:Add "EditablePanel"
	function self.TopLine2:Paint(w, h)
		surface.SetDrawColor(white_text)
		surface.DrawRect(0, 0, w, h)
	end

	self.TopLine2:Dock(TOP)
	self.TopLine2:SetTall(3)

	self.Offer = self.Specials:Add "pluto_stardust_offer"
	self.Offer2 = self.Specials:Add "pluto_stardust_offer"
end

vgui.Register("pluto_stardust_shop", PANEL, "EditablePanel")

local PANEL = {}

function PANEL:Init()
	self:SetCurve(6)
	self:SetSize(80, 60)
end

vgui.Register("pluto_stardust_offer_inner", PANEL, "ttt_curved_panel_outline")

local PANEL = {}
function PANEL:Init()
	self:SetSize(90, 70)
	self.Inner = self:Add "pluto_stardust_offer_inner"
	self.Inner:Center()
end
vgui.Register("pluto_stardust_offer", PANEL, "EditablePanel")