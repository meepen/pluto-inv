SWEP.Base = "weapon_tttbase"
SWEP.Category = "TFA CS:O"
SWEP.Author = "Kamikaze"
SWEP.Editor = "add___123"

SWEP.Spawnable = false
SWEP.AdminSpawnable = false
SWEP.DrawCrosshair = true
SWEP.PrintName = "Vitality's Offer"
SWEP.Slot = 1

SWEP.Primary.Damage = 30
SWEP.Primary.Sound = Sound "Skull1.Fire"
SWEP.Primary.Delay = 0.5
SWEP.Primary.Recoil = 3
SWEP.Primary.RecoilTiming = 0.08
SWEP.Primary.Automatic = true

SWEP.Primary.ClipSize = 8
SWEP.Primary.DefaultClip = 32
SWEP.Primary.Ammo = "pistol"

SWEP.ViewModel = "models/weapons/tfa_cso/c_skull1.mdl"
SWEP.ViewModelFOV = 85
SWEP.ViewModelFlip = true
SWEP.UseHands = true

SWEP.WorldModel	= "models/weapons/tfa_cso/w_skull1.mdl"

SWEP.HoldType = "revolver"

DEFINE_BASECLASS(SWEP.Base)

SWEP.Offset = {
	Pos = {
        Up = -4.5,
        Right = 1,
        Forward = 7,
	},
	Ang = {
        Up = -90,
        Right = 0,
        Forward = 170
	},
	Scale = 1.2
}

SWEP.Ironsights = {
	Pos = Vector(5.83, -3.84, 0.791),
	Angle = Vector(-1.152, 2.233, -2.722),
	TimeTo = 0.23,
	TimeFrom = 0.22,
	SlowDown = 0.8,
	Zoom = 0.75,
}

SWEP.RecoilInstructions = {
	Interval = 1,
	Angle(-15),
}

function SWEP:Initialize()
	BaseClass.Initialize(self)

	if (SERVER) then
		self.Damaged = {}
	end

	hook.Add("DoPlayerDeath", self, self.DoPlayerDeath)
end

function SWEP:FireBulletsCallback(tr, dmginfo, data)
	BaseClass.FireBulletsCallback(self, tr, dmginfo, data)

	if (SERVER and ttt.GetRoundState() ~= ttt.ROUNDSTATE_PREPARING) then
		local own = self:GetOwner()

		if (not IsValid(own)) then
			return
		end

		local ent = tr.Entity

		if (not IsValid(ent) or not ent:IsPlayer()) then
			return 
		end

		pluto.statuses.poison(own, {
			Weapon = self,
			Damage = 10
		})

		self.Damaged[ent] = (self.Damaged[ent] or 0) + 10
	end
end

function SWEP:DoPlayerDeath(ply, atk, dmg)
	if (not self.Damaged or not self.Damaged[ply]) then
		return
	end

	local amt = self.Damaged[ply] * 2
	self.Damaged[ply] = nil

	pluto.statuses.heal(self:GetOwner(), amt, amt / 20)
end

function SWEP:OnRemove()
	hook.Remove("DoPlayerDeath", self)
end