SWEP.Base				= "weapon_ttt_aug"
SWEP.Category				= "TFA CS:O"
SWEP.Author				= "Kamikaze"
SWEP.PrintName				= "Star Chaser AR"
SWEP.Slot				= 2

SWEP.Primary.Sound 			= "StarAR.Fire"

SWEP.WorldModel			= "models/weapons/tfa_cso/w_starchaserar.mdl"
SWEP.ViewModel			= "models/weapons/tfa_cso/c_starchaserar.mdl"
SWEP.ViewModelFOV			= 80
SWEP.ViewModelFlip			= true
SWEP.UseHands = true

SWEP.HoldType 				= "smg"

SWEP.Offset = {
	Pos = {
        Up = -4,
        Right = 1.2,
        Forward = 5,
	},
	Ang = {
        Up = -90,
        Right = 0,
        Forward = 170
	},
	Scale = 1.2
}

SWEP.HasScope				= true

SWEP.MuzzleAttachment = "0"

SWEP.Secondary.ScopeTable = {
	["ScopeMaterial"] =  Material("scope/starchaser/starchasersr_scope.png", "smooth"),
	["ScopeBorder"] = Color(0,0,0,190),
	["ScopeCrosshair"] = { ["r"] = 0, ["g"]  = 0, ["b"] = 0, ["a"] = 255, ["s"] = 0 }
}

SWEP.Ironsights = {
	Pos = Vector(7.802, -5.099, 1.32),
	Angle = Vector(-50.796, 1.095, -5.718),
	TimeTo = 0.23,
	TimeFrom = 0.22,
	SlowDown = 0.3,
	Zoom = 0.5,
}

SWEP.Bullets = {
	HullSize = 0,
	Num = 1,
	DamageDropoffRange = 650,
	DamageDropoffRangeMax = 4200,
	DamageMinimumPercent = 0.1,
	Spread = Vector(0.01, 0.02),
	TracerName = "tfa_tracer_gauss"
}

SWEP.MuzzleFlashEffect = "tfa_muzzleflash_sniper_energy"

SWEP.Spawnable = false
SWEP.AutoSpawnable = false
SWEP.PlutoSpawnable = false

DEFINE_BASECLASS(SWEP.Base)
function SWEP:Reload()
	if (self:GetIronsights()) then

	else
		BaseClass.Reload(self)
	end
end