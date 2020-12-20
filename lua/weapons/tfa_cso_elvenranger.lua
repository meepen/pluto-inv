SWEP.Base = "weapon_tttbase"
SWEP.Category = "TFA CS:O"
SWEP.Author = "Anri"
SWEP.Spawnable = false
SWEP.AdminSpawnable = false
SWEP.DrawCrosshair = true
SWEP.PrintName = "AWP Elven Ranger"
SWEP.Slot = 2

SWEP.Primary.Sound = Sound("ElvenRanger.Fire")
SWEP.Primary.Damage = 45
SWEP.HeadshotMultiplier = 100

SWEP.Primary.ClipSize = 4
SWEP.Primary.DefaultClip = 8
SWEP.Primary.Delay = 1.7

SWEP.ReloadSpeed = 0.5

SWEP.AmmoEnt               = "item_ammo_357_ttt"
SWEP.Primary.Ammo          = "357"

SWEP.ViewModel = "models/weapons/tfa_cso/c_elven_ranger.mdl"
SWEP.ViewModelFOV = 90
SWEP.ViewModelFlip = true
SWEP.UseHands = true

SWEP.WorldModel = "models/weapons/tfa_cso/w_elven_ranger.mdl"

SWEP.HoldType 				= "ar2"
SWEP.Offset = {
	Pos = {
		Up = -6,
		Right = 1,
		Forward = 11.5,
	},
	Ang = {
		Up = 90,
		Right = 0,
		Forward = 190
	},
	Scale = 1.25
}

SWEP.HasScope = true
SWEP.Secondary.ScopeTable = {
	["ScopeMaterial"] =  Material("scope/elven_ranger/elven_ranger_scope.png", "smooth"),
	["ScopeBorder"] = Color(0,0,0,255),
	["ScopeCrosshair"] = { ["r"] = 0, ["g"]  = 0, ["b"] = 0, ["a"] = 255, ["s"] = 0 }
}

SWEP.IronSightsPos = Vector(5.84, 0, 2)
SWEP.IronSightsAng = Vector(0, 0, 0)

SWEP.Tracer				= 0
SWEP.TracerName 		= "cso_tra_elv_rng"

SWEP.Ironsights = {
	Pos = Vector(0, 0, -10),
	Angle = Vector(0, 0, 0),
	TimeTo = 0.1,
	TimeFrom = 0.1,
	SlowDown = 0.3,
	Zoom = 0.35,
}

SWEP.RecoilInstructions = {
	Interval = 1,
	Angle(-200),
}
SWEP.Primary.RecoilTiming  = 0.09

SWEP.Primary.PenetrationValue = 50

function SWEP:GetReloadDuration(speed)
	return 2 / speed + 0.1
end
