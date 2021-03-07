SWEP.Base				= "tfa_cso_m95"

SWEP.ViewModel			= "models/weapons/tfa_cso/c_m95_xmas.mdl"
SWEP.WorldModel			= "models/weapons/tfa_cso/w_m95xmas.mdl"

SWEP.HoldType 				= "ar2"
SWEP.Slot = 2
SWEP.ViewModelFOV = 90
SWEP.UseHands = true

SWEP.Offset = {
	Pos = {
		Up = -7.5,
		Right = 1.25,
		Forward = 5.4,
	},
	Ang = {
		Up = -180,
		Right = 80,
		Forward = 90
	},
	Scale = 1
}

SWEP.Secondary.ScopeTable = {
	["ScopeMaterial"] =  Material("scope/sniper/sniper_scope.png", "smooth"),
	["ScopeBorder"] = Color(0,0,0,255),
	["ScopeCrosshair"] = { ["r"] = 0, ["g"]  = 0, ["b"] = 0, ["a"] = 255, ["s"] = 0 }
}

SWEP.Ortho = {-5, 0, angle = Angle(-30, 180, 160), size = 0.8 }