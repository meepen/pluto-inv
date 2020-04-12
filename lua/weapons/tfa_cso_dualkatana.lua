SWEP.Base = "tfa_melee_base"
SWEP.Category = "TFA CS:O"
SWEP.PrintName = "Dual Wakizashi"
SWEP.Author	= "Kamikaze" --Author Tooltip
SWEP.Type	= "Melee weapon"
SWEP.ViewModel = "models/weapons/tfa_cso/c_dualkatana.mdl"
SWEP.WorldModel = "models/weapons/tfa_cso/w_katana.mdl"
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 85
SWEP.UseHands = true
SWEP.HoldType = "melee"
SWEP.DrawCrosshair = true

SWEP.Primary.Directional = false

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.DisableIdleAnimations = false

SWEP.Secondary.CanBash = false

-- nZombies Stuff
SWEP.NZWonderWeapon		= false	-- Is this a Wonder-Weapon? If true, only one player can have it at a time. Cheats aren't stopped, though.
--SWEP.NZRePaPText		= "your text here"	-- When RePaPing, what should be shown? Example: Press E to your text here for 2000 points.
SWEP.NZPaPName				= "Tiendo No Kamikaze"
--SWEP.NZPaPReplacement 	= "tfa_cso_dualsword"	-- If Pack-a-Punched, replace this gun with the entity class shown here.
SWEP.NZPreventBox		= false	-- If true, this gun won't be placed in random boxes GENERATED. Users can still place it in manually.
SWEP.NZTotalBlackList	= false	-- if true, this gun can't be placed in the box, even manually, and can't be bought off a wall, even if placed manually. Only code can give this gun.
SWEP.PaPMats			= {}

SWEP.Precision = 50
SWEP.Secondary.MaxCombo = -1
SWEP.Primary.MaxCombo = -1

SWEP.WElements = {
	["katana_a"] = { type = "Model", model = "models/weapons/tfa_cso/w_katana.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(4, 0.5, 7.50), angle = Angle(0, -20, 175), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.Offset = {
		Pos = {
		Up = -7.5,
		Right = 2.5,
		Forward = 4,
		},
		Ang = {
		Up = -150,
		Right = 0,
		Forward = 10
		},
		Scale = 1
}

sound.Add({
	['name'] = "DualKatana.Draw",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/dualkatana/draw.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "DualKatana.Slash1",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/dualkatana/slash1.ogg"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "DualKatana.Slash2",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/dualkatana/slash2.ogg"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "DualKatana.Stab",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/dualkatana/stab.ogg"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "DualKatana.HitFleshSlash1",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/dualkatana/hit1.ogg"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "DualKatana.HitFleshSlash2",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/dualkatana/hit2.ogg"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "DualKatana.HitFleshStab",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/dualkatana/stab_hit.ogg"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "DualKatana.HitWall",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/dualkatana/wall.ogg" },
	['pitch'] = {100,100}
})

SWEP.Primary.Attacks = {
	{
		['act'] = ACT_VM_HITLEFT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 95, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(-100,0,-10), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 150, --This isn't overpowered enough, I swear!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.2, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 0.2,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 1.0, --time before next attack
		['hull'] = 48, --Hullsize
		['direction'] = "F", --Swing dir,
		['hitflesh'] = "DualKatana.HitFleshSlash1",
		['hitworld'] = "DualKatana.HitWall",
		['maxhits'] = 25
	},
	{
		['act'] = ACT_VM_HITRIGHT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 95, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(100,0,50), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 75, --This isn't overpowered enough, I swear!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.2, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 0.2,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 1.0, --time before next attack
		['hull'] = 32, --Hullsize
		['direction'] = "F", --Swing dir,
		['hitflesh'] = "DualKatana.HitFleshSlash2",
		['hitworld'] = "DualKatana.HitWall",
		['maxhits'] = 25
	}
}

SWEP.Secondary.Attacks = {
	{
		['act'] = ACT_VM_MISSLEFT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 80, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(0,0,80), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 370, --Nope!! Not overpowered!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.4, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 0.4,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 1.7, --time before next attack
		['hull'] = 64, --Hullsize
		['direction'] = "F", --Swing dir
		['hitflesh'] = "DualKatana.HitFleshStab",
		['hitworld'] = "DualKatana.HitWall",
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
	SWEP.WepSelectIconCSO = Material("vgui/killicons/tfa_cso_dualkatana")
	SWEP.DrawWeaponSelection = TFA_CSO_DrawWeaponSelection
end
