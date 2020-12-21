local NODE = pluto.nodes.get "mythic_reserves"

NODE.Name = "Mythic Reserves"
NODE.Experience = 5600
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

	local id = "pluto_mythic_reserves" .. wep:GetPlutoID()

	local last_increase = ttt.GetRoundStateChangeTime()
	hook.Add("Tick", id, function()
		if (not IsValid(wep)) then
			hook.Remove("Tick", id)
			return
		end


		if (last_increase + wep:GetDelay() * 4 < CurTime()) then
			last_increase = last_increase + wep:GetDelay() * 4
			wep:SetClip1(math.min(wep:GetMaxClip1(), wep:Clip1() + 1))
		end
	end)
end
