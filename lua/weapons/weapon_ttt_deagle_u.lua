AddCSLuaFile()

local tbl = {"Magnum.ClipOut","weapons/deagle_beast/de_clipout.ogg",
"Magnum.ClipIn","weapons/deagle_beast/de_clipin.ogg",
"Magnum.SlideForward","weapons/deagle_beast/de_slideback.ogg",
"Magnum.Deploy","weapons/deagle_beast/de_deploy.ogg",
}
for i = 1,#tbl,2 do
	sound.Add(
	{
		name = tbl[i],
		channel = CHAN_WEAPON,
		volume = 1.0,
		soundlevel = 80,
		sound = tbl[i+1]
	})
end

SWEP.PrintName 		= "Demon's Promise"
SWEP.Slot 			= 1
SWEP.SlotPos 		= 0

SWEP.Base 		= "weapon_tttbase"
SWEP.HoldType 	= "pistol"

SWEP.ViewModel 	= "models/cf/c_deagle_beast.mdl"
SWEP.WorldModel = "models/cf/w_deagle_beast.mdl"

SWEP.Ortho = {-3.5, 6, size = 0.7, angle = Angle(-45, 180, 145)}

SWEP.Primary.Sound 		= Sound("weapons/deagle_beast/deagle-1.ogg")
SWEP.Primary.Damage 	= 45
SWEP.Primary.ClipSize 	= 8
SWEP.Primary.Delay 		= 0.6
SWEP.Primary.DefaultClip= 16
SWEP.Primary.Automatic 	= true
SWEP.Primary.Ammo          = "AlyxGun"
SWEP.AmmoEnt               = "item_ammo_revolver_ttt"
SWEP.Primary.Recoil = 2
SWEP.Primary.RecoilTiming = 0.1
SWEP.HeadshotMultiplier = 5

SWEP.MeleeRange 	= 50
SWEP.MeleeDamage 	= 62
SWEP.MeleeDuration	= 1.2
SWEP.DeployDuration	= 0
SWEP.MeleeAttack 	= 0.165
SWEP.MuzzleScale	= 1.3

SWEP.Bullets = {
	HullSize = 0,
	Num = 1,
	DamageDropoffRange = 600,
	DamageDropoffRangeMax = 3600,
	DamageMinimumPercent = 0.1,
	Spread = Vector(0.02, 0.02)
}

SWEP.RecoilInstructions = {
	Interval = 1,
	Angle(-50),
}

SWEP.NoPlayerModelHands = true
SWEP.DeploySequence = 3
SWEP.MeleeSequence = 12

SWEP.Ironsights = false

DEFINE_BASECLASS "weapon_tttbase"

function SWEP:SetupDataTables()
	BaseClass.SetupDataTables(self)

	self:NetVar("MeleeTime", "Float", math.huge)
end

function SWEP:SendWeaponSequence(seq,o)
	o = o or self:GetOwner()
	local vm = o:GetViewModel()
	if IsValid(vm) then
		vm:SendViewModelMatchingSequence(seq)
	end
end

local swing, hit = {"weapons/knife/knife_slash1.wav","weapons/knife/knife_slash2.wav"},{"weapons/knife/knife_hit1.wav","weapons/knife/knife_hit2.wav","weapons/knife/knife_hit3.wav","weapons/knife/knife_hit4.wav"}

function SWEP:SecondaryAttack()
	if (self:GetNextSecondaryFire() > CurTime()) then
		return
	end

	self:SendWeaponSequence(self.MeleeSequence)
	local ct = CurTime()+self.MeleeDuration
	self:SetNextSecondaryFire(ct)
	self:SetNextPrimaryFire(ct)

	self:SetMeleeTime(CurTime() + self.MeleeAttack)

	self:EmitSound(table.Random(swing), nil, nil, nil, CHAN_USER_BASE + 1)

	self.Owner:DoAnimationEvent(ACT_GMOD_GESTURE_MELEE_SHOVE_2HAND)
end

local maxs = Vector(5, 5, 5)

local base = BaseClass
function SWEP:Think()
	if (self:GetMeleeTime() < CurTime()) then
		self:SetMeleeTime(math.huge)
		
		local owner = self:GetOwner()
		owner:LagCompensation(true)

		local spos = owner:GetShootPos()
		local sdest = spos + owner:GetAimVector() * 80

		local tr_main = util.TraceHull {
			start = spos,
			endpos = sdest,
			filter = owner,
			mask = MASK_SHOT_HULL,
			mins = -maxs,
			maxs = maxs
		}

		local hitEnt = tr_main.Entity

		if (IsValid(hitEnt) or tr_main.HitWorld) then
			self:SendWeaponAnim(ACT_VM_HITCENTER)

			if (not CLIENT or IsFirstTimePredicted()) then
				local edata = EffectData()
				edata:SetStart(spos)
				edata:SetOrigin(tr_main.HitPos)
				edata:SetNormal(VectorRand())
				edata:SetSurfaceProp(tr_main.SurfaceProps)
				edata:SetHitBox(tr_main.HitBox)
				edata:SetDamageType(DMG_CLUB)
				edata:SetEntity(hitEnt)

				util.Effect("Impact", edata)
				if (hitEnt:IsPlayer() or hitEnt:GetClass() == "prop_ragdoll") then
					edata:SetColor(BLOOD_COLOR_RED)
					edata:SetScale(1)
					util.Effect("BloodImpact", edata, true, true)
				end
			end
		end


		-- Do another trace that sees nodraw stuff like func_button
		local tr_all = util.TraceLine {
			start = spos,
			endpos = sdest,
			filter = owner
		}

		if (IsValid(hitEnt)) then
			local dmg = DamageInfo()
			dmg:SetDamage(self.Primary.Damage)
			dmg:SetAttacker(owner)
			dmg:SetInflictor(self)
			dmg:SetDamageForce(owner:GetAimVector() * 1500)
			dmg:SetDamagePosition(tr_main.HitPos)
			dmg:SetDamageType(DMG_CLUB)

			self:EmitSound(table.Random(hit), nil, nil, nil, CHAN_USER_BASE + 1)

			if (SERVER) then
				hitEnt:DispatchTraceAttack(dmg, tr_main)
			end
		end

		owner:LagCompensation(false)
	end

	return BaseClass.Think(self)
end

function SWEP:Holster(w)
	if (self:GetMeleeTime() ~= math.huge) then
		return false
	end

	return BaseClass.Holster(self)
end