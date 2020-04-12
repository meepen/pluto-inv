if !ConVarExists( "sv_tfa_cso_dmg_windrider_rb" ) then
	CreateConVar( "sv_tfa_cso_dmg_windrider_rb", 12, FCVAR_ARCHIVE, "How much damage does the Windrider's right-click do per attack? Default is 12." )
end

if !ConVarExists( "sv_tfa_cso_dmg_gunslinger_rb" ) then
	CreateConVar( "sv_tfa_cso_dmg_gunslinger_rb", 15, FCVAR_ARCHIVE, "How much damage does the Gunslinger's right-click do per attack? Default is 15." )
end

if !ConVarExists( "sv_tfa_cso_dmg_gunslinger_gs_rb" ) then
	CreateConVar( "sv_tfa_cso_dmg_gunslinger_gs_rb", 18, FCVAR_ARCHIVE, "How much damage does the Gunslinger GS's right-click do per attack? Default is 18." )
end

if !ConVarExists( "sv_tfa_cso_dmg_gunslingers_player" ) then
	CreateConVar( "sv_tfa_cso_dmg_gunslingers_player", 0, FCVAR_ARCHIVE, "Can the Gunslingers' right-click deal damage to players? 0 is no, 1 is yes. Default is 0. NOTE: Bots are still considered players!" )
end

if !ConVarExists( "sv_tfa_cso_dmg_trinity_detect_player" ) then
	CreateConVar( "sv_tfa_cso_dmg_trinity_detect_player", 0, FCVAR_ARCHIVE, "Will the Trinity Grenade detect players? 0 is no, 1 is yes. Default is 0. NOTE: Bots are still considered players!" )
end