SWEP.Base = "tfa_melee_base"
SWEP.Category = "TFA CS:O"
SWEP.PrintName = "Holy Sword Divine Crusader"
SWEP.Author		= "Kamikaze" --Author Tooltip
SWEP.Type	= "Transcendense grade melee weapon"
SWEP.ViewModel = "models/weapons/tfa_cso/c_holysword.mdl"
SWEP.WorldModel = "models/weapons/tfa_cso/w_holysword.mdl"
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 80
SWEP.UseHands = true
SWEP.HoldType = "melee2"
SWEP.DrawCrosshair = true

SWEP.Primary.Directional = false

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.DisableIdleAnimations = false

SWEP.Secondary.CanBash = false

-- nZombies Stuff
SWEP.NZWonderWeapon		= true	-- Is this a Wonder-Weapon? If true, only one player can have it at a time. Cheats aren't stopped, though.
--SWEP.NZRePaPText		= "your text here"	-- When RePaPing, what should be shown? Example: Press E to your text here for 2000 points.
SWEP.NZPaPName				= "Holycalibur"
--SWEP.NZPaPReplacement 	= "tfa_cso_runebreaker_expert"	-- If Pack-a-Punched, replace this gun with the entity class shown here.
SWEP.NZPreventBox		= false	-- If true, this gun won't be placed in random boxes GENERATED. Users can still place it in manually.
SWEP.NZTotalBlackList	= false	-- if true, this gun can't be placed in the box, even manually, and can't be bought off a wall, even if placed manually. Only code can give this gun.
SWEP.PaPMats			= {}

SWEP.Precision = 50
SWEP.Secondary.MaxCombo = -1
SWEP.Primary.MaxCombo = -1

SWEP.Offset = {
		Pos = {
		Up = -12,
		Right = 2,
		Forward = 4,
		},
		Ang = {
		Up = 30,
		Right = -30,
		Forward = 70
		},
		Scale = 1
}

sound.Add({
	['name'] = "Holysword.SlashChange",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/holysword/slash_change.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Holysword.Draw",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/holysword/draw.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Holysword.Idle",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/holysword/idle.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Holysword.Paring",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/holysword/paring.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Holysword.ParingSlash",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/holysword/paring_slash.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Holysword.ParryAttack",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/holysword/parryattack.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Holysword.Slash1",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/holysword/slash1.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Holysword.Slash2",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/holysword/slash2.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Holysword.Slash3",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/holysword/slash3.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Holysword.HitWall",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/holysword/hitwall.ogg" },
	['pitch'] = {100,100}
})

SWEP.Primary.Attacks = {
	{
		['act'] = ACT_VM_HITLEFT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 28*5, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(-180,0,-45), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 1500, --This isn't overpowered enough, I swear!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.02, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 0.02,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 0.7, --time before next attack
		['hull'] = 128, --Hullsize
		['direction'] = "L", --Swing dir,
		['hitflesh'] = "Weapon_Knife.Hit",
		['hitworld'] = "Holysword.HitWall",
		['maxhits'] = 25
	},
	{
		['act'] = ACT_VM_HITRIGHT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 28*5, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(180,0,45), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 1500, --This isn't overpowered enough, I swear!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.02, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 0.02,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 0.7, --time before next attack
		['hull'] = 128, --Hullsize
		['direction'] = "L", --Swing dir,
		['hitflesh'] = "Weapon_Knife.Hit",
		['hitworld'] = "Holysword.HitWall",
		['maxhits'] = 25
	},
	{
		['act'] = ACT_VM_PRIMARYATTACK, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 28*5, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(0,0,-100), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 1800, --This isn't overpowered enough, I swear!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.02, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 0.02,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 0.7, --time before next attack
		['hull'] = 128, --Hullsize
		['direction'] = "L", --Swing dir,
		['hitflesh'] = "Weapon_Knife.Hit",
		['hitworld'] = "Holysword.HitWall",
		['maxhits'] = 25
	},
}

SWEP.Secondary.Attacks = {
	{
		['act'] = ACT_VM_MISSRIGHT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 25*5, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(180,0,0), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 6000, --This isn't overpowered enough, I swear!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 1.1, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 1.1,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 2.5, --time before next attack
		['hull'] = 128, --Hullsize
		['direction'] = "L", --Swing dir,
		['hitflesh'] = "Weapon_Knife.Hit",
		['hitworld'] = "Holysword.HitWall",
		['maxhits'] = 25
	}
}

DEFINE_BASECLASS(SWEP.Base)
function SWEP:Holster( ... )
	self:StopSound("Holysword.Idle")
	return BaseClass.Holster(self,...)
end
if CLIENT then
	SWEP.WepSelectIconCSO = Material("vgui/killicons/tfa_cso_holysword")
	SWEP.DrawWeaponSelection = TFA_CSO_DrawWeaponSelection
end
