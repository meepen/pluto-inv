SWEP.Category				= "TFA CS:O"
SWEP.PrintName				= "Jack-o'-Lantern"
SWEP.Slot				= 3
SWEP.HoldType 				= "grenade"

SWEP.ViewModelFOV			= 80
SWEP.ViewModelFlip			= true
SWEP.ViewModel				= "models/weapons/tfa_cso/c_pumpkin.mdl"
SWEP.WorldModel				= "models/weapons/tfa_cso/w_pumpkin.mdl"
SWEP.Base				= "weapon_ttt_basegrenade"
SWEP.UseHands = true

SWEP.Velocity = 1250
SWEP.Velocity_Underhand = 450

SWEP.Offset = {
	Pos = {
		Up = -2,
		Right = 3,
		Forward = 3,
	},
	Ang = {
		Up = -1,
		Right = -2,
		Forward = 180
	},
	Scale = 1.2
}

DEFINE_BASECLASS(SWEP.Base)

function SWEP:Deploy( ... )
	return BaseClass.Deploy( self, ... )
end

function SWEP:Holster( ... )
	return BaseClass.Holster( self, ... )
end

function SWEP:OnRemove( ... )
	return BaseClass.OnRemove( self, ... )
end