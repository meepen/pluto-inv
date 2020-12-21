local NODE = pluto.nodes.get "enigmatic_siren"

NODE.Name = "Enigmatic Voice: Siren"
NODE.Description = "Your gun makes siren noises when you are shooting."
NODE.Experience = 3100

function NODE:ModifyWeapon(node, wep)
	timer.Simple(0, function()
		if (not IsValid(wep)) then
			return
		end
		if (not wep.EnigmaticVoice) then
			return
		end
	end)
end
