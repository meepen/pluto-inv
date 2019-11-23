AddCSLuaFile()

local tbl = {"Magnum.ClipOut","weapons/deagle_beast/de_clipout.ogg",
"Magnum.ClipIn","weapons/deagle_beast/de_clipin.ogg",
"Magnum.SlideForward","weapons/deagle_beast/de_slideback.ogg",
"Magnum.Deploy","weapons/deagle_beast/de_deploy.ogg",
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

SWEP.PrintName 		= "Deagle - Beast"
SWEP.Slot 			= 1
SWEP.SlotPos 		= 0

SWEP.Base 		= "weapon_tttbase"
SWEP.HoldType 	= "pistol"

SWEP.ViewModel 	= "models/cf/c_deagle_beast.mdl"
SWEP.WorldModel = "models/cf/w_deagle_beast.mdl"

SWEP.Primary.Sound 		= Sound("weapons/deagle_beast/deagle-1.ogg")
SWEP.Primary.Damage 	= 51
SWEP.Primary.Cone 		= 0.0125
SWEP.Primary.ClipSize 	= 11
SWEP.Primary.Delay 		= 0.3
SWEP.Primary.DefaultClip= 55
SWEP.Primary.Automatic 	= false
SWEP.Primary.Ammo 		= "357"

SWEP.MeleeRange 	= 50
SWEP.MeleeDamage 	= 62
SWEP.MeleeDuration	= 0.9
SWEP.DeployDuration	= 0.6
SWEP.MeleeAttack 	= 0.165
SWEP.MuzzleScale	= 1.3

SWEP.DeploySequence = 3
SWEP.MeleeSequence = 12