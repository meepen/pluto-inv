SWEP.Base = "tfa_melee_base"
SWEP.Category = "TFA CS:O"
SWEP.PrintName = "Cold Steel Knife"
SWEP.Author	= "Kamikaze" 
SWEP.ViewModel = "models/weapons/tfa_cso/c_cold_steel_knife.mdl"
SWEP.WorldModel = "models/weapons/tfa_cso/w_cold_steel_knife.mdl"
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

SWEP.VMPos = Vector(0,0,0) 

-- nZombies Stuff
SWEP.NZWonderWeapon		= false	
--SWEP.NZRePaPText		= "your text here"	-- When RePaPing, what should be shown? Example: Press E to your text here for 2000 points.
SWEP.NZPaPName				= "Lady's Kiss"
--SWEP.NZPaPReplacement 	= "tfa_cso_dualinfinityfinal"	-- If Pack-a-Punched, replace this gun with the entity class shown here.
SWEP.NZPreventBox		= false	
SWEP.NZTotalBlackList	= false	


SWEP.Offset = { 
		Pos = {
		Up = -4,
		Right = 2,
		Forward = 3.5,
		},
		Ang = {
		Up = 90,
		Right = -10,
		Forward = 175
		},
		Scale = 1.35
}


sound.Add({
	['name'] = "ColdSteelKnife.Draw",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/cold_steel_knife/draw.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "ColdSteelKnife.Slash1",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/cold_steel_knife/slash1.ogg"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "ColdSteelKnife.Slash2",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/cold_steel_knife/slash2.ogg"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "ColdSteelKnife.HitFleshSlash",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/cold_steel_knife/hit1.ogg", "weapons/tfa_cso/cold_steel_knife/hit2.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "ColdSteelKnife.HitFleshStab",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/cold_steel_knife/stab_hit.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "ColdSteelKnife.HitWall",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/cold_steel_knife/wall.ogg" },
	['pitch'] = {100,100}
})

SWEP.Primary.Attacks = {
	{
		['act'] = ACT_VM_HITLEFT, 
		['len'] = 60, 
		['dir'] = Vector(50,0,10), 
		['dmg'] = 35, 
		['dmgtype'] = DMG_SLASH, 
		['delay'] = 0.18, 
		['spr'] = true, 
		['snd'] = "Weapon_Knife.Miss", 
		['snd_delay'] = 0.15,
		["viewpunch"] = Angle(0,0,0), 
		['end'] = 0.4, 
		['hull'] = 48, 
		['direction'] = "W", 
		['hitflesh'] = "ColdSteelKnife.HitFleshSlash",
		['hitworld'] = "ColdSteelKnife.HitWall"
	},
	{
		['act'] = ACT_VM_HITRIGHT, 
		['len'] = 60, 
		['dir'] = Vector(-50,0,-10), 
		['dmg'] = 35, 
		['dmgtype'] = DMG_SLASH, 
		['delay'] = 0.15, 
		['spr'] = true, 
		['snd'] = "Weapon_Knife.Miss", 
		['snd_delay'] = 0.15,
		["viewpunch"] = Angle(0,0,0), 
		['end'] = 0.4, 
		['hull'] = 48, 
		['direction'] = "W", 
		['hitflesh'] = "ColdSteelKnife.HitFleshSlash",
		['hitworld'] = "ColdSteelKnife.HitWall"
	}
}

SWEP.Secondary.Attacks = {
	{
		['act'] = ACT_VM_MISSLEFT, 
		['len'] = 60, 
		['dir'] = Vector(0,0,-40), 
		['dmg'] = 65, 
		['dmgtype'] = bit.bor(DMG_SLASH,DMG_ALWAYSGIB), 
		['delay'] = 0.15, 
		['spr'] = true, 
		['snd'] = "Weapon_Knife.Miss", 
		['snd_delay'] = 0.10,
		["viewpunch"] = Angle(0,0,0), 
		['end'] = 1, 
		['hull'] = 48, 
		['direction'] = "S", 
		['hitflesh'] = "ColdSteelKnife.HitFleshStab",
		['hitworld'] = "ColdSteelKnife.HitWall"
	}
}
if CLIENT then
	SWEP.WepSelectIconCSO = Material("vgui/killicons/tfa_cso_coldsteelblade")
	SWEP.DrawWeaponSelection = TFA_CSO_DrawWeaponSelection
end
