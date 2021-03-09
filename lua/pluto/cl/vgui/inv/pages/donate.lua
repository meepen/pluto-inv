local PANEL = {}

PANEL.Margin = 75

function PANEL:Init()
	self:DockMargin(self.Margin, 25, self.Margin, 25)
	self.Inner = self:Add "EditablePanel"
	self.Inner:Dock(FILL)

	function self.Inner.PerformLayout(s, w, h)
		if (IsValid(self.Text)) then
			self.Text:Remove()
		end

		self.Text = self.Inner:Add "pluto_text_inner"
		self.Text:SetSize(w - 30, 200)
		self.Text:SetDefaultRenderSystem(pluto.fonts.systems.shadow)
		self.Text:SetDefaultFont "pluto_inventory_font_lg"
		self.Text:SetDefaultTextColor(Color(255, 255, 255))
		self.Text:AppendText [[We take extreme pride in programming this server from the ground up. Because of this we are able to keep our servers fast and expandable.
---
Pluto takes a stance where we will never enable pay-to-win mechanics to our server to keep things fair for everyone who puts their time into this server!
---
However because of these two things (and the fact we don't have cosmetics yet) we do not make much money. 
---
Donating to us helps keep the servers up, keep the developers fed (BREADBOWLS) and enable more content to come to Pluto faster.
]]

		self.Text:Center()
		self.Text:SetPos(self.Text:GetPos(), 40)

		self.DonateBar:SetWide(w / 2)
		self.DonateBar:CenterHorizontal()
		self.DonateBar:MoveBelow(self.Text, 30)
		self.DonateLabel:MoveAbove(self.DonateBar, 5)
		self.DonateLabel:CenterHorizontal()

		self.DonateButton:MoveBelow(self.DonateBar, 24)
		self.DonateButton:CenterHorizontal()
		self.YourDonationsLabel:CenterHorizontal()
	end

	self.Top = self.Inner:Add "EditablePanel"
	self.Top:Dock(TOP)
	self.Top:SetTall(30) -- TODO(meep): show donation points


	self.DonateButton = self.Inner:Add "pluto_inventory_button"
	self.DonateButton:SetColor(Color(7, 133, 28), Color(52, 52, 52))
	self.DonateButton:SetCurve(4)
	self.DonateButton:SetMouseInputEnabled(true)
	self.DonateButtonLabel = self.DonateButton:Add "pluto_label"
	self.DonateButtonLabel:SetFont "pluto_inventory_font_lg"
	self.DonateButtonLabel:SetTextColor(Color(255, 255, 255))
	self.DonateButtonLabel:SetContentAlignment(5)
	self.DonateButtonLabel:SetText "Click here to donate! <3"
	self.DonateButtonLabel:SetRenderSystem(pluto.fonts.systems.shadow)
	self.DonateButtonLabel:SizeToContents()
	self.DonateButtonLabel:Dock(FILL)
	self.DonateButton:SetSize(self.DonateButtonLabel:GetWide() + 10, self.DonateButtonLabel:GetTall() + 4)

	function self.DonateButton.DoClick()
		gui.OpenURL "https://pluto.gg/donate"
	end

	self.DonateBar = self.Inner:Add "pluto_showcase_bar"
	self.DonateBar:SetTall(16)
	self.DonateBar:AddFilling(GetGlobalInt("pluto_donate_pct", 0) / 100, "Monthly", Color(109, 148, 233))

	self.DonateLabel = self.Inner:Add "pluto_label"
	self.DonateLabel:SetFont "pluto_inventory_font"
	self.DonateLabel:SetRenderSystem(pluto.fonts.systems.shadow)
	self.DonateLabel:SetTextColor(Color(255, 255, 255))
	self:SetDonateText("Monthly goal: " .. string.format("$%.2f USD", GetGlobalInt "pluto_donate_goal" / 100))

	self.YourDonationsLabel = self.Inner:Add "pluto_label"
	self.YourDonationsLabel:SetFont "pluto_inventory_font"
	self.YourDonationsLabel:SetRenderSystem(pluto.fonts.systems.shadow)
	self.YourDonationsLabel:SetTextColor(Color(237, 237, 52))
	self.YourDonationsLabel:SetText("You have " .. (pluto.cl_tokens or 0) .. " tokens" .. (pluto.cl_tokens > 0 and " <3" or ""))
	self.YourDonationsLabel:SizeToContents()
	self.YourDonationsLabel:SetPos(0, 5)
end


function PANEL:SetDonateText(text)
	self.DonateLabel:SetText(text)
	self.DonateLabel:SizeToContents()
	self.DonateLabel:CenterHorizontal()
end

vgui.Register("pluto_inventory_donate", PANEL, "pluto_inventory_component")