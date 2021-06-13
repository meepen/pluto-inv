--- Rounds ---

pluto.rounds = pluto.rounds or {}

surface.CreateFont("round_small", {
	font = "Roboto",
	size = math.max(16, ScrH() * 0.025),
})
surface.CreateFont("round_medium", {
	font = "Roboto",
	size = math.max(20, ScrH() * 0.0375),
})
surface.CreateFont("round_large", {
	font = "Roboto",
	size = math.max(24, ScrH() * 0.05),
})
surface.CreateFont("round_header", {
	font = "Lato",
	size = math.max(28, ScrH() * 0.0625),
})

local fonts = {"round_small", "round_medium", "round_large", "round_header"}
local outline_text = Color(12, 13, 15)

local function doDraw(str, size, x, y, col, align)
	local _, h = draw.SimpleTextOutlined(str, fonts[size], x, y, col or white_text, align, TEXT_ALIGN_CENTER, math.ceil(size / 2), outline_text)
	return h
end

pluto.rounds.AppendHeader = function(str, size, y, col)
	return y + doDraw(str, size, ScrW() / 2, y, col, TEXT_ALIGN_CENTER)
end

pluto.rounds.AppendStats = function(str, size, y, col)
	return y + doDraw(str, size, 5, y, col, TEXT_ALIGN_LEFT)
end

local top_limit = 100
local top_time = 1
local time_limit = 8
local round_notifications = {}

pluto.rounds.Notify = function(message, color, short)
	table.insert(round_notifications, 1, {
		String = message,
		Color = color,
		Short = short,
		Time = CurTime(),
	})

	print(message)
end

hook.Add("HUDPaint", "round_notify", function()
	y = ScrH() + 20
	for k, msg in ipairs(round_notifications) do
		if (k == #round_notifications and CurTime() - msg.Time >= time_limit) then
			round_notifications[k] = nil
			return
		end

		if (msg.Short and (CurTime() - msg.Time) >= time_limit / 2) then
			continue
		end

		this_y = math.min(ScrH() - Lerp((CurTime() - msg.Time) / top_time, -20, top_limit), y)

		local _, h = draw.SimpleTextOutlined(msg.String, "round_medium", ScrW() / 2, this_y, msg.Color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, outline_text)
		y = this_y - h
	end
end)

net.Receive("round_data", function()
	if (not pluto.rounds.state) then
		print("pluto.rounds.state not found")
		return
	end

	local name = net.ReadString()
	local typ = net.ReadString()
	local var
	if (typ == "string") then
		var = net.ReadString()
	elseif (typ == "number") then
		var = net.ReadUInt(32)
	elseif (typ == "bool") then
		var = net.ReadBool()
	end

	pluto.rounds.state[name] = var
end)

net.Receive("round_notify", function()
	pluto.rounds.Notify(net.ReadString(), Color(net.ReadUInt(8), net.ReadUInt(8), net.ReadUInt(8)), net.ReadBool())
end)

--- Minis ---

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
	self:SetPos((ScrW() - (w + 50)) / 2, ScrH() - 300)
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