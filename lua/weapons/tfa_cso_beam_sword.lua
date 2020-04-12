SWEP.Base = "tfa_melee_base"
SWEP.Category = "TFA CS:O"
SWEP.PrintName = "Beam Sword"

SWEP.ViewModel = "models/weapons/tfa_cso/c_beam_sword.mdl"
SWEP.WorldModel = "models/weapons/tfa_cso/w_beam_sword.mdl"
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 75
SWEP.UseHands = true
SWEP.HoldType = "melee2"
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
SWEP.NZPaPName			= "Copyright Lightsword 5000"	
--SWEP.NZPaPReplacement 	= "nil"	-- If Pack-a-Punched, replace this gun with the entity class shown here.
SWEP.NZPreventBox		= false	
SWEP.NZTotalBlackList	= false	

SWEP.Offset = { 
		Pos = {
		Up = -1,
		Right = 1,
		Forward = 4,
		},
		Ang = {
		Up = 90,
		Right = -10,
		Forward = 180
		},
		Scale = 1.35
}

sound.Add({
	['name'] = "BeamSword.Draw",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/beamsword/draw.ogg" },
	['pitch'] = {95,105}
})
sound.Add({
	['name'] = "BeamSword.Idle",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/beamsword/idle.ogg" },
	['pitch'] = {100}
})
sound.Add({
	['name'] = "BeamSword.MidSlash1",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/beamsword/midslash1.ogg" },
	['pitch'] = {95,105}
})
sound.Add({
	['name'] = "BeamSword.MidSlash2",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/beamsword/midslash2.ogg" },
	['pitch'] = {95,105}
})
sound.Add({
	['name'] = "BeamSword.Stab",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/beamsword/stab.ogg" },
	['pitch'] = {95,105}
})
sound.Add({
	['name'] = "BeamSword.Hit",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/beamsword/hit_1.ogg", "weapons/tfa_cso/beamsword/hit_2.ogg" },
	['pitch'] = {95,105}
})
sound.Add({
	['name'] = "BeamSword.HitWorld",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/beamsword/hit_wall_1.ogg", "weapons/tfa_cso/beamsword/hit_wall_2.ogg" },
	['pitch'] = {95,105}
})
sound.Add({
	['name'] = "TFABaseMelee.Null",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "common/null.ogg" },
	['pitch'] = {95,105}
})

SWEP.Primary.Attacks = {
	{
		['act'] = ACT_VM_PRIMARYATTACK, 
		['len'] = 100, 
		['dir'] = Vector(-60,0,-60), 
		['dmg'] = 200, 
		['dmgtype'] = bit.bor(DMG_SLASH,DMG_ALWAYSGIB), 
		['delay'] = 0.25, 
		['spr'] = true, 
		['snd'] = "TFABaseMelee.Null", 
		['snd_delay'] = 0.25,
		["viewpunch"] = Angle(0,0,0), 
		['end'] = 1, 
		['hull'] = 24, 
		['direction'] = "W", 
		['hitflesh'] = "BeamSword.Hit",
		['hitworld'] = "BeamSword.HitWorld"
	}
}

SWEP.Secondary.Attacks = {
	{
		['act'] = ACT_VM_SECONDARYATTACK, 
		['len'] = 100, 
		['dir'] = Vector(-60,0,60), 
		['dmg'] = 200, 
		['dmgtype'] = bit.bor(DMG_SLASH,DMG_ALWAYSGIB), 
		['delay'] = 0.25, 
		['spr'] = true, 
		['snd'] = "TFABaseMelee.Null", 
		['snd_delay'] = 0.2,
		["viewpunch"] = Angle(0,0,0), 
		['end'] = 1, 
		['hull'] = 24, 
		['direction'] = "S", 
		['hitflesh'] = "BeamSword.Hit",
		['hitworld'] = "BeamSword.HitWorld"
	}
}

DEFINE_BASECLASS(SWEP.Base)
function SWEP:Holster( ... )
	self:StopSound("BeamSword.Idle")
	return BaseClass.Holster(self,...)
end
if CLIENT then
	SWEP.WepSelectIconCSO = Material("vgui/killicons/tfa_cso_beam_sword")
	SWEP.DrawWeaponSelection = TFA_CSO_DrawWeaponSelection
end
