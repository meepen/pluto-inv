local pluto_fov = CreateConVar("pluto_fov", GetConVar "fov_desired":GetFloat(), FCVAR_ARCHIVE, "FOV Addend", 60, 160)

hook.Add("TTTPopulateSettingsMenu", "pluto_settings", function()
	local cat = vgui.Create "ttt_settings_category"
	
	cat:AddSlider("FOV", "pluto_fov")
	cat:InvalidateLayout(true)
	cat:SizeToContents()
	ttt.settings:AddTab("Pluto", cat)
end)

hook.Add("TTTGetFOV", "pluto_fov", function()
	return pluto_fov:GetFloat()
end)