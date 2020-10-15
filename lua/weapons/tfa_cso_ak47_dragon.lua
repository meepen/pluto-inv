SWEP.Base				= "tfa_gun_base"
SWEP.Category				= "TFA CS:O" 
SWEP.Author				= "Kamikaze" 
SWEP.PrintName				= "AK-47 Dragon"		
SWEP.Slot				= 2

--Firing related
SWEP.Primary.Sound 			= Sound("Ak47.Fire")				
SWEP.Primary.Damage		= 31					
SWEP.DamageType = DMG_BULLET 
SWEP.Primary.NumShots	= 1 
SWEP.Primary.Automatic			= true					
SWEP.Primary.RPM				= 600					
SWEP.Primary.RPM_Semi				= 600

--Ammo Related
SWEP.Primary.ClipSize			= 30					
SWEP.Primary.DefaultClip			= 120				
SWEP.Primary.Ammo			= "ar2"

--[[VIEWMODEL]]--
SWEP.ViewModel			= "models/weapons/tfa_cso/c_ak47Dragon.mdl" 
SWEP.ViewModelFOV			= 82	
SWEP.ViewModelFlip			= true
SWEP.UseHands = true
--[[WORLDMODEL]]--

SWEP.WorldModel			= "models/weapons/tfa_cso/w_ak47_dragon.mdl" 

SWEP.HoldType 				= "ar2"

SWEP.Offset = { 
	Pos = {
		Up = -5.5,
		Right = 0.5,
		Forward = 14,
	},
	Ang = {
		Up = -90,
		Right = 0,
		Forward = 170
	},
	Scale = 1.2
}

SWEP.IronSightsPos = Vector(8.625, -4.114, 2.35)
SWEP.IronSightsAng = Vector(2.08, 0.23, 0)


SWEP.MuzzleAttachment			= "0"
SWEP.ShellAttachment			= "2"

SWEP.Base				= "tfa_gun_base"
