SWEP.Base = "weapon_ttt_unarmed"
SWEP.PrintName = "Nitro Spray"

SWEP.Primary.Automatic = false

SWEP.RopeLength = 100


DEFINE_BASECLASS(SWEP.Base)

function SWEP:PrimaryAttack()
end

function SWEP:Tick()
	if (not SERVER) then
		return
	end

	if (IsValid(self:GetOwner()) and IsValid(self.FakePlayer)) then
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