surface.CreateFont("pluto_mini_button", {
	font = "Lato",
	size = 25,
})

local PANEL = {}

function PANEL:Init()
	self:SetSize(350, 75)
	self:SetFont("pluto_mini_button")
	self:SetContentAlignment(5)
	self:SetTextColor(Color(0, 0, 0))
	self:ChangeText("Click Me")
	self.BorderColor = Color(0, 0, 0)
	self.FillColor = Color(255, 255, 255)
	self.Mini = ""
end

function PANEL:ChangeText(text)
	self:SetText(text)
	local w, h = self:GetTextSize()
	self:SetSize(w + 50, 75)
	self:SetPos((ScrW() - (w + 50)) / 2, ScrH() - 200)
end

function PANEL:DoClick()
	net.Start("pluto_mini_" .. self.Mini)
	net.SendToServer()
	self:Remove()
end

function PANEL:ChangeMini(mini)
	self.Mini = mini
end

function PANEL:Paint(w, h)
	draw.RoundedBox(20, 0, 0, w, h, self.BorderColor)
	draw.RoundedBox(20, 2, 2, w - 4, h - 4, self.FillColor)
end

vgui.Register("pluto_mini_button", PANEL, "DButton")

net.Receive("mini_speed", function()
	pluto.rounds.speeds[LocalPlayer()] = net.ReadFloat()
end)