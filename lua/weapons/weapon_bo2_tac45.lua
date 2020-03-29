--/***********************************************************************************************\--
--|-- CODE BY DEADALUS3010 - PORTED BY MEGADETH9811 - MODELS/SOUNDS FROM INFITY WARD/ACTIVISION --|--
--\***********************************************************************************************/--

-- Sound Settings
-------------------
sound.Add({
	name = 			"Weapon_BO2_Tac45.Magout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/tac45/magout.ogg"
})

sound.Add({
	name = 			"Weapon_BO2_Tac45.Magin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/tac45/magin.ogg"
})

sound.Add({
	name = 			"Weapon_BO2_Tac45.Slide",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/tac45/slide.ogg"
})

-- Main Settings
-------------------
SWEP.PrintName					= "Tac-45"			
SWEP.Spawnable					= false
SWEP.AdminSpawnable 			= false
SWEP.DrawAmmo					= false									
SWEP.DrawCrosshair				= false	
SWEP.ViewModelFOV 				= 65
SWEP.ViewModel					= "models/weapons/v_bo2_tac45.mdl"	
SWEP.WorldModel					= "models/weapons/w_pist_p228.mdl"
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
SWEP.Slot         				= 1							
SWEP.SlotPos					= 1	
SWEP.AutoSpawnable				= false
SWEP.Kind						= WEAPON_PISTOL
SWEP.AmmoEnt 					= "item_ammo_pistol_ttt"
SWEP.AllowDrop 					= true
SWEP.IsSilent 					= false
SWEP.NoSights 					= false
SWEP.Base 						= "weapon_tttbase"

-- Primary fire settings
-------------------
SWEP.Primary.Sound 				= "weapons/tac45/fire.ogg" 
SWEP.Primary.Damage				= 18
SWEP.Primary.NumShots			= 1
SWEP.Primary.Spread				= 0.06
SWEP.Primary.RPM				= 625
SWEP.Primary.KickUp				= 0.5		
SWEP.Primary.KickDown			= 0.4	
SWEP.Primary.KickHorizontal		= 0.4	
SWEP.Primary.ClipSize			= 10		
SWEP.Primary.DefaultClip  	  	= 10
SWEP.Primary.ClipMax 			= 20	
SWEP.Primary.Tracer				= 1			
SWEP.Primary.Force				= 10
SWEP.Primary.Automatic			= false
SWEP.Primary.Ammo				= "pistol"	
SWEP.HeadshotMultiplier 		= 2
SWEP.Primary.IronAccuracy 		= .017

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
SWEP.IronSightsPos = Vector(-6.361, -11.171, 1.279)
SWEP.IronSightsAng = Vector(0, 0, 0)
