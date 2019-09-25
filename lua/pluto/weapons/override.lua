local weapons_OnLoaded = weapons.OnLoaded

function weapons.OnLoaded()
	weapons.Register(weapons.GetStored "weapon_tttbase", "weapon_tttbase_old")
	weapons.Register({
		Base = "weapon_plutobase"
	}, "weapon_tttbase")
	weapons_OnLoaded()
end
