SWEP.Base = "weapon_tttbase"
SWEP.Category = "TFA CS:O"
SWEP.Author = "Kamikaze"
SWEP.Spawnable = false
SWEP.AdminSpawnable = false
SWEP.DrawCrosshair = true
SWEP.PrintName = "Watergun"
SWEP.Slot = 1

SWEP.Primary.Sound = Sound("WaterGun.Fire")
SWEP.Primary.SilencedSound = Sound("WaterGun.Fire")
SWEP.Primary.Damage = 7
SWEP.Primary.Automatic = true
SWEP.Primary.Delay = 60 / 500

SWEP.Primary.ClipSize = 80
SWEP.Primary.DefaultClip = 240
SWEP.Primary.Ammo = "none"

SWEP.ViewModel = "models/weapons/tfa_cso/c_watergun.mdl"
SWEP.ViewModelFOV = 80
SWEP.ViewModelFlip = true
SWEP.UseHands = true

SWEP.WorldModel			= "models/weapons/tfa_cso/w_watergun.mdl"

SWEP.HoldType 				= "ar2"
SWEP.Offset = {
	Pos = {
		Up = -5,
		Right = 1,
		Forward = 5,
	},
	Ang = {
		Up = 90,
		Right = 0,
		Forward = 190
	},
	Scale = 1.25
}

//Water Gun. Not safe, though!
local soundData = {
	name 		= "WaterGun.Draw" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/water_gun/draw.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "WaterGun.Pump" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/water_gun/pump.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "WaterGun.ClipOut" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/water_gun/clipout.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "WaterGun.ClipIn" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/water_gun/clipin.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "WaterGun.Fire" ,
	channel 	= CHAN_USER_BASE+11,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/water_gun/fire.ogg"
}

sound.Add(soundData)

SWEP.Tracer 		= 1
SWEP.Bullets = {
	HullSize = 0,
	Num = 1,
	DamageDropoffRange = 650,
	DamageDropoffRangeMax = 4200,
	DamageMinimumPercent = 0.1,
	Spread = Vector(0.01, 0.02),
	TracerName = "tracer_snowball"
}

function SWEP:GetReserveAmmo()
	return self:GetMaxClip1()
end

SWEP.RecoilInstructions = {
	Interval = 1,
	Angle(-2),
	Angle(-2, 1),
	Angle(-2, 2),
	Angle(-2, 1),
}

function SWEP:DoImpactEffect(tr)
	return true
end

local r = Color(0, 80, 200)
local g = Color(30, 200, 30)

function SWEP:GetPrintNameColor()
	local change = 1
	local from, to = r, g
	local pct = (CurTime() % change) / change

	if (pct > 0.5) then
		pct = pct - 0.5
		from, to = to, from
	end

	pct = pct * 2

	local cur = Color(Lerp(pct, from.r, to.r), Lerp(pct, from.g, to.g), Lerp(pct, from.b, to.g))
	
	return cur
end

SWEP.Ortho = { 1, 2, angle = Angle(90, 0, 123) }