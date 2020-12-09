MOD.Type = "implicit"
MOD.Name = "Coined"
MOD.Tags = {}

MOD.Color = Color(254, 233, 105)

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:CanRollOn(class)
	return false
end

function MOD:FormatModifier(index, roll)
	return ""
end

MOD.Description = "Gives 15% more currency rewards per max modifier"

MOD.NoCoined = true

MOD.Tiers = {
	{ 1, 1 },
}

function MOD:OnUpdateSpawnPoints(wep, rolls, atk, vic, state)
	if (IsValid(atk) and state.Points > 0) then
		local gun = wep.PlutoGun
		if (not gun.RowID or gun.RowID < 2000000) then
			state.Points = state.Points * (1 + 0.15 * gun:GetMaxAffixes())
		else
			local mod_count = 0

			for _, modlist in pairs(gun.Mods) do
				mod_count = mod_count + #modlist

				for _, mod in pairs(modlist) do
					if (pluto.mods.byname[mod.Mod].NoCoined) then
						mod_count = mod_count - 1
					end
				end
			end

			state.Points = state.Points * (1 + 0.1 * mod_count)
		end
	end
end

return MOD