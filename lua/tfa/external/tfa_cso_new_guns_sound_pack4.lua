--TFA.AddFireSound( "Gun.Fire", "weapons/tfa_cso/gun/fire.ogg", false, "^" )
--TFA.AddWeaponSound( "Gun.Reload", "weapons/tfa_cso/gun/reload.ogg" )

--Gunkata
TFA.AddFireSound( "Gunkata.Fire", "weapons/tfa_cso/gunkata/fire.ogg", false, "^" )
TFA.AddFireSound( "Gunkata.Skill_Explode", "weapons/tfa_cso/gunkata/skill_last_exp.ogg", false, "^" )
TFA.AddWeaponSound( "Gunkata.Reload", "weapons/tfa_cso/gunkata/reload.ogg" )
TFA.AddWeaponSound( "Gunkata.Reload2", "weapons/tfa_cso/gunkata/reload2.ogg" )
TFA.AddWeaponSound( "Gunkata.Draw2", "weapons/tfa_cso/gunkata/draw2.ogg" )
TFA.AddWeaponSound( "Gunkata.Draw", "weapons/tfa_cso/gunkata/draw.ogg" )
TFA.AddWeaponSound( "Gunkata.Idle", "weapons/tfa_cso/gunkata/idle.ogg" )
TFA.AddWeaponSound( "Gunkata.Skill1", "weapons/tfa_cso/gunkata/skill_01.ogg" )
TFA.AddWeaponSound( "Gunkata.Skill2", "weapons/tfa_cso/gunkata/skill_02.ogg" )
TFA.AddWeaponSound( "Gunkata.Skill3", "weapons/tfa_cso/gunkata/skill_03.ogg" )
TFA.AddWeaponSound( "Gunkata.Skill4", "weapons/tfa_cso/gunkata/skill_04.ogg" )
TFA.AddWeaponSound( "Gunkata.Skill5", "weapons/tfa_cso/gunkata/skill_05.ogg" )
TFA.AddWeaponSound( "Gunkata.Skilllast", "weapons/tfa_cso/gunkata/skill_last.ogg" )
TFA.AddWeaponSound( "Gunkata.SkilllastExp", "weapons/tfa_cso/gunkata/skill_last_exp.ogg" )
TFA.AddWeaponSound( "Gunkata.Hit1", "weapons/tfa_cso/gunkata/hit1.ogg" )
TFA.AddWeaponSound( "Gunkata.Hit2", "weapons/tfa_cso/gunkata/hit2.ogg" )

--Laserfist
TFA.AddFireSound( "Laserfist.FireA", "weapons/tfa_cso/laserfist/fire_a.ogg", false, "^" )
TFA.AddFireSound( "Laserfist.FireB", "weapons/tfa_cso/laserfist/fire_b.ogg", false, "^" )
TFA.AddWeaponSound( "Laserfist.ClipIn1", "weapons/tfa_cso/laserfist/clipin1.ogg" )
TFA.AddWeaponSound( "Laserfist.ClipIn2", "weapons/tfa_cso/laserfist/clipin2.ogg" )
TFA.AddWeaponSound( "Laserfist.ClipOut", "weapons/tfa_cso/laserfist/clipout.ogg" )
TFA.AddWeaponSound( "Laserfist.Draw", "weapons/tfa_cso/laserfist/draw.ogg" )
TFA.AddWeaponSound( "Laserfist.Idle", "weapons/tfa_cso/laserfist/idle.ogg" )
TFA.AddWeaponSound( "Laserfist.Charge", "weapons/tfa_cso/laserfist/charge.ogg" )
TFA.AddWeaponSound( "Laserfist.Empty_End", "weapons/tfa_cso/laserfist/shoot_empty_end" )
TFA.AddWeaponSound( "Laserfist.Empty_Loop", "weapons/tfa_cso/laserfist/shoot_empty_loop.ogg" )
TFA.AddWeaponSound( "Laserfist.Boom", "weapons/tfa_cso/laserfist/shootb_exp.ogg" )
TFA.AddWeaponSound( "Laserfist.Ready", "weapons/tfa_cso/laserfist/shootb_ready.ogg" )
TFA.AddWeaponSound( "Laserfist.ShootB_Shoot", "weapons/tfa_cso/laserfist/shootb_shoot.ogg" )
TFA.AddWeaponSound( "Laserfist.ShootB_Loop", "weapons/tfa_cso/laserfist/shootb_loop.ogg" )

--Holy Bomb
TFA.AddFireSound ( "Holybomb.Explode", "weapons/tfa_cso/holybomb/explode.ogg", false, "^" )
TFA.AddWeaponSound ( "HolyBomb.PullPin", "weapons/tfa_cso/holybomb/pullpin.ogg" )
TFA.AddWeaponSound ( "HolyBomb.Draw", "weapons/tfa_cso/holybomb/draw.ogg" )

--Dark Legacy Luger
TFA.AddFireSound ( "Luger_Legacy.Fire", "weapons/tfa_cso/luger_legacy/fire.ogg", false, "^" )

--Trinity Grenade
TFA.AddFireSound ( "Trinity.ExplodeRed", "weapons/tfa_cso/trinity/red_explode.ogg", false, "^" )
TFA.AddFireSound ( "Trinity.ExplodeGreen", "weapons/tfa_cso/trinity/green_explode.ogg", false, "^" )
TFA.AddFireSound ( "Trinity.ExplodeWhite", "weapons/tfa_cso/trinity/white_explode.ogg", false, "^" )
--TFA.AddWeaponSound ( "Trinity.IdleRed", "weapons/tfa_cso/trinity/red_idle.ogg" )
--TFA.AddWeaponSound ( "Trinity.IdleGreen", "weapons/tfa_cso/trinity/green_idle.ogg" )
--TFA.AddWeaponSound ( "Trinity.IdleWhite", "weapons/tfa_cso/trinity/white_idle.ogg" )
--This fixes idle sounds looping over themselves

sound.Add({
	['name'] = "Trinity.IdleRed",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/trinity/red_idle.ogg"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Trinity.IdleGreen",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/trinity/green_idle.ogg"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Trinity.IdleWhite",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/trinity/white_idle.ogg"},
	['pitch'] = {100,100}
})

TFA.AddWeaponSound ( "Trinity.TransformRed", "weapons/tfa_cso/trinity/red_transform.ogg" )
TFA.AddWeaponSound ( "Trinity.TransformGreen", "weapons/tfa_cso/trinity/green_transform.ogg" )
TFA.AddWeaponSound ( "Trinity.TransformWhite", "weapons/tfa_cso/trinity/white_transform.ogg" )
TFA.AddWeaponSound ( "Trinity.TransformBase", "weapons/tfa_cso/trinity/transform_base.ogg" )
TFA.AddWeaponSound ( "Trinity.PullPin", "weapons/tfa_cso/trinity/pullpin.ogg" )
TFA.AddWeaponSound ( "Trinity.Draw", "weapons/tfa_cso/trinity/draw.ogg" )

--Zhubajie Minigun
TFA.AddFireSound( "Zhubajie.Fire", "weapons/tfa_cso/monkeywpset1/fire.ogg", false, "^" )
TFA.AddWeaponSound( "Zhubajie.Spindown", "weapons/tfa_cso/monkeywpset1/spindown.ogg" )
TFA.AddWeaponSound( "Zhubajie.ClipIn", "weapons/tfa_cso/monkeywpset1/clipin.ogg" )
TFA.AddWeaponSound( "Zhubajie.ClipOut", "weapons/tfa_cso/monkeywpset1/clipout.ogg" )
TFA.AddWeaponSound( "Zhubajie.ClipOut1", "weapons/tfa_cso/monkeywpset1/clipout1.ogg" )
TFA.AddWeaponSound( "Zhubajie.ClipOut2", "weapons/tfa_cso/monkeywpset1/clipout2.ogg" )

--Sha Wujing Dual Handgun
TFA.AddFireSound( "Wujing.Fire", "weapons/tfa_cso/monkeywpset2/fire.ogg", false, "^" )
TFA.AddWeaponSound( "Wujing.Draw", "weapons/tfa_cso/monkeywpset2/draw.ogg" )
TFA.AddWeaponSound( "Wujing.ClipIn", "weapons/tfa_cso/monkeywpset2/clipin.ogg" )
TFA.AddWeaponSound( "Wujing.ClipOut", "weapons/tfa_cso/monkeywpset2/clipout.ogg" )

--X-Tracker
TFA.AddFireSound( "XTracker.Fire", "weapons/tfa_cso/xtracker/fire.ogg", false, "^" )
TFA.AddFireSound( "XTracker.ShootB", "weapons/tfa_cso/xtracker/shootb.ogg", false, "^" )
TFA.AddFireSound( "XTracker.Exp", "weapons/tfa_cso/xtracker/exp.ogg", false, "^" )
TFA.AddWeaponSound( "XTracker.Reload", "weapons/tfa_cso/xtracker/reload.ogg" )
TFA.AddWeaponSound( "XTracker.ZoomIn", "weapons/tfa_cso/xtracker/zoom_in.ogg" )
TFA.AddWeaponSound( "XTracker.ZoomOut", "weapons/tfa_cso/xtracker/zoom_out.ogg" )
TFA.AddWeaponSound( "XTracker.ScopeOn", "weapons/tfa_cso/xtracker/scope_on.ogg" )
TFA.AddWeaponSound( "XTracker.Shoot_On1", "weapons/tfa_cso/xtracker/shootb_on1.ogg" )
TFA.AddWeaponSound( "XTracker.Shoot_On2", "weapons/tfa_cso/xtracker/shootb_on2.ogg" )
TFA.AddWeaponSound( "XTracker.Beep", "weapons/tfa_cso/xtracker/beep.ogg" )
TFA.AddWeaponSound( "XTracker.Draw", "weapons/tfa_cso/xtracker/draw.ogg" )

--Janus 1
TFA.AddFireSound( "Janus1.Fire", "weapons/tfa_cso/janus1/fire.ogg", false, "^" )
TFA.AddFireSound( "Janus1.Fire2", "weapons/tfa_cso/janus1/fire2.ogg", false, "^" )
TFA.AddFireSound( "Janus1.Exp", "weapons/tfa_cso/janus1/exp.ogg", false, "^" )
TFA.AddWeaponSound( "Janus1.Change1", "weapons/tfa_cso/janus1/change1.ogg" )
TFA.AddWeaponSound( "Janus1.Change2", "weapons/tfa_cso/janus1/change2.ogg" )
TFA.AddWeaponSound( "Janus1.Draw", "weapons/tfa_cso/janus1/draw.ogg" )

--Bazooka
TFA.AddFireSound( "Bazooka.Fire", "weapons/tfa_cso/bazooka/fire.ogg", false, "^" )
TFA.AddFireSound( "Bazooka.Exp1", "weapons/tfa_cso/bazooka/exp1.ogg", false, "^" )
TFA.AddFireSound( "Bazooka.Exp2", "weapons/tfa_cso/bazooka/exp2.ogg", false, "^" )
TFA.AddFireSound( "Bazooka.Exp3", "weapons/tfa_cso/bazooka/exp3.ogg", false, "^" )
TFA.AddWeaponSound( "Bazooka.Draw", "weapons/tfa_cso/bazooka/draw.ogg" )
TFA.AddWeaponSound( "Bazooka.ClipOut", "weapons/tfa_cso/bazooka/clipout.ogg" )
TFA.AddWeaponSound( "Bazooka.ClipIn", "weapons/tfa_cso/bazooka/clipin.ogg" )

--Petrol Boomer
TFA.AddFireSound( "PetrolBoomer.Fire", "weapons/tfa_cso/petrolboomer/fire.ogg", false, "^" )
TFA.AddFireSound( "PetrolBoomer.Exp", "weapons/tfa_cso/petrolboomer/exp.ogg", false, "^" )
TFA.AddWeaponSound( "PetrolBoomer.Draw", "weapons/tfa_cso/petrolboomer/draw.ogg" )
TFA.AddWeaponSound( "PetrolBoomer.Reload", "weapons/tfa_cso/petrolboomer/reload.ogg" )
TFA.AddWeaponSound( "PetrolBoomer.Draw_Empty", "weapons/tfa_cso/petrolboomer/draw_empty.ogg" )
TFA.AddWeaponSound( "PetrolBoomer.Idle", "weapons/tfa_cso/petrolboomer/idle.ogg" )

--Lightning Bazzi-1
TFA.AddFireSound( "CartRed.Fire", "weapons/tfa_cso/cartred/fire.ogg", false, "^" )
TFA.AddFireSound( "CartRed.Fire2", "weapons/tfa_cso/cartred/fire2.ogg", false, "^" )
TFA.AddWeaponSound( "CartRed.ClipIn", "weapons/tfa_cso/cartred/clipin.ogg" )
TFA.AddWeaponSound( "CartRed.ClipOut", "weapons/tfa_cso/cartred/clipout.ogg" )
TFA.AddWeaponSound( "CartRed.Foley5", "weapons/tfa_cso/cartred/foley5.ogg" )
TFA.AddWeaponSound( "CartRed.HeadOpen", "weapons/tfa_cso/cartred/headopen.ogg" )
TFA.AddWeaponSound( "CartRed.HeadClose", "weapons/tfa_cso/cartred/headclose.ogg" )

--UMP45 Snake
TFA.AddFireSound( "Snakegun.Fire", "weapons/tfa_cso/snakegun/fire.ogg", false, "^" )
TFA.AddWeaponSound( "Snakegun.ClipIn", "weapons/tfa_cso/snakegun/clipin.ogg" )
TFA.AddWeaponSound( "Snakegun.ClipOut1", "weapons/tfa_cso/snakegun/clipout1.ogg" )
TFA.AddWeaponSound( "Snakegun.ClipOut2", "weapons/tfa_cso/snakegun/clipout2.ogg" )
TFA.AddWeaponSound( "Snakegun.Draw", "weapons/tfa_cso/snakegun/draw.ogg" )
TFA.AddWeaponSound( "Snakegun.Boltpull", "weapons/tfa_cso/snakegun/boltpull.ogg" )

--Lightning Dao-1
TFA.AddFireSound( "CartBlue.Fire", "weapons/tfa_cso/cartblue/fire.ogg", false, "^" )
TFA.AddFireSound( "CartBlue.Fire2", "weapons/tfa_cso/cartblue/fire2.ogg", false, "^" )
TFA.AddWeaponSound( "CartBlue.ClipIn", "weapons/tfa_cso/cartblue/clipin.ogg" )
TFA.AddWeaponSound( "CartBlue.ClipOut", "weapons/tfa_cso/cartblue/clipout.ogg" )
TFA.AddWeaponSound( "CartBlue.ClipOut2", "weapons/tfa_cso/cartblue/clipout2.ogg" )
TFA.AddWeaponSound( "CartBlue.Foley1", "weapons/tfa_cso/cartblue/foley1.ogg" )
TFA.AddWeaponSound( "CartBlue.Foley2", "weapons/tfa_cso/cartblue/foley2.ogg" )
TFA.AddWeaponSound( "CartBlue.Foley3", "weapons/tfa_cso/cartblue/foley3.ogg" )
TFA.AddWeaponSound( "CartBlue.Foley4", "weapons/tfa_cso/cartblue/foley4.ogg" )
TFA.AddWeaponSound( "CartBlue.Draw", "weapons/tfa_cso/cartblue/draw.ogg" )
TFA.AddWeaponSound( "CartBlue.Draw2", "weapons/tfa_cso/cartblue/draw2.ogg" )
TFA.AddWeaponSound( "CartBlue.Hit", "weapons/tfa_cso/cartblue/hit.ogg" )
TFA.AddWeaponSound( "CartBlue.Jump", "weapons/tfa_cso/cartblue/jump.ogg" )
TFA.AddWeaponSound( "CartBlue.Spindown", "weapons/tfa_cso/cartblue/spindown.ogg" )
TFA.AddWeaponSound( "CartBlue.Turn", "weapons/tfa_cso/cartblue/turn.ogg" )
TFA.AddWeaponSound( "CartBlue.Yaho", "weapons/tfa_cso/cartblue/yaho.ogg" )

--MP7 Unicorn
TFA.AddFireSound( "Horsegun.Fire", "weapons/tfa_cso/horsegun/fire.ogg", false, "^" )
TFA.AddWeaponSound( "Horsegun.ClipIn", "weapons/tfa_cso/horsegun/clipin.ogg" )
TFA.AddWeaponSound( "Horsegun.ClipOut", "weapons/tfa_cso/horsegun/clipout.ogg" )
TFA.AddWeaponSound( "Horsegun.Idle", "weapons/tfa_cso/horsegun/idle.ogg" )
TFA.AddWeaponSound( "Horsegun.Draw", "weapons/tfa_cso/horsegun/draw.ogg" )
TFA.AddWeaponSound( "Horsegun.Boltpull", "weapons/tfa_cso/horsegun/boltpull.ogg" )

--M95 Ghost Knight
TFA.AddFireSound( "M95Ghost.Fire", "weapons/tfa_cso/m95ghost/fire.ogg", false, "^" )
TFA.AddFireSound( "M95Ghost.Fire2", "weapons/tfa_cso/m95ghost/fire2.ogg", false, "^" )
TFA.AddWeaponSound( "M95Ghost.ClipIn", "weapons/tfa_cso/m95ghost/clipin.ogg" )
TFA.AddWeaponSound( "M95Ghost.ClipOut", "weapons/tfa_cso/m95ghost/clipout.ogg" )
TFA.AddWeaponSound( "M95Ghost.Idle", "weapons/tfa_cso/m95ghost/idle.ogg" )
TFA.AddWeaponSound( "M95Ghost.Draw", "weapons/tfa_cso/m95ghost/draw.ogg" )
TFA.AddWeaponSound( "M95Ghost.Point", "weapons/tfa_cso/m95ghost/point.ogg" )
TFA.AddWeaponSound( "M95Ghost.Net1", "weapons/tfa_cso/m95ghost/shoot_net1.ogg" )
TFA.AddWeaponSound( "M95Ghost.Net2", "weapons/tfa_cso/m95ghost/shoot_net2.ogg" )

--M3 Big Shark
TFA.AddFireSound( "M3Shark.Fire", "weapons/tfa_cso/m3shark/fire.ogg", false, "^" )
TFA.AddWeaponSound( "M3Shark.Insert", "weapons/tfa_cso/m3shark/insert.ogg" )
TFA.AddWeaponSound( "M3Shark.After_Reload", "weapons/tfa_cso/m3shark/after_reload.ogg" )
TFA.AddWeaponSound( "M3Shark.Idle", "weapons/tfa_cso/m3shark/idle.ogg" )
TFA.AddWeaponSound( "M3Shark.Draw", "weapons/tfa_cso/m3shark/draw.ogg" )

--Newcomen Expert
TFA.AddFireSound( "NewcomenV6.Fire", "weapons/tfa_cso/newcomen_v6/fire.ogg", false, "^" )
TFA.AddWeaponSound( "NewcomenV6.Draw", "weapons/tfa_cso/newcomen_v6/draw.ogg" )
TFA.AddWeaponSound( "NewcomenV6.Reload", "weapons/tfa_cso/newcomen_v6/reload.ogg" )
TFA.AddWeaponSound( "NewcomenV6.Idle", "weapons/tfa_cso/newcomen_v6/idle.ogg" )

--Dart Pistol
TFA.AddFireSound( "Dartpistol.Fire", "weapons/tfa_cso/dartpistol/fire.ogg", false, "^" )
TFA.AddFireSound( "Dartpistol.Explosion1", "weapons/tfa_cso/dartpistol/explosion1.ogg", false, "^" )
TFA.AddFireSound( "Dartpistol.Explosion2", "weapons/tfa_cso/dartpistol/explosion2.ogg", false, "^" )
TFA.AddWeaponSound( "Dartpistol.Draw", "weapons/tfa_cso/dartpistol/draw.ogg" )
TFA.AddWeaponSound( "Dartpistol.ClipOut1", "weapons/tfa_cso/dartpistol/clipout1.ogg" )
TFA.AddWeaponSound( "Dartpistol.ClipOut2", "weapons/tfa_cso/dartpistol/clipout2.ogg" )
TFA.AddWeaponSound( "Dartpistol.ClipIn1", "weapons/tfa_cso/dartpistol/clipin1.ogg" )
TFA.AddWeaponSound( "Dartpistol.ClipIn2", "weapons/tfa_cso/dartpistol/clipin2.ogg" )
TFA.AddWeaponSound( "Dartpistol.ClipIn3", "weapons/tfa_cso/dartpistol/clipin3.ogg" )

--Magnum Drill Gold

local soundData = {
	name 		= "MagnumDrill.Draw" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/magnum_drill/draw.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "MagnumDrill.ClipOut" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/magnum_drill/clipout.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "MagnumDrill.ClipIn" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/magnum_drill/clipin.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "MagnumDrill.Idle" ,
	channel 	= CHAN_WEAPON,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/magnum_drill/idle.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "MagnumDrill.Fire" ,
	channel 	= CHAN_USER_BASE+11,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/magnum_drill/fire.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "MagnumDrill.Drill" ,
	channel 	= CHAN_USER_BASE+11,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/magnum_drill/drill.ogg"
}

sound.Add(soundData)

--Heaven Scorcher
TFA.AddFireSound( "HeavenScorcher.Fire", "weapons/tfa_cso/heaven_scorcher/fire.ogg", false, "^" )
TFA.AddFireSound( "HeavenScorcher.Mine_Shoot", "weapons/tfa_cso/heaven_scorcher/mine_shoot.ogg", false, "^" )
TFA.AddFireSound( "HeavenScorcher.Mine_Explosion", "weapons/tfa_cso/heaven_scorcher/mine_exp.ogg", false, "^" )
TFA.AddFireSound( "HeavenScorcher.Explosion1", "weapons/tfa_cso/heaven_scorcher/exp.ogg", false, "^" )
TFA.AddFireSound( "HeavenScorcher.Explosion2", "weapons/tfa_cso/heaven_scorcher/exp2.ogg", false, "^" )
TFA.AddWeaponSound( "HeavenScorcher.Draw", "weapons/tfa_cso/heaven_scorcher/draw.ogg" )
TFA.AddWeaponSound( "HeavenScorcher.Idle", "weapons/tfa_cso/heaven_scorcher/idle.ogg" )
TFA.AddWeaponSound( "HeavenScorcher.BMod_On", "weapons/tfa_cso/heaven_scorcher/bmod_on.ogg" )
TFA.AddWeaponSound( "HeavenScorcher.BMod_Exp", "weapons/tfa_cso/heaven_scorcher/bmod_on_exp.ogg" )
TFA.AddWeaponSound( "HeavenScorcher.Mine_Set", "weapons/tfa_cso/heaven_scorcher/mine_set.ogg" )
TFA.AddWeaponSound( "HeavenScorcher.Mine_Mode", "weapons/tfa_cso/heaven_scorcher/mine_mode.ogg" )
TFA.AddWeaponSound( "HeavenScorcher.ClipOut", "weapons/tfa_cso/heaven_scorcher/clipout.ogg" )
TFA.AddWeaponSound( "HeavenScorcher.ClipIn", "weapons/tfa_cso/heaven_scorcher/clipin.ogg" )

--Mac-10
TFA.AddFireSound( "MAC10.Fire", "weapons/tfa_cso/mac10/fire.ogg", false, "^" )
TFA.AddWeaponSound( "MAC10.ClipOut", "weapons/tfa_cso/mac10/clipout.ogg")
TFA.AddWeaponSound( "MAC10V2.ClipIn", "weapons/tfa_cso/mac10/clipin_v2.ogg")
TFA.AddWeaponSound( "MAC10.ClipRelease", "weapons/tfa_cso/mac10/cliprelease.ogg")
TFA.AddWeaponSound( "MAC10.Boltpull", "weapons/tfa_cso/mac10/boltpull.ogg")

--P228
TFA.AddFireSound( "P228.Fire", "weapons/tfa_cso/p228/fire.ogg", false, "^" )
TFA.AddWeaponSound( "P228.ClipIn", "weapons/tfa_cso/p228/clipin.ogg")
TFA.AddWeaponSound( "P228.ClipOut", "weapons/tfa_cso/p228/clipout.ogg")
TFA.AddWeaponSound( "P228.Deploy", "weapons/tfa_cso/p228/deploy.ogg")
TFA.AddWeaponSound( "P228.SlidePull", "weapons/tfa_cso/p228/slidepull.ogg")
TFA.AddWeaponSound( "P228.SlideRelease1", "weapons/tfa_cso/p228/sliderelease1.ogg")

--Ballista
TFA.AddWeaponSound( "Ballista.Exp2", "weapons/tfa_cso/ballista/exp2.ogg")
TFA.AddWeaponSound( "Ballista.Exp3", "weapons/tfa_cso/ballista/exp3.ogg")
TFA.AddWeaponSound( "Ballista.Reload1", "weapons/tfa_cso/ballista/reload1.ogg")
TFA.AddWeaponSound( "Ballista.Reload2", "weapons/tfa_cso/ballista/reload2.ogg")
TFA.AddWeaponSound( "Ballista.Draw", "weapons/tfa_cso/ballista/draw.ogg")
TFA.AddWeaponSound( "Ballista.Missile", "weapons/tfa_cso/ballista/missile.ogg")
TFA.AddWeaponSound( "Ballista.Missile_Last", "weapons/tfa_cso/ballista/missile_last.ogg")
TFA.AddWeaponSound( "Ballista.Missile_On", "weapons/tfa_cso/ballista/missile_on.ogg")

sound.Add({
	['name'] = "Ballista.Exp1",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/ballista/exp1.ogg"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Ballista.Missile_Reload",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/ballista/missile_reload.ogg"},
	['pitch'] = {100,100}
})

local soundData = {
	name 		= "Ballista.Fire" ,
	channel 	= CHAN_USER_BASE+11,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/ballista/fire.ogg"
}

sound.Add(soundData)

local soundData = {
	name 		= "Ballista.Fire2" ,
	channel 	= CHAN_USER_BASE+11,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/ballista/fire2.ogg"
}

sound.Add(soundData)

--Heart Bomb

sound.Add({
	['name'] = "Heartbomb.Explode",
	['channel'] = CHAN_USER_BASE,
	['sound'] = { "weapons/tfa_cso/heartbomb/explode.ogg"},
	['pitch'] = {100,100}
})

TFA.AddWeaponSound ( "HeartBomb.Pin", "weapons/tfa_cso/heartbomb/pin.ogg" )
TFA.AddWeaponSound ( "HeartBomb.Arrow", "weapons/tfa_cso/heartbomb/arrow.ogg" )
TFA.AddWeaponSound ( "HeartBomb.Draw", "weapons/tfa_cso/heartbomb/draw.ogg" )

--ThunderStorm

sound.Add({
	['name'] = "Thunderstorm.Explode",
	['channel'] = CHAN_USER_BASE,
	['sound'] = { "weapons/tfa_cso/thunderstorm/explode.ogg"},
	['pitch'] = {100,100}
})

TFA.AddWeaponSound ( "Thunderstorm.Throw", "weapons/tfa_cso/thunderstorm/throw.ogg" )
TFA.AddWeaponSound ( "Thunderstorm.Pullpin", "weapons/tfa_cso/thunderstorm/pullpin.ogg" )
TFA.AddWeaponSound ( "Thunderstorm.Idle", "weapons/tfa_cso/thunderstorm/idle.ogg" )
TFA.AddWeaponSound ( "Thunderstorm.Draw", "weapons/tfa_cso/thunderstorm/draw.ogg" )
TFA.AddWeaponSound ( "Thunderstorm.Charge", "weapons/tfa_cso/thunderstorm/charge.ogg" )