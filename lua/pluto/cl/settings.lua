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

hook.Add("TTTScoreboardHeader", "PlutoScoreboardHeader", function(PANEL, Padding)
	surface.CreateFont("ttt_scoreboard_header_small", {
		font = 'Lato',
		size = math.max(22, ScrH() / 60),
		weight = 300,
	})

	function PANEL:Init()
		self:SetCurve(4)
		self:SetColor(Color(17, 15, 13, 0.75 * 255))

		self.Logo = self:Add("DImage")
		self.Logo:Dock(LEFT)
		self.Logo:SetImage("pluto/pluto-logo-header.png")
		self.Logo:SetSize(448)
		
		self.Texts = self:Add("EditablePanel")
		self.Texts:Dock(RIGHT)
		self.Texts:SetContentAlignment(3)

		function self.Texts:Init()
			self.Map = self:Add("DLabel")
			self.Map:SetFont("ttt_scoreboard_header_small")
			self.Map:SetText("You're playing on ttt_innocentmotel_v2 on DALLAS 2")
			self.Map:Dock(TOP)

			self.Change = self:Add("DLabel")
			self.Change:SetFont("ttt_scoreboard_header_small")
			self.Change:SetText("Map will change in 3 rounds")
			self.Change:Dock(TOP)
		end
		
		self:DockPadding(Padding, Padding, Padding, Padding)
	end
	
	function PANEL:PerformLayout(w, h)
		self:SetTall(110 + Padding * 2)

		self.Texts.Map:SizeToContents()
		self.Texts.Change:SizeToContents()
		self.Texts:SizeToContents()
	end
end)