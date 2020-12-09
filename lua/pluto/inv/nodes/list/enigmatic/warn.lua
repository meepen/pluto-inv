local NODE = pluto.nodes.get "enigmatic_warn"

NODE.Name = "Enigmatic Voice: Warn"
NODE.Description = "The voice inside this gun warns when someone watches you from afar occasionally."

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
