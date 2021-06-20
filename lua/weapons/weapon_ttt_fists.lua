SWEP.Base = "weapon_ttt_crowbar"
SWEP.PrintName = "Fists"
SWEP.Author	= "add___123"

SWEP.ViewModel = "models/weapons/c_arms.mdl"
SWEP.WorldModel = ""
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 50
SWEP.UseHands = true

SWEP.Primary.Damage = 25

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.DrawAmmo = false

SWEP.HitDistance = 64

SWEP.PlutoSpawnable = false
SWEP.AutoSpawnable = false

local SwingSound = "WeaponFrag.Throw"
local HitSound = "Flesh.ImpactHard"

DEFINE_BASECLASS(SWEP.Base)

function SWEP:Initialize()
	BaseClass.Initialize(self)

	self:SetHoldType "fist"
end

function SWEP:SetupDataTables()
	BaseClass.SetupDataTables(self)

	self:NetVar("NextMeleeAttack", "Int", 0)
	self:NetVar("NextIdle", "Int", 0)
	self:NetVar("Combo", "Int", 0)
end

function SWEP:UpdateNextIdle()
	local vm = self.Owner:GetViewModel()
	self:SetNextIdle(CurTime() + vm:SequenceDuration() / vm:GetPlaybackRate())
end

function SWEP:PrimaryAttack(right)
	self.Owner:SetAnimation(PLAYER_ATTACK1)

	local anim = "fists_left"

	if (right) then
		anim = "fists_right"
	end

	if (self:GetCombo() >= 2) then
		anim = "fists_uppercut"
	end

	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence(vm:LookupSequence(anim))

	self:EmitSound(SwingSound)

	self:UpdateNextIdle()
	self:SetNextMeleeAttack(CurTime() + 0.2)

	self:SetNextPrimaryFire(CurTime() + 0.7)
	self:SetNextSecondaryFire(CurTime() + 0.7)
end

function SWEP:SecondaryAttack()
	self:PrimaryAttack(true)
end

local phys_pushscale = GetConVar("phys_pushscale")

function SWEP:DealDamage()
	local anim = self:GetSequenceName(self.Owner:GetViewModel():GetSequence())

	self.Owner:LagCompensation(true)

	local tr = util.TraceLine({
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.HitDistance,
		filter = self.Owner,
		mask = MASK_SHOT_HULL
	})

	if (not IsValid(tr.Entity)) then
		tr = util.TraceHull({
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.HitDistance,
			filter = self.Owner,
			mins = Vector(-10, -10, -8),
			maxs = Vector(10, 10, 8),
			mask = MASK_SHOT_HULL
		})
	end

	-- We need the second part for single player because SWEP:Think is ran shared in SP
	if (tr.Hit and not (game.SinglePlayer() and CLIENT)) then
		self:EmitSound(HitSound)
	end

	local hit = false
	local scale = phys_pushscale:GetFloat()

	if (SERVER and IsValid(tr.Entity) and (tr.Entity:IsNPC() or tr.Entity:IsPlayer() or tr.Entity:Health() > 0)) then
		local dmginfo = DamageInfo()

		local attacker = self.Owner
		if (not IsValid(attacker)) then attacker = self end
		dmginfo:SetAttacker(attacker)

		dmginfo:SetInflictor(self)
		dmginfo:SetDamage(self.Primary.Damage + math.random(-5, 5))

		if (anim == "fists_left") then
			dmginfo:SetDamageForce(self.Owner:GetRight() * 4912 * scale + self.Owner:GetForward() * 9998 * scale) -- Yes we need those specific numbers
		elseif (anim == "fists_right") then
			dmginfo:SetDamageForce(self.Owner:GetRight() * -4912 * scale + self.Owner:GetForward() * 9989 * scale)
		elseif (anim == "fists_uppercut") then
			dmginfo:SetDamageForce(self.Owner:GetUp() * 5158 * scale + self.Owner:GetForward() * 10012 * scale)
			dmginfo:SetDamage(math.random(12, 24))
		end

		SuppressHostEvents(NULL) -- Let the breakable gibs spawn in multiplayer on client
		tr.Entity:TakeDamageInfo(dmginfo)
		SuppressHostEvents(self.Owner)

		hit = true
	end

	if (IsValid(tr.Entity)) then
		local phys = tr.Entity:GetPhysicsObject()
		if (IsValid(phys)) then
			phys:ApplyForceOffset(self.Owner:GetAimVector() * 80 * phys:GetMass() * scale, tr.HitPos)
		end
	end

	if (SERVER) then
		if (hit and anim ~= "fists_uppercut") then
			self:SetCombo(self:GetCombo() + 1)
		else
			self:SetCombo(0)
		end
	end

	self.Owner:LagCompensation(false)
end

function SWEP:OnDrop()
	self:Remove() -- You can't drop fists
end

function SWEP:Deploy()
	local speed = GetConVarNumber("sv_defaultdeployspeed")

	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence(vm:LookupSequence("fists_draw"))
	vm:SetPlaybackRate(speed)

	self:SetNextPrimaryFire(CurTime() + vm:SequenceDuration() / speed)
	self:SetNextSecondaryFire(CurTime() + vm:SequenceDuration() / speed)
	self:UpdateNextIdle()

	if (SERVER) then
		self:SetCombo(0)
	end

	return true
end

function SWEP:Holster(...)
	self:SetNextMeleeAttack(0)

	return BaseClass.Holster(self, ...)
end

function SWEP:Think()
	local vm = self.Owner:GetViewModel()
	local curtime = CurTime()
	local idletime = self:GetNextIdle()

	if (idletime > 0 and CurTime() > idletime) then
		vm:SendViewModelMatchingSequence(vm:LookupSequence("fists_idle_0" .. math.random(1, 2)))

		self:UpdateNextIdle()
	end

	local meleetime = self:GetNextMeleeAttack()

	if (meleetime > 0 and CurTime() > meleetime) then
		self:DealDamage()

		self:SetNextMeleeAttack(0)
	end

	if (SERVER and CurTime() > self:GetNextPrimaryFire() + 0.1) then
		self:SetCombo(0)
	end
end