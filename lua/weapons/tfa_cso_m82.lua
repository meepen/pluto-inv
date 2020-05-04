SWEP.Base				= "tfa_gun_base"
SWEP.Category				= "TFA CS:O"
SWEP.Author				= "Kamikaze"
SWEP.PrintName				= "Hunting Rifle"
SWEP.Slot				= 2

SWEP.Primary.Sound 			= Sound "M82.Fire"
SWEP.Primary.Damage		= 45
SWEP.HeadshotMultiplier    = 2
SWEP.Primary.NumShots	= 1
SWEP.Primary.Automatic			= false
SWEP.Primary.Delay				= 60 / 45

SWEP.Primary.ClipSize			= 7
SWEP.Primary.DefaultClip			= 14
SWEP.AmmoEnt               = "item_ammo_357_ttt"

SWEP.ViewModel			= "models/weapons/tfa_cso/c_m82.mdl"
SWEP.ViewModelFlip = true
SWEP.ViewModelChange = {
	Pos = Vector(3, 0, -5),
	Ang = Vector(30, 25, 5)
}
SWEP.WorldModel			= "models/weapons/tfa_cso/w_m82.mdl"

SWEP.HoldType 				= "ar2"

SWEP.Offset = {
	Pos = {
        Up = -4,
        Right = 0.9,
        Forward = 6.5,
	},
	Ang = {
        Up = -90,
        Right = 0,
        Forward = 170
	},
	Scale = 1.2
}

SWEP.Ironsights = {
	Pos = Vector(0, 0, -10),
	Angle = Vector(0, 0, 0),
	TimeTo = 0.1,
	TimeFrom = 0.1,
	SlowDown = 0.3,
	Zoom = 0.35,
}

SWEP.Bullets = {
	HullSize = 0,
	Num = 1,
	DamageDropoffRange = 5300,
	DamageDropoffRangeMax = 9600,
	DamageMinimumPercent = 0.1,
	Spread = vector_origin
}
 
SWEP.MuzzleAttachment			= "0"
--SWEP.MuzzleAttachmentRaw = 1
SWEP.ShellAttachment			= "2"

SWEP.HasScope = true

SWEP.Primary.RecoilTiming  = 0.09
SWEP.RecoilInstructions = {
	Interval = 1,
	Angle(-40),
}

SWEP.Secondary.ScopeTable = {
	["ScopeMaterial"] =  Material("scope/m82/m82_scope.png", "smooth"),
	["ScopeBorder"] = Color(0,0,0,255),
	["ScopeCrosshair"] = { ["r"] = 0, ["g"]  = 0, ["b"] = 0, ["a"] = 255, ["s"] = 0 }
}

SWEP.Ortho = {-3.5, 1.5, angle = Angle(30, 180, -60), size = 1.1}
