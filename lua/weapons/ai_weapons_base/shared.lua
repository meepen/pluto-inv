SWEP.Author = "Cpt. Hazama"
SWEP.Contact = "Silverlan@gmx.de"
SWEP.Purpose = ""
SWEP.Instructions = ""
SWEP.HoldType = "pistol"

SWEP.Spawnable = false
SWEP.AdminSpawnable = false

SWEP.ViewModel		= "models/weapons/v_pistol.mdl"
SWEP.WorldModel		= "models/weapons/w_357.mdl"
SWEP.AnimPrefix		= "python"

SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"
SWEP.Primary.AmmoPickup	= 32
SWEP.Primary.NumShots = 1
SWEP.Primary.AmmoSize = -1
SWEP.Primary.Tracer = 1
SWEP.Primary.Force = 5

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.AmmoPickup	= 0

SWEP.Type = "pistol"
SWEP.Base = "ai_translator"
SWEP.DelayEquip = 0
SWEP.PrimaryClip = 0

function SWEP:Initialize()
	self.Type = self.HoldType
	if(SERVER) then self:InitSounds() end
end

function SWEP:InitSounds() self:slvPlaySound("Equip") end

function SWEP:Undeploy()
	self.Weapon:SetNextSecondaryFire(CurTime() +999)
	self.Weapon:SetNextPrimaryFire(CurTime() +999)
	if(SERVER) then self:UndeploySounds() end
end

function SWEP:UndeploySounds() self:slvPlaySound("Unequip") end

function SWEP:Equip(owner)
	self:SetNoDraw(true)
	self:DrawShadow(false)
	local fnext = CurTime() +self.DelayEquip
	self:SetNextPrimaryFire(fnext)
	self:SetNextSecondaryFire(fnext)
end

local acts = {
	["1gt"] = {
		[ACT_IDLE] = ACT_DOD_STAND_AIM_GREN_FRAG,
		[ACT_WALK] = ACT_DOD_WALK_AIM_GREN_FRAG,
		[ACT_RUN] = ACT_DOD_RUN_AIM_GREN_FRAG
	},
	["2ha"] = {
		[ACT_IDLE] = ACT_DOD_STAND_AIM_C96,
		[ACT_WALK] = ACT_DOD_WALK_AIM_C96,
		[ACT_RUN] = ACT_DOD_RUN_AIM_C96
	},
	["2hh"] = {
		[ACT_IDLE] = ACT_SLAM_STICKWALL_IDLE,
		[ACT_WALK] = ACT_SLAM_STICKWALL_ATTACH2,
		[ACT_RUN] = ACT_SLAM_STICKWALL_ATTACH
	},
	["2hl"] = {
		[ACT_IDLE] = ACT_MP_ATTACK_STAND_PRIMARY,
		[ACT_WALK] = ACT_MP_WALK_SECONDARY,
		[ACT_RUN] = ACT_MP_RUN_SECONDARY
	},
	["2hm"] = {
		[ACT_IDLE] = ACT_HL2MP_IDLE,
		[ACT_WALK] = ACT_SHOTGUN_RELOAD_FINISH,
		[ACT_RUN] = ACT_SHOTGUN_PUMP,
		[ACT_MELEE_ATTACK2] = ACT_MELEE_ATTACK2
	},
	["2hr"] = {
		[ACT_IDLE] = ACT_GESTURE_RANGE_ATTACK_AR2_GRENADE,
		[ACT_WALK] = ACT_GESTURE_RANGE_ATTACK_SMG2,
		[ACT_RUN] = ACT_GESTURE_RANGE_ATTACK_SMG1_LOW
	}
}

function SWEP:TranslateActivity(act)
	local holdType = self.HoldType
	if(holdType && acts[holdType] && acts[holdType][act]) then act = acts[holdType][act] end
	local owner = self:GetOwner()
	return IsValid(owner) && owner:TranslateActivity(act) || act
end

local gestures = {
	["1gt"] = {
		[ACT_DISARM] = ACT_GESTURE_RANGE_ATTACK2,
	},
	["2ha"] = {
		[ACT_DISARM] = ACT_DOD_HS_IDLE,
		[ACT_RANGE_ATTACK1] = ACT_GESTURE_RANGE_ATTACK_AR1
	},
	["2hh"] = {
		[ACT_DISARM] = ACT_SLAM_STICKWALL_ND_DRAW,
		[ACT_RANGE_ATTACK1] = ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1
	},
	["2hl"] = {
		[ACT_DISARM] = ACT_ITEM_THROW,
		[ACT_RANGE_ATTACK1] = ACT_GESTURE_RANGE_ATTACK_ML
	},
	["2hm"] = {
		[ACT_DISARM] = ACT_SMG2_TOBURST,
		[ACT_MELEE_ATTACK1] = ACT_GESTURE_MELEE_ATTACK2
	},
	["2hr"] = {
		[ACT_DISARM] = ACT_GESTURE_RANGE_ATTACK_SMG1,
		[ACT_RANGE_ATTACK1] = ACT_GESTURE_RANGE_ATTACK_AR1,
		[ACT_RANGE_ATTACK2] = ACT_IDLE_SMG1,
		[ACT_RELOAD] = ACT_IDLE_ANGRY_SMG1,
	}
}

function SWEP:TranslateGesture(act)
	local holdType = self.HoldType
	if(holdType && gestures[holdType] && gestures[holdType][act]) then act = gestures[holdType][act] end
	local owner = self:GetOwner()
	return IsValid(owner) && owner:TranslateGesture(act) || act
end

function SWEP:PrimaryAttack(pos,dir)
	if self.PrimaryClip <= 0 then return self:DoReload() end
	if(CurTime() < self:GetNextPrimaryFire()) then return end
	self.Weapon:SetNextSecondaryFire(CurTime() +self.Primary.Delay)
	self.Weapon:SetNextPrimaryFire(CurTime() +self.Primary.Delay)
	self.Weapon:DoPrimaryAttack(pos,dir)
end

function SWEP:DoPrimaryAttack(ShootPos,ShootDir)
	if self.PrimaryClip <= 0 then return self:DoReload() end
	if(CurTime() < self:GetNextPrimaryFire()) then return end
	self.Weapon:SetNextSecondaryFire(CurTime() +self.Primary.Delay)
	self.Weapon:SetNextPrimaryFire(CurTime() +self.Primary.Delay)
	self.Weapon:Attack(self.Primary.Cone,ShootPos,ShootDir)
	if self.Weapon.OnPrimaryAttack then self.Weapon:OnPrimaryAttack() end
end

function SWEP:Attack(flCone, ShootPos, ShootDir)
	if self.Owner:GunTraceBlocked() then return end
	if SERVER then
		self:slvPlaySound("Primary")
		self.PrimaryClip = self.PrimaryClip -1
	end
	local iDmg = self.Weapon.Primary.Damage
	if type(iDmg) == "string" then iDmg = GetConVarNumber(iDmg) end
	self.Owner:PlayLayeredGesture(self.Owner.WeaponFire,2,1)
	self.Weapon:ShootBullet(iDmg, self.Weapon.Primary.NumShots, flCone, 1, self.Weapon.Primary.Force, ShootPos, ShootDir)
end

function SWEP:ShootBullet(damage, num_bullets, aimcone, tracer, force, ShootPos, ShootDir, bSecondary)
	local bullet = {}
	bullet.Num 		= num_bullets
	bullet.Src 		= self.Owner:GetShootPos()
	bullet.Dir 		= self.Owner:GetAimVector()
	bullet.Spread 	= Vector(aimcone, aimcone, 0)
	bullet.Tracer	= tracer || 1
	bullet.TracerName = "Tracer"
	bullet.Force	= force || 1
	bullet.Damage	= damage
	bullet.AmmoType = "Pistol"
	
	self.Owner:FireBullets(bullet)
	
	self.Weapon:ShootEffects(bSecondary)
end

function SWEP:OnPrimaryAttack() end

function SWEP:SecondaryAttack()
end

function SWEP:Think()
end