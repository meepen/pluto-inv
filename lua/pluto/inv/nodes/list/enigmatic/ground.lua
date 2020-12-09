local NODE = pluto.nodes.get "enigmatic_ground"

NODE.Name = "Enigmatic Voice: HELP!"
NODE.Description = "The voice inside this gun is afraid of beind alone. Calls for help when not being held."

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
