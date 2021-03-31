SWEP.Base = "weapon_tttbase"
SWEP.Category = "Nintendo Weapons"
SWEP.Author = "Gravemind"

SWEP.PrintName = "NES Zapper"
SWEP.Slot = 1
SWEP.DrawCrosshair = true
SWEP.ViewModel = "models/weapons/v_pist_nesz.mdl"
SWEP.WorldModel = "models/weapons/w_pist_nesz.mdl"
SWEP.ViewModelFOV = 64
SWEP.ViewModelFlip = true
SWEP.HoldType = "pistol"
SWEP.Spawnable = false

SWEP.Primary.ClipSize = 10
SWEP.Primary.DefaultClip = 10
SWEP.Primary.RecoilTiming  = 0.06
SWEP.Primary.Delay = 0.4
SWEP.Primary.Ammo = "Pistol"

SWEP.Offset = { --Procedural world model animation, defaulted for CS:S purposes.
	Pos = {
        Up = 0,
        Right = 0,
        Forward = 0,
	},
	Ang = {
        Up = 90,
        Right = 0,
        Forward = 190
	}
}

sound.Add {
	name = "Weapon_NESZapper.Single",
	channel = CHAN_WEAPON,
	pitch = {90, 110},
	level = 70,
	sound = {
		"weapons/neszapper/neszap1.wav",
		"weapons/neszapper/neszap2.wav",
		"weapons/neszapper/neszap3.wav",
	}
}

SWEP.Ironsights = {
	Pos = Vector(4.73, -3, 2.4),
	Angle = Vector(0, 0, 0),
	TimeTo = 0.1,
	TimeFrom = 0.15,
	SlowDown = 0.9,
	Zoom = 0.95,
}

SWEP.Bullets = {
	TracerName = "GaussTracer",
	HullSize = 0,
	Num = 1,
	DamageDropoffRange = 400,
	DamageDropoffRangeMax = 2500,
	DamageMinimumPercent = 0.1,
	Spread = Vector(0.02, 0.02)
}

SWEP.Primary.Sound         = Sound "Weapon_NESZapper.Single"

DEFINE_BASECLASS(SWEP.Base)
function SWEP:Deploy()
	if (CLIENT and IsFirstTimePredicted()) then
		if (ttt.GetHUDTarget() ~= self:GetOwner()) then
			return
		end
		if (IsValid(self.DeployingSound)) then
			self.DeployingSound:Stop()
		end
		sound.PlayFile("sound/weapons/NESZapper/NESDeploy.wav", "mono", function(snd)
			if (IsValid(snd)) then
				snd:Play()
				snd:SetVolume(0.2)
				self.DeployingSound = snd
			end
		end)
	end

	return BaseClass.Deploy(self)
end

function SWEP:Holster()
	if (IsValid(self.DeployingSound)) then
		self.DeployingSound:Stop()
	end

	return BaseClass.Holster(self)
end

local power
SWEP.RecoilInstructions = {
	Interval = 1,
	Angle(-10, 0.5),
	Angle(-10, 1),
	Angle(-10, -2),
}

SWEP.Ortho = {-4, 4, angle = Angle(0, 0, -27), size = 1}
