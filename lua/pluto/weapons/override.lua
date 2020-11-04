pluto.weapons = pluto.weapons or {}

pluto.weapons.guns = pluto.weapons.guns or {}
pluto.weapons.melees = pluto.weapons.melees or {}
pluto.weapons.grenades = pluto.weapons.grenades or {}

weapons.RealOnLoaded = weapons.RealOnLoaded or weapons.OnLoaded

function weapons.OnLoaded()
	weapons.Register(weapons.GetStored "weapon_tttbase", "weapon_tttbase_old")
	weapons.Register({
		Base = "weapon_plutobase"
	}, "weapon_tttbase")
	weapons.GetStored "weapon_ttt_crowbar".PlutoSpawnable = true
	weapons.RealOnLoaded()


	for _, wep in pairs(weapons.GetList()) do
		wep = weapons.GetStored(wep.ClassName)
		if (wep.PlutoIcon and SERVER) then
			resource.AddSingleFile(wep.PlutoIcon)
		end
		if (wep.Base == "tfa_gun_base" or wep.Base == "tfa_melee_base" or wep.Base == "tfa_nade_base" or wep.Base == "tfa_bash_base") then
			--pwarnf("GUN DISABLED: %s", wep.ClassName)
			wep.AutoSpawnable = false
			wep.Spawnable = false
			wep.PlutoSpawnable = false
			continue
		end

		wep = baseclass.Get(wep.ClassName)
		if (not wep.AutoSpawnable and not wep.PlutoSpawnable) then
			continue
		end

		if (wep.Slot == 3) then
			table.insert(pluto.weapons.grenades, wep.ClassName)
		elseif (wep.Slot == 2 or wep.Slot == 1) then
			table.insert(pluto.weapons.guns, wep.ClassName)
		elseif (wep.Slot == 0) then
			table.insert(pluto.weapons.melees, wep.ClassName)
		end
	end
end