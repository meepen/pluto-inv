SWEP.Base				= "weapon_tfa_gun_base"
SWEP.Category				= "TFA CS:O2" --The category.  Please, just choose something generic or something I've already done if you plan on only doing like one swep..SWEP.DrawCrosshair			= true		-- Draw the crosshair?
SWEP.PrintName				= "Type 88"		-- Weapon name (Shown on HUD)
SWEP.Slot				= 2				-- Slot in the weapon selection menu.  Subtract 1, as this starts at 0.
--[[WEAPON HANDLING]]--
SWEP.Primary.Sound = Sound("tfa_cso2_qjy88.1") -- This is the sound of the weapon, when you shoot.
SWEP.Primary.Damage = 22 -- Damage, in standard damage points.
SWEP.HeadshotMultiplier = 1.2
SWEP.Primary.Automatic = true -- Automatic/Semi Auto
SWEP.Primary.Delay = 60 / 550 -- This is in Rounds Per Minute / RPM

--Ammo Related
SWEP.Primary.ClipSize = 100 -- This is the size of a clip
SWEP.Primary.DefaultClip = 400

--[[VIEWMODEL]]--
SWEP.ViewModel			= "models/weapons/tfa_cso2/c_qjy88.mdl" --Viewmodel path
SWEP.ViewModelFOV			= 75		-- This controls how big the viewmodel looks.  Less is more.
SWEP.ViewModelFlip = true

--[[WORLDMODEL]]--
SWEP.WorldModel			= "models/weapons/tfa_cso2/w_qjy88.mdl" -- Weapon world model path
SWEP.HoldType = "ar2" -- This is how others view you carrying the weapon. Options include:

SWEP.Offset = {
	Pos = {
		Up = 0.5,
		Right = 0.5,
		Forward = 4
	},
	Ang = {
		Up = 1,
		Right = -10,
		Forward = 178
	},
	Scale = 1.0
}

SWEP.AutoSpawnable = false
SWEP.Spawnable = false
SWEP.PlutoSpawnable = false


SWEP.Ironsights = {
	Pos = Vector(6.255, -2.779, 2.46),
	Angle = Vector(-0.285, 3.908, -0.235),
	TimeTo = 0.25,
	TimeFrom = 0.15,
	SlowDown = 0.35,
	Zoom = 0.8,
}

SWEP.Idle_Blend = 0.0 --Start an idle this far early into the end of a transition
SWEP.Idle_Smooth = 0.0 --Start an idle this far early into the end of another animation


DEFINE_BASECLASS( SWEP.Base )


local power = 9
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

SWEP.Bullets = {
	HullSize = 0,
	Num = 1,
	DamageDropoffRange = 700,
	DamageDropoffRangeMax = 2300,
	DamageMinimumPercent = 0.45,
	Spread = Vector(0.044, 0.044)
}