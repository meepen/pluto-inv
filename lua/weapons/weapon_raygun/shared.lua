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
		"weapons/waw_raygun/fire1.wav",
	}
}

sound.Add {
	name = "waw_raygun.open",
	channel = CHAN_WEAPON,
	pitch = 100,
	level = 70,
	sound = {
		"weapons/waw_raygun/open.wav",
	}
}

sound.Add {
	name = "waw_raygun.out",
	channel = CHAN_WEAPON,
	pitch = 100,
	level = 70,
	sound = {
		"weapons/waw_raygun/out.wav",
	}
}

sound.Add {
	name = "waw_raygun.in",
	channel = CHAN_WEAPON,
	pitch = 100,
	level = 70,
	sound = {
		"weapons/waw_raygun/in.wav",
	}
}

sound.Add {
	name = "waw_raygun.open",
	channel = CHAN_WEAPON,
	pitch = 100,
	level = 70,
	sound = {
		"weapons/waw_raygun/open.wav",
	}
}

sound.Add {
	name = "waw_raygun.close",
	channel = CHAN_WEAPON,
	pitch = 100,
	level = 70,
	sound = {
		"weapons/waw_raygun/close.wav",
	}
}

SWEP.Primary.Sound = "waw_raygun.Single"

SWEP.Primary.ClipSize = 10
SWEP.Primary.DefaultClip = 10
SWEP.Primary.Delay = 0.45
SWEP.Primary.Ammo = "Pistol"
SWEP.HoldType = "pistol"

DEFINE_BASECLASS(SWEP.Base)


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

function SWEP:GetViewModelPosition(eyepos, eyeang)
	return BaseClass.GetViewModelPosition(self, eyepos + eyeang:Forward() * 5, eyeang)
end

SWEP.RecoilInstructions = {
	Interval = 1,
	Angle(-10, 0.5),
	Angle(-10, 1),
	Angle(-10, -2),
}

SWEP.Ortho = {4.5, -3.8, angle = Angle(45, 55)}