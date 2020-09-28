
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("ai_translations.lua")
AddCSLuaFile("sh_anim.lua")

include("shared.lua")

SWEP.Weight				= 5			// Decides whether we should switch from/to this
SWEP.AutoSwitchTo		= true		// Auto switch to if we pick it up
SWEP.AutoSwitchFrom		= true		// Auto switch from if you pick up a better weapon
SWEP.tblSoundsDelayed = {}
SWEP.tblAnimsDelayed = {}

function SWEP:AddClip1(iAmount)
	self.Weapon:SetClip1(self:Clip1() +iAmount)
end

function SWEP:AddClip2(iAmount)
	self.Weapon:SetClip2(self:Clip2() +iAmount)
end

function SWEP:SetAmmoSecondary(iAmount)
	if !self.Owner:IsPlayer() then return end
	self.Weapon.Owner:SetAmmunition(self.Secondary.Ammo, iAmount)
end

function SWEP:AddAmmoSecondary(iAmount)
	if !self.Owner:IsPlayer() then return end
	self.Weapon.Owner:AddAmmunition(self.Secondary.Ammo, iAmount)
end

function SWEP:SetAmmoPrimary(iAmount)
	if !self.Owner:IsPlayer() then return end
	self.Weapon.Owner:SetAmmunition(self.Primary.Ammo, iAmount)
end

function SWEP:AddAmmoPrimary(iAmount)
	if !self.Owner:IsPlayer() then return end
	self.Weapon.Owner:AddAmmunition(self.Primary.Ammo, iAmount)
end

function SWEP:SendDelayedWeaponAnim(act, flDelay)
	table.insert(self.tblAnimsDelayed, {act = act, flDelay = CurTime() +flDelay})
end

local tblDecals = {}
tblDecals[MAT_ALIENFLESH] = "Impact.BloodyFlesh"
tblDecals[MAT_ANTLION] = "Impact.Antlion"
tblDecals[MAT_BLOODYFLESH] = "Impact.BloodyFlesh"
tblDecals[MAT_CLIP] = "Impact.Concrete"
tblDecals[MAT_COMPUTER] = "Impact.Concrete"
tblDecals[MAT_CONCRETE] = "Impact.Concrete"
tblDecals[MAT_DIRT] = "Impact.Sand"
tblDecals[MAT_FLESH] = "Impact.BloodyFlesh"
tblDecals[MAT_FOLIAGE] = "Impact.Wood"
tblDecals[MAT_GLASS] = "Impact.Glass"
tblDecals[MAT_GRATE] = "Impact.Metal"
tblDecals[MAT_METAL] = "Impact.Metal"
tblDecals[MAT_PLASTIC] = "Impact.Concrete"
tblDecals[MAT_SAND] = "Impact.Sand"
tblDecals[MAT_SLOSH] = "Impact.Sand"
tblDecals[MAT_TILE] = "Impact.Concrete"
tblDecals[MAT_VENT] = "Impact.Metal"
tblDecals[MAT_WOOD] = "Impact.Wood"
function SWEP:CreateDecal(tr)
	local sDecal = tblDecals[tr.MatType]
	if !sDecal then return end
	util.Decal(sDecal, tr.HitPos +tr.HitNormal, tr.HitPos -tr.HitNormal)
end

function SWEP:PlayThirdPersonAnim(anim)
	anim = anim || PLAYER_ATTACK1
	if !game.SinglePlayer() || self.Owner:IsNPC() then self.Owner:SetAnimation(anim); return end
	GAMEMODE:DoAnimationEvent(self.Owner, PLAYERANIMEVENT_ATTACK_PRIMARY)
	umsg.Start("slv_tpanim", self.Owner)
		umsg.Short(anim)
	umsg.End()
end

function SWEP:slvPlaySound(sSound, flDelay, bClientOnly)
	local iWav = string.find(sSound, ".wav")
	if !self.tblSounds[sSound] && !iWav then return end
	local sType = type(self.tblSounds[sSound])
	local _sSound
	if iWav then _sSound = sSound
	elseif sType == "string" then
		_sSound = self.tblSounds[sSound]
	else
		_sSound = self.tblSounds[sSound][math.random(1,table.Count(self.tblSounds[sSound]))]
	end
	if flDelay && flDelay > 0 then
		table.insert(self.tblSoundsDelayed, {sSound = _sSound, flDelay = CurTime() +flDelay, bClientOnly = bClientOnly})
		return
	end
	//print("Emitting sound " .. _sSound)
	if bClientOnly then
		self.Owner:ConCommand("playgamesound " .. _sSound)
	else
		self.Owner:EmitSound(_sSound, 75, 100)
	end
end

function SWEP:AcceptInput(name, entActivator, entCaller, data)
	return false
end

function SWEP:KeyValue(key, value)
end

function SWEP:OnPickedUp(entOwner)
	entOwner:EmitSound("items/ammo_pickup.wav", 75, 100)
	if !entOwner:IsPlayer() then return end
	if self.Primary.Ammo != "none" && !util.IsDefaultAmmoType(self.Primary.Ammo) then
		local iAmmoPrimary = entOwner:GetAmmunition(self.Primary.Ammo)
		local iAmmoPickup = self.Primary.AmmoPickup
		iAmmoPickup = math.Clamp(iAmmoPickup, 0, self.Primary.AmmoSize -iAmmoPrimary)
		if iAmmoPickup > 0 then
			entOwner:AddAmmunition(self.Primary.Ammo, iAmmoPickup)
			local entWeapon = entOwner:GetActiveWeapon()
			if IsValid(entWeapon) && entWeapon:GetClass() == self:GetClass() && !entWeapon.Primary.SingleClip && entWeapon:Clip1() == 0 && entWeapon:CanReload() then
				entWeapon:Reload(true)
			end
			if self:Clip1() == 0 && !self.Weapon.Primary.SingleClip && !self.Weapon.delayReloaded then self:Reload(true); return end
			local ammoName = util.GetAmmoName(self.Primary.Ammo)
			umsg.Start("HLR_HUDItemPickedUp", entOwner)
				umsg.String(ammoName .. "," .. iAmmoPickup)
			umsg.End()
		end
	end
	if self.Secondary.Ammo == "none" || self.Secondary.Ammo == self.Primary.Ammo then return end
	local iAmmoSecondary = entOwner:GetAmmunition(self.Secondary.Ammo)
	local iAmmoPickup = self.Secondary.AmmoPickup
	iAmmoPickup = math.Clamp(iAmmoPickup, 0, self.Secondary.AmmoSize -iAmmoSecondary)
	if iAmmoPickup > 0 then
		entOwner:AddAmmunition(self.Secondary.Ammo, iAmmoPickup)
		local rp = RecipientFilter() 
		rp:AddPlayer(entOwner)
		local ammoName = util.GetAmmoName(self.Secondary.Ammo)
		umsg.Start("HLR_HUDItemPickedUp", rp)
			umsg.String(ammoName .. "," .. iAmmoPickup)
		umsg.End()
	end
end

function SWEP:Equip(entOwner)
	self:OnPickedUp(entOwner)
	if self.Weapon.OnEquip then self.Weapon:OnEquip(entOwner) end
end

function SWEP:EquipAmmo(entOwner)
	self:OnPickedUp(entOwner)
	if self.Weapon.OnEquipAmmo then self.Weapon:OnEquipAmmo(entOwner) end
end

function SWEP:Drop()
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then return end
	local tracedata = {}
	tracedata.start = self:GetPos()
	tracedata.endpos = tracedata.start -Vector(0,0,8192)
	tracedata.mask = MASK_SOLID_BRUSHONLY
	local tr = util.TraceLine(tracedata)
	
	self:SetPos(tr.HitPos +Vector(0,0,2))
	self:SetAngles(tr.HitNormal:Angle() +Angle(90,0,0))
end

function SWEP:OnDrop()
	self:Drop()
end

function SWEP:ShouldDropOnDie()
	return true
end

function SWEP:NPCShoot_Secondary(ShootPos, ShootDir)
	self:SecondaryAttack(ShootPos, ShootDir)
end

function SWEP:NPCShoot_Primary(ShootPos, ShootDir)
	self:PrimaryAttack(ShootPos, ShootDir)
end

AccessorFunc(SWEP, "fNPCMinBurst", "NPCMinBurst")
AccessorFunc(SWEP, "fNPCMaxBurst", "NPCMaxBurst")
AccessorFunc(SWEP, "fNPCFireRate", "NPCFireRate")
AccessorFunc(SWEP, "fNPCMinRestTime", "NPCMinRest")
AccessorFunc(SWEP, "fNPCMaxRestTime", "NPCMaxRest")


