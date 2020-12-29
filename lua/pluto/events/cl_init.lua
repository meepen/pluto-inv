surface.CreateFont("pluto_mini_button", {
	font = "Lato",
	size = 25,
})

local PANEL = {}

function PANEL:Init()
	self:SetSize(350, 75)
	self:SetFont("mini_dash")
	self:SetContentAlignment(5)
	self:SetTextColor(ttt.roles.Traitor.Color)
	self:ChangeText("Click Me")
	self.FillColor = Color(0, 0, 0)
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

function PANEL:ChangeColor(color)
	self.FillColor = color
end

function PANEL:ChangeMini(mini)
	self.Mini = mini
end

function PANEL:Paint(w, h)
	draw.RoundedBox(20, 0, 0, w, h, self.FillColor)
end

vgui.Register("pluto_mini_button", PANEL, "DButton")

net.Receive("mini_speed", function()
	pluto.rounds.speeds[LocalPlayer()] = net.ReadFloat()
end)

net.Receive("pluto_mini_dash", function()
	local dashbutton = vgui.Create "pluto_mini_button"
	dashbutton:ChangeText "Click to steal all models! (KOSable)"
	dashbutton:ChangeMini "dash"

	timer.Simple(14, function()
		if (IsValid(dashbutton)) then
			dashbutton:Remove()
		end
	end)
end)