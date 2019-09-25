pluto.weapons = pluto.weapons or {}

pluto.weapons.guns = pluto.weapons.guns or {}
pluto.weapons.melees = pluto.weapons.melees or {}

local weapons_OnLoaded = weapons.OnLoaded

function weapons.OnLoaded()
	weapons.Register(weapons.GetStored "weapon_tttbase", "weapon_tttbase_old")
	weapons.Register({
		Base = "weapon_plutobase"
	}, "weapon_tttbase")
	weapons.GetStored "weapon_ttt_crowbar".PlutoSpawnable = true
	weapons_OnLoaded()


	for _, wep in pairs(weapons.GetList()) do
		if (not wep.AutoSpawnable and not wep.PlutoSpawnable) then
			continue
		end

		if (wep.Slot == 2 or wep.Slot == 1) then
			table.insert(pluto.weapons.guns, wep.ClassName)
		elseif (wep.Slot == 1) then
			table.insert(pluto.weapons.melees, wep.ClassName)
		end
	end
end
