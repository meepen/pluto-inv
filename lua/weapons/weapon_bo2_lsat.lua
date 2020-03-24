--/***********************************************************************************************\--
--|-- CODE BY DEADALUS3010 - PORTED BY MEGADETH9811 - MODELS/SOUNDS FROM INFITY WARD/ACTIVISION --|--
--\***********************************************************************************************/--

-- Sound Settings
-------------------
sound.Add({
	name = 			"Weapon_BO2_LSAT.LidOpen",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/lsat/open.ogg"
})

sound.Add({
	name = 			"Weapon_BO2_LSAT.Magout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/lsat/magout.ogg"
})

sound.Add({
	name = 			"Weapon_BO2_LSAT.Magin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/lsat/magin.ogg"
})

sound.Add({
	name = 			"Weapon_BO2_LSAT.Chain",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/lsat/belt.ogg"
})

sound.Add({
	name = 			"Weapon_BO2_LSAT.LidClose",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/lsat/close.ogg"
})

sound.Add({
	name = 			"Weapon_BO2_LSAT.Bolt",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/lsat/bolt.ogg"
})

-- Main Settings
-------------------
SWEP.PrintName					= "LSAT"			
SWEP.Spawnable					= false
SWEP.AdminSpawnable 			= false
SWEP.DrawAmmo					= false									
SWEP.DrawCrosshair				= false	
SWEP.ViewModelFOV 				= 65
SWEP.ViewModel					= "models/weapons/v_bo2_lsat.mdl"	
SWEP.WorldModel					= "models/weapons/w_mach_m249para.mdl"
SWEP.ShowWorldModel			 	= true
SWEP.MuzzleAttachment			= "1"
SWEP.ShellEjectAttachment		= "2" 
SWEP.HoldType					= "pistol"	
SWEP.BounceWeaponIcon			= true	
		
-- Other Settings
-------------------
SWEP.Weight						= 30							
SWEP.AutoSwitchTo				= false					
SWEP.AutoSwitchFrom				= false
SWEP.UseHands					= true
SWEP.ViewModelFlip				= false

-- TTT settings
-------------------
SWEP.Slot         				= 2							
SWEP.SlotPos					= 2	
SWEP.AutoSpawnable				= false
SWEP.Kind						= WEAPON_HEAVY
SWEP.AmmoEnt 					= "item_ammo_smg1_ttt"
SWEP.AllowDrop 					= true
SWEP.IsSilent 					= false
SWEP.NoSights 					= false
SWEP.Base 						= "weapon_tttbase"

-- Primary fire settings
-------------------
SWEP.Primary.Sound 				= "weapons/lsat/fire.ogg" 
SWEP.Primary.Damage				= 25
SWEP.Primary.NumShots			= 1
SWEP.Primary.Spread				= 0.08
SWEP.Primary.RPM				= 750
SWEP.Primary.Delay       		= 0.124
SWEP.Primary.KickUp				= 0.45		
SWEP.Primary.KickDown			= 0.3	
SWEP.Primary.KickHorizontal		= 0.3	
SWEP.Primary.ClipSize			= 100		
SWEP.Primary.DefaultClip  	  	= 100
SWEP.Primary.ClipMax 			= 200	
SWEP.Primary.Tracer				= 1			
SWEP.Primary.Force				= 10
SWEP.Primary.Automatic			= true
SWEP.Primary.Ammo				= "smg1"	
SWEP.HeadshotMultiplier 		= 2
SWEP.Primary.IronAccuracy 		= 0.02

-- Secundary fire settings
-------------------
SWEP.Secondary.ClipSize			= -1
SWEP.Secondary.DefaultClip		= 1
SWEP.Secondary.Ammo				= "none"
SWEP.Secondary.IronFOV			= 65

-- Other fire settings
-------------------
SWEP.CrouchModifier				= 0.2
SWEP.IronSightModifier 			= 0.001
SWEP.RunModifier 				= 0.5
SWEP.JumpModifier 				= 1.6
SWEP.Zoom1Cone					= 0.001
SWEP.ConeSpray					= 0.001
SWEP.ConeIncrement				= 0.001		
SWEP.ConeMax					= 0.001		
SWEP.ConeDecrement				= 0.001			

-- Sights
-------------------
SWEP.IronSightsPos = Vector(-8.961, -13.452, 1)
SWEP.IronSightsAng = Vector(0, 0.05, 0.523)
