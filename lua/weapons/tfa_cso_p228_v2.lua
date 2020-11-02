SWEP.Base				= "weapon_ttt_p228"
SWEP.Spawnable				= false --Can you, as a normal user, spawn this?
SWEP.AdminSpawnable			= false --Can an adminstrator spawn this?  Does not tie into your admin mod necessarily, unless its coded to allow for GMod's default ranks somewhere in its code.  Evolve and ULX should work, but try to use weapon restriction rather than these.
SWEP.DrawCrosshair			= true		-- Draw the crosshair?
SWEP.PrintName				= "P228"		-- Weapon name (Shown on HUD)
SWEP.Slot				= 1

SWEP.Primary.Sound 			= Sound("P228.Fire")


SWEP.ViewModel			= "models/weapons/tfa_cso/c_p228_v2.mdl" --Viewmodel path
SWEP.ViewModelFOV			= 80		-- This controls how big the viewmodel looks.  Less is more.
SWEP.ViewModelFlip			= true

SWEP.WorldModel			= "models/weapons/tfa_cso/w_p228.mdl" -- same case UHGI;DFSD/

SWEP.HoldType 				= "pistol"

SWEP.Offset = { --Procedural world model animation, defaulted for CS:S purposes.
	Pos = {
        Up = -3,
        Right = 1.5,
        Forward = 5,
	},
	Ang = {
        Up = -90,
        Right = 0,
        Forward = 170
	},
	Scale = 1.25
}


SWEP.IronSightsPos = Vector(4.24, -1.407, 1.608)
SWEP.IronSightsAng = Vector(0.703, -2.1, -4.222)

SWEP.MuzzleAttachment			= "1" 		-- Should be "1" for CSS models or "muzzle" for hl2 models
--SWEP.MuzzleAttachmentRaw = 1 --This will override whatever string you gave.  This is the raw attachment number.  This is overridden or created when a gun makes a muzzle event.
SWEP.ShellAttachment			= "2" 		-- Should be "2" for CSS models or "shell" for hl2 models
