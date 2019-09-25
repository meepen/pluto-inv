hook.Add("TTTWeaponInitialize", "pluto_modify", function(e)
	timer.Simple(0, function()
		if (not IsValid(e) or e.IsPlutoModified or IsValid(e:GetOwner())) then
			return
		end
	end)
end)