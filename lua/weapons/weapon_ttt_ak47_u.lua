local tbl = {"AK47.SlideBack","weapons/ak47_beast/rifle_slideback.ogg",
"AK47.ClipIn","weapons/ak47_beast/rifle_clip_in_1.ogg",
"AK47.SlideForward","weapons/ak47_beast/rifle_slideforward.ogg",
"AK47.Deploy","weapons/ak47_beast/rifle_deploy_1.ogg"
}
for i = 1,#tbl,2 do
	sound.Add(
	{
		name = tbl[i],
		channel = CHAN_WEAPON,
		volume = 1.0,
		soundlevel = 80,
		sound = tbl[i+1]
	})
end

AddCSLuaFile()
SWEP.ViewModelFOV	= 60

SWEP.PrintName 		= "AK47 - Beast"
SWEP.Slot 			= 2
SWEP.SlotPos 		= 1

SWEP.Base 		= "weapon_tttbase"
SWEP.HoldType 	= "ar2"

SWEP.ViewModel 	= "models/cf/c_ak47_beast.mdl"
SWEP.WorldModel = "models/cf/w_ak47_beast.mdl"

SWEP.Primary.Sound 		= Sound "weapons/ak47_beast/rifle_fire_1.ogg"
SWEP.Primary.Damage 	= 32
SWEP.Primary.Cone 		= 0.03
SWEP.Primary.ClipSize 	= 35
SWEP.Primary.Delay 		= 0.1
SWEP.Primary.DefaultClip= 140
SWEP.Primary.Automatic 	= true
SWEP.Primary.Ammo 		= "ar2"

SWEP.MeleeRange 	= 62
SWEP.MeleeDamage 	= 51
SWEP.MeleeAttack	= 0.22
SWEP.MeleeDuration	= 0.85
SWEP.MeleeSound		= "weapons/ak47_beast/rifle_melee.ogg"

SWEP.MuzzleAttach	= 2
SWEP.MuzzleScale	= 1
SWEP.ShellEffect	= true