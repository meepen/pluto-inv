AddCSLuaFile()
SWEP.Author = "Zaratusa"
SWEP.Contact = "http://steamcommunity.com/profiles/76561198032479768"

SWEP.PrintName = "Golden Deagle"

SWEP.Slot = 1

SWEP.UseHands = true
SWEP.ViewModelFlip = true
SWEP.ViewModelFOV = 90

SWEP.Base = "weapon_ttt_deagle"

SWEP.Primary.Delay = 0.6
SWEP.Primary.Damage = 60
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 7
SWEP.Primary.DefaultClip = 14
SWEP.Primary.Sound = "Golden_Deagle.Single"
SWEP.Primary.Ammo = "AlyxGun"
SWEP.AmmoEnt = "item_ammo_revolver_ttt"

SWEP.HeadshotMultiplier = 3

SWEP.HoldType = "pistol"
SWEP.ViewModel = "models/weapons/zaratusa/golden_deagle/v_golden_deagle.mdl"
SWEP.WorldModel = "models/weapons/zaratusa/golden_deagle/w_golden_deagle.mdl"

SWEP.Ironsights = {
	Pos = Vector(3.76, -0.5, 1.67),
	Angle = Vector(-0.6, 0, 0),
	TimeTo = 0.25,
	TimeFrom = 0.25,
	SlowDown = 0.75,
	Zoom = 0.9,
}

SWEP.RecoilInstructions = {
	Interval = 0.1,
	Angle(-50),
}

SWEP.Bullets = {
	HullSize = 0,
	Num = 1,
	DamageDropoffRange = 1000,
	DamageDropoffRangeMax = 5500,
	DamageMinimumPercent = 0.3,
	Spread = Vector(0.01, 0.01),
}

SWEP.AutoSpawnable = false
SWEP.Spawnable = false
SWEP.PlutoSpawnable = false

sound.Add {
	name = "Golden_Deagle.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	pitch = {95, 105},
	sound = "weapons/golden_deagle/deagle-1.ogg"
}

sound.Add {
	name = "Golden_Deagle.Clipout",
	channel = CHAN_WEAPON,
	volume = 1.0,
	sound = "weapons/golden_deagle/clipout.ogg"
}

sound.Add {
	name = "Golden_Deagle.Clipin",
	channel = CHAN_WEAPON,
	volume = 1.0,
	sound = "weapons/golden_deagle/clipin.ogg"
}

sound.Add {
	name = "Golden_Deagle.Sliderelease",
	channel = CHAN_WEAPON,
	volume = 1.0,
	sound = "weapons/golden_deagle/sliderelease.ogg"
}

sound.Add {
	name = "Golden_Deagle.Slideback",
	channel = CHAN_WEAPON,
	volume = 1.0,
	sound = "weapons/golden_deagle/slideback.ogg"
}

sound.Add {
	name = "Golden_Deagle.Slideforward",
	channel = CHAN_WEAPON,
	volume = 1.0,
	sound = "weapons/golden_deagle/slideforward.ogg"
}

game.AddParticles "particles/smoke_trail.pcf"

SWEP.Ortho = {-3.5, 5.5, angle = Angle(180, 0, 130), size = 0.7}

DEFINE_BASECLASS(SWEP.Base)

function SWEP:Initialize()
	BaseClass.Initialize(self)

	hook.Add("PlayerRagdollCreated", self, self.PlayerRagdollCreated)
end

function SWEP:PlayerRagdollCreated(ply, rag, atk, dmg)
	if (dmg and dmg:GetInflictor() == self) then
		pluto.statuses.greed(atk, 50 * 39.37, 10)
		if (dmg:GetDamageCustom() == HITGROUP_HEAD) then
			MakeGold(rag)
		end
	end
end

function SWEP:UpdateSpawnPoints()
	if (IsValid(atk) and state.Points > 0) then
		state.Points = state.Points * 2
	end
end