SWEP.Base = "weapon_tttbase"
SWEP.Category = "TFA CS:O"
SWEP.Author = "Anri"
SWEP.Editor = "add___123" -- Changed basically everything

SWEP.Ironsights = false

SWEP.Spawnable = false
SWEP.AutoSpawnable = false
SWEP.PlutoSpawnable = false
SWEP.AdminSpawnable = false
SWEP.DrawCrosshair = true
SWEP.PrintName = "Sacred Strike"
SWEP.Slot = 2

SWEP.Primary.Sound = Sound("Paladin.Fire")

SWEP.Primary.Delay = 0.15
SWEP.Primary.BaseDamage = 25
SWEP.Primary.DashBonus = 5
SWEP.Primary.KillBonus = 5
SWEP.Primary.Damage = SWEP.Primary.BaseDamage

SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 350
SWEP.Primary.Ammo = "ar2"

SWEP.Primary.Automatic = true

SWEP.Secondary.Delay = 45
SWEP.Secondary.Duration = 6
SWEP.Secondary.Sound1 = "Weapon_Mortar.Single"
SWEP.Secondary.Sound2 = "TripwireGrenade.ShootRope"
SWEP.Secondary.KillCooldown = 0.5
SWEP.Secondary.KillExtension = 0.5
SWEP.AllowDrop = true

SWEP.ViewModel = "models/weapons/tfa_cso/c_paladin.mdl"
SWEP.ViewModelFOV = 74
SWEP.ViewModelFlip = true
SWEP.UseHands = true

SWEP.WorldModel = "models/weapons/tfa_cso/w_paladin.mdl"
SWEP.HoldType = "ar2"

SWEP.Offset = {
	Pos = {
		Up = -2.3,
		Right = 0.75,
		Forward = 5,
	},
	Ang = {
		Up = 90,
		Right = 0,
		Forward = 185
	},
	Scale = 1.2

}

local pow = 1.5
SWEP.RecoilInstructions = {
	Interval = 1,
	pow * Angle(-8, -2),
	pow * Angle(-7, -1),
	pow * Angle(-5, 3),
	pow * Angle(-4, 0),
	pow * Angle(-5, 0),
	pow * Angle(-5, 2),
	pow * Angle(-7, 1),
	pow * Angle(-6, 0),
	pow * Angle(-5, -3),
}

DEFINE_BASECLASS(SWEP.Base)

function SWEP:Initialize()
	BaseClass.Initialize(self)

	if (SERVER) then
		hook.Add("Think", self, self.DoThink)

		hook.Add("DoPlayerDeath", self, function(self, vic, att, dmg)
			if (IsValid(self:GetOwner()) and IsValid(vic) and self:GetOwner() == vic and self.Ragdoll) then
				BLINK_DISSOLVER:Fire("Dissolve", "DissolveID" .. self.Ragdoll:EntIndex(), 0.01)
				self.Ragdoll = nil
				-- Remove connection
				return
			end

			if (timer.Exists(tostring(self) .. "Returning") or not dmg) then
				return
			end

			local inf = dmg:GetInflictor()

			if (not IsValid(self) or not IsValid(inf)) then
				return
			end

			if (self ~= inf and not (IsValid(self:GetOwner()) and self:GetOwner() == att and (IsValid(att:GetActiveWeapon()) and self == att:GetActiveWeapon()))) then
				return
			end
			
			if (self:GetDashed()) then
				self:SetCharge(math.min(1, self:GetCharge() + self.Secondary.KillExtension))
				self.Primary.Damage = self.Primary.Damage + self.Primary.KillBonus
			else
				self:SetCharge(math.min(1, self:GetCharge() + self.Secondary.KillCooldown))
			end
		end)

		self.Anchor = ents.Create "prop_physics"
		if (IsValid(self.Anchor)) then
			self.Anchor:SetPos(self:GetPos())

			self.Anchor:SetModel("models/weapons/w_bugbait.mdl")

			self.Anchor:SetColor(Color(50, 250, 50, 240))
			self.Anchor:SetNoDraw(true)
			self.Anchor:DrawShadow(false)

			self.Anchor:SetHealth(999)
			self.Anchor:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
			self.Anchor:SetSolid(SOLID_NONE)

			self.Anchor:Spawn()
			local phys = self.Anchor:GetPhysicsObject()
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
end

SWEP.Ortho = {-2, 2, angle = Angle(-60, -20, 0)}

function SWEP:SetupDataTables()
	BaseClass.SetupDataTables(self)

	self:NetVar("Charge", "Float", 1)
	self:NetVar("Dashed", "Bool", false)
end

function SWEP:OnRemove()
	if (SERVER) then
		timer.Remove(tostring(self) .. "Returning")

		if (IsValid(self.Anchor)) then
			self.Anchor:Remove()
		end
	end
end

local function CreateShadow(self, ply)
    if (not IsValid(BLINK_DISSOLVER)) then
        BLINK_DISSOLVER = ents.Create "env_entity_dissolver"
        BLINK_DISSOLVER:SetKeyValue("dissolvetype", 3)
        BLINK_DISSOLVER:Spawn()
    end

	if (not IsValid(ply)) then
		return	
	end

	local rgd = ents.Create "prop_ragdoll"
	if (not IsValid(rgd)) then
		return
	end

	rgd:SetPos(ply:GetPos())
	rgd:SetModel(ply:GetModel())

	for k, bdgrp in ipairs(ply:GetBodyGroups()) do
		rgd:SetBodygroup(bdgrp.id, ply:GetBodygroup(bdgrp.id))
	end

	rgd:SetAngles(ply:GetAngles())
	rgd:Spawn()
	rgd:Activate()
	rgd:SetGravity(0)
	rgd:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
	rgd:SetMaxHealth(10000)
	rgd:SetHealth(10000)
	rgd.Owner = ply
	rgd:SetOwner(ply)

	if IsValid(rgd) then
		for i = 0, rgd:GetPhysicsObjectCount() - 1 do
			local phys = rgd:GetPhysicsObjectNum(i)
			phys:Wake()

			if IsValid(phys) then
				local pos, ang = ply:GetBonePosition(rgd:TranslatePhysBoneToBone(i))
				phys:EnableGravity(false)

				if pos and ang then
					phys:SetPos(pos)
					phys:SetAngles(ang)
				end
			end

			phys:EnableMotion(false)

			timer.Simple(0.1, function()
				phys:Sleep()
			end)
		end
	end

	local rope = constraint.Rope(self.Anchor, rgd, 0, 0, vector_origin, vector_origin,
		10, 10, 0,
		10, "cable/xbeam", false)

	rgd.IsSafeToRemove = true
	rgd:SetName("DissolveID" .. rgd:EntIndex())
	--MakeGold(rgd, "models/player/shared/steel_player")
	rgd:SetMaterial("cable/xbeam")

	self.Ragdoll = rgd
end

function SWEP:DoReload(act)
	BaseClass.DoReload(self, act)

	self:SetNextSecondaryFire(CurTime() + 0.1)
end

local last_dash = 0

function SWEP:SecondaryAttack()
	if (self:GetCharge() == 1 and not self:GetDashed()) then
		local ply = self:GetOwner()

		if (not IsValid(ply) or not ply:Alive() or CurTime() - last_dash < 0.1) then
			return
		end

		last_dash = CurTime()

		local dashVelocity = ply:GetVelocity()
		dashVelocity.z = 0
		dashVelocity = dashVelocity:GetNormalized()
		if (ply:OnGround()) then
			dashVelocity.z = 0.15
			ply:SetVelocity(dashVelocity * 1500)
		else
			ply:SetVelocity(dashVelocity * 200)
		end
		print("ADDING VELOCITY")

		if (CLIENT) then
			return
		end

		self:SetDashed(true)
		self.AllowDrop = false
		self.ReturnPos = ply:GetPos()
		self.ReturnEyeAngles = ply:EyeAngles()

		self.Primary.Damage = self.Primary.Damage + self.Primary.DashBonus

		timer.Simple(0.01, function()
			self:EmitSound(self.Secondary.Sound1)
		end)

		CreateShadow(self, ply)
		-- Create connection
	elseif (self:GetDashed()) then
		self:SetCharge(0)
	end
end

function SWEP:DoThink()
	if (IsValid(self:GetOwner()) and IsValid(self.Anchor)) then
		self.Anchor:SetPos(self:GetOwner():GetPos() + vector_up * 40)
		self.Anchor:SetAngles(self:GetOwner():GetAngles())
	end

	if (not timer.Exists(tostring(self) .. "Returning") and not self:GetDashed() and self:GetCharge() ~= 1) then
		self:SetCharge(math.min(1, self:GetCharge() + FrameTime() / self.Secondary.Delay))
	elseif (not timer.Exists(tostring(self) .. "Returning") and self:GetDashed() and self:GetCharge() ~= 0) then
		self:SetCharge(math.max(0, self:GetCharge() - FrameTime() / self.Secondary.Duration))
	elseif (not timer.Exists(tostring(self) .. "Returning") and self:GetDashed() and self:GetCharge() == 0) then
		local ply = self:GetOwner()

		if (not IsValid(ply) or not ply:Alive() or not self.ReturnPos or not self.ReturnEyeAngles --[[or not self.ReturnVelocity]]) then
			self:SetDashed(false)
			self.AllowDrop = true
			return
		end

		local oldPos = ply:GetPos()
		local oldEyeAngles = ply:EyeAngles()
		local dist = oldPos:Distance(self.ReturnPos)

		if (not dist or not oldPos or not oldEyeAngles) then
			return
		end
		
		local reps = math.Clamp(dist / 80, 40, 60)
		local count = 0

		self:SetDashed(false)

		timer.Simple(0.01, function()
			self:EmitSound(self.Secondary.Sound2)
		end)

		timer.Create(tostring(self) .. "Returning", 0.01, 0, function()
			count = count + 1

			if (not IsValid(ply) or not ply:Alive() or count > reps) then
				timer.Remove(tostring(self) .. "Returning")
				self.AllowDrop = true
				self:StopSound(self.Secondary.Sound2)
				self.Primary.Damage = self.Primary.BaseDamage
				if (IsValid(self.Ragdoll)) then
					BLINK_DISSOLVER:Fire("Dissolve", "DissolveID" .. self.Ragdoll:EntIndex(), 0.01)
					self.Ragdoll = nil
					-- Remove connection if dissolving doesn't automatically do it
				end
				return
			end

			local newPos = Vector(Lerp(count / reps, oldPos.x, self.ReturnPos.x), Lerp(count / reps, oldPos.y, self.ReturnPos.y), Lerp(count / reps, oldPos.z, self.ReturnPos.z) + (5 * count / reps))
			local newEyeAngles = Angle(Lerp(count / reps, oldEyeAngles.p, self.ReturnEyeAngles.p), Lerp(count / reps, oldEyeAngles.y, self.ReturnEyeAngles.y), Lerp(count / reps, oldEyeAngles.r, self.ReturnEyeAngles.r))

			ply:SetPos(newPos)
			ply:SetEyeAngles(newEyeAngles)
			ply:SetVelocity(-1 * ply:GetVelocity())
		end)
	end
end

function SWEP:Holster( ... )
	self:StopSound("Paladin.Idle")
	return BaseClass.Holster(self,...)
end

if (CLIENT) then
	function SWEP:DrawHUD()
		local w = 15
		local left = ScrW() / 2 - 50 - w / 2
		local h = 60
		local top = ScrH() / 2 - h / 2

		surface.SetDrawColor(color_black)
		surface.DrawOutlinedRect(left, top, w, h)

		if (self:GetCharge() > 1.2) then
			surface.SetDrawColor(0, 100, 255)
		elseif (self:GetCharge() > 0.8) then
			surface.SetDrawColor(0, 255, 255)
		elseif (self:GetCharge() > 0.4) then
			surface.SetDrawColor(0, 255, 100)
		else
			surface.SetDrawColor(100, 255, 0)
		end
		local real_tall = math.Round((h - 2) * self:GetCharge())
		surface.DrawRect(left + 1, top + 1 + (h - 2) - real_tall, w - 2, real_tall)

		BaseClass.DrawHUD(self)
	end
end