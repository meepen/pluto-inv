local pluto_chat_font = CreateConVar("pluto_chat_font", "Roboto Bk", FCVAR_ARCHIVE)
local pluto_chat_font_bold = CreateConVar("pluto_chat_font_bold", "1", FCVAR_ARCHIVE, "bold", 0, 1)
local pluto_chat_font_weight = CreateConVar("pluto_chat_font_weight", "100", FCVAR_ARCHIVE, "weight", 0, 1500)

local function initfont()
	surface.CreateFont("pluto_chat_font", {
		font = pluto_chat_font:GetString(),
		size = 20,
		bold = pluto_chat_font_bold:GetBool(),
		weight = pluto_chat_font_weight:GetFloat(),
	})

	surface.CreateFont("pluto_chat_font_clickable", {
		font = pluto_chat_font:GetString(),
		size = 20,
		bold = pluto_chat_font_bold:GetBool(),
		weight = pluto_chat_font_weight:GetFloat(),
		underline = true,
	})
end

cvars.AddChangeCallback(pluto_chat_font:GetName(), initfont, pluto_chat_font:GetName())
cvars.AddChangeCallback(pluto_chat_font_bold:GetName(), initfont, pluto_chat_font_bold:GetName())
cvars.AddChangeCallback(pluto_chat_font_weight:GetName(), initfont, pluto_chat_font_weight:GetName())


hook.Add("TTTPopulateSettingsMenu", "pluto_settings", function()
	local cat = vgui.Create "ttt_settings_category"

	cat:AddTextEntry("Font", "pluto_chat_font")
	cat:AddCheckBox("Bold", "pluto_chat_font_bold")
	cat:AddSlider("Weight", "pluto_chat_font_weight")
	cat:AddSlider("Fade Sustain", "pluto_chat_fade_sustain")
	cat:AddSlider("Fade Length", "pluto_chat_fade_length")
	cat:AddSlider("Unopened opacity", "pluto_chat_closed_alpha")
	cat:InvalidateLayout(true)
	cat:SizeToContents()
	ttt.settings:AddTab("Chat", cat)
end)

initfont()