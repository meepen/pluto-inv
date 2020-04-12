SWEP.Base = "tfa_melee_base"
SWEP.Category = "TFA CS:O"
SWEP.PrintName = "Snap Blade"
SWEP.Author		= "Kamikaze" --Author Tooltip
SWEP.ViewModel = "models/weapons/tfa_cso/c_snap_blade.mdl"
SWEP.WorldModel = "models/weapons/tfa_cso/w_snap_blade.mdl"
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
SWEP.Secondary.MaxCombo = -1
SWEP.Primary.MaxCombo = -1

SWEP.VMPos = Vector(0,0,0) --The viewmodel positional offset, constantly.  Subtract this from any other modifications to viewmodel position.

-- nZombies Stuff
SWEP.NZWonderWeapon		= false	-- Is this a Wonder-Weapon? If true, only one player can have it at a time. Cheats aren't stopped, though.
--SWEP.NZRePaPText		= "your text here"	-- When RePaPing, what should be shown? Example: Press E to your text here for 2000 points.
SWEP.NZPaPName				= "Lady's Kiss"
--SWEP.NZPaPReplacement 	= "tfa_cso_dualinfinityfinal"	-- If Pack-a-Punched, replace this gun with the entity class shown here.
SWEP.NZPreventBox		= false	-- If true, this gun won't be placed in random boxes GENERATED. Users can still place it in manually.
SWEP.NZTotalBlackList	= false	-- if true, this gun can't be placed in the box, even manually, and can't be bought off a wall, even if placed manually. Only code can give this gun.

SWEP.WElements = {
	["snap_blade"] = { type = "Model", model = "models/weapons/tfa_cso/w_snap_blade.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(4, 1, 4.00), angle = Angle(180, 170, 90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.Offset = { --Procedural world model animation, defaulted for CS:S purposes.
		Pos = {
		Up = -3,
		Right = 2.5,
		Forward = 3.5,
		},
		Ang = {
		Up = 90,
		Right = 180,
		Forward = -90
		},
		Scale = 1
}


sound.Add({
	['name'] = "SnapBlade.Draw",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/snap_blade/draw.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "SnapBlade.MidSlash1",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/snap_blade/midslash1.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "SnapBlade.MidSlash2",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/snap_blade/midslash2.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "SnapBlade.Stab",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/snap_blade/stab.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "SnapBlade.Wall",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/mastercombatknife/wall.ogg" },
	['pitch'] = {100,100}
})

SWEP.Primary.Attacks = {
	{
		['act'] = ACT_VM_PRIMARYATTACK, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 110, -- Trace distance
		['dir'] = Vector(-50,0,-70), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 180, --This isn't overpowered enough, I swear!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.15, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 0.01,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 0.6, --time before next attack
		['hull'] = 32, --Hullsize
		['direction'] = "W", --Swing dir,
		['hitflesh'] = "Weapon_Knife.Hit",
		['hitworld'] = "SnapBlade.Wall"
	},
	{
		['act'] = ACT_VM_HITRIGHT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 110, -- Trace distance
		['dir'] = Vector(150,0,0), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 180, --This isn't overpowered enough, I swear!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.15, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 0.01,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 0.6, --time before next attack
		['hull'] = 32, --Hullsize
		['direction'] = "L", --Swing dir,
		['hitflesh'] = "Weapon_Knife.Hit",
		['hitworld'] = "SnapBlade.Wall",
	},
}

SWEP.Secondary.Attacks = {
	{
		['act'] = ACT_VM_MISSRIGHT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 115, -- Trace distance
		['dir'] = Vector(120,0,-100), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 450, --This isn't overpowered enough, I swear!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.25, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 0.01,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 1.20, --time before next attack
		['hull'] = 32, --Hullsize
		['direction'] = "S", --Swing dir,
		['hitflesh'] = "Weapon_Knife.Hit",
		['hitworld'] = "SnapBlade.Wall"
	},
	{
		['act'] = ACT_VM_MISSLEFT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 110, -- Trace distance
		["dir"] = Vector(150,0,0), -- Trace direction/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 550, --This isn't overpowered enough, I swear!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.4, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 0.01,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 1.35, --time before next attack
		['hull'] = 128, --Hullsize
		['direction'] = "N", --Swing dir,
		['hitflesh'] = "Weapon_Knife.Hit",
		['hitworld'] = "SnapBlade.Wall"
	}
}
if CLIENT then
	SWEP.WepSelectIconCSO = Material("vgui/killicons/tfa_cso_snap_blade")
	SWEP.DrawWeaponSelection = TFA_CSO_DrawWeaponSelection
end
