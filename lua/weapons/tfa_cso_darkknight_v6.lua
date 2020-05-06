SWEP.Base				= "tfa_gun_base"
SWEP.Category				= "TFA CS:O"
SWEP.Author				= "Kamikaze"
SWEP.PrintName				= "ₚᵣₐᵢₛₑ"
SWEP.Slot				= 2

--[[WEAPON HANDLING]]--

--Firing related
SWEP.Primary.Sound 			= Sound "DarkKnight.Fire"
SWEP.Primary.Damage		= 15
SWEP.HeadshotMultiplier = 1.5
SWEP.Primary.NumShots	= 1
SWEP.Primary.Automatic			= true
SWEP.Primary.Delay				= 60 / 800

SWEP.Primary.ClipSize			= 40
SWEP.Primary.DefaultClip			= 80

SWEP.ViewModel			= "models/weapons/tfa_cso/c_dark_knight_overlord.mdl"
SWEP.ViewModelFOV			= 80
SWEP.ViewModelFlip			= true
SWEP.UseHands = true

SWEP.WorldModel			= "models/weapons/tfa_cso/w_dark_knight_overlord.mdl"

SWEP.HoldType 				= "ar2"

SWEP.Offset = {
	Pos = {
        Up = -2,
        Right = 1,
        Forward = 15,
	},
	Ang = {
        Up = 90,
        Right = 0,
        Forward = 190
	},
	Scale = 0.9
}

SWEP.MuzzleAttachment			= "0"
SWEP.ShellAttachment			= "2"

SWEP.MuzzleFlashEffect = "cso_muz_dkn_ol"

SWEP.Tracer				= 0
SWEP.TracerName 		= "cso_tra_dkn_ol"

SWEP.TracerCount 		= 1


SWEP.Bullets = {
	HullSize = 0,
	Num = 1,
	DamageDropoffRange = 600,
	DamageDropoffRangeMax = 2400,
	DamageMinimumPercent = 0.1,
	Spread = Vector(0.020, 0.030, 0.00),
	TracerName = "cso_tra_dkn_ol",
}

SWEP.Secondary.Delay = 2

function SWEP:SecondaryAttack()
	if (self:GetNextSecondaryFire() > CurTime() or not SERVER or not self.Charged) then
		return
	end

	self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)

	local e = ents.Create "pluto_darken"
	e:SetPos(self:GetOwner():GetShootPos())
	e:Spawn()

	self.Charged = false
end

function SWEP:Kill(state, atk, vic)
	self.Charged = true
end

local pow = 3
SWEP.RecoilInstructions = {
	Interval = 1,
	pow * Angle(-3, -1),
	pow * Angle(-4, -1),
	pow * Angle(-2, 1),
	pow * Angle(-1, 0),
	pow * Angle(-1, 0),
	pow * Angle(-3, 2),
	pow * Angle(-3, 1),
	pow * Angle(-2, 0),
	pow * Angle(-3, -2),
}

SWEP.Primary.Ammo          = "Pistol"
SWEP.AmmoEnt               = "item_ammo_pistol_ttt"

SWEP.Ortho = {3.5, 1.5, angle = Angle(-145, -180, 150), size = 1.1}