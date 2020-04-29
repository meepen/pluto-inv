SWEP.Base				= "weapon_ttt_m4a1"
SWEP.Category				= "TFA CS:O"
SWEP.Author				= "Anri"
SWEP.PrintName				= "Lego M4A1"
SWEP.Slot				= 2

SWEP.Primary.Sound 			= "BrickPieceV2.Fire"

SWEP.AutoSpawnable = false
SWEP.Spawnable = false
SWEP.PlutoSpawnable = false

SWEP.ViewModel			= "models/weapons/tfa_cso/c_brick_piece_v2.mdl"
SWEP.ViewModelFOV			= 90
SWEP.ViewModelFlip			= true
SWEP.UseHands = true
SWEP.WorldModel			= "models/weapons/tfa_cso/w_brick_piece_v2.mdl"
SWEP.HoldType 				= "ar2"
SWEP.Offset = {
	Pos = {
		Up = -2.6,
		Right = 1,
		Forward = 17.25,
	},
	Ang = {
		Up = 94,
		Right = 0,
		Forward = 190
	},
	Scale = 1.15
}


SWEP.Ironsights = {
	Pos = Vector(6.73, -3, 0.23),
	Angle = Vector(3.186, -0.141, 0),
	TimeTo = 0.25,
	TimeFrom = 0.15,
	SlowDown = 0.35,
	Zoom = 0.6,
}

SWEP.MuzzleAttachment			= "1"

DEFINE_BASECLASS(SWEP.Base)

SWEP.DamageSounds = {
	default = {
		"imhurt01",
		"imhurt02",
		"moan01",
		"moan02",
		"moan03",
		"moan04",
		"moan05",
	},
	leg = {
		"myleg01",
		"myleg02",
	},
	chest = {
		"mygut01",
		"mygut02",
	}
}

function SWEP:DoFireBullets(src, dir, data)
	if (CLIENT) then
		return
	end

	local owner = self:GetOwner()

	local e = ents.Create "prop_physics"
	e:SetModel "models/hunter/plates/plate.mdl"

	dir = dir or owner:EyeAngles():Forward()
	src = src or owner:GetShootPos()

	e:SetModelScale(0.5 + math.random() * 0.5, 0)
	e:SetPos(src + dir * 50)
	e:Spawn()
	e:GetPhysicsObject():SetVelocity(dir * 10000)
	e:GetPhysicsObject():SetMass(5)

	e:AddCallback("PhysicsCollide", function(self, dat)
		local other = dat.HitEntity
		if (IsValid(other) and other:IsPlayer()) then
			timer.Simple(0, function()
				if (IsValid(self)) then
					self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
				end
			end)
		end
	end)
	e.Weapon = self
	e.Owner = self:GetOwner()

	hook.Add("EntityTakeDamage", e, function(self, vic, dmg)
		if (vic:IsPlayer() and dmg:GetInflictor() == self) then
			dmg:SetDamage(self.Weapon.Primary.Damage)
			dmg:SetInflictor(self.Weapon)
			dmg:SetAttacker(self.Owner)


			if (math.random() > 0.3) then
				local hg = -1

				local fmt = pluto.models.gendered[vic:GetModel()] == "Male" and "vo/npc/male01/%s.wav" or "vo/npc/female01/%s.wav"

				local type = "default"

				if (math.random() > 0.25) then
					if (hg == HITGROUP_RIGHTLEG or hg == HITGROUP_LEFTLEG) then
						type = "leg"
					elseif (hg == HITGROUP_CHEST or hg == HITGROUP_GEAR or hg == HITGROUP_STOMACH) then
						type = "chest"
					end
				end

				vic:EmitSound(string.format(fmt, (table.Random(self.Weapon.DamageSounds[type]))))
				self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
			end
		end
	end)

	e:SetColor(ColorRand())

	timer.Simple(10, function()
		if (IsValid(e)) then
			e:Remove()
		end
	end)
end
