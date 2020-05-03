SWEP.Base				= "tfa_cso_m82"
SWEP.Category				= "TFA CS:O"
SWEP.Author				= "Kamikaze"

SWEP.ViewModel			= "models/weapons/tfa_cso/c_m82_v6.mdl"
SWEP.WorldModel			= "models/weapons/tfa_cso/w_m82_v6.mdl"

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

SWEP.Secondary.ScopeTable = {
	["ScopeMaterial"] =  Material("scope/m82/m82_scope.png", "smooth"),
	["ScopeBorder"] = Color(0, 0, 0, 255),
	["ScopeCrosshair"] = { ["r"] = 0, ["g"]  = 0, ["b"] = 0, ["a"] = 255, ["s"] = 0 }
}
