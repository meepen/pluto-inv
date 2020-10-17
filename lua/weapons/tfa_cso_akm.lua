SWEP.Base				= "tfa_gun_base"
SWEP.Category				= "TFA CS:O" 
SWEP.Author				= "Anri"
SWEP.PrintName				= "AKM"		
SWEP.Slot				= 2

SWEP.Primary.Sound 			= Sound("AKM.Fire")				
SWEP.Primary.Damage		= 30					
SWEP.DamageType = DMG_BULLET 
SWEP.Primary.NumShots	= 1 
SWEP.Primary.Automatic			= true					
SWEP.Primary.RPM				= 600					
SWEP.Primary.RPM_Semi				= 600

SWEP.Primary.ClipSize			= 30					
SWEP.Primary.DefaultClip			= 120				
SWEP.Primary.Ammo			= "ar2"

SWEP.ViewModel			= "models/weapons/tfa_cso/c_akm.mdl" 
SWEP.ViewModelFOV			= 82		
SWEP.ViewModelFlip			= true		
SWEP.UseHands = true 
SWEP.VMPos = Vector(0,0,0) 
SWEP.VMAng = Vector(0,0,0) 

//SWEP.ViewModelBoneMods = {
//	["root"] = { scale = Vector(1, 1, 1), pos = Vector(0, -0.5, 0), angle = Angle(0, 0, 0) },
//	["spsmg"] = { scale = Vector(1, 1, 1), pos = Vector(0, -0.5, 0), angle = Angle(0, 0, 0) }
//}

--[[WORLDMODEL]]--

SWEP.WorldModel			= "models/weapons/tfa_cso/w_akm.mdl" 

SWEP.HoldType 				= "ar2"		
-- normal melee melee2 fist knife smg ar2 pistol rpg physgun grenade shotgun crossbow slam passive
-- You're mostly going to use ar2, smg, shotgun or pistol. rpg and crossbow make for good sniper rifles

SWEP.Offset = { 
	Pos = {
		Up = -1.5,
		Right = 1,
		Forward = 8,
	},
	Ang = {
		Up = -185,
		Right = 60,
		Forward = 95
	},
	Scale = 1
}

SWEP.IronSightsPos = Vector(8.685, -4.462, 3)
SWEP.IronSightsAng = Vector(0.282, -0.077, 0)


SWEP.MuzzleAttachment			= "0" 		
SWEP.ShellAttachment			= "2"

SWEP.Base				= "tfa_gun_base"