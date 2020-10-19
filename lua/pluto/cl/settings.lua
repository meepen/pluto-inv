local pluto_fov = CreateConVar("pluto_fov", GetConVar "fov_desired":GetFloat(), FCVAR_ARCHIVE, "FOV Addend", 60, 160)
local pluto_inspect_toggle = CreateConVar("pluto_inspect_toggle", 0, {FCVAR_ARCHIVE, FCVAR_UNLOGGED}, "Makes the +inspect toggleable")
local pluto_inspect_slider = CreateConVar("pluto_inspect_slider", 4, {FCVAR_ARCHIVE, FCVAR_UNLOGGED}, "Lifespan of +inspect menu", 2, 10)

hook.Add("TTTPopulateSettingsMenu", "pluto_settings", function()
	local cat = vgui.Create "ttt_settings_category"

	cat:AddSlider("FOV", "pluto_fov")
	cat:AddCheckBox("Disable Cosmetics", "pluto_disable_cosmetics")
	cat:AddCheckBox("Make +inspect menu toggleable", "pluto_inspect_toggle")
	cat:AddSlider("+inspect time", "pluto_inspect_slider")
	cat:InvalidateLayout(true)
	cat:SizeToContents()
	ttt.settings:AddTab("Pluto", cat)
end)

hook.Add("TTTGetFOV", "pluto_fov", function()
	return pluto_fov:GetFloat()
end)

hook.Add("TTTGetScoreboardLogoPanel", "PlutoScoreboardHeader", function()
	return "pluto_scoreboard_header"
end)

local PANEL = {}

function PANEL:Init()
	self.Image = Material("pluto/pluto-logo-header.png")
	self.RealWidth = self.Image:GetInt "$realwidth"
	self.RealHeight = self.Image:GetInt "$realheight"

	self:SetSize(self.RealWidth, self.RealHeight)
end

function PANEL:Paint(w, h)
	surface.SetMaterial(self.Image)
	surface.SetDrawColor(255, 255, 255, 255)
	surface.DrawTexturedRectUV(0, 0, w - 1, h - 1, -0.5 / w, -0.5 / h, 1 - 0.5 / w, 1 - 0.5 / h)
end

vgui.Register("pluto_scoreboard_header", PANEL, "EditablePanel")
