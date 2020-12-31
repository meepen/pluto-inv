local NODE = pluto.nodes.get "demon_damage"

NODE.Name = "Demonic Possession: Damage"
NODE.Description = "Once your gun is possessed, deal 20% increased damage; start with 50% health."
NODE.Experience = 5000

function NODE:ModifyWeapon(node, wep)
	timer.Simple(0, function()
		if (not IsValid(wep)) then
			return
		end
		if (not wep.DemonicPossession) then
			return
		end

		hook.Add("ScalePlayerDamage", wep, function(self, hit, group, dmg)
			if (dmg:GetInflictor() ~= self) then
				return
			end

			dmg:ScaleDamage(1.2)
		end)

		if (SERVER) then
			hook.Add("TTTRWSetHealth", wep, function(self, ply)
				local owner = wep:GetOwner()
				if (not IsValid(owner) or owner ~= ply) then
					return
				end

				owner:SetHealth(owner:Health() * 0.5)
			end)
		end

		if (CLIENT and LocalPlayer() == wep:GetOwner()) then
			chat.AddText(Color(255, 20, 50, 200), "i will grant you strength... for a price...")
		end
	end)
end
