SWEP.Base = "weapon_tttbase"
SWEP.Category = "TFA CS:O"
SWEP.Author = "Kamikaze"
SWEP.Editor = "add___123"

SWEP.Spawnable = false
SWEP.AdminSpawnable = false
SWEP.DrawCrosshair = true
SWEP.PrintName = "Vitality's Wager"
SWEP.Slot = 2
SWEP.HasScope = true
SWEP.IsSniper = false

SWEP.Primary.Damage = 55
SWEP.Primary.Sound = Sound "Skull5.Fire"
SWEP.Secondary.Sound = Sound "Default.Zoom"
SWEP.Primary.Delay = 1.2
SWEP.Primary.Recoil = 3
SWEP.Primary.RecoilTiming  = 0.085
SWEP.Primary.Automatic = true

SWEP.HealthCost = 5
SWEP.HealthGained = 10

SWEP.Primary.ClipSize = 16
SWEP.Primary.DefaultClip = 50
SWEP.Primary.Ammo = "357"

SWEP.ViewModel = "models/weapons/tfa_cso/c_skull5.mdl"
SWEP.ViewModelFOV = 85
SWEP.ViewModelFlip = true
SWEP.UseHands = true

SWEP.WorldModel	= "models/weapons/tfa_cso/w_skull5.mdl"

SWEP.HoldType = "ar2"

DEFINE_BASECLASS(SWEP.Base)

SWEP.Offset = {
    Pos = {
        Up = -3.4,
        Right = 1,
        Forward = 11.5,
    },
    Ang = {
        Up = 170,
        Right = 68,
        Forward = 100
    },
	Scale = 1
}

SWEP.Bullets = {
	HullSize = 0,
	Num = 1,
	DamageDropoffRange = 4500,
	DamageDropoffRangeMax = 7520,
	DamageMinimumPercent = 0.1,
	Spread = vector_origin
}

SWEP.Ironsights = {
	Pos = Vector(5, -15, -2),
	Angle = Vector(2.6, 1.37, 3.5),
	TimeTo = 0.075,
	TimeFrom = 0.1,
	SlowDown = 0.3,
	Zoom = 0.3,
}

SWEP.RecoilInstructions = {
	Interval = 1,
	Angle(-20),
}

function SWEP:FireBulletsCallback(tr, dmginfo, data)
	BaseClass.FireBulletsCallback(self, tr, dmginfo, data)

	if (SERVER and ttt.GetRoundState() ~= ttt.ROUNDSTATE_PREPARING) then
		local ent = tr.Entity
		local own = self:GetOwner()

		if (not IsValid(own)) then
			return
		end

		if (IsValid(ent) and ent:IsPlayer()) then
			own:SetMaxHealth(own:GetMaxHealth() + self.HealthGained)

			pluto.statuses.heal(own, self.HealthGained, self.HealthGained / 10)

			timer.Simple(8, function()
				if (IsValid(own) and own:Alive() and ttt.GetRoundState() ~= ttt.ROUNDSTATE_PREPARING) then
					own:SetMaxHealth(own:GetMaxHealth() - self.HealthGained)
				end
			end)
		else
			pluto.statuses.poison(own, {
				Weapon = self,
				Damage = self.HealthCost
			})
		end
	end
end

SWEP.Ortho = {-2, 3, angle = Angle(0, -130, 155), size = 0.8}
