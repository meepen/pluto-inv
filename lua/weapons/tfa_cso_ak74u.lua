SWEP.Base				= "tfa_gun_base"
SWEP.Category				= "TFA CS:O" 
SWEP.Author				= "Anri"
SWEP.PrintName				= "AK-74U"		
SWEP.Slot				= 2

SWEP.Primary.Sound 			= Sound("AK74U.Fire")				
SWEP.Primary.Damage		= 29
SWEP.Primary.NumShots	= 1 
SWEP.Primary.Automatic			= true					
SWEP.Primary.RPM				= 680					
SWEP.Primary.RPM_Semi				= 680

SWEP.Primary.ClipSize			= 30					
SWEP.Primary.DefaultClip			= 180				
SWEP.Primary.Ammo			= "ar2"

SWEP.ViewModel			= "models/weapons/tfa_cso/c_ak74u.mdl" 
SWEP.ViewModelFOV			= 75		
SWEP.ViewModelFlip			= true

SWEP.WorldModel			= "models/weapons/tfa_cso/w_ak74u.mdl" 

SWEP.HoldType 				= "ar2"

SWEP.Offset = { 
	Pos = {
		Up = -3.75,
		Right = 1.25,
		Forward = 8,
	},
	Ang = {
		Up = 88,
		Right = 0,
		Forward = 190
	},
	Scale = 1
}

SWEP.IronSightsPos = Vector(7.639, -2.391, 2.1)
SWEP.IronSightsAng = Vector(0, 0.09, 0)

SWEP.MuzzleAttachment			= "1" 		
--SWEP.MuzzleAttachmentRaw = 1 --This will override whatever string you gave.  This is the raw attachment number.  This is overridden or created when a gun makes a muzzle event.
SWEP.ShellAttachment			= "2"

SWEP.Base				= "tfa_gun_base"
