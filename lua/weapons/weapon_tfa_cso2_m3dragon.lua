SWEP.Base				= "weapon_ttt_shotgun"
SWEP.Category				= "TFA CS:O2" --The category.  Please, just choose something generic or something I've already done if you plan on only doing like one swep..

SWEP.PrintName				= "M3 Dragon"		-- Weapon name (Shown on HUD)
SWEP.Slot				= 2

SWEP.Primary.Sound = Sound("tfa_cso2_m3dragon.1")
SWEP.Primary.Damage = 4.5

SWEP.Bullets = {
	HullSize = 0,
	Num = 12,
	DamageDropoffRange = 600,
	DamageDropoffRangeMax = 3600,
	DamageMinimumPercent = 0.1,
	Spread = Vector(0.1, 0.1),
	TracerName = "tfa_tracer_incendiary"
}

SWEP.Primary.Delay = 1.2
SWEP.Primary.Automatic = true

--Ammo Related
SWEP.Primary.ClipSize = 8 -- This is the size of a clip
SWEP.Primary.DefaultClip = 16 -- This is the number of bullets the gun gives you, counting a clip as defined directly above.

SWEP.ViewModelFOV			= 75
SWEP.ViewModelFlip			= true
SWEP.UseHands = true
SWEP.HoldType = "shotgun"
SWEP.Offset = {
	Pos = {
		Up = -0.5,
		Right = 0.5,
		Forward = 3.5
	},
	Ang = {
		Up = -1,
		Right = 15,
		Forward = 178
	},
	Scale = 1
}

SWEP.Ortho = {-4, 4, angle = Angle(180, 110, 210)}

SWEP.Ironsights = {
	Pos = Vector(5.3, 0, 1.48),
	Angle = Vector(-0, 0, 0),
	Zoom = 0.9
}

SWEP.Spawnable = false --  = false
SWEP.AutoSpawnable = false --  = false
--Tracer Stuff
SWEP.TracerName 		= "tfa_tracer_incendiary" 	--Change to a string of your tracer name.  Can be custom. There is a nice example at https://github.com/garrynewman/garrysmod/blob/master/garrysmod/gamemodes/base/entities/effects/tooltracer.lua
SWEP.TracerCount 		= 3	 	--0 disables, otherwise, 1 in X chance

SWEP.WorldModel			= "models/weapons/tfa_cso2/w_m3dragon.mdl" -- Weapon world model path
SWEP.ViewModel			= "models/weapons/tfa_cso2/c_m3dragon.mdl" -- Weapon world model path

DEFINE_BASECLASS(SWEP.Base)

function SWEP:FireBulletsCallback(tr, dmginfo)
	BaseClass.FireBulletsCallback(self, tr, dmginfo)
	if (SERVER and IsValid(tr.Entity)) then
		if (tr.Entity:IsPlayer() and not tr.Entity:Alive()) then
			return
		end
		tr.Entity:Ignite(2)

		if (tr.Entity:IsPlayer()) then
			pluto.statuses.limp(tr.Entity, self:GetDelay())
		end
	end
end
