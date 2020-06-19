hook.Add("PlutoExperienceGain", "pluto_player_exp", function(ply, exp, damager, vic)
	pluto.inv.addplayerexperience(ply, exp)
end)