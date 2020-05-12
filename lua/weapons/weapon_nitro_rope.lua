SWEP.Base = "weapon_ttt_magneto"
SWEP.PrintName = "Nitro Web"

SWEP.Primary.Automatic = false

SWEP.RopeLength = 100


DEFINE_BASECLASS(SWEP.Base)

function SWEP:Initialize()
	BaseClass.Initialize(self)

	self.Ropes = {}

	if (not SERVER) then
		return
	end

	self.FakePlayer = ents.Create "prop_physics"
	if (IsValid(self.FakePlayer)) then
		self.FakePlayer:SetPos(self:GetPos())

		self.FakePlayer:SetModel("models/weapons/w_bugbait.mdl")

		self.FakePlayer:SetColor(Color(50, 250, 50, 240))
		self.FakePlayer:SetNoDraw(true)
		self.FakePlayer:DrawShadow(false)

		self.FakePlayer:SetHealth(999)
		self.FakePlayer:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		self.FakePlayer:SetSolid(SOLID_NONE)

		self.FakePlayer:Spawn()
		local phys = self.FakePlayer:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetMass(200)
			phys:SetDamping(0, 1000)
			phys:EnableGravity(false)
			phys:EnableCollisions(false)
			phys:EnableMotion(false)
			phys:AddGameFlag(FVPHYSICS_PLAYER_HELD)
		end
	end
end

function SWEP:AllowTether(target)
	local phys = target:GetPhysicsObject()
	local ply = self:GetOwner()

	return IsValid(phys) and IsValid(ply) and
			  (not phys:HasGameFlag(FVPHYSICS_NO_PLAYER_PICKUP)) and
			  phys:GetMass() < 150 and
			  (target.CanPickup != false)
end


function SWEP:PrimaryAttack()
	if (IsValid(self.EntHolding)) then
		return BaseClass.PrimaryAttack(self)
	end

	if (not SERVER) then
		return
	end
	local amt = 0

	for rope, attached in pairs(self.Ropes) do
		if (IsValid(rope)) then
			amt = amt + 1
		end
	end

	if (amt >= 4) then
		return
	end

	local length = self.RopeLength
	local owner = self:GetOwner()
	owner:LagCompensation(true)
	local tr = util.TraceLine {
		start = owner:EyePos(),
		endpos = owner:EyePos() + owner:GetAimVector() * self.RopeLength,
		filter = player.GetAll(),
		mask = MASK_PLAYER_SOLID,
	}
	owner:LagCompensation(false)

	if (not IsValid(tr.Entity) or not self:AllowTether(tr.Entity)) then
		return
	end


	local rope = constraint.Rope(self.FakePlayer, tr.Entity, 0, 0, vector_origin, tr.Entity:WorldToLocal(tr.HitPos),
		length, length * 0.1, 2500,
		1, "cable/xbeam", false)

	if (not IsValid(rope)) then
		return
	end

	self.Ropes[rope] = tr.Entity
end

function SWEP:Think()
	if (BaseClass.Think) then
		BaseClass.Think(self)
	end

	if (not SERVER) then
		return
	end

	if (IsValid(self:GetOwner())) then
		self.FakePlayer:SetPos(self:GetOwner():GetPos() + vector_up * 20)
		self.FakePlayer:SetAngles(self:GetOwner():GetAngles())
	end

	for rope, attached in pairs(self.Ropes) do
		if (IsValid(rope)) then
			attached:SetPhysicsAttacker(self:GetOwner(), 1)
			attached:PhysWake()
		end
	end
end

function SWEP:Reload()
	for rope in pairs(self.Ropes) do
		if (IsValid(rope)) then
			rope:Remove()
		end
	end
end


function SWEP:OnRemove()
	for rope, attached in pairs(self.Ropes) do
		if (IsValid(rope)) then
			rope:Remove()
		end
	end

	if (IsValid(self.FakePlayer)) then
		self.FakePlayer:Remove()
	end

	return BaseClass.OnRemove(self)
end