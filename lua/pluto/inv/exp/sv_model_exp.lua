hook.Add("PlutoExperienceGain", "pluto_model_exp", function(ply, exp, damager, vic)
	local model = ply.RoundModel
	if (not model) then
		return
	end

	pluto.inv.addexperience(model.RowID, exp)
end)