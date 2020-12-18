SWEP.Base = "weapon_ttt_shotgun"
SWEP.Category = "TFA CS:O"
SWEP.Author = "Kamikaze"

SWEP.Spawnable = false
SWEP.AdminSpawnable = false
SWEP.PlutoSpawnable = true
SWEP.AutoSpawnable = false
SWEP.DrawCrosshair = true

SWEP.PrintName = "Christmas 1887"
SWEP.Slot = 2

SWEP.Primary.Sound = Sound("M1887XMAS.Fire")
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 8
SWEP.Primary.DefaultClip = 16
SWEP.Primary.Ammo = "buckshot"


SWEP.ViewModel			= "models/weapons/tfa_cso/c_m1887xmas.mdl"
SWEP.ViewModelFOV			= 80
SWEP.ViewModelFlip			= true
SWEP.UseHands = true
SWEP.NoPlayerModelHands = true

--[[WORLDMODEL]]--

SWEP.WorldModel			= "models/weapons/tfa_cso/w_m1887xmas.mdl" -- Worldmodel path

SWEP.HoldType 				= "shotgun"		-- This is how others view you carrying the weapon. Options include:
-- normal melee melee2 fist knife smg ar2 pistol rpg physgun grenade shotgun crossbow slam passive
-- You're mostly going to use ar2, smg, shotgun or pistol. rpg and crossbow make for good sniper rifles

SWEP.Offset = { --Procedural world model animation, defaulted for CS:S purposes.
	Pos = {
		Up = -1.8,
		Right = 2.2,
		Forward = 5,
	},
	Ang = {
		Up = -90,
		Right = 0,
		Forward = 170
	},
	Scale = 1.1
}

SWEP.Ironsights = {
	Pos = Vector(5.393, 0, -0.205),
	Angle = Vector(2.375, 0, 5.171),
	TimeTo = 0.23,
	TimeFrom = 0.22,
	SlowDown = 0.3,
	Zoom = 0.9,
}

DEFINE_BASECLASS(SWEP.Base)
function SWEP:DoFireBullets(...)
	BaseClass.DoFireBullets(self, ...)
	local data = EffectData()
	local owner = self:GetOwner()
	data:SetStart(owner:GetShootPos())
	data:SetOrigin(data:GetStart() + owner:GetAimVector())
	data:SetMagnitude(3)
	data:SetRadius(100)
	data:SetScale(1)
	data:SetFlags(CONFETTI_SHOT + 4)
	util.Effect("pluto_confetti", data)
end
