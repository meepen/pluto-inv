local pluto_fov = CreateConVar("pluto_fov", GetConVar "fov_desired":GetFloat(), FCVAR_ARCHIVE, "FOV Addend", 60, 160)
local pluto_trash_speed = CreateConVar("pluto_trash_speed", 1, {FCVAR_ARCHIVE, FCVAR_UNLOGGED}, "Speed multiplier for item trashing", 1, 5)
local pluto_open_speed = CreateConVar("pluto_open_speed", 1, {FCVAR_ARCHIVE, FCVAR_UNLOGGED}, "Speed multiplier for item opening", 1, 5)
local pluto_print_console = CreateConVar("pluto_print_console", 0, {FCVAR_ARCHIVE, FCVAR_UNLOGGED}, "Disable pluto inv console prints")
local pluto_quest_hud = CreateConVar("pluto_quest_hud", 0, {FCVAR_ARCHIVE, FCVAR_UNLOGGED}, "Show plut quest hud")
local pluto_inactive_quests = CreateConVar("pluto_inactive_quests", 0, {FCVAR_ARCHIVE, FCVAR_UNLOGGED}, "Show inactive quests in pluto quest hud")

hook.Add("TTTPopulateSettingsMenu", "pluto_settings", function()
	local cat = vgui.Create "ttt_settings_category"

	cat:AddSlider("FOV", "pluto_fov")
	--cat:AddCheckBox("Disable Cosmetics", "pluto_disable_cosmetics")
	cat:AddCheckBox("Disable Inventory-Related Console Prints", "pluto_print_console")
	cat:AddSlider("Item trashing speed", "pluto_trash_speed")
	cat:AddSlider("Item opening speed", "pluto_open_speed")
	cat:AddCheckBox("Enable Gun Hover", "pluto_hover_enabled")
	cat:AddSlider("Gun Hover Image Size", "pluto_hover_pct")
	cat:AddCheckBox("Make +inspect menu toggleable", "pluto_inspect_toggle")
	cat:AddSlider("Toggle mode +inspect's lifespan (0=forever)", "pluto_inspect_toggle_autoclose")
	cat:AddSlider("+inspect animation speed", "pluto_inspect_lifespan")
	cat:AddCheckBox("Show quest hud", "pluto_quest_hud")
	cat:AddCheckBox("Show inactive quests", "pluto_inactive_quests")
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

function PANEL:PerformLayout(w, h)
	self:Center()
end

vgui.Register("pluto_scoreboard_header", PANEL, "EditablePanel")
