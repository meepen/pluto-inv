SWEP.Base = "tfa_melee_base"
SWEP.Category = "TFA CS:O"
SWEP.PrintName = "Serpent Blade"

SWEP.ViewModel = "models/weapons/tfa_cso/c_serpent_blade.mdl"
SWEP.WorldModel = "models/weapons/tfa_cso/w_serpent_blade.mdl"
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 85
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
SWEP.NZPaPName				= "Viper's Kiss"
--SWEP.NZPaPReplacement 	= "tfa_cso_dualinfinityfinal"	-- If Pack-a-Punched, replace this gun with the entity class shown here.
SWEP.NZPreventBox		= false	-- If true, this gun won't be placed in random boxes GENERATED. Users can still place it in manually.
SWEP.NZTotalBlackList	= false	-- if true, this gun can't be placed in the box, even manually, and can't be bought off a wall, even if placed manually. Only code can give this gun.


SWEP.Offset = { --Procedural world model animation, defaulted for CS:S purposes.
		Pos = {
		Up = -11,
		Right = 3,
		Forward = 4,
		},
		Ang = {
		Up = 90,
		Right = -10,
		Forward = 175
		},
		Scale = 1.35
}

sound.Add({
	['name'] = "SerpentBlade.Draw",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/serpentblade/draw.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "SerpentBlade.Slash1",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/serpentblade/slash_1.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "SerpentBlade.Slash2",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/serpentblade/slash_2.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "SerpentBlade.Stab",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/serpentblade/stab.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "SerpentBlade.HitFleshSlash1",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/serpentblade/hit.ogg"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "SerpentBlade.HitWall",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/serpentblade/wall.ogg" },
	['pitch'] = {100,100}
})

SWEP.Primary.Attacks = {
	{
		['act'] = ACT_VM_PRIMARYATTACK, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 90, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(100,0,-55), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 75, --This isn't overpowered enough, I swear!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.10, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 0.10,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 0.4, --time before next attack
		['hull'] = 32, --Hullsize
		['direction'] = "W", --Swing dir,
		['hitflesh'] = "SerpentBlade.HitFleshSlash1",
		['hitworld'] = "SerpentBlade.HitWall"
	},
	{
		['act'] = ACT_VM_SECONDARYATTACK, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 90, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(-100,0,20), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 75, --This isn't overpowered enough, I swear!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.1, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 0.1,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 0.4, --time before next attack
		['hull'] = 32, --Hullsize
		['direction'] = "W", --Swing dir,
		['hitflesh'] = "SerpentBlade.HitFleshSlash1",
		['hitworld'] = "SerpentBlade.HitWall"
	}
}

SWEP.Secondary.Attacks = {
	{
		['act'] = ACT_VM_RELOAD, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 80, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(-90,0,80), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 195, --This isn't overpowered enough, I swear!!
		['dmgtype'] = bit.bor(DMG_SLASH,DMG_ALWAYSGIB), --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.5, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 0.5,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 1.2, --time before next attack
		['hull'] = 32, --Hullsize
		['direction'] = "S", --Swing dir,
		['hitflesh'] = "SerpentBlade.HitFleshSlash1",
		['hitworld'] = "SerpentBlade.HitWall"
	}
}
if CLIENT then
	SWEP.WepSelectIconCSO = Material("vgui/killicons/tfa_cso_serpent_blade")
	SWEP.DrawWeaponSelection = TFA_CSO_DrawWeaponSelection
end
