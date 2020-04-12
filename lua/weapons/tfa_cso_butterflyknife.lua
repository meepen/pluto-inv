SWEP.Base = "tfa_melee_base"
SWEP.Category = "TFA CS:O"
SWEP.PrintName = "Balisong"
SWEP.Author	= "Kamikaze" 
SWEP.Type	= "Melee weapon"
SWEP.ViewModel = "models/weapons/tfa_cso/c_butterflyknife.mdl"
SWEP.WorldModel = "models/weapons/tfa_cso/w_butterflyknife.mdl"
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
SWEP.NZWonderWeapon		= false	
--SWEP.NZRePaPText		= "your text here"	-- When RePaPing, what should be shown? Example: Press E to your text here for 2000 points.
SWEP.NZPaPName				= "Tricky Stabby"
--SWEP.NZPaPReplacement 	= "tfa_cso_dualsword"	-- If Pack-a-Punched, replace this gun with the entity class shown here.
SWEP.NZPreventBox		= false	
SWEP.NZTotalBlackList	= false	
SWEP.PaPMats			= {}

SWEP.Precision = 50
SWEP.Secondary.MaxCombo = -1
SWEP.Primary.MaxCombo = -1

SWEP.Offset = {
		Pos = {
		Up = -2.5,
		Right = 1.2,
		Forward = 3.5,
		},
		Ang = {
		Up = 150,
		Right = 10,
		Forward = 90
		},
		Scale = 1
}

sound.Add({
	['name'] = "ButterflyKnife.Draw",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/butterflyknife/draw.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "ButterflyKnife.Slash1",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/butterflyknife/slash1.ogg"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "ButterflyKnife.Slash2",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/butterflyknife/slash2.ogg"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "ButterflyKnife.HitFleshSlash1",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/butterflyknife/hit1.ogg"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "ButterflyKnife.HitFleshSlash2",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/butterflyknife/hit2.ogg"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "ButterflyKnife.HitWall",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/butterflyknife/wall.ogg" },
	['pitch'] = {100,100}
})

SWEP.Primary.Attacks = {
	{
		['act'] = ACT_VM_HITLEFT, 
		['len'] = 10*5, 
		['dir'] = Vector(-60,0,-40), 
		['dmg'] = 20, 
		['dmgtype'] = DMG_SLASH, 
		['delay'] = 0.1, 
		['spr'] = true, 
		['snd'] = "TFABaseMelee.Null", 
		['snd_delay'] = 0.01,
		["viewpunch"] = Angle(0,0,0), 
		['end'] = 0.35, 
		['hull'] = 32, 
		['direction'] = "F", 
		['hitflesh'] = "ButterflyKnife.HitFleshSlash1",
		['hitworld'] = "ButterflyKnife.HitWall",
		['maxhits'] = 25
	},
	{
		['act'] = ACT_VM_HITRIGHT, 
		['len'] = 10*5, 
		['dir'] = Vector(60,0,0), 
		['dmg'] = 20, 
		['dmgtype'] = DMG_SLASH, 
		['delay'] = 0.1, 
		['spr'] = true, 
		['snd'] = "TFABaseMelee.Null", 
		['snd_delay'] = 0.01,
		["viewpunch"] = Angle(0,0,0), 
		['end'] = 0.35, 
		['hull'] = 32, 
		['direction'] = "F", 
		['hitflesh'] = "ButterflyKnife.HitFleshSlash1",
		['hitworld'] = "ButterflyKnife.HitWall",
		['maxhits'] = 25
	}
}

SWEP.Secondary.Attacks = {
	{
		['act'] = ACT_VM_MISSLEFT, 
		['len'] = 10*5, 
		['dir'] = Vector(60,0,40), 
		['dmg'] = 55, 
		['dmgtype'] = DMG_SLASH, 
		['delay'] = 0.1, 
		['spr'] = true, 
		['snd'] = "TFABaseMelee.Null", 
		['snd_delay'] = 0.01,
		["viewpunch"] = Angle(0,0,0), 
		['end'] = 0.5, 
		['hull'] = 32, 
		['direction'] = "F", 
		['hitflesh'] = "ButterflyKnife.HitFleshSlash2",
		['hitworld'] = "ButterflyKnife.HitWall",
		['maxhits'] = 25
	},
	{
		['act'] = ACT_VM_MISSRIGHT, 
		['len'] = 10*5, 
		['dir'] = Vector(0,0,-60), 
		['dmg'] = 55, 
		['dmgtype'] = DMG_SLASH, 
		['delay'] = 0.15, 
		['spr'] = true, 
		['snd'] = "TFABaseMelee.Null", 
		['snd_delay'] = 0.01,
		["viewpunch"] = Angle(0,0,0), 
		['end'] = 0.5, 
		['hull'] = 32, 
		['direction'] = "F", 
		['hitflesh'] = "ButterflyKnife.HitFleshSlash2",
		['hitworld'] = "ButterflyKnife.HitWall",
		['maxhits'] = 25
	},
	{
		['act'] = ACT_VM_PRIMARYATTACK, 
		['len'] = 10*5, 
		['dir'] = Vector(-60,0,0), 
		['dmg'] = 55, 
		['dmgtype'] = DMG_SLASH, 
		['delay'] = 0.1, 
		['spr'] = true, 
		['snd'] = "TFABaseMelee.Null", 
		['snd_delay'] = 0.01,
		["viewpunch"] = Angle(0,0,0), 
		['end'] = 0.5, 
		['hull'] = 32, 
		['direction'] = "F", 
		['hitflesh'] = "ButterflyKnife.HitFleshSlash2",
		['hitworld'] = "ButterflyKnife.HitWall",
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
	SWEP.WepSelectIconCSO = Material("vgui/killicons/tfa_cso_butterflyknife")
	SWEP.DrawWeaponSelection = TFA_CSO_DrawWeaponSelection
end
