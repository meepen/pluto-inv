SWEP.Base				= "weapon_tttbase"
SWEP.Category				= "TFA CS:O"
SWEP.Author				= "Kamikaze"
SWEP.PrintName				= "CHARGER-5"
SWEP.Slot				= 2

--[[WEAPON HANDLING]]--

--Firing related
SWEP.Primary.Sound 			= Sound "Charger5.Fire"
SWEP.Primary.Damage		= 16
SWEP.HeadshotMultiplier = 1.3
SWEP.Primary.Automatic			= true
SWEP.Primary.Delay				= 60 / 600

SWEP.IsInUse = true

--Ammo Related

SWEP.Primary.ClipSize			= 40
SWEP.Primary.DefaultClip			= 80
SWEP.Primary.Ammo			= "ar2"
--Pistol, buckshot, and slam like to ricochet. Use AirboatGun for a light metal peircing shotgun pellets

SWEP.ViewModel			= "models/weapons/tfa_cso/c_charger5.mdl"
SWEP.ViewModelFOV			= 80
SWEP.ViewModelFlip			= true

SWEP.WorldModel			= "models/weapons/tfa_cso/w_charger5.mdl"

SWEP.HoldType 				= "smg"
-- normal melee melee2 fist knife smg ar2 pistol rpg physgun grenade shotgun crossbow slam passive
-- You're mostly going to use ar2, smg, shotgun or pistol. rpg and crossbow make for good sniper rifles

SWEP.Offset = {
	Pos = {
        Up = -4.5,
        Right = 1,
        Forward = 5.5,
	},
	Ang = {
        Up = -90,
        Right = 0,
        Forward = 170
	},
	Scale = 1.2
}

SWEP.AutoSpawnable = false
SWEP.Spawnable = true

SWEP.MuzzleAttachment			= "0"
SWEP.ShellAttachment			= "2"
SWEP.Primary.Ammo          = "smg1"
SWEP.AmmoEnt               = "item_ammo_smg1_ttt"

SWEP.Ironsights = {
	Pos = Vector(5.8, 0, 1.2),
	Angle = Vector(0, 0, 0),
	TimeTo = 0.25,
	TimeFrom = 0.15,
	SlowDown = 0.35,
	Zoom = 0.9,
}

local pow = 2
SWEP.RecoilInstructions = {
	Interval = 1,
	pow * Angle(-6, -1),
	pow * Angle(-4, -1),
	pow * Angle(-2, 2),
	pow * Angle(-1, 0),
	pow * Angle(-1, 0),
	pow * Angle(-3, 2),
	pow * Angle(-3, 1),
	pow * Angle(-2, 0),
	pow * Angle(-3, -2),
}

SWEP.Bullets = {
	HullSize = 0,
	Num = 1,
	DamageDropoffRange = 600,
	DamageDropoffRangeMax = 2400,
	DamageMinimumPercent = 0.1,
	Spread = Vector(0.020, 0.020, 0.00)
}

DEFINE_BASECLASS(SWEP.Base)


if (CLIENT) then
	local last_play = -math.huge
	net.Receive("tfa_cso_charger5", function()
		local mult = 2

		if (math.random() < 0.3) then
			local rand = Angle((math.random() - 0.5) * mult, (math.random() - 0.5) * mult)
			LocalPlayer():SetEyeAngles(LocalPlayer():EyeAngles() + rand)
		end

		if (CurTime() < last_play + 10) then
			return
		end

		surface.PlaySound "hl1/fvox/shock_damage.wav"
		last_play = CurTime()
	end)
end

-- play hl1/fvox/shock_damage.wav
function SWEP:FireBulletsCallback(tr, dmginfo)
	BaseClass.FireBulletsCallback(self, tr, dmginfo)

	if (not SERVER) then
		return
	end

	if (IsValid(tr.Entity) and dmginfo:GetDamage() > 0 and tr.Entity:IsPlayer() and math.random() > 0.8) then

		-- do electrical effect
		net.Start "tfa_cso_charger5"
		net.Send(tr.Entity)

		tr.Entity:EmitSound "ambient/levels/labs/electric_explosion5.wav"
	end
end

SWEP.Ortho = {-0.5, 0, angle = Angle(30, 180, -60), size = 1.1}
