include("ai_translations.lua")
include("sh_anim.lua")

SWEP.Author = "Silverlan"
SWEP.Contact = "Silverlan@gmx.de"
SWEP.Purpose = ""
SWEP.Instructions = ""
SWEP.Category		= "SLVBase_Fixed"

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/v_pistol.mdl"
SWEP.WorldModel		= "models/weapons/w_357.mdl"
SWEP.AnimPrefix		= "python"
SWEP.EmptySound = true
SWEP.InWater = true
SWEP.AutoReload = true

SWEP.Spawnable = false
SWEP.AdminSpawnable = false

SWEP.Primary.ClipSize		= 8					// Size of a clip
SWEP.Primary.DefaultClip	= 32				// Default number of bullets in a clip
SWEP.Primary.Automatic		= false				// Automatic/Semi Auto
SWEP.Primary.Ammo			= "Pistol"
SWEP.Primary.AmmoPickup	= 32
SWEP.Primary.NumShots = 1

SWEP.Secondary.ClipSize		= 8					// Size of a clip
SWEP.Secondary.DefaultClip	= 32				// Default number of bullets in a clip
SWEP.Secondary.Automatic	= false				// Automatic/Semi Auto
SWEP.Secondary.Ammo			= "Pistol"
SWEP.Secondary.AmmoPickup	= 0
SWEP.NPCFireRate = 0.1

SWEP.LastReload = 0

function SWEP:Initialize()
	self.Weapon:SetClip1(self.Primary.ClipSize)
	self.Weapon:SetClip2(self.Secondary.ClipSize)
	self:SetWeaponHoldType(self.HoldType)
	if SERVER then
		self:SetNPCMinBurst(30)
		self:SetNPCMaxBurst(30)
		self:SetNPCFireRate(self.NPCFireRate)
		self.Weapon.nextIdle = 0
		self:Drop()
		if self.PostInit then
			timer.Simple(0, function()
				if IsValid(self) then
					self:PostInit()
				end
			end)
		end
	end
	if self.Weapon.OnInitialize then self.Weapon:OnInitialize() end
end

function SWEP:GetClip1()
	if self.Weapon.Primary.SingleClip then return self:GetAmmoPrimary()
	else return self:Clip1() end
end

function SWEP:GetClip2()
	return self:Clip2()
end

function SWEP:GetAmmoPrimary()
	if !self.Weapon.Owner:IsPlayer() then return 9999 end
	return self.Weapon.Owner:GetAmmunition(self.Primary.Ammo)
end

function SWEP:GetAmmoSecondary()
	if !self.Weapon.Owner:IsPlayer() then return 9999 end
	return self.Weapon.Owner:GetAmmunition(self.Secondary.Ammo)
end

function SWEP:Precache()
end

function SWEP:PrimaryAttack(ShootPos, ShootDir)
	if (!self.Weapon.InWater && self.Owner:WaterLevel() == 3) then return end
	self.Weapon:SetNextSecondaryFire(CurTime() +self.Primary.Delay)
	self.Weapon:SetNextPrimaryFire(CurTime() +self.Primary.Delay)
	self.Weapon:Attack(self.Primary.Cone, ShootPos, ShootDir)
	if self.Weapon.OnPrimaryAttack then self.Weapon:OnPrimaryAttack() end
end

function SWEP:Attack(flCone, ShootPos, ShootDir)
	if !self:CanPrimaryAttack() then if self.Weapon.AutoReload then self:Reload() end; return end
	if SERVER then
		self:slvPlaySound("Primary")
		self:AddClip1(-1)
		if self.Owner:IsPlayer() then self.Owner:ViewPunch(Angle(self.Primary.Recoil,0,0)) end// math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 )) end
	end
	local iDmg = self.Weapon.Primary.Damage
	if type(iDmg) == "string" then iDmg = GetConVarNumber(iDmg) end
	self.Weapon:ShootBullet(iDmg, self.Weapon.Primary.NumShots, flCone, self.Weapon.Primary.Tracer, self.Weapon.Primary.Force, ShootPos, ShootDir)
	if game.SinglePlayer() || CLIENT then
		self:SetNetworkedFloat("LastShootTime", CurTime())
	end
end

function SWEP:SecondaryAttack(ShootPos, ShootDir)
	self.Weapon:SetNextSecondaryFire(CurTime() +self.Secondary.Delay)
	self.Weapon:SetNextPrimaryFire(CurTime() +self.Secondary.Delay)
	
	if (!self.Weapon.InWater && self.Owner:WaterLevel() == 3) then return end
	self.Weapon:Attack(self.Secondary.Cone, ShootPos, ShootDir)
	if self.Weapon.OnSecondaryAttack then self.Weapon:OnSecondaryAttack() end
end


function SWEP:CanPrimaryAttack()
	if self:Clip1() == 0 then if SERVER && self.Weapon.EmptySound then self.Weapon:EmitSound("Weapon_Pistol.Empty") end; return false end
	return true
end

function SWEP:CanSecondaryAttack()
	if self:Clip2() == 0 then return false end
	return true
end

function SWEP:CanReload()
	return !self.Primary.SingleClip && self:GetAmmoPrimary() > 0 && self:Clip1() < self.Primary.DefaultClip && !self.Weapon.delayReloaded && !self.Weapon.nextReload
end

function SWEP:NextIdle(flDelay)
	if flDelay == -1 then self.Weapon.nextIdle = nil; return end
	self.Weapon.nextIdle = CurTime() +flDelay
end

function SWEP:ReloadTime(flDelay)
	self.Weapon.delayReloaded = CurTime() +flDelay
end

function SWEP:ReloadOnNextIdle(bReload)
	self.bReloadOnNextIdle = bReload
end

function SWEP:Think()
	if self.attackDelay && CurTime() >= self.attackDelay then self:DoAttack(); self.attackDelay = nil end
	if self.Weapon.nextIdle && CurTime() >= self.Weapon.nextIdle then
		if (self.Weapon.AutoReload || self.bReloadOnNextIdle) && self:Clip1() == 0 && self.Weapon:CanReload() then self.bReloadOnNextIdle = nil; self:Reload(); return end
		if self.Weapon.CustomIdle then self.Weapon:CustomIdle()
		else
			self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
			self:NextIdle(self:SequenceDuration())
		end
		if self.Weapon.OnIdle then self.Weapon:OnIdle() end
	end
	if self.Weapon.SingleReload && self.Weapon.nextReload && CurTime() >= self.Weapon.nextReload then
		self.Weapon:SendWeaponAnim(ACT_VM_PULLBACK)
		self:ReloadTime(self.Weapon.ReloadDelay)
		self.nextReload = CurTime() +self:SequenceDuration()
	end
	if self.Weapon.delayReloaded && CurTime() >= self.Weapon.delayReloaded then
		local iClip = self:Clip1()
		local iClipMax = self.Primary.DefaultClip
		local iClipAdd
		if !self.Weapon.SingleReload then iClipAdd = iClipMax -iClip
		else iClipAdd = 1 end
		local iAmmoPrimary = self:GetAmmoPrimary()
		if iClipAdd > iAmmoPrimary then iClipAdd = iAmmoPrimary end
		
		if SERVER then
			self:slvPlaySound("ReloadB")
			self:AddClip1(iClipAdd)
			self:AddAmmoPrimary(-iClipAdd)
		end
		self.Weapon.delayReloaded = nil
		if self.Weapon.nextReload && ((iClip +iClipAdd) == iClipMax || self:GetAmmoPrimary() == 0) then
			self.Weapon.nextReload = nil
			self:SendWeaponAnim(ACT_VM_PULLBACK_HIGH)
			if self.Weapon.OnReloadEnded then self.Weapon:OnReloadEnded() end
			self:NextIdle(self:SequenceDuration())
		end
	end
	if CLIENT then if self.Weapon.OnThink then self.Weapon:OnThink() end; return end
	for k, v in pairs(self.tblSoundsDelayed) do
		if CurTime() >= v.flDelay then
			local sSound = v.sSound
			if v.bClientOnly then
				self.Owner:ConCommand("playgamesound " .. sSound)
			else
				self.Owner:EmitSound(sSound, 75, 100)
			end
			self.tblSoundsDelayed[k] = nil
		end
	end
	for k, v in pairs(self.tblAnimsDelayed) do
		if CurTime() >= v.flDelay then
			self:SendWeaponAnim(v.act)
			self.tblAnimsDelayed[k] = nil
		end
	end
	if self.Weapon.OnThink then self.Weapon:OnThink() end
end

function SWEP:Reload(bInformClient)
	self:DoReload(bInformClient)
end

function SWEP:DoReload(bInformClient)
	if !self:CanReload() then return false end
	self.Weapon:SendWeaponAnim(ACT_VM_RELOAD)
	self:NextIdle(self:SequenceDuration())
	self:PlayThirdPersonAnim(PLAYER_RELOAD)
	if SERVER then
		self:slvPlaySound("ReloadA")
		if bInformClient then
			umsg.Start("HLR_SWEPDoReload", rp)
			umsg.Entity(self)
			umsg.End()
		end
	end
	if self.Weapon.SingleReload then
		self.Weapon.nextReload = CurTime() +self:SequenceDuration()
		return
	end
	self.Weapon:SetNextSecondaryFire(self.Weapon.nextIdle)
	self.Weapon:SetNextPrimaryFire(self.Weapon.nextIdle)
	
	if self.Owner:IsPlayer() then self:ReloadTime(self.Weapon.ReloadDelay)
	else
		self:SetClip1(self.Primary.DefaultClip)
	end
	if self.Weapon.OnReload then self.Weapon:OnReload() end
	return true
end

function SWEP:Deploy()
	if SERVER then self:slvPlaySound("Deploy") end
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	self:NextIdle(self:SequenceDuration())
	self.Weapon:SetNextSecondaryFire(self.Weapon.nextIdle)
	self.Weapon:SetNextPrimaryFire(self.Weapon.nextIdle)
	if self.Weapon.OnDeploy then self.Weapon:OnDeploy() end
	return true
end

function SWEP:Draw()
	return true
end

function SWEP:GetCapabilities()
	return bit.bor(CAP_WEAPON_RANGE_ATTACK1,CAP_INNATE_RANGE_ATTACK1,CAP_WEAPON_RANGE_ATTACK2,CAP_INNATE_RANGE_ATTACK2)
end

function SWEP:Holster(wep)
	if IsValid(self.clMdl) then self.clMdl:Remove() end
	self.lastAttack = nil
	self.lastAttackAct = nil
	self.attackDelay = nil
	self.Weapon.delayReloaded = nil
	self.Weapon.tblSoundsDelayed = {}
	self.Weapon.tblAnimsDelayed = {}
	if self.Weapon.OnHolster then self.Weapon:OnHolster() end
	return true
end

function SWEP:ShootEffects(bSecondary)
	if !IsValid(self.Owner) then return end
	self.Owner:MuzzleFlash()
	local act
	if !bSecondary then act = ACT_VM_PRIMARYATTACK
	else act = ACT_VM_SECONDARYATTACK end
	self.Weapon:SendWeaponAnim(act)
	self:NextIdle(self:SequenceDuration())
	self:PlayThirdPersonAnim()
end

function SWEP:EntsInViewCone(pos, flDistance)
	for k, v in ipairs(ents.FindInSphere(pos, flDistance)) do
		if IsValid(v) && v != self && v != self.Owner && (v:IsPhysicsEntity() || v:IsNPC() || v:IsPlayer()) && self.Owner:EntInViewCone(v,25) then
			return true
		end
	end
	return false
end

function SWEP:DoMeleeDamage(iDist, iDmg)
	local posStart = self.Owner:GetShootPos()
	local posEnd = posStart +self.Owner:GetAimVector() *iDist
	local tracedata = {}
	tracedata.start = posStart
	tracedata.endpos = posEnd
	tracedata.filter = self.Owner
	local tr = util.TraceLine(tracedata)
	
	local bEntsInViewCone = self:EntsInViewCone(tracedata.endpos, 12)
	local act
	if tr.Hit || bEntsInViewCone then
		if IsValid(tr.Entity) || bEntsInViewCone then
			if CLIENT then return 1, tr end
			return 1, tr, util.BlastDmg(self, self.Owner, tr.HitPos +tr.Normal *6, 12, iDmg, self.Owner, DMG_SLASH)
		end
		return 2, tr
	end
	return 0, tr
end

function SWEP:ShootBullet(damage, num_bullets, aimcone, tracer, force, ShootPos, ShootDir, bSecondary)
	local bullet = {}
	bullet.Num 		= num_bullets
	if !self.Owner:IsPlayer() then
		bullet.Src = ShootPos
		bullet.Dir = ShootDir
		bullet.Spread 	= Vector(0, 0, 0)
	else
		bullet.Src 		= self.Owner:GetShootPos()
		bullet.Dir 		= self.Owner:GetAimVector()
		bullet.Spread 	= Vector(aimcone, aimcone, 0)
	end
	bullet.Tracer	= tracer || 2
	bullet.Force	= force || 1
	bullet.Damage	= damage
	bullet.AmmoType = "Pistol"
	
	self.Owner:FireBullets(bullet)
	
	self.Weapon:ShootEffects(bSecondary)
end

function SWEP:ContextScreenClick( aimvec, mousecode, pressed, ply )
end

function SWEP:OnRestore()
end

function SWEP:OnRemove()
end

function SWEP:OwnerChanged(arg)
end
