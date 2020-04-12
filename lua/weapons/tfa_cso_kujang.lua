SWEP.Base = "tfa_melee_base"
SWEP.Category = "TFA CS:O"
SWEP.PrintName = "Kujang"
SWEP.Author	= "Kamikaze" --Author Tooltip
SWEP.Type	= "Melee weapon"
SWEP.ViewModel = "models/weapons/tfa_cso/c_kujang.mdl"
SWEP.WorldModel = "models/weapons/tfa_cso/w_kujang.mdl"
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

-- nZombies Stuff
SWEP.NZWonderWeapon		= false	-- Is this a Wonder-Weapon? If true, only one player can have it at a time. Cheats aren't stopped, though.
--SWEP.NZRePaPText		= "your text here"	-- When RePaPing, what should be shown? Example: Press E to your text here for 2000 points.
SWEP.NZPaPName				= "Param"
--SWEP.NZPaPReplacement 	= "tfa_cso_dualsword"	-- If Pack-a-Punched, replace this gun with the entity class shown here.
SWEP.NZPreventBox		= false	-- If true, this gun won't be placed in random boxes GENERATED. Users can still place it in manually.
SWEP.NZTotalBlackList	= false	-- if true, this gun can't be placed in the box, even manually, and can't be bought off a wall, even if placed manually. Only code can give this gun.
SWEP.PaPMats			= {}

SWEP.Precision = 50
SWEP.Secondary.MaxCombo = -1
SWEP.Primary.MaxCombo = -1

SWEP.Offset = {
		Pos = {
		Up = -5.5,
		Right = 1,
		Forward = 1,
		},
		Ang = {
		Up = 90,
		Right = 90,
		Forward = 0
		},
		Scale = 1
}

sound.Add({
	['name'] = "Kujang.Draw",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/kujang/draw.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Kujang.Slash",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/kujang/slash.ogg"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Kujang.HitFleshSlash1",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/kujang/hit1.ogg"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Kujang.HitFleshSlash2",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/kujang/hit2.ogg"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Kujang.HitWall",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/kujang/wall.ogg" },
	['pitch'] = {100,100}
})

SWEP.Primary.Attacks = {
	{
		['act'] = ACT_VM_HITLEFT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 14*5, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(90,0,0), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 40, --This isn't overpowered enough, I swear!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.15, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 0.01,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 0.6, --time before next attack
		['hull'] = 32, --Hullsize
		['direction'] = "F", --Swing dir,
		['hitflesh'] = "Kujang.HitFleshSlash1",
		['hitworld'] = "Kujang.HitWall",
		['maxhits'] = 25
	},
	{
		['act'] = ACT_VM_HITRIGHT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 14*5, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(90,0,0), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 40, --This isn't overpowered enough, I swear!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.15, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 0.01,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 0.6, --time before next attack
		['hull'] = 32, --Hullsize
		['direction'] = "F", --Swing dir,
		['hitflesh'] = "Kujang.HitFleshSlash1",
		['hitworld'] = "Kujang.HitWall",
		['maxhits'] = 25
	}
}

SWEP.Secondary.Attacks = {
	{
		['act'] = ACT_VM_MISSLEFT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 14*5, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(0,0,-80), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 80, --Nope!! Not overpowered!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.2, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 0.01,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 1.2, --time before next attack
		['hull'] = 64, --Hullsize
		['direction'] = "F", --Swing dir
		['hitflesh'] = "Kujang.HitFleshSlash2",
		['hitworld'] = "Kujang.HitWall",
		['maxhits'] = 25
	}
}

SWEP.InspectionActions = {ACT_VM_RECOIL1}

DEFINE_BASECLASS(SWEP.Base)
function SWEP:Holster( ... )
	self:StopSound("Hellfire.Idle")
	return BaseClass.Holster(self,...)
end
if CLIENT then
	SWEP.WepSelectIconCSO = Material("vgui/killicons/tfa_cso_kujang")
	SWEP.DrawWeaponSelection = TFA_CSO_DrawWeaponSelection
end
