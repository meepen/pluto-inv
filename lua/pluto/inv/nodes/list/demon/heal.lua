local NODE = pluto.nodes.get "demon_heal"

NODE.Name = "Demonic Possession: Regen"
NODE.Description = "Once your gun is possessed, full heal on kill."
NODE.Experience = 7500

function NODE:ModifyWeapon(node, wep)
	timer.Simple(0, function()
		if (not IsValid(wep)) then
			return
		end
		if (not wep.DemonicPossession) then
			return
		end

		hook.Add("PlayerDeath", wep, function(self, vic, inf, atk)
			if (atk ~= self:GetOwner()) then
				return
			end
			
			self:GetOwner():SetHealth(self:GetOwner():GetMaxHealth())
		end)

		if (CLIENT and LocalPlayer() == wep:GetOwner()) then
			chat.AddText(Color(255, 20, 50, 200), "i will grant you eternal life...")
		end
	end)
end
