SWEP.Base = "tfa_melee_base"
SWEP.Category = "TFA CS:O"
SWEP.PrintName = "Dual Nata Knives"
SWEP.Author		= "Kamikaze" --Author Tooltip
SWEP.ViewModel = "models/weapons/tfa_cso/c_dualnata.mdl"
SWEP.WorldModel = "models/weapons/tfa_cso/w_dualnata.mdl"
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 80
SWEP.UseHands = true
SWEP.HoldType = "knife"
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


SWEP.Offset = { --Procedural world model animation, defaulted for CS:S purposes.
		Pos = {
		Up = -2,
		Right = 1,
		Forward = 3,
		},
		Ang = {
		Up = 80,
		Right = -90,
		Forward = -90
		},
		Scale = 1
}

SWEP.WElements = {
	["dual_nata"] = { type = "Model", model = "models/weapons/tfa_cso/w_dualnata.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(4, 1.5, -0.5), angle = Angle (-75, -60, -40), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

sound.Add({
	['name'] = "Dualnata.Draw",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/dualnata/draw.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Dualnata.Slash1",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/dualnata/slash1.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Dualnata.Slash2",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/dualnata/slash2.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Dualnata.Wall",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/dualnata/wall.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Dualnata.Stab",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/dualnata/stab.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Dualnata.Stab_Hit",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/dualnata/stab_hit.ogg" },
	['pitch'] = {100,100}
})

SWEP.Primary.Attacks = {
	{
		['act'] = ACT_VM_HITLEFT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 85, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(90,0,-20), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 160, --This isn't overpowered enough, I swear!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.15, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "Weapon_Knife.Miss", -- Sound ID
		['snd_delay'] = 0.01,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 0.5, --time before next attack
		['hull'] = 70, --Hullsize
		['direction'] = "W", --Swing dir,
		['hitflesh'] = "Weapon_Knife.Hit",
		['hitworld'] = "Dualnata.Wall"
	},
		{
		['act'] = ACT_VM_HITRIGHT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 85, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(-90,0,-10), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 160, --This isn't overpowered enough, I swear!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.15, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "Weapon_Knife.Miss", -- Sound ID
		['snd_delay'] = 0.01,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 0.5, --time before next attack
		['hull'] = 70, --Hullsize
		['direction'] = "W", --Swing dir,
		['hitflesh'] = "Weapon_Knife.Hit",
		['hitworld'] = "Dualnata.Wall"
	},
}

SWEP.Secondary.Attacks = {
	{
		['act'] = ACT_VM_MISSRIGHT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 90, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(0,5,0), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 800, --This isn't overpowered enough, I swear!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.15, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "Weapon_Knife.Miss", -- Sound ID
		['snd_delay'] = 0.0,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 1.25, --time before next attack
		['hull'] = 50, --Hullsize
		['direction'] = "S", --Swing dir,
		['hitflesh'] = "Dualnata.Stab_Hit",
		['hitworld'] = "Dualnata.Wall"
	}
}
if CLIENT then
	SWEP.WepSelectIconCSO = Material("vgui/killicons/tfa_cso_dualnata")
	SWEP.DrawWeaponSelection = TFA_CSO_DrawWeaponSelection
end
