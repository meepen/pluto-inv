SWEP.Base = "tfa_melee_base"
SWEP.Category = "TFA CS:O"
SWEP.PrintName = "Dual Sword Phantom Slayer"

SWEP.ViewModel = "models/weapons/tfa_cso/c_dualphantomslayer.mdl"
SWEP.WorldModel = "models/weapons/tfa_cso/w_dualsword_thunder.mdl"
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 80
SWEP.UseHands = true
SWEP.HoldType = "melee"
SWEP.DrawCrosshair = true

SWEP.Primary.Directional = false

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.DisableIdleAnimations = false

SWEP.Secondary.CanBash = false

-- nZombies Stuff
SWEP.NZWonderWeapon		= true	-- Is this a Wonder-Weapon? If true, only one player can have it at a time. Cheats aren't stopped, though.
--SWEP.NZRePaPText		= "your text here"	-- When RePaPing, what should be shown? Example: Press E to your text here for 2000 points.
SWEP.NZPaPName				= "Dancing Dragons"
SWEP.NZPaPReplacement 	= "tfa_cso_dualsword_rb"	-- If Pack-a-Punched, replace this gun with the entity class shown here.
SWEP.NZPreventBox		= false	-- If true, this gun won't be placed in random boxes GENERATED. Users can still place it in manually.
SWEP.NZTotalBlackList	= false	-- if true, this gun can't be placed in the box, even manually, and can't be bought off a wall, even if placed manually. Only code can give this gun.
SWEP.PaPMats			= {}

SWEP.Precision = 50
SWEP.Secondary.MaxCombo = -1
SWEP.Primary.MaxCombo = -1
SWEP.MoveSpeed = 1.2 --Multiply the player's movespeed by this.

SWEP.WElements = {
	["fire_sword"] = { type = "Model", model = "models/weapons/tfa_cso/w_dualsword_fire.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(3.5, 0, 8.00), angle = Angle(10, -100, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.Offset = {
		Pos = {
		Up = -8,
		Right = 1,
		Forward = 4,
		},
		Ang = {
		Up = 180,
		Right = 180,
		Forward = 0
		},
		Scale = 1
}

sound.Add({
	['name'] = "DualSword.Idle",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/dual_sword/idle.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "DualSword.SkillStart",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/dual_sword/skill_start.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "DualSword.SkillEnd",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/dual_sword/skill_end.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "DualSword.SlashEnd",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/dual_sword/swing_end.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "DualSword.StabEnd",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/dual_sword/stab_end.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "DualSword.Swing",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/dual_sword/swing_1.ogg", "weapons/tfa_cso/dual_sword/swing_2.ogg", "weapons/tfa_cso/dual_sword/swing_3.ogg", "weapons/tfa_cso/dual_sword/swing_4.ogg", "weapons/tfa_cso/dual_sword/swing_5.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "DualSword.Stab",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/dual_sword/stab_1.ogg", "weapons/tfa_cso/dual_sword/stab_2.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "DualSword.HitFleshSlash",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/dual_sword/hit_1.ogg", "weapons/tfa_cso/dual_sword/hit_2.ogg", "weapons/tfa_cso/dual_sword/hit_3.ogg" },
	['pitch'] = {95,105}
})
sound.Add({
	['name'] = "DualSword.HitFleshStab",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/dual_sword/stab_1_hit.ogg", "weapons/tfa_cso/dual_sword/stab_2_hit.ogg" },
	['pitch'] = {95,105}
})
sound.Add({
	['name'] = "DualSword.HitWall",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/dual_sword/hit_wall.ogg" },
	['pitch'] = {95,105}
})

SWEP.Primary.Attacks = {
	{
		['act'] = ACT_VM_HITLEFT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 25*5, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(-180,0,15), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 100, --This isn't overpowered enough, I swear!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.03, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 0.035,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 0.135, --time before next attack
		['hull'] = 128, --Hullsize
		['direction'] = "L", --Swing dir,
		['hitflesh'] = "DualSword.HitFleshSlash",
		['hitworld'] = "Weapon_Knife.HitWall",
		['maxhits'] = 25
	},
	{
		['act'] = ACT_VM_HITRIGHT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 25*5, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(180,0,35), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 100, --This isn't overpowered enough, I swear!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.03, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 0.035,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 0.135, --time before next attack
		['hull'] = 128, --Hullsize
		['direction'] = "L", --Swing dir,
		['hitflesh'] = "DualSword.HitFleshSlash",
		['hitworld'] = "Weapon_Knife.HitWall",
		['maxhits'] = 25
	},
	{
		['act'] = ACT_VM_PRIMARYATTACK, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 25*5, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(-180,0,-35), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 100, --This isn't overpowered enough, I swear!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.03, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 0.035,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 0.135, --time before next attack
		['hull'] = 128, --Hullsize
		['direction'] = "L", --Swing dir,
		['hitflesh'] = "DualSword.HitFleshSlash",
		['hitworld'] = "Weapon_Knife.HitWall",
		['maxhits'] = 25
	},
	{
		['act'] = ACT_VM_PULLBACK, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 25*5, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(180,0,17.5), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 100, --This isn't overpowered enough, I swear!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.03, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 0.035,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 0.135, --time before next attack
		['hull'] = 128, --Hullsize
		['direction'] = "L", --Swing dir,
		['hitflesh'] = "DualSword.HitFleshSlash",
		['hitworld'] = "Weapon_Knife.HitWall",
		['maxhits'] = 25
	},
}

SWEP.Secondary.Attacks = {
	{
		['act'] = ACT_VM_MISSLEFT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 30*5, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(0,90,0), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 750, --Nope!! Not overpowered!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.035, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 0.035,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 0.5, --time before next attack
		['hull'] = 256, --Hullsize
		['direction'] = "F", --Swing dir
		['hitflesh'] = "DualSword.HitFleshStab",
		['hitworld'] = "Weapon_Knife.HitWall",
		['maxhits'] = 25
	},
	{
		['act'] = ACT_VM_MISSRIGHT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 32*5, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(0,90,0), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 2500, --Nope!! Not overpowered!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.05, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 0.05,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 1, --time before next attack
		['hull'] = 256, --Hullsize
		['direction'] = "F", --Swing dir
		['hitflesh'] = "DualSword.HitFleshStab",
		['hitworld'] = "Weapon_Knife.HitWall",
		['maxhits'] = 25
	}
}

SWEP.InspectionActions = {ACT_VM_RECOIL1}

DEFINE_BASECLASS(SWEP.Base)
function SWEP:Holster( ... )
	self:StopSound("DualSword.Idle")
	return BaseClass.Holster(self,...)
end
if CLIENT then
	SWEP.WepSelectIconCSO = Material("vgui/killicons/tfa_cso_dualsword")
	SWEP.DrawWeaponSelection = TFA_CSO_DrawWeaponSelection
end
