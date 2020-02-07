local Effects = {
	-- noise maker
	function(ply)
		
	end
}

function pluto.inv.readnitro()
	local ply = net.ReadEntity()
	local reward_num = net.ReadUInt(16)


	local effect = Effects[reward_num]

	if (effect) then
		effect(ply)
	else
		pwarnf("No nitro effect for %i", reward_num)
	end
end