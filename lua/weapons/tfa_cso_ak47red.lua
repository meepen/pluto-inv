SWEP.Base				= "tfa_gun_base"
SWEP.Category				= "TFA CS:O" 
SWEP.Author				= "Anri"
SWEP.PrintName				= "AK-47 Red"		
SWEP.Slot				= 2

SWEP.Primary.Sound 			= Sound("Ak47.Fire")				
SWEP.Primary.Damage		= 32					
SWEP.DamageType = DMG_BULLET 
SWEP.Primary.NumShots	= 1 
SWEP.Primary.Automatic			= true					
SWEP.Primary.RPM				= 600					
SWEP.Primary.RPM_Semi				= 600

SWEP.Primary.ClipSize			= 30					
SWEP.Primary.DefaultClip			= 120				
SWEP.Primary.Ammo			= "ar2"

SWEP.ViewModel			= "models/weapons/tfa_cso/c_ak47red.mdl" 
SWEP.ViewModelFOV			= 82		
SWEP.ViewModelFlip			= true		
SWEP.UseHands = true

SWEP.WorldModel			= "models/weapons/tfa_cso/w_ak47red.mdl" 

SWEP.HoldType 				= "ar2"

SWEP.Offset = { 
	Pos = {
		Up = -1.2,
		Right = 1.3,
		Forward = 8,
	},
	Ang = {
		Up = -185,
		Right = 65,
		Forward = 95
	},
	Scale = 1
}

SWEP.IronSightsPos = Vector(8.685, -4.462, 3)
SWEP.IronSightsAng = Vector(0.282, -0.077, 0)

--Muzzle Flash
SWEP.MuzzleAttachment			= "0"
SWEP.ShellAttachment			= "2"

SWEP.Base				= "tfa_gun_base"
