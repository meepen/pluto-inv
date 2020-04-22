SWEP.Base = "weapon_ttt_crowbar"
SWEP.Category = "TFA CS:O"
SWEP.PrintName = "Dread Nova"
SWEP.Author				= "Kamikaze"

SWEP.ViewModel = "models/weapons/tfa_cso/c_dreadnova.mdl"
SWEP.WorldModel = "models/weapons/tfa_cso/w_dreadnova_a.mdl"
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 85

SWEP.Primary.Delay = 0.25
SWEP.Primary.Damage = 15
SWEP.Primary.Extents = Vector(2, 2, 2)
SWEP.Secondary.Delay = 1.4

SWEP.WElements = {
	["dreadnova_a"] = { type = "Model", model = "models/weapons/tfa_cso/w_dreadnova_a.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(6, -1.5, 5.50), angle = Angle(0, -180, 10), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.Offset = {
	Pos = {
		Up = -7.5,
		Right = 3,
		Forward = 3,
	},
	Ang = {
		Up = -30,
		Right = 160,
		Forward = -10
	},
	Scale = 1
}

sound.Add {
	level = 80,
	volume = 0.4,
	['name'] = "Dreadnova.Charge_Start",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/dreadnova/charge_start.ogg" },
	['pitch'] = {100,100}
}

sound.Add {
	level = 80,
	volume = 0.4,
	['name'] = "Dreadnova.Charge_Release",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/dreadnova/charge_release.ogg" },
	['pitch'] = {100,100}
}
sound.Add({
	level = 80,
	volume = 0.4,
	['name'] = "Dreadnova.Draw",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/dreadnova/draw.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	level = 80,
	volume = 0.4,
	['name'] = "Dreadnova.SlashEnd",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/budgetslayer/slash_end.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	level = 80,
	volume = 0.4,
	['name'] = "Dreadnova.SlashEnd",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/dreadnova/slash_end.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	level = 80,
	volume = 0.4,
	['name'] = "Dreadnova.Slash1",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/dreadnova/slash1.ogg"},
	['pitch'] = {100,100}
})
sound.Add({
	level = 80,
	volume = 0.4,
	['name'] = "Dreadnova.Slash2",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/dreadnova/slash2.ogg"},
	['pitch'] = {100,100}
})
sound.Add({
	level = 80,
	volume = 0.4,
	['name'] = "Dreadnova.Slash3",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/dreadnova/slash3.ogg"},
	['pitch'] = {100,100}
})
sound.Add({
	level = 80,
	volume = 0.4,
	['name'] = "Dreadnova.Slash4",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/dreadnova/slash4.ogg"},
	['pitch'] = {100,100}
})
sound.Add({
	level = 80,
	volume = 0.4,
	['name'] = "Dreadnova.Stab",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/dreadnova/stab.ogg"},
	['pitch'] = {100,100}
})
sound.Add({
	level = 80,
	volume = 0.4,
	['name'] = "Dreadnova.HitFleshSlash",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/dreadnova/hit.ogg"},
	['pitch'] = {100,100}
})
sound.Add({
	level = 80,
	volume = 0.4,
	['name'] = "Dreadnova.HitFleshStab",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/dreadnova/stab_hit.ogg"},
	['pitch'] = {100,100}
})
sound.Add({
	level = 80,
	volume = 0.4,
	['name'] = "Dreadnova.HitWall",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/dreadnova/wall.ogg" },
	['pitch'] = {100,100}
})

SWEP.Primary.Attacks = {
	{
		['act'] = ACT_VM_HITLEFT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 24*5, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(-180,0,90), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 600, --This isn't overpowered enough, I swear!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.03, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "Dreadnova.Slash1", -- Sound ID
		['snd_delay'] = 0.035,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 0.3, --time before next attack
		['hull'] = 32, --Hullsize
		['direction'] = "F", --Swing dir,
		['hitflesh'] = "Dreadnova.HitFleshSlash",
		['hitworld'] = "Dreadnova.HitWall",
		['maxhits'] = 25
	},
	{
		['act'] = ACT_VM_HITRIGHT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 24*5, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(180,0,90), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 600, --This isn't overpowered enough, I swear!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.03, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "Dreadnova.Slash2", -- Sound ID
		['snd_delay'] = 0.035,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 0.3, --time before next attack
		['hull'] = 32, --Hullsize
		['direction'] = "F", --Swing dir,
		['hitflesh'] = "Dreadnova.HitFleshSlash",
		['hitworld'] = "Dreadnova.HitWall",
		['maxhits'] = 25
	},
	{
		['act'] = ACT_VM_PRIMARYATTACK, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 24*5, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(180,0,0), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 1200, --This isn't overpowered enough, I swear!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.03, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "Dreadnova.Slash3", -- Sound ID
		['snd_delay'] = 0.035,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 0.3, --time before next attack
		['hull'] = 32, --Hullsize
		['direction'] = "F", --Swing dir,
		['hitflesh'] = "Dreadnova.HitFleshSlash",
		['hitworld'] = "Dreadnova.HitWall",
		['maxhits'] = 25
	},
}

SWEP.Secondary.Attacks = {
	{
		['act'] = ACT_VM_MISSLEFT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 28*5, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(0,60,0), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 4500, --Nope!! Not overpowered!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.4, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 0.4,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 0.9, --time before next attack
		['hull'] = 128, --Hullsize
		['direction'] = "F", --Swing dir
		['hitflesh'] = "Dreadnova.HitFleshSlash",
		['hitworld'] = "Dreadnova.HitWall",
		['maxhits'] = 25
	}
}

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
