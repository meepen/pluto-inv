SWEP.Base = "weapon_tttbase"
SWEP.PrintName			= "Raygun"
SWEP.Author				= "ErrolLiamP"
SWEP.ViewModelFOV		= 50

SWEP.VElements = {
	["raygun"] = {
		type = "Model",
		model = "models/raygun/ray_gun.mdl",
		bone = "ValveBiped.Bip01_R_Hand",
		rel = "",
		pos = Vector(13.77, -0.616, -2.32),
		angle = Angle(-86.367, 2.88, 93.068),
		size = Vector(1.062, 1.062, 1.062),
		color = Color(255, 255, 255, 255),
		surpresslightning = false,
		material = "",
		skin = 1,
		bodygroup = {}
	}
}
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
	Pos = Vector(-6, 0, 0),
	Angle = Vector(2.4, -1.3, 1),
	TimeTo = 0.1,
	TimeFrom = 0.15,
	SlowDown = 0.9,
	Zoom = 0.95,
}

SWEP.Category				= "Call of Duty" 
SWEP.Slot					= 1
 
SWEP.UseHands               = true

SWEP.ViewModelFOV = 45
SWEP.ViewModel = "models/weapons/c_pistol.mdl"
SWEP.WorldModel = "models/raygun/ray_gun.mdl"
SWEP.ShowViewModel = true
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
	name = "Weapon_RayGun.Single",
	channel = CHAN_WEAPON,
	pitch = {95, 105},
	level = 70,
	sound = {
		"weapons/raygun/raygun_fire.wav",
	}
}

SWEP.Primary.Sound = "Weapon_RayGun.Single"

SWEP.Primary.ClipSize = 10
SWEP.Primary.DefaultClip = 10
SWEP.Primary.Delay = 0.45
SWEP.Primary.Ammo = "Pistol"
SWEP.HoldType = "pistol"


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

SWEP.RecoilInstructions = {
	Interval = 1,
	Angle(-10, 0.5),
	Angle(-10, 1),
	Angle(-10, -2),
}

SWEP.Ortho = {4.5, -3.8, angle = Angle(45, 55)}