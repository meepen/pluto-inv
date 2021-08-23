SWEP.Base = "weapon_tttbase"
SWEP.PrintName			= "Raygun"
SWEP.Author				= "ErrolLiamP"

SWEP.VElements = {}

SWEP.Offset = {
	Pos = {
        Up = -2,
        Right = 1,
        Forward = 12,
	},
	Ang = {
        Up = 90,
        Right = -90,
        Forward = 190
	}
}

SWEP.Ironsights = {
	Pos = Vector(-5, 1, 1.6),
	Angle = Vector(-0.7, -0.9, 0),
	TimeTo = 0.1,
	TimeFrom = 0.15,
	SlowDown = 0.9,
	Zoom = 0.95,
}

SWEP.Category				= "Call of Duty" 
SWEP.Slot					= 1
 
SWEP.UseHands               = true

SWEP.Secondary.Automatic = true

SWEP.ViewModelFOV = 60
SWEP.ViewModel = "models/weapons/v_waw_raygun.mdl"
SWEP.WorldModel = "models/raygun/ray_gun.mdl"

SWEP.ShowWorldModel = false
SWEP.ViewModelBoneMods = {
	["ValveBiped.base"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.clip"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.Bullets = {
	HullSize = 0,
	Num = 1,
	DamageDropoffRange = 5300,
	DamageDropoffRangeMax = 9600,
	DamageMinimumPercent = 0.1,
	Spread = vector_origin,
	TracerName = "raygun_effect"
}

sound.Add {
	name = "waw_raygun.Single",
	channel = CHAN_WEAPON,
	pitch = {95, 105},
	level = 70,
	sound = {
		"weapons/waw_raygun/fire.wav",
	}
}

sound.Add {
	name = "waw_raygun.open",
	channel = CHAN_WEAPON,
	pitch = 100,
	level = 70,
	sound = {
		"weapons/waw_raygun/open.wav",
	},
	volume = 0.6
}

sound.Add {
	name = "waw_raygun.out",
	channel = CHAN_WEAPON,
	pitch = 100,
	level = 70,
	sound = {
		"weapons/waw_raygun/out.wav",
	},
	volume = 0.6
}

sound.Add {
	name = "waw_raygun.in",
	channel = CHAN_WEAPON,
	pitch = 100,
	level = 70,
	sound = {
		"weapons/waw_raygun/in.wav",
	},
	volume = 0.6
}

sound.Add {
	name = "waw_raygun.open",
	channel = CHAN_WEAPON,
	pitch = 100,
	level = 70,
	sound = {
		"weapons/waw_raygun/open.wav",
	},
	volume = 0.6
}

sound.Add {
	name = "waw_raygun.close",
	channel = CHAN_WEAPON,
	pitch = 100,
	level = 70,
	sound = {
		"weapons/waw_raygun/close.wav",
	},
	volume = 0.6
}

SWEP.Primary.Sound = "waw_raygun.Single"
SWEP.Primary.Damage = 25
SWEP.HeadshotMultiplier = 1.5

SWEP.Primary.ClipSize = 20
SWEP.Primary.Delay = 0.45
SWEP.Primary.Ammo = "none"
SWEP.HoldType = "pistol"

DEFINE_BASECLASS(SWEP.Base)

function SWEP:SetupDataTables()
	self:NetVar("Mode", "Int", 0)
	return BaseClass.SetupDataTables(self)
end

function SWEP:GetReserveAmmo()
	return self.Primary.ClipSize
end

function SWEP:_DispatchEffect(EFFECTSTR)
	local owner = self:GetOwner()
	if (not IsValid(owner)) then
		return
	end

	local view = CLIENT and GetViewEntity() or owner:GetViewEntity()

	if (not owner:IsNPC() and view:IsPlayer() ) then
		ParticleEffectAttach(EFFECTSTR, PATTACH_POINT_FOLLOW, owner:GetViewModel(), owner:GetViewModel():LookupAttachment "muzzle")
	else
		ParticleEffectAttach(EFFECTSTR, PATTACH_POINT_FOLLOW, owner, owner:LookupAttachment "anim_attachment_rh")
	end
end

function SWEP:_ShootEffect(EFFECTSTR,startpos,endpos)
	local owner = self:GetOwner()
	if (not IsValid(owner)) then
		return
	end

	local view = CLIENT and GetViewEntity() or owner:GetViewEntity()
	if (not owner:IsNPC() and view:IsPlayer()) then
		util.ParticleTracerEx(EFFECTSTR, self:GetAttachment( self:LookupAttachment( "muzzle" ) ).Pos, endpos, true, owner:GetViewModel():EntIndex(), owner:GetViewModel():LookupAttachment "muzzle");
	else
		util.ParticleTracerEx(EFFECTSTR, owner:GetAttachment( owner:LookupAttachment( "anim_attachment_rh" ) ).Pos, endpos, true, owner:EntIndex(), owner:LookupAttachment "anim_attachment_rh");
	end
end
	
function SWEP:_ImpactEffect(traceHit)
	local data = EffectData()
	data:SetOrigin(traceHit.HitPos)
	data:SetNormal(traceHit.HitNormal)
	data:SetScale(20)
	util.Effect("StunstickImpact", data)

	local rand = math.random(1,1.5)
	self:CreateBlast(rand,traceHit.HitPos)
	self:CreateBlast(rand,traceHit.HitPos)

	self:EmitSound(Sound "weapons/raygun/raygun_fire.wav")
	if (SERVER and traceHit.Entity and IsValid(traceHit.Entity) and string.find(traceHit.Entity:GetClass(), "ragdoll")) then
		traceHit.Entity:Fire "StartRagdollBoogie"
	end
end

function SWEP:PrimaryAttack()
	self:SetMode(1)
	return BaseClass.PrimaryAttack(self)
end

function SWEP:SecondaryAttack()
	if (not self:CanPrimaryAttack() or self:GetNextPrimaryFire() > CurTime()) then
		return
	end

	self:SetMode(2)
	return BaseClass.PrimaryAttack(self)
end

function SWEP:IsToggleADS()
	return true
end

function SWEP:AddTracerEffectData(data)
	data:SetColor(self:GetMode())
end

function SWEP:ShootBullet(data)
	return BaseClass.ShootBullet(self, data) * self:GetMode()
end

function SWEP:GetViewModelPosition(eyepos, eyeang)
	return BaseClass.GetViewModelPosition(self, eyepos + eyeang:Forward() * 6, eyeang)
end

function SWEP:GetPenetration()
	if (self:GetMode() == 1) then
		return 100
	end

	return BaseClass.GetPenetration(self)
end

function SWEP:FireBulletsCallback(tr, dmginfo, data)
	BaseClass.FireBulletsCallback(self, tr, dmginfo, data)
	if (SERVER and not tr.HitregCallback and self:GetMode() == 2) then
		local inf, atk, pos = dmginfo:GetInflictor(), dmginfo:GetAttacker(), dmginfo:GetDamagePosition()

		local dmg = DamageInfo()
		dmg:SetInflictor(inf)
		dmg:SetAttacker(atk)
		dmg:SetDamagePosition(pos)

		local damage, dist = 20, 100

		for _, ent in ipairs(ents.FindInSphere(dmg:GetDamagePosition(), dist)) do
			if (ent:IsPlayer() and ent:Alive()) then
				dmg:SetDamage(damage - ent:GetPos():Distance(dmg:GetDamagePosition()) / dist * damage)
				ent:TakeDamageInfo(dmg)
			end
		end
	end
end

SWEP.RecoilInstructions = {
	Interval = 1,
	Angle(-10, 0.5),
	Angle(-10, 1),
	Angle(-10, -2),
}

SWEP.Ortho = {4.5, -3.8, angle = Angle(45, 55)}