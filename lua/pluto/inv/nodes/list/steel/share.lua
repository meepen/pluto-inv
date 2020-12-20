local NODE = pluto.nodes.get "steel_share"

NODE.Name = "Ice: Share"
NODE.Experience = 9999
NODE.Description = "2% of currency earned with this gun is shared with other players."

function NODE:ModifyWeapon(node, wep)
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
				old(state)
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