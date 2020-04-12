SWEP.Base = "tfa_melee_base"
SWEP.Category = "TFA CS:O"
SWEP.PrintName = "Dual Sword Hellfire"
SWEP.Author				= "Kamikaze" 
SWEP.Type	= "Unique grade melee weapon"
SWEP.ViewModel = "models/weapons/tfa_cso/c_budgetswordslayer.mdl"
SWEP.WorldModel = "models/weapons/tfa_cso/w_budgetsword_hell.mdl"
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 80
SWEP.UseHands = true
SWEP.HoldType = "melee"
SWEP.DrawCrosshair = true

SWEP.Primary.Directional = false

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.DisableIdleAnimations = false

SWEP.Secondary.CanBash = false

-- nZombies Stuff
SWEP.NZWonderWeapon		= true	
--SWEP.NZRePaPText		= "your text here"	-- When RePaPing, what should be shown? Example: Press E to your text here for 2000 points.
SWEP.NZPaPName				= "Wallet Slayer"
SWEP.NZPaPReplacement 	= "tfa_cso_dualsword"	
SWEP.NZPreventBox		= false	
SWEP.NZTotalBlackList	= false	
SWEP.PaPMats			= {}

SWEP.Precision = 50
SWEP.Secondary.MaxCombo = -1
SWEP.Primary.MaxCombo = -1
SWEP.MoveSpeed = 1.2 

SWEP.WElements = {
	["fire_sword"] = { type = "Model", model = "models/weapons/tfa_cso/w_budgetsword_fire.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(3.5, 0, 8.00), angle = Angle(10, -100, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.Offset = {
		Pos = {
		Up = -8,
		Right = 1,
		Forward = 4,
		},
		Ang = {
		Up = 180,
		Right = 180,
		Forward = 0
		},
		Scale = 1
}

sound.Add({
	['name'] = "Hellfire.Idle",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/budgetslayer/idle.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Hellfire.SkillStart",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/budgetslayer/skill_start.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Hellfire.SkillEnd",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/budgetslayer/skill_loop_end.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Hellfire.SlashEnd",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/budgetslayer/slash_end.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Hellfire.StabEnd",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/budgetslayer/stab_end.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Hellfire.Slash1",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/budgetslayer/slash1.ogg"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Hellfire.Slash2",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/budgetslayer/slash2.ogg"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Hellfire.Slash3",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/budgetslayer/slash3.ogg"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Hellfire.Slash4",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/budgetslayer/slash4.ogg"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Hellfire.Stab1",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/budgetslayer/stab.ogg"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Hellfire.Stab2",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/budgetslayer/stab2.ogg"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Hellfire.HitFleshSlash",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/budgetslayer/hit1.ogg", "weapons/tfa_cso/budgetslayer/hit2.ogg", "weapons/tfa_cso/budgetslayer/hit3.ogg" },
	['pitch'] = {95,105}
})
sound.Add({
	['name'] = "Hellfire.HitFleshStab",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/budgetslayer/stab_hit.ogg", "weapons/tfa_cso/dual_sword/stab2_hit.ogg" },
	['pitch'] = {95,105}
})
sound.Add({
	['name'] = "DualSword.HitWall",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/dual_sword/hit_wall.ogg" },
	['pitch'] = {95,105}
})

SWEP.Primary.Attacks = {
	{
		['act'] = ACT_VM_HITLEFT, 
		['len'] = 25*5, 
		['dir'] = Vector(-180,0,15), 
		['dmg'] = 80, 
		['dmgtype'] = DMG_SLASH, 
		['delay'] = 0.03, 
		['spr'] = true, 
		['snd'] = "TFABaseMelee.Null", 
		['snd_delay'] = 0.035,
		["viewpunch"] = Angle(0,0,0), 
		['end'] = 0.15, 
		['hull'] = 96, 
		['direction'] = "L", 
		['hitflesh'] = "DualSword.HitFleshSlash",
		['hitworld'] = "Weapon_Knife.HitWall",
		['maxhits'] = 25
	},
	{
		['act'] = ACT_VM_HITRIGHT, 
		['len'] = 25*5, 
		['dir'] = Vector(180,0,35), 
		['dmg'] = 80, 
		['dmgtype'] = DMG_SLASH, 
		['delay'] = 0.03, 
		['spr'] = true, 
		['snd'] = "TFABaseMelee.Null", 
		['snd_delay'] = 0.035,
		["viewpunch"] = Angle(0,0,0), 
		['end'] = 0.15, 
		['hull'] = 96, 
		['direction'] = "L", 
		['hitflesh'] = "DualSword.HitFleshSlash",
		['hitworld'] = "Weapon_Knife.HitWall",
		['maxhits'] = 25
	},
	{
		['act'] = ACT_VM_PRIMARYATTACK, 
		['len'] = 25*5, 
		['dir'] = Vector(-180,0,-35), 
		['dmg'] = 80, 
		['dmgtype'] = DMG_SLASH, 
		['delay'] = 0.03, 
		['spr'] = true, 
		['snd'] = "TFABaseMelee.Null", 
		['snd_delay'] = 0.035,
		["viewpunch"] = Angle(0,0,0), 
		['end'] = 0.15, 
		['hull'] = 96, 
		['direction'] = "L", 
		['hitflesh'] = "DualSword.HitFleshSlash",
		['hitworld'] = "Weapon_Knife.HitWall",
		['maxhits'] = 25
	},
	{
		['act'] = ACT_VM_PULLBACK, 
		['len'] = 25*5, 
		['dir'] = Vector(180,0,17.5), 
		['dmg'] = 80, 
		['dmgtype'] = DMG_SLASH, 
		['delay'] = 0.03, 
		['spr'] = true, 
		['snd'] = "TFABaseMelee.Null", 
		['snd_delay'] = 0.035,
		["viewpunch"] = Angle(0,0,0), 
		['end'] = 0.15, 
		['hull'] = 96, 
		['direction'] = "L", 
		['hitflesh'] = "DualSword.HitFleshSlash",
		['hitworld'] = "Weapon_Knife.HitWall",
		['maxhits'] = 254
	},
}

SWEP.Secondary.Attacks = {
	{
		['act'] = ACT_VM_MISSLEFT, 
		['len'] = 30*5, 
		['dir'] = Vector(0,90,0), 
		['dmg'] = 600, 
		['dmgtype'] = DMG_SLASH, 
		['delay'] = 0.035, 
		['spr'] = true, 
		['snd'] = "TFABaseMelee.Null", 
		['snd_delay'] = 0.035,
		["viewpunch"] = Angle(0,0,0), 
		['end'] = 0.5, 
		['hull'] = 256, 
		['direction'] = "F", 
		['hitflesh'] = "DualSword.HitFleshStab",
		['hitworld'] = "Weapon_Knife.HitWall",
		['maxhits'] = 25
	},
	{
		['act'] = ACT_VM_MISSRIGHT, 
		['len'] = 30*5, 
		['dir'] = Vector(0,90,0), 
		['dmg'] = 2000, 
		['dmgtype'] = DMG_SLASH, 
		['delay'] = 0.05, 
		['spr'] = true, 
		['snd'] = "TFABaseMelee.Null", 
		['snd_delay'] = 0.05,
		["viewpunch"] = Angle(0,0,0), 
		['end'] = 1, 
		['hull'] = 256, 
		['direction'] = "F", 
		['hitflesh'] = "DualSword.HitFleshStab",
		['hitworld'] = "Weapon_Knife.HitWall",
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
	SWEP.WepSelectIconCSO = Material("vgui/killicons/tfa_cso_budgetsword")
	SWEP.DrawWeaponSelection = TFA_CSO_DrawWeaponSelection
end
