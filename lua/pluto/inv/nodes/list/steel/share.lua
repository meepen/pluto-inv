--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
local NODE = pluto.nodes.get "steel_share"

NODE.Name = "Ice: Share"
NODE.Experience = 9999
NODE.Description = "2% of currency earned with this gun is shared with other players."

function NODE:ModifyWeapon(node, wep)
	if (not SERVER) then
		return
	end
	timer.Simple(0, function()
		if (not IsValid(wep)) then
			return
		end
		if (not wep.SteelEnchant) then
			return
		end

		local old = wep.UpdateSpawnPoints
		function wep:UpdateSpawnPoints(state)
			if (old) then
				old(self, state)
			end

			state.Points = state.Points * (1 + (5 + node.node_val1 * 10) / 100)
			timer.Simple(0, function()
				for _, ply in pairs(round.GetActivePlayers()) do
					if (not IsValid(ply.Player)) then
						continue
					end
				
					pluto.currency.givespawns(ply.Player, state.Points * 0.02)
				end
			end)
		end
	end)
end