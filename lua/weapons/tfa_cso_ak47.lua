SWEP.Base				= "tfa_gun_base"
SWEP.Category				= "TFA CS:O" 
SWEP.Author				= "Kamikaze" 
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.Instructions				= ""
SWEP.PrintName				= "AK-47"		
SWEP.Slot				= 2	

--[[WEAPON HANDLING]]--

--Firing related
SWEP.Primary.Sound 			= Sound("Ak47.Fire")				
SWEP.Primary.Damage		= 31					
SWEP.DamageType = DMG_BULLET 
SWEP.Primary.NumShots	= 1 
SWEP.Primary.Automatic			= true					
SWEP.Primary.RPM				= 600					
SWEP.Primary.RPM_Semi				= 600					
SWEP.FiresUnderwater = false

SWEP.Primary.ClipSize			= 30					
SWEP.Primary.DefaultClip			= 120				
SWEP.Primary.Ammo			= "ar2"
--[[VIEWMODEL]]--

SWEP.ViewModel			= "models/weapons/tfa_cso/c_ak47.mdl" 
SWEP.ViewModelFOV			= 82		
SWEP.ViewModelFlip			= true		
SWEP.UseHands = true 
SWEP.VMPos = Vector(0,0,0) 
SWEP.VMAng = Vector(0,0,0) 

--[[WORLDMODEL]]--

SWEP.WorldModel			= "models/weapons/tfa_cso/w_ak47.mdl" 

SWEP.HoldType 				= "ar2"

SWEP.Offset = { 
	Pos = {
		Up = -1.5,
		Right = 1.5,
		Forward = 8,
	},
	Ang = {
		Up = -185,
		Right = 60,
		Forward = 95
	},
	Scale = 1
}

SWEP.ShowWorldModel = true 

--[[SHOTGUN CODE]]--

SWEP.Shotgun = false 
              
SWEP.IronSightsPos = Vector(8.52, -4.114, 2.4)
SWEP.IronSightsAng = Vector(2.08, -0.03, 0)

SWEP.MuzzleAttachment			= "0" 		
SWEP.ShellAttachment			= "2" 		


SWEP.Base				= "tfa_gun_base"
