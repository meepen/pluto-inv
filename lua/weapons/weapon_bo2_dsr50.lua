--/***********************************************************************************************\--
--|-- CODE BY DEADALUS3010 - PORTED BY MEGADETH9811 - MODELS/SOUNDS FROM INFITY WARD/ACTIVISION --|--
--\***********************************************************************************************/--

-- Sound Settings
-------------------
sound.Add({
	name = 			"Weapon_BO2_DSR.BoltBack",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/ballista/bolt_back.ogg"
})

sound.Add({
	name = 			"Weapon_BO2_DSR.Magout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/ballista/magout.ogg"
})

sound.Add({
	name = 			"Weapon_BO2_DSR.Magin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/ballista/magin.ogg"
})

sound.Add({
	name = 			"Weapon_BO2_DSR.BoltForward",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/ballista/bolt_forward.ogg"
})

sound.Add({
	name = 			"Weapon_BO2_DSR.Chamber",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/ballista/rechamber.ogg"
})

-- Main Settings
-------------------
SWEP.PrintName					= "DSR .50"			
SWEP.Spawnable					= false
SWEP.AdminSpawnable 			= false
SWEP.DrawAmmo					= false									
SWEP.DrawCrosshair				= false	
SWEP.ViewModelFOV 				= 65
SWEP.ViewModel					= "models/weapons/v_bo2_dsr50.mdl"	
SWEP.WorldModel					= "models/weapons/w_snip_scout.mdl"
SWEP.ShowWorldModel			 	= true
SWEP.MuzzleAttachment			= "1"
SWEP.ShellEjectAttachment		= "2" 
SWEP.HoldType					= "ar2"	
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
SWEP.AmmoEnt 					= "item_ammo_357_ttt"
SWEP.AllowDrop 					= true
SWEP.IsSilent 					= false
SWEP.NoSights 					= false
SWEP.Base 						= "weapon_tttbase"

-- Primary fire settings
-------------------
SWEP.Primary.Sound 				= "weapons/dsr50/fire.ogg" 
SWEP.Primary.Damage				= 70
SWEP.Primary.NumShots			= 1
SWEP.Primary.Spread				= 0.06
SWEP.Primary.RPM				= 47
SWEP.Primary.Delay				= 1.3
SWEP.Primary.KickUp				= 1.2		
SWEP.Primary.KickDown			= 1.2	
SWEP.Primary.KickHorizontal		= 1.2	
SWEP.Primary.ClipSize			= 5		
SWEP.Primary.DefaultClip  	  	= 5
SWEP.Primary.ClipMax 			= 10	
SWEP.Primary.Tracer				= 1			
SWEP.Primary.Force				= 10
SWEP.Primary.Automatic			= false
SWEP.Primary.Ammo				= "357"	
SWEP.HeadshotMultiplier 		= 2
SWEP.Primary.IronAccuracy 		= .0001

-- Secundary fire settings
-------------------
SWEP.Secondary.ClipSize			= -1
SWEP.Secondary.DefaultClip		= 1
SWEP.Secondary.Ammo				= "none"
SWEP.Secondary.IronFOV			= 65
SWEP.Secondary.UseACOG			= false	
SWEP.Secondary.UseMilDot		= false		
SWEP.Secondary.UseSVD			= false	
SWEP.Secondary.UseParabolic		= true	
SWEP.Secondary.UseElcan			= false
SWEP.Secondary.UseGreenDuplex	= false
SWEP.Secondary.ScopeZoom		= 6
SWEP.BoltAction					= true

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
SWEP.IronSightsPos = Vector(75.319, 0, -47.081)
SWEP.IronSightsAng = Vector(0, 0, 0)
