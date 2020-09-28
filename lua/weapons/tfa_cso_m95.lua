SWEP.Base				= "tfa_gun_base"
SWEP.Category				= "TFA CS:O"
SWEP.Author				= "Kamikaze"
SWEP.PrintName				= "Barret .50 Cal"
SWEP.Slot				= 2

SWEP.Primary.Sound 			= Sound "M95.Fire"
SWEP.Primary.Damage		= 60
SWEP.Primary.Automatic			= false
SWEP.Primary.Delay				= 60 / 25

SWEP.UseHands = true
SWEP.NoPlayerModelHands = true

SWEP.HeadshotMultiplier = 2.5

SWEP.Primary.RecoilTiming  = 0.09

SWEP.IsInUse = true

SWEP.ReloadSpeed = 0.75

SWEP.Primary.ClipSize			= 4
SWEP.Primary.DefaultClip			= 12

SWEP.AmmoEnt               = "item_ammo_357_ttt"

SWEP.ViewModel			= "models/weapons/tfa_cso/c_m95.mdl"
SWEP.ViewModelFOV			= 80
SWEP.ViewModelFlip			= true

SWEP.WorldModel			= "models/weapons/tfa_cso/w_m95.mdl"

SWEP.HoldType 				= "ar2"

SWEP.Offset = {
	Pos = {
		Up = -5.5,
		Right = 1.25,
		Forward = 9,
	},
	Ang = {
		Up = -90,
		Right = 0,
		Forward = 170
	},
	Scale = 1.2
}

SWEP.HasScope = true
SWEP.IsSniper = false

SWEP.Ironsights = {
	Pos = Vector(0, 0, -10),
	Angle = Vector(0, 0, 0),
	TimeTo = 0.1,
	TimeFrom = 0.1,
	SlowDown = 0.3,
	Zoom = 0.35,
}

SWEP.Bullets = {
	HullSize = 0,
	Num = 1,
	DamageDropoffRange = 5300,
	DamageDropoffRangeMax = 6500,
	DamageMinimumPercent = 0.1,
}

SWEP.RecoilInstructions = {
	Interval = 1,
	Angle(-200),
}

SWEP.Ortho = {-4, 2.5, angle = Angle(30, 180, -60)}


local scales = {
	[HITGROUP_LEFTARM] = 0.3,
	[HITGROUP_RIGHTARM] = 0.3,
	[HITGROUP_LEFTLEG] = 0.4,
	[HITGROUP_RIGHTLEG] = 0.4
}

DEFINE_BASECLASS(SWEP.Base)

function SWEP:GetHitgroupScale(hg)
	if (scales[hg]) then
		return scales[hg]
	end

	return BaseClass.GetHitgroupScale(self, hg)
end

function SWEP:GetSpread()
	return BaseClass.GetSpread(self) + Vector(0.2, 0.2) * (1 - self:GetCurrentZoomPercent())
end

function SWEP:ScaleRollType(type, roll, init)
	if (type == "damage") then
		local ret = roll / 2

		if (init) then
			pluto.mods.byname.mag:ModifyWeapon(self, {roll * 1.5})
			pluto.mods.byname.firerate:ModifyWeapon(self, {roll * 0.75})
			self.HeadshotMultiplier = self.HeadshotMultiplier * (1 + roll / 100 * 5)
		end

		return ret
	end
	return roll
end
