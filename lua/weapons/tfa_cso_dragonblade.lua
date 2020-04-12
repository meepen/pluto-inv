SWEP.Base = "tfa_melee_base"
SWEP.Category = "TFA CS:O"
SWEP.PrintName = "Green Dragon Blade"

SWEP.ViewModel = "models/weapons/tfa_cso/c_dragonblade.mdl"
SWEP.WorldModel = "models/weapons/tfa_cso/w_dragonblade.mdl"
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
--SWEP.NZPaPName				= "Guan Yu"
SWEP.NZPaPReplacement 	= "tfa_cso_dragonblade_expert"	-- If Pack-a-Punched, replace this gun with the entity class shown here.
SWEP.NZPreventBox		= false	-- If true, this gun won't be placed in random boxes GENERATED. Users can still place it in manually.
SWEP.NZTotalBlackList	= false	-- if true, this gun can't be placed in the box, even manually, and can't be bought off a wall, even if placed manually. Only code can give this gun.
SWEP.PaPMats			= {}

SWEP.Precision = 50
SWEP.Secondary.MaxCombo = -1
SWEP.Primary.MaxCombo = -1

SWEP.Offset = {
		Pos = {
		Up = -8,
		Right = 1,
		Forward = 4,
		},
		Ang = {
		Up = 225,
		Right = 180,
		Forward = 0
		},
		Scale = 1
}

sound.Add({
	['name'] = "DragonSword.Idle",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/dragon_blade/idle.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "DragonSword.Draw",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/dragon_blade/draw.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "DragonSword.Stab",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/dragon_blade/stab_hitidkprobablywontuseitanyways.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "DragonSword.Slash1",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/dragon_blade/slash_1.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "DragonSword.Slash2",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/dragon_blade/slash_2.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "DragonSword.HitFlesh",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/dragon_blade/hit_1.ogg", "weapons/tfa_cso/dragon_blade/hit_2.ogg" },
	['pitch'] = {100,100}
})

SWEP.Primary.Attacks = {
	{
		['act'] = ACT_VM_PRIMARYATTACK, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 135, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(-90,0,90), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 250, --This isn't overpowered enough, I swear!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.45, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 0.45,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 1.1, --time before next attack
		['hull'] = 192, --Hullsize
		['direction'] = "L", --Swing dir,
		['hitflesh'] = "DragonSword.HitFlesh",
		['hitworld'] = "Weapon_Knife.HitWall",
		['maxhits'] = 25
	},
	{
		['act'] = ACT_VM_PULLBACK, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 135, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(0,50,0), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 125, --This isn't overpowered enough, I swear!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.03, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 0.03,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 0.8, --time before next attack
		['hull'] = 192, --Hullsize
		['direction'] = "L", --Swing dir,
		['hitflesh'] = "DragonSword.HitFlesh",
		['hitworld'] = "Weapon_Knife.HitWall",
		['maxhits'] = 25
	}
}

SWEP.Secondary.Attacks = {
	{
		['act'] = ACT_VM_MISSLEFT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 135, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(-150,0,-65), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 375, --Nope!! Not overpowered!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.7, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 0.7,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 1.75, --time before next attack
		['hull'] = 256, --Hullsize
		['direction'] = "F", --Swing dir
		['hitflesh'] = "DualSword.HitFleshStab",
		['hitworld'] = "Weapon_Knife.HitWall",
		['maxhits'] = 25
	}
}

DEFINE_BASECLASS(SWEP.Base)
function SWEP:Holster( ... )
	self:StopSound("DragonSword.Idle")
	return BaseClass.Holster(self,...)
end
if CLIENT then
	SWEP.WepSelectIconCSO = Material("vgui/killicons/tfa_cso_dragonblade")
	SWEP.DrawWeaponSelection = TFA_CSO_DrawWeaponSelection
end
