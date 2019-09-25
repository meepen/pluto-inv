hook.Add("TTTWeaponInitialize", "pluto_modify", function(e)
	timer.Simple(0, function()
		if (not IsValid(e) or e.IsPlutoModified or IsValid(e:GetOwner())) then
			return
		end

		local modify = ents.Create "pluto_modify"
		modify:SetParent(e)

		modify:Spawn()
	end)
end)