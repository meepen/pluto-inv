SWEP.Base = "tfa_melee_base"
SWEP.Category = "TFA CS:O"
SWEP.PrintName = "Jay's Dagger"
SWEP.Author				= "Kamikaze" --Author Tooltip
SWEP.Type	= "Non-existent grade melee weapon"
SWEP.ViewModel = "models/weapons/tfa_cso/c_jaydagger.mdl"
SWEP.WorldModel = "models/weapons/tfa_cso/w_jaydagger.mdl"
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
SWEP.NZPaPName				= "Endless Dagger"
--SWEP.NZPaPReplacement 	= "tfa_cso_dualsword"	-- If Pack-a-Punched, replace this gun with the entity class shown here.
SWEP.NZPreventBox		= false	-- If true, this gun won't be placed in random boxes GENERATED. Users can still place it in manually.
SWEP.NZTotalBlackList	= false	-- if true, this gun can't be placed in the box, even manually, and can't be bought off a wall, even if placed manually. Only code can give this gun.
SWEP.PaPMats			= {}

SWEP.Precision = 50
SWEP.Secondary.MaxCombo = -1
SWEP.Primary.MaxCombo = -1

SWEP.WElements = {
	["jaydagger_a"] = { type = "Model", model = "models/weapons/tfa_cso/w_jaydagger.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(4.5, 1, 3.50), angle = Angle(-10, -10, -10), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.Offset = {
		Pos = {
		Up = -3.5,
		Right = 3,
		Forward = 3,
		},
		Ang = {
		Up = 80,
		Right = 160,
		Forward = -0
		},
		Scale = 1
}

sound.Add({
	['name'] = "JayDagger.Draw",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/jaydagger/draw.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "JayDagger.Midslash1",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/jaydagger/midslash1.ogg"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "JayDagger.Midslash2",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/jaydagger/midslash2.ogg"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "JayDagger.Stab",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/jaydagger/stab.ogg"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "JayDagger.HitFleshSlash1",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/jaydagger/hit1.ogg"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "JayDagger.HitFleshSlash2",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/jaydagger/hit2.ogg"},
	['pitch'] = {100,100}
})

sound.Add({
	['name'] = "JayDagger.HitFleshSlash3",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/jaydagger/hit3.ogg"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "JayDagger.HitWall",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/jaydagger/wall.ogg" },
	['pitch'] = {100,100}
})

SWEP.Primary.Attacks = {
	{
		['act'] = ACT_VM_HITLEFT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 18*5, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(-90,0,-80), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 300, --This isn't overpowered enough, I swear!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.06, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 0.035,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 0.4, --time before next attack
		['hull'] = 32, --Hullsize
		['direction'] = "F", --Swing dir,
		['hitflesh'] = "JayDagger.HitFleshSlash1",
		['hitworld'] = "JayDagger.HitWall",
		['maxhits'] = 25
	},
	{
		['act'] = ACT_VM_HITRIGHT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 18*5, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(-90,0,60), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 300, --This isn't overpowered enough, I swear!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.06, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 0.035,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 0.5, --time before next attack
		['hull'] = 32, --Hullsize
		['direction'] = "F", --Swing dir,
		['hitflesh'] = "JayDagger.HitFleshSlash2",
		['hitworld'] = "JayDagger.HitWall",
		['maxhits'] = 25
	}
}

SWEP.Secondary.Attacks = {
	{
		['act'] = ACT_VM_MISSLEFT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 18*5, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(100,0,-45), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 950, --Nope!! Not overpowered!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.4, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 0.035,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 1, --time before next attack
		['hull'] = 64, --Hullsize
		['direction'] = "F", --Swing dir
		['hitflesh'] = "JayDagger.HitFleshSlash3",
		['hitworld'] = "JayDagger.HitWall",
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
	SWEP.WepSelectIconCSO = Material("vgui/killicons/tfa_cso_jaydagger")
	SWEP.DrawWeaponSelection = TFA_CSO_DrawWeaponSelection
end
