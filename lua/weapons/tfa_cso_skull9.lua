SWEP.Base = "weapon_ttt_crowbar"
SWEP.Category = "TFA CS:O"
SWEP.PrintName = "Vitality's End"
SWEP.Editor = "add___123"

SWEP.ViewModel = "models/weapons/tfa_cso/c_skull_9.mdl"
SWEP.WorldModel = "models/weapons/tfa_cso/w_skull_9.mdl"
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 100
SWEP.UseHands = true
SWEP.HoldType = "melee2"

SWEP.Spawnable = false
SWEP.AdminSpawnable = false
SWEP.DrawCrosshair = true

SWEP.Primary.Range           = 130
SWEP.Primary.Delay           = 1.2
SWEP.Primary.Damage          = 60
SWEP.Secondary.Damage        = 60

SWEP.Primary.Attacks = {
	{
		['act'] = ACT_VM_PRIMARYATTACK, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 130, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(0,0,-90), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 450, --This isn't overpowered enough, I swear!!
		['dmgtype'] = bit.bor(DMG_SLASH,DMG_ALWAYSGIB), --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 1.5, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 1,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 0, --time before next attack
		['hull'] = 256, --Hullsize
		['direction'] = "F", --Swing dir,
		['hitflesh'] = "SKULL9.HitFlesh",
		['hitworld'] = "SKULL9.HitWorld"
	}
}

SWEP.Secondary.Attacks = {
	{
		['act'] = ACT_VM_SECONDARYATTACK, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 130, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(-140,-5,0), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 1, --This isn't overpowered enough, I swear!!
		['dmgtype'] = DMG_CLUB, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.8, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 1,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 2, --time before next attack
		['hull'] = 512, --Hullsize
		['direction'] = "S", --Swing dir,
		['hitflesh'] = "Weapon_Knife.Hit",
		['hitworld'] = "Weapon_Knife.HitWall",
		['maxhits'] = 1
	}
}

sound.Add({
	['name'] = "SKULL9.Draw",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/skull9/draw.ogg" },
	['pitch'] = {95,105}
})
sound.Add({
	['name'] = "SKULL9.Slash1",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/skull9/slash_1.ogg" },
	['pitch'] = {95,105}
})
sound.Add({
	['name'] = "SKULL9.Slash2",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/skull9/slash_2.ogg" },
	['pitch'] = {95,105}
})
sound.Add({
	['name'] = "SKULL9.HitFlesh",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/skull9/hit_flesh.ogg" },
	['pitch'] = {95,105}
})
sound.Add({
	['name'] = "SKULL9.HitWorld",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/skull9/hit_wall.ogg" },
	['pitch'] = {95,105}
})
sound.Add({
	['name'] = "TFABaseMelee.Null",
	['channel'] = CHAN_STATIC,
	['sound'] = { "common/null.ogg" },
	['pitch'] = {95,105}
})

DEFINE_BASECLASS(SWEP.Base)

function SWEP:DoHit(hitEnt, tr, damage)
	BaseClass.DoHit(self, hitEnt, tr, damage)

	if (SERVER and ttt.GetRoundState() ~= ttt.ROUNDSTATE_PREPARING) then
		if (not IsValid(hitEnt) or not hitEnt:IsPlayer()) then
			return 
		end

		local dmg = damage or self.Primary.Damage

		if (hitEnt:Health() > 0) then
			pluto.statuses.poison(self:GetOwner(), {
				Weapon = self,
				Damage = dmg * (3 / 4)
			})
		end
	end
end

function SWEP:GetCurrentAnimation(what)
	local t = self[what or "Primary"].Attacks
	return t[(self:GetBulletsShot() % #t) + 1]
end

function SWEP:SoundEffect(tr_main)
	if (IsValid(tr_main.Entity) and tr_main.Entity:IsPlayer()) then
		self:EmitSound(self:GetCurrentAnimation().hitflesh)
	elseif (IsValid(tr_main.Entity) or tr_main.HitWorld) then
		self:EmitSound(self:GetCurrentAnimation().hitworld)
	elseif (SERVER) then
		self:EmitSound(self:GetCurrentAnimation().snd)
	end
end

function SWEP:PrimaryAttack()
	if (self:GetNextPrimaryFire() > CurTime()) then
		return
	end

	local owner = self:GetOwner()
	owner:SetAnimation(PLAYER_ATTACK1)
	self:SetBulletsShot(self:GetBulletsShot() + 1)

	self:SendWeaponAnim(self:GetCurrentAnimation "Secondary".act)
	self:SetSecondary(CurTime() + 1.1)

	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
end