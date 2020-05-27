SWEP.Base				= "weapon_tttbase"
SWEP.Category				= "TFA CS:O" --The category.  Please, just choose something generic or something I've already done if you plan on only doing like one swep.
SWEP.Author				= "Kamikaze" --Author Tooltip
SWEP.DrawCrosshair			= true		-- Draw the crosshair?
SWEP.PrintName				= "Hunter Killer X-45"		-- Weapon name (Shown on HUD)
SWEP.Slot				= 1				-- Slot in the weapon selection menu.  Subtract 1, as this starts at 0.

--[[WEAPON HANDLING]]--

--Firing related
SWEP.Primary.Sound 			= Sound("X-45.Fire")				-- This is the sound of the weapon, when you shoot.
SWEP.Primary.Damage		= 42
SWEP.Primary.Automatic			= true					-- Automatic/Semi Auto
SWEP.Primary.Delay				= 60 / 300

SWEP.Primary.ClipSize			= 15					-- This is the size of a clip
SWEP.Primary.DefaultClip			= 30				-- This is the number of bullets the gun gives you, counting a clip as defined directly above.
SWEP.Primary.Ammo			= "pistol"

SWEP.ViewModel			= "models/weapons/tfa_cso/c_x-45.mdl" --Viewmodel path
SWEP.ViewModelFOV			= 75		-- This controls how big the viewmodel looks.  Less is more.
SWEP.ViewModelFlip			= true		-- Set this to true for CSS models, or false for everything else (with a righthanded viewmodel.)
SWEP.UseHands = true --Use gmod c_arms system.

SWEP.WorldModel			= "models/weapons/tfa_cso/w_x-45.mdl" -- Worldmodel path

SWEP.HoldType 				= "pistol"

SWEP.NoPlayerModelHands = true

SWEP.Offset = {
	Pos = {
		Up = -3.2,
		Right = 0.8,
		Forward = 5,
	},
	Ang = {
		Up = -90,
		Right = 0,
		Forward = 170
	},
	Scale = 1
}

SWEP.IronSightsPos = Vector(8.013, -5.671, 0.423)
SWEP.IronSightsAng = Vector(5.388, 1.192, 5.572)


--Muzzle Flash

SWEP.MuzzleAttachment			= "1" 		-- Should be "1" for CSS models or "muzzle" for hl2 models
--SWEP.MuzzleAttachmentRaw = 1 --This will override whatever string you gave.  This is the raw attachment number.  This is overridden or created when a gun makes a muzzle event.
SWEP.ShellAttachment			= "2" 		-- Should be "2" for CSS models or "shell" for hl2 models

local soundData = {
	name		= "X-45.ClipIn1" ,
	channel	 = CHAN_WEAPON,
	volume	  = 1,
	soundlevel  = 80,
	pitchstart  = 100,
	pitchend	= 100,
	sound	   = "weapons/tfa_cso/x-45/clipin1.ogg"
}
 
sound.Add(soundData)

local soundData = {
	name		= "X-45.ClipIn2" ,
	channel	 = CHAN_WEAPON,
	volume	  = 1,
	soundlevel  = 80,
	pitchstart  = 100,
	pitchend	= 100,
	sound	   = "weapons/tfa_cso/x-45/clipin2.ogg"
}
 
sound.Add(soundData)
 
local soundData = {
	name		= "X-45.ClipOut" ,
	channel	 = CHAN_WEAPON,
	volume	  = 1,
	soundlevel  = 80,
	pitchstart  = 100,
	pitchend	= 100,
	sound	   = "weapons/tfa_cso/x-45/clipout.ogg"
}
 
sound.Add(soundData)

local soundData = {
	name		= "X-45.Draw" ,
	channel	 = CHAN_WEAPON,
	volume	  = 1,
	soundlevel  = 80,
	pitchstart  = 100,
	pitchend	= 100,
	sound	   = "weapons/tfa_cso/x-45/draw.ogg"
}
 
sound.Add(soundData)
 
local soundData = {
	name		= "X-45.Fire" ,
	channel	 = CHAN_USER_BASE+11,
	volume	  = 1,
	soundlevel  = 80,
	pitchstart  = 100,
	pitchend	= 100,
	sound	   = "weapons/tfa_cso/x-45/fire.ogg"
}
 
sound.Add(soundData)