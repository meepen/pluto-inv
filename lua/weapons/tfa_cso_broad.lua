SWEP.Base				= "tfa_gun_base"
SWEP.Category				= "TFA CS:O" 
SWEP.Author				= "Kamikaze"

SWEP.PrintName				= "Broad Divine"		
SWEP.Slot				= 2		

SWEP.Primary.Sound 			= "Broad.Fire"				
SWEP.Primary.Damage		= 11
SWEP.Primary.Automatic			= true					
SWEP.Primary.Delay				= 60 / 850
SWEP.Primary.ClipSize			= 200					
SWEP.Primary.DefaultClip			= 400				
SWEP.Primary.Ammo			= "ar2"

SWEP.ViewModel			= "models/weapons/tfa_cso/c_broad.mdl" 
SWEP.ViewModelFOV			= 90		
SWEP.ViewModelFlip			= true		
SWEP.UseHands = true

SWEP.WorldModel			= "models/weapons/tfa_cso/w_broad.mdl" 

SWEP.HoldType 				= "ar2"

SWEP.Offset = { 
	Pos = {
        Up = -1,
        Right = 0.6,
        Forward = 10.5,
	},
	Ang = {
        Up = -90,
        Right = 0,
        Forward = 175
	},
	Scale = 1
}

SWEP.Bullets = {
	HullSize = 0,
	Num = 1,
	DamageDropoffRange = 700,
	DamageDropoffRangeMax = 1300,
	DamageMinimumPercent = 0.35,
	Spread = Vector(0.048, 0.048)
}

SWEP.Ironsights = {
	Pos = Vector(6.15, 0, 1.11),
	Angle = Vector(0, 0.209, -3.855),
	TimeTo = 0.3,
	TimeFrom = 0.25,
	SlowDown = 0.35,
	Zoom = 0.85,
}

local power = 10

SWEP.RecoilInstructions = {
	Interval = 2,
	Angle(-power, -power * 0.6),
	Angle(-power, -power * 0.48),
	Angle(-power, -power * 0.2),
	Angle(-power, power * 0.4),
	Angle(-power, power * 0.2),
	Angle(-power, power * 0.6),
	Angle(-power, power * 0.35),
	Angle(-power, power * 0.2),
	Angle(-power, -power * 0.2),
	Angle(-power, -power * 0.4),
}

SWEP.MuzzleAttachment			= "0" 		
