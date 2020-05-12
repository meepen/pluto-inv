SWEP.Base = "weapon_ttt_magneto"
SWEP.PrintName = "Nitro Web"

SWEP.Primary.Automatic = false

SWEP.RopeLength = 100


DEFINE_BASECLASS(SWEP.Base)

function SWEP:Initialize()
	BaseClass.Initialize(self)

	self.Ropes = {}
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

	if (not IsValid(tr.Entity)) then
		return
	end


	local rope = constraint.Rope(owner, tr.Entity, 0, 0, vector_origin, tr.Entity:WorldToLocal(tr.HitPos),
		length, 20, 1300,
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

	return BaseClass.OnRemove(self)
end