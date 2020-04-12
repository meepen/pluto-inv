--TFA.AddFireSound( "Gun.Fire", "weapons/tfa_cso/gun/fire.ogg", false, "^" )
--TFA.AddWeaponSound( "Gun.Reload", "weapons/tfa_cso/gun/reload.ogg" )

--Galil maverick
TFA.AddFireSound( "GalilCraft.Fire", "weapons/tfa_cso/galilcraft/fire.ogg", false, "^" )
TFA.AddWeaponSound( "GalilCraft.ClipIn", "weapons/tfa_cso/galilcraft/clipin.ogg")
TFA.AddWeaponSound( "GalilCraft.ClipOut", "weapons/tfa_cso/galilcraft/clipout.ogg")
TFA.AddWeaponSound( "GalilCraft.Boltpull", "weapons/tfa_cso/galilcraft/boltpull.ogg")

--Hunter Killer X-12
TFA.AddFireSound( "X-12.Fire", "weapons/tfa_cso/x-12/fire.ogg", false, "^" )
TFA.AddWeaponSound( "X-12.Draw", "weapons/tfa_cso/x-12/draw.ogg" )
TFA.AddWeaponSound( "X-12.ClipIn1", "weapons/tfa_cso/x-12/clipin1.ogg" )
TFA.AddWeaponSound( "X-12.ClipIn2", "weapons/tfa_cso/x-12/clipin2.ogg" )
TFA.AddWeaponSound( "X-12.ClipOut1", "weapons/tfa_cso/x-12/clipout1.ogg" )
TFA.AddWeaponSound( "X-12.ClipOut2", "weapons/tfa_cso/x-12/clipout2.ogg" )


//StarChaser AR. Shooting AUG
local soundData = {
    name        = "StarAR.Idle" ,
    channel     = CHAN_WEAPON,
    volume      = 1,
    soundlevel  = 80,
    pitchstart  = 100,
    pitchend    = 100,
    sound       = "weapons/tfa_cso/starchaserar/idle.ogg"
}

sound.Add(soundData)
