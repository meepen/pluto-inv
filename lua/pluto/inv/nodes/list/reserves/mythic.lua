local NODE = pluto.nodes.get "mythic_reserves"

NODE.Name = "Mythic Reserves"
NODE.Description = "Every few seconds generate a bullet for this weapon. This weapon cannot reload. This weapon has 50% more mag size. This gun shoots 15% slower."

function NODE:ModifyWeapon(node, wep)
	wep.Primary.ClipSize_Original = wep.Primary.ClipSize_Original or wep.Primary.ClipSize
	wep.Primary.DefaultClip_Original = wep.Primary.DefaultClip_Original or wep.Primary.DefaultClip

	wep.Pluto.ClipSize = (wep.Pluto.ClipSize or 1) + 0.5
	local round = wep.Pluto.ClipSize > 1 and math.ceil or math.floor
	wep.Primary.ClipSize = round(wep.Primary.ClipSize_Original * wep.Pluto.ClipSize)
	wep.Primary.DefaultClip = round(wep.Primary.DefaultClip_Original * wep.Pluto.ClipSize)

	wep:DefinePlutoOverrides("Delay", 0, function(old, pct)
		local rpm = 60 / old

		rpm = rpm + pct * rpm

		return 60 / rpm
	end)

	wep.NoReload = true

	wep.Pluto.Delay = wep.Pluto.Delay - 0.15

	if (not SERVER) then
		return
	end

	local id = "pluto_mythic_reserves" .. wep:GetPlutoID()
	timer.Create(id, wep:GetDelay() * 3, 0, function()
		if (not IsValid(wep)) then
			timer.Remove(id)
			return
		end

		if (wep:Clip1() < wep:GetMaxClip1()) then
			wep:SetClip1(math.min(wep:GetMaxClip1(), wep:Clip1() + 1))
			return
		end
		local owner = wep:GetOwner()
	end)
end
