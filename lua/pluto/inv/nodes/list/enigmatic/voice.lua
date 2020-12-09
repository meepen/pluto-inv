local NODE = pluto.nodes.get "enigmatic_voice"

NODE.Name = "Enigmatic Voice"
NODE.Description = "This gun has been possessed by a toxic shithead."

function NODE:ModifyWeapon(node, wep)
	wep.EnigmaticVoice = true
end
