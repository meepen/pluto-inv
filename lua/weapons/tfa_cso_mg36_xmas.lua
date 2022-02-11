SWEP.Base = "weapon_tttbase"
SWEP.Category = "TFA CS:O"
SWEP.Author = "Kamikaze"
SWEP.Spawnable = false
SWEP.AdminSpawnable = false
SWEP.DrawCrosshair = true
SWEP.PrintName = "Snowball Shooter"
SWEP.Slot = 1
SWEP.HasScope = true

SWEP.Primary.Sound = Sound("MG36XMAS.Fire")
SWEP.Primary.SilencedSound = Sound("MG36XMAS.Fire")
SWEP.Primary.Damage = 6
SWEP.Primary.Automatic = true
SWEP.Primary.Delay = 60 / 700

SWEP.Primary.ClipSize = 100
SWEP.Primary.DefaultClip = 300
SWEP.Primary.Ammo = "none"

SWEP.ViewModel = "models/weapons/tfa_cso/c_mg36_xmas.mdl"
SWEP.ViewModelFOV = 80
SWEP.ViewModelFlip = true
SWEP.UseHands = true

--[[WORLDMODEL]]--

SWEP.WorldModel = "models/weapons/tfa_cso/w_mg36_xmas.mdl"

SWEP.HoldType = "ar2"
SWEP.Offset = {
	Pos = {
		Up = -1,
		Right = 1,
		Forward = 11,
	},
	Ang = {
		Up = -90,
		Right = 0,
		Forward = 170
	},
	Scale = 1
}

SWEP.Ironsights = {
	Pos = Vector(6.447, -1.448, -5),
	Angle = Vector(0, 0, -2.21),
	TimeTo = 0.1,
	TimeFrom = 0.1,
	SlowDown = 0.3,
	Zoom = 0.5,
}

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
	Angle(-2, -1),
	Angle(-2, 2),
	Angle(-2, -1),
}

function SWEP:DoImpactEffect(tr)
	return true
end

local r = Color(200, 80, 0)
local g = Color(30, 200, 0)

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

DEFINE_BASECLASS(SWEP.Base)

function SWEP:Initialize()
	BaseClass.Initialize(self)

	hook.Add("PlayerRagdollCreated", self, self.PlayerRagdollCreated)
end

function SWEP:PlayerRagdollCreated(ply, rag, atk, dmg)
	if (dmg and dmg:GetInflictor() == self) then
		MakeGold(rag, "models/player/shared/ice_player")
	end
end

SWEP.Ortho = { 1, 2, angle = Angle(90, 0, 123) }