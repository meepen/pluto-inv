local NODE = pluto.nodes.get "enigmatic_voice"

NODE.Name = "Enigmatic Voice"
NODE.Description = "This gun has been possessed by a soul of pure toxicity."
NODE.Experience = 4800

function NODE:ModifyWeapon(node, wep)
	wep.EnigmaticVoice = true
end
