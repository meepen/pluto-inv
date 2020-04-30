//This is just here to make sure gun sounds are loaded on clients properly
//because I don't know how to make good autorun lua that works on clients in MP

//Avalanche. Sci-Fi LMG
local soundData = {
	name		= "Avalanche.ClipIn1" ,
	channel	 = CHAN_WEAPON,
	volume	  = 1,
	soundlevel  = 80,
	pitchstart  = 100,
	pitchend	= 100,
	sound	   = "weapons/tfa_cso/avalanche/clipin1.ogg"
}
 
sound.Add(soundData)

local soundData = {
	name		= "Avalanche.ClipIn2" ,
	channel	 = CHAN_WEAPON,
	volume	  = 1,
	soundlevel  = 80,
	pitchstart  = 100,
	pitchend	= 100,
	sound	   = "weapons/tfa_cso/avalanche/clipin2.ogg"
}
 
sound.Add(soundData)

local soundData = {
	name		= "Avalanche.ClipOut" ,
	channel	 = CHAN_WEAPON,
	volume	  = 1,
	soundlevel  = 80,
	pitchstart  = 100,
	pitchend	= 100,
	sound	   = "weapons/tfa_cso/avalanche/clipout.ogg"
}
 
sound.Add(soundData)
 
local soundData = {
	name		= "Avalanche.ChangeA" ,
	channel	 = CHAN_WEAPON,
	volume	  = 1,
	soundlevel  = 80,
	pitchstart  = 100,
	pitchend	= 100,
	sound	   = "weapons/tfa_cso/avalanche/changea.ogg"
}
 
sound.Add(soundData)

local soundData = {
	name		= "Avalanche.ChangeB" ,
	channel	 = CHAN_WEAPON,
	volume	  = 1,
	soundlevel  = 80,
	pitchstart  = 100,
	pitchend	= 100,
	sound	   = "weapons/tfa_cso/avalanche/changeb.ogg"
}
 
sound.Add(soundData)
 
local soundData = {
	name		= "Avalanche.Fire" ,
	channel	 = CHAN_USER_BASE+11,
	volume	  = 1,
	soundlevel  = 80,
	pitchstart  = 100,
	pitchend	= 100,
	sound	   = "weapons/tfa_cso/avalanche/fire.ogg"
}

sound.Add(soundData)

//Dragon TMP
local soundData = {
	name 		= "Dragon TMP.Out" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/dragontmp/clipout.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "Dragon TMP.In" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/dragontmp/clipin.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "Dragon TMP.Deploy" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/dragontmp/deploy.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "Dragon TMP.Fire" ,
	channel 	= CHAN_USER_BASE+11,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/dragontmp/fire.ogg"
}

sound.Add(soundData)

//SF Ethereal
local soundData = {
	name 		= "SF Ethereal.Deploy" ,
	channel 	= CHAN_WEAPON,
	volume 		= 0.5,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/sfethereal/deploy.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "SF Ethereal.Reload" ,
	channel 	= CHAN_WEAPON,
	volume 		= 0.5,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/sfethereal/reload.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "SF Ethereal.Fire" ,
	channel 	= CHAN_USER_BASE+11,
	volume 		= 0.5,
	soundlevel 	= 75,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/sfethereal/fire.ogg"
}

sound.Add(soundData)
//Flintlock Pistol
local soundData = {
	name 		= "Flintlock.Draw" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/flintlock/draw.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "Flintlock.In 1" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/flintlock/in1.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "Flintlock.In 2" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/flintlock/in2.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "Flintlock.In 3" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/flintlock/in3.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "Flintlock.Fire" ,
	channel 	= CHAN_USER_BASE+11,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/flintlock/fire.ogg"
}

sound.Add(soundData)

//Milkor M32 MGL. Quite a mouthful, huh?
local soundData = {
	name 		= "Milkor M32 MGL.Deploy" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/m32/deploy.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "Milkor M32 MGL.Start Reload" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/m32/reloadstart.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "Milkor M32 MGL.Insert" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/m32/insert.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "Milkor M32 MGL.After Reload" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/m32/afterreload.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "Milkor M32 MGL.Fire" ,
	channel 	= CHAN_USER_BASE+11,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/m32/fire.ogg"
}

sound.Add(soundData)

//STG-44
local soundData = {
	name 		= "Weapon_STG44.Clipout" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/stg/clipout.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "Weapon_STG44.BoltPull" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/stg/boltpull.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "Weapon_STG44.Fire" ,
	channel 	= CHAN_USER_BASE+11,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/stg/fire.ogg"
}

sound.Add(soundData)

//Crossbow. Not to be confused with Half-Life 2's Crossbow!
local soundData = {
	name 		= "Crossbow.Foley1" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/crossbow/foley1.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "Crossbow.Foley2" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/crossbow/foley2.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "Crossbow.Foley3" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/crossbow/foley3.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "Crossbow.Foley4" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/crossbow/foley4.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "Crossbow.Deploy" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/crossbow/deploy.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "Crossbow.Fire" ,
	channel 	= CHAN_USER_BASE+11,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/crossbow/fire.ogg"
}

sound.Add(soundData)

//Elven Ranger. Why put gold in your mouth when you can put gold on your AWP!?
local soundData = {
	name 		= "ElvenRanger.Idle" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/elvenranger/idle.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "ElvenRanger.Reload" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/elvenranger/reload.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "ElvenRanger.Fire" ,
	channel 	= CHAN_USER_BASE+11,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/elvenranger/fire.ogg"
}

sound.Add(soundData)

//Paladin. God-tier destruction.
local soundData = {
	name 		= "Paladin.Idle" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/paladin/idle.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "Paladin.Reload" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/paladin/reload.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "Paladin.Draw" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/paladin/draw.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "Paladin.Fire" ,
	channel 	= CHAN_USER_BASE+11,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/paladin/fire.ogg"
}

sound.Add(soundData)

//Dark Knight. Which one is better? Paladin or Dark Knight?
local soundData = {
	name 		= "DarkKnight.Idle" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/darkknight/idle.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "DarkKnight.Clipout" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/darkknight/clipout.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "DarkKnight.Clipin1" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/darkknight/clipin1.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "DarkKnight.Clipin2" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/darkknight/clipin2.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "DarkKnight.Fire" ,
	channel 	= CHAN_USER_BASE+11,
	volume 		= 0.5,
	soundlevel 	= 75,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/darkknight/fire.ogg"
}

sound.Add(soundData)

//Sapientia. A religious revolver. Why.
local soundData = {
	name 		= "Sapientia.ClipOut" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/sapientia/clipout.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "Sapientia.ClipIn" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/sapientia/clipin.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "Sapientia.Draw" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/sapientia/draw.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "Sapientia.Fire" ,
	channel 	= CHAN_USER_BASE+11,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/sapientia/fire.ogg"
}

sound.Add(soundData)

//Dual Kriss Custom. Rock like it's MW2 every day with these dual SMGs.
local soundData = {
	name 		= "DualKrissCustom.ClipOut" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/dualkrisscustom/clipout.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "DualKrissCustom.ClipIn" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/dualkrisscustom/clipin.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "DualKrissCustom.Draw" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/dualkrisscustom/draw.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "DualKrissCustom.Fire" ,
	channel 	= CHAN_USER_BASE+11,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/dualkrisscustom/fire.ogg"
}

sound.Add(soundData)

//Dual UZIs. Just like Max Payne!
local soundData = {
	name 		= "DualUzi.ClipOut" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/dualuzi/clipout.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "DualUzi.ClipIn" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/dualuzi/clipin.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "DualUzi.Draw" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/dualuzi/draw.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "DualUzi.Idle1" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/dualuzi/idle1.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "DualUzi.Idle2" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/dualuzi/idle2.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "DualUzi.Fire" ,
	channel 	= CHAN_USER_BASE+11,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/dualuzi/fire.ogg"
}

sound.Add(soundData)

//Aeolis. Steampunk meets weaponry.
local soundData = {
	name 		= "Aeolis.ClipOut" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/aeolis/clipout.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "Aeolis.ClipIn1" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/aeolis/clipin1.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "Aeolis.ClipIn2" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/aeolis/clipin2.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "Aeolis.ClipIn3" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/aeolis/clipin3.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "Aeolis.Draw" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/aeolis/draw.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "Aeolis.Idle" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/aeolis/idle.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "Aeolis.Fire" ,
	channel 	= CHAN_USER_BASE+11,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/aeolis/fire.ogg"
}

sound.Add(soundData)

//Newcomen. Steampunk SMG, anyone?
local soundData = {
	name 		= "Newcomen.Reload" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/newcomen/reload.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "Newcomen.Draw" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/newcomen/draw.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "Newcomen.Idle" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/newcomen/idle.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "Newcomen.Fire" ,
	channel 	= CHAN_USER_BASE+11,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/newcomen/fire.ogg"
}

sound.Add(soundData)

//Brick Piece V2. Legos meet killer weaponry! Fun for the whole familiy..?
local soundData = {
	name 		= "BrickPieceV2.ClipIn" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/brickpiecev2/clipin.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "BrickPieceV2.ClipOut" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/brickpiecev2/clipout.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "BrickPieceV2.Draw" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/brickpiecev2/draw.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "BrickPieceV2.Fire" ,
	channel 	= CHAN_USER_BASE+11,
	volume 		= 0.5,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/brickpiecev2/fire.ogg"
}

sound.Add(soundData)

//VULCANUS-3. There's probably going to be more then just one.
local soundData = {
	name 		= "Vulcanus3.ClipIn" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/vulcanus3/clipin.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "Vulcanus3.ClipOut" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/vulcanus3/clipout.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "Vulcanus3.Draw" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/vulcanus3/draw.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "Vulcanus3.Fire" ,
	channel 	= CHAN_USER_BASE+11,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/vulcanus3/fire.ogg"
}

sound.Add(soundData)

//SPAS-12 Superior. Because scopes on shotguns. Why
local soundData = {
	name 		= "Spas12Superior.Insert" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/spas12superior/insert.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "Spas12Superior.Pump" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/spas12superior/pump.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "Spas12Superior.Draw" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/spas12superior/draw.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "Spas12Superior.Fire" ,
	channel 	= CHAN_USER_BASE+11,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/spas12superior/fire.ogg"
}

sound.Add(soundData)

//SKULL-2. Double the revolver, double the fun.
local soundData = {
	name 		= "SKULL2.ReloadLeft" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/skull2/reload_left.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "SKULL2.ReloadRight" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/skull2/reload_right.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "SKULL2.Draw" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/skull2/draw.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "SKULL2.Fire" ,
	channel 	= CHAN_USER_BASE+11,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/skull2/fire.ogg"
}

sound.Add(soundData)

//SKULL-3. Double SMGs? Single SMG? Your choice, spawn A or B mode.
local soundData = {
	name 		= "SKULL3.ClipOut" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/skull3/clipout.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "SKULL3.ClipIn" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/skull3/clipin.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "SKULL3.DualIdle" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/skull3/dual_idle.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "SKULL3.Fire" ,
	channel 	= CHAN_USER_BASE+11,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/skull3/fire.ogg"
}

sound.Add(soundData)

//SKULL-4. Double SMGs? Screw that, double rifles.
local soundData = {
	name 		= "SKULL4.ClipOut" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/skull4/clipout.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "SKULL4.ClipIn" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/skull4/clipin.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "SKULL4.Draw" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/skull4/draw.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "SKULL4.Fire" ,
	channel 	= CHAN_USER_BASE+11,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/skull4/fire.ogg"
}

sound.Add(soundData)


//SKULL-5. Fully automatic snipers, anyone?
local soundData = {
	name 		= "SKULL5.ClipOut" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/skull5/clipout.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "SKULL5.ClipIn" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/skull5/clipin.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "SKULL5.BoltPull" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/skull5/boltpull.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "SKULL5.Draw" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/skull5/draw.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "SKULL5.Fire" ,
	channel 	= CHAN_USER_BASE+11,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/skull5/fire.ogg"
}

sound.Add(soundData)

//SKULL-6. LMG-Sniper hybrid. Running outta ideas, huh Nexon?
local soundData = {
	name 		= "SKULL6.ClipOut" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/skull6/clipout.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "SKULL6.BoxIn1" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/skull6/boxin1.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "SKULL6.BoxIn2" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/skull6/boxin2.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "SKULL6.BoxOut" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/skull6/boxout.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "SKULL6.Chain" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/skull6/chain.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "SKULL6.Fire" ,
	channel 	= CHAN_USER_BASE+11,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/skull6/fire.ogg"
}

sound.Add(soundData)

//SKULL-8. More LMGs. Now I'm running out of ideas...
local soundData = {
	name 		= "SKULL8.CoverDown" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/skull8/cover_down.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "SKULL8.CoverUp" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/skull8/cover_up.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "SKULL8.BoxIn" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/skull8/box_in.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "SKULL8.BoxOut" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/skull8/box_out.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "SKULL8.Chain" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/skull8/chain.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "SKULL8.Melee1" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/skull8/melee_1.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "SKULL8.Melee2" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/skull8/melee_2.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "SKULL8.Fire" ,
	channel 	= CHAN_USER_BASE+11,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/skull8/fire.ogg"
}

sound.Add(soundData)

//THANATOS-5. Blades: The Rifle. Had to recode because I completely deleted it by mistake.
local soundData = {
	name 		= "THANATOS5.ClipOut" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/thanatos5/clipout.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "THANATOS5.ClipIn" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/thanatos5/clipin.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "THANATOS5.ClipHit" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/thanatos5/cliphit.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "THANATOS5.Fire" ,
	channel 	= CHAN_USER_BASE+11,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/thanatos5/fire.ogg"
}

sound.Add(soundData)

//BALROG-1. Witty response? Hah, no.
local soundData = {
	name 		= "BALROG1.Reload" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/balrog1/reload.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "BALROG1.Draw" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/balrog1/draw.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "BALROG1.Fire" ,
	channel 	= CHAN_USER_BASE+11,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/balrog1/fire.ogg"
}

sound.Add(soundData)

//BALROG-3. Shiny.
local soundData = {
	name 		= "BALROG3.ClipOut" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/balrog3/clipout.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "BALROG3.ClipIn" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/balrog3/clipin.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "BALROG3.BoltPull" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/balrog3/boltpull.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "BALROG3.Draw" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/balrog3/draw.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "BALROG3.Fire" ,
	channel 	= CHAN_USER_BASE+11,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/balrog3/fire.ogg"
}

sound.Add(soundData)

//BALROG-7. LMGs with more scopes.
local soundData = {
	name 		= "BALROG7.ClipOut1" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/balrog7/clipout1.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "BALROG7.ClipOut2" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/balrog7/clipout2.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "BALROG7.ClipIn1" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/balrog7/clipin1.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "BALROG7.ClipIn2" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/balrog7/clipin2.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "BALROG7.ClipIn3" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/balrog7/clipin3.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "BALROG7.Draw" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/balrog7/draw.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "BALROG7.Fire" ,
	channel 	= CHAN_USER_BASE+11,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/balrog7/fire.ogg"
}

sound.Add(soundData)

//BALROG-11. Skipped 9 because of skeleton issues.
local soundData = {
	name 		= "BALROG11.Insert" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/balrog11/insert.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "BALROG11.Draw" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/balrog11/draw.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "BALROG11.Fire" ,
	channel 	= CHAN_USER_BASE+11,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/balrog11/fire.ogg"
}

sound.Add(soundData)

--CROW-5
TFA.AddFireSound( "CROW5.Fire", "weapons/tfa_cso/crow5/fire.ogg", false, "" )
TFA.AddWeaponSound( "CROW5.Draw", "weapons/tfa_cso/crow5/draw.ogg" )
TFA.AddWeaponSound( "CROW5.Reload_In", "weapons/tfa_cso/crow5/reload_in.ogg" )
TFA.AddWeaponSound( "CROW5.Reload_A", "weapons/tfa_cso/crow5/reload_a.ogg" )
TFA.AddWeaponSound( "CROW5.Reload_B", "weapons/tfa_cso/crow5/reload_b.ogg" )

---CANNON-Fireball
local soundData = {
	name 		= "Cannon.Exp" ,
	channel 	= CHAN_USER_BASE+11,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/blackdragoncannon/exp.ogg"
}

sound.Add(soundData)