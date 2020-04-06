hook.Add("Tick", "pluto_no_god", function()
	for k, v in pairs(player.GetAll()) do
		if (v:Alive() and v:HasGodMode()) then
			v:Kill()
			v:ChatPrint "NO GOD"
		end
	end
end)