SWEP.Base = "tfa_melee_base"
SWEP.Category = "TFA CS:O"
SWEP.PrintName = "Soul Bane Dagger"
SWEP.Author		= "Kamikaze" 
SWEP.ViewModel = "models/weapons/tfa_cso/c_combatknife.mdl"
SWEP.WorldModel = "models/weapons/tfa_cso/w_combatknife.mdl"
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
		Up = -5,
		Right = 1.5,
		Forward = 5,
		},
		Ang = {
		Up = 80,
		Right = -100,
		Forward = 30
		},
		Scale = 1
}


sound.Add({
	['name'] = "Combatknife.Draw",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/combatknife/draw.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Combatknife.Hit1",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/combatknife/hit1.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Combatknife.Hit2",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/combatknife/hit2.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Combatknife.Slash",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/combatknife/slash.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Combatknife.Stab",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/combatknife/stab.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Combatknife.Wall",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/combatknife/wall.ogg" },
	['pitch'] = {100,100}
})

SWEP.Primary.Attacks = {
	{
		['act'] = ACT_VM_HITLEFT, 
		['len'] = 65, 
		['dir'] = Vector(50,0,0), 
		['dmg'] = 45, 
		['dmgtype'] = DMG_SLASH, 
		['delay'] = 0.15, 
		['spr'] = true, 
		['snd'] = "Weapon_Knife.Miss", 
		['snd_delay'] = 0.01,
		["viewpunch"] = Angle(0,0,0), 
		['end'] = 0.6, 
		['hull'] = 50, 
		['direction'] = "W", 
		['hitflesh'] = "Combatknife.Hit1",
		['hitworld'] = "Combatknife.Wall"
	},
}

SWEP.Secondary.Attacks = {
	{
		['act'] = ACT_VM_MISSRIGHT, 
		['len'] = 70, 
		['dir'] = Vector(-40,0,0), 
		['dmg'] = 80, 
		['dmgtype'] = DMG_SLASH, 
		['delay'] = 0.15, 
		['spr'] = true, 
		['snd'] = "Weapon_Knife.Miss", 
		['snd_delay'] = 0.01,
		["viewpunch"] = Angle(0,0,0), 
		['end'] = 1.25, 
		['hull'] = 50, 
		['direction'] = "S", 
		['hitflesh'] = "Combatknife.Stab",
		['hitworld'] = "Combatknife.Wall"
	}
}
if CLIENT then
	SWEP.WepSelectIconCSO = Material("vgui/killicons/tfa_cso_combatknife")
	SWEP.DrawWeaponSelection = TFA_CSO_DrawWeaponSelection
end
