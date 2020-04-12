SWEP.Base = "tfa_melee_base"
SWEP.Category = "TFA CS:O"
SWEP.PrintName = "Soul Bane Serrated Blade"
SWEP.Author		= "Kamikaze" --Author Tooltip
SWEP.ViewModel = "models/weapons/tfa_cso/c_mastercombatknife.mdl"
SWEP.WorldModel = "models/weapons/tfa_cso/w_mastercombatknife.mdl"
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
		Up = -8.2,
		Right = 1,
		Forward = 3.5,
		},
		Ang = {
		Up = 60,
		Right = -70,
		Forward = 10
		},
		Scale = 1
}


sound.Add({
	['name'] = "Mastercombat.Draw",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/mastercombatknife/draw.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Mastercombat.Hit",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/mastercombatknife/hit.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Mastercombat.Slash",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/mastercombatknife/slash.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Mastercombat.Stab",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/mastercombatknife/stab.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Mastercombat.Wall",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/mastercombatknife/wall.ogg" },
	['pitch'] = {100,100}
})

SWEP.Primary.Attacks = {
	{
		['act'] = ACT_VM_HITLEFT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 16*5, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(-60,0,0), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 60, --This isn't overpowered enough, I swear!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.15, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "Weapon_Knife.Miss", -- Sound ID
		['snd_delay'] = 0.01,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 0.6, --time before next attack
		['hull'] = 60, --Hullsize
		['direction'] = "W", --Swing dir,
		['hitflesh'] = "Mastercombat.Hit",
		['hitworld'] = "Mastercombat.Wall"
	},
}

SWEP.Secondary.Attacks = {
	{
		['act'] = ACT_VM_MISSRIGHT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 15*5, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(0,0,-40), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 120, --This isn't overpowered enough, I swear!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.18, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "Weapon_Knife.Miss", -- Sound ID
		['snd_delay'] = 0.01,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 1.25, --time before next attack
		['hull'] = 60, --Hullsize
		['direction'] = "S", --Swing dir,
		['hitflesh'] = "Mastercombat.Stab",
		['hitworld'] = "Mastercombat.Wall"
	}
}
if CLIENT then
	SWEP.WepSelectIconCSO = Material("vgui/killicons/tfa_cso_mastercombatknife")
	SWEP.DrawWeaponSelection = TFA_CSO_DrawWeaponSelection
end
