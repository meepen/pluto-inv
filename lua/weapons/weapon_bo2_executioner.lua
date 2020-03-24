--/***********************************************************************************************\--
--|-- CODE BY DEADALUS3010 - PORTED BY MEGADETH9811 - MODELS/SOUNDS FROM INFITY WARD/ACTIVISION --|--
--\***********************************************************************************************/--

-- Sound Settings
-------------------
sound.Add({
	name = 			"Weapon_BO2_Judge.Open",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/executioner/open.ogg"
})

sound.Add({
	name = 			"Weapon_BO2_Judge.ShellsOut",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/executioner/empty.ogg"
})

sound.Add({
	name = 			"Weapon_BO2_Judge.Insert",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/executioner/shell.ogg"
})

sound.Add({
	name = 			"Weapon_BO2_Judge.Close",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/executioner/close.ogg"
})

-- Main Settings
-------------------
SWEP.PrintName					= "Executioner"
SWEP.Spawnable					= false
SWEP.AdminSpawnable 			= false	
SWEP.DrawAmmo					= false			
SWEP.DrawCrosshair				= false	
SWEP.ViewModelFOV 				= 65
SWEP.ViewModel					= "models/weapons/v_bo2_judge.mdl"	
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
SWEP.AutoSpawnable				= true
SWEP.Kind						= WEAPON_PISTOL
SWEP.AmmoEnt 					= "item_ammo_buckshot_ttt"
SWEP.AllowDrop 					= true
SWEP.IsSilent 					= false
SWEP.NoSights 					= false
SWEP.Base 						= "weapon_tttbase"

-- Primary fire settings
-------------------
SWEP.Primary.Sound 				= "weapons/executioner/fire.ogg" 
SWEP.Primary.Damage				= 6
SWEP.Primary.NumShots			= 5
SWEP.Primary.Spread				= 0.09
SWEP.Primary.RPM				= 60
SWEP.Primary.KickUp				= 1.9	
SWEP.Primary.KickDown			= 1.7	
SWEP.Primary.KickHorizontal		= 1.7	
SWEP.Primary.ClipSize			= 5		
SWEP.Primary.DefaultClip  	  	= 5
SWEP.Primary.ClipMax 			= 10	
SWEP.Primary.Tracer				= 1			
SWEP.Primary.Force				= 10
SWEP.Primary.Automatic			= false
SWEP.Primary.Ammo				= "buckshot"	
SWEP.HeadshotMultiplier 		= 2
SWEP.Primary.IronAccuracy 		= 1.9

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
SWEP.IronSightsPos = Vector(-5.72, -8.943, -0.24)
SWEP.IronSightsAng = Vector(-0.787, 0, 0)
