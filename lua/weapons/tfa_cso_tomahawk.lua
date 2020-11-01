SWEP.Base = "weapon_ttt_crowbar"
SWEP.Category = "TFA CS:O"
SWEP.PrintName = "Tomahawk"
SWEP.Author	= "Kamikaze"
SWEP.ViewModel = "models/weapons/tfa_cso/c_tomahawk.mdl"
SWEP.WorldModel = "models/weapons/tfa_cso/w_tomahawk.mdl"
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 85
SWEP.HoldType = "melee"
SWEP.Slot = 0

SWEP.StabMissTable = {"ACT_VM_PULLBACK"}

SWEP.Primary.Damage = 25

SWEP.Offset = {
	Pos = {
		Up = -6.5,
		Right = 0,
		Forward = 3.5,
	},
	Ang = {
		Up = -20,
		Right = 180,
		Forward = -20
	},
	Scale = 1
}

sound.Add({
	['name'] = "Tomahawk.Draw",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/tomahawk/draw.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Tomahawk.Slash1",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/tomahawk/slash1.ogg"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Tomahawk.Slash2",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/tomahawk/slash2.ogg"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Tomahawk.Stab",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/tomahawk/stab.ogg"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Tomahawk.HitFleshSlash1",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/tomahawk/hit1.ogg"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Tomahawk.HitFleshSlash2",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/tomahawk/hit2.ogg"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Tomahawk.HitFleshSlash3",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/tomahawk/hit3.ogg"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Tomahawk.HitWall",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/tomahawk/wall.ogg" },
	['pitch'] = {100,100}
})

SWEP.Primary.Attacks = {
	{
		['act'] = ACT_VM_HITLEFT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 15*5, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(80,0,-70), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 65, --This isn't overpowered enough, I swear!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.15, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 0.01,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 0.6, --time before next attack
		['hull'] = 32, --Hullsize
		['direction'] = "F", --Swing dir,
		['hitflesh'] = "Tomahawk.HitFleshSlash2",
		['hitworld'] = "Tomahawk.HitWall",
		['maxhits'] = 25
	},
	{
		['act'] = ACT_VM_HITRIGHT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 15*5, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(-80,0,-30), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 65, --This isn't overpowered enough, I swear!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.15, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 0.01,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 0.6, --time before next attack
		['hull'] = 32, --Hullsize
		['direction'] = "F", --Swing dir,
		['hitflesh'] = "Tomahawk.HitFleshSlash2",
		['hitworld'] = "Tomahawk.HitWall",
		['maxhits'] = 25
	}
}

SWEP.Secondary.Attacks = {
	{
		['act'] = ACT_VM_MISSLEFT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 15*5, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(0,0,-40), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 130, --Nope!! Not overpowered!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.2, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 0.01,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 1.2, --time before next attack
		['hull'] = 64, --Hullsize
		['direction'] = "F", --Swing dir
		['hitflesh'] = "Tomahawk.HitFleshSlash3",
		['hitworld'] = "Tomahawk.HitWall",
		['maxhits'] = 25
	}
}
SWEP.WElements = {}

SWEP.InspectionActions = {ACT_VM_RECOIL1}

DEFINE_BASECLASS(SWEP.Base)
function SWEP:Holster( ... )
	self:StopSound "Hellfire.Idle"
	return BaseClass.Holster(self,...)
end

function SWEP:Initialize()
	self:SetModelScale(15)
	BaseClass.Initialize(self)
end

function SWEP:GetCurrentAnimation(what)
	local t = self[what or "Primary"].Attacks
	return t[(self:GetBulletsShot() % #t) + 1]
end

function SWEP:MeleeAnimation(tr_main)
	self:SendWeaponAnim(self:GetCurrentAnimation().act)
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

function SWEP:SecondaryAttack()
	if (self:GetNextPrimaryFire() > CurTime()) then
		return
	end

	self:SetBulletsShot(self:GetBulletsShot() + 1)

	self:SendWeaponAnim(self:GetCurrentAnimation "Secondary".act)
	self:SetSecondary(CurTime() + 0.4)

	self:SetNextPrimaryFire(CurTime() + self.Secondary.Delay)
end

SWEP.Ortho = {2.2, 3, angle = Angle(0, 0, 0), size = 0.65}
