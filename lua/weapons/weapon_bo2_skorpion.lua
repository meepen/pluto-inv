--/***********************************************************************************************\--
--|-- CODE BY DEADALUS3010 - PORTED BY MEGADETH9811 - MODELS/SOUNDS FROM INFITY WARD/ACTIVISION --|--
--\***********************************************************************************************/--

-- Sound Settings
-------------------
sound.Add({
	name = 			"Weapon_BO2_Skorpion.Magout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/skorpion/magout.ogg"
})

sound.Add({
	name = 			"Weapon_BO2_Skorpion.Magin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/skorpion/magin.ogg"
})

sound.Add({
	name = 			"Weapon_BO2_Skorpion.Button",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/skorpion/button.ogg"
})

-- Main Settings
-------------------
SWEP.PrintName					= "Skorpion Evo"			
SWEP.Spawnable					= false
SWEP.AdminSpawnable 			= false
SWEP.DrawAmmo					= false									
SWEP.DrawCrosshair				= false	
SWEP.ViewModelFOV 				= 65
SWEP.ViewModel					= "models/weapons/v_bo2_skorpion.mdl"	
SWEP.WorldModel					= "models/weapons/w_rif_famas.mdl"
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
SWEP.AmmoEnt 					= "item_ammo_smg1_ttt"
SWEP.AllowDrop 					= true
SWEP.IsSilent 					= false
SWEP.NoSights 					= false
SWEP.Base 						= "weapon_tttbase"

-- Primary fire settings
-------------------
SWEP.Primary.Sound 				= "weapons/skorpion/fire.ogg" 
SWEP.Primary.Damage				= 13
SWEP.Primary.NumShots			= 1
SWEP.Primary.Spread				= 0.055
SWEP.Primary.RPM				= 1250
SWEP.Primary.Delay       		= 0.099
SWEP.Primary.KickUp				= 0.4
SWEP.Primary.KickDown			= 0.35	
SWEP.Primary.KickHorizontal		= 0.35	
SWEP.Primary.ClipSize			= 32		
SWEP.Primary.DefaultClip  	  	= 32
SWEP.Primary.ClipMax 			= 64	
SWEP.Primary.Tracer				= 1			
SWEP.Primary.Force				= 10
SWEP.Primary.Automatic			= true
SWEP.Primary.Ammo				= "smg1"	
SWEP.HeadshotMultiplier 		= 2
SWEP.Primary.IronAccuracy 		= 0.1

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
SWEP.IronSightsPos = Vector(-7.6, -6.441, 2.44)
SWEP.IronSightsAng = Vector(0, 0, 0)
