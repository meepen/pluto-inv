SWEP.Base				= "weapon_ttt_crowbar"
SWEP.Category				= "TFA CS:O" --The category.  Please, just choose something generic or something I've already done if you plan on only doing like one swep.
SWEP.Author				= "Kamikaze and WackoD" --Author Tooltip
SWEP.PrintName				= "Dual Beretta Gunslinger Global Showcase 2018"		-- Weapon name (Shown on HUD)	
SWEP.Slot				= 8				-- Slot in the weapon selection menu.  Subtract 1, as this starts at 0.

SWEP.Primary.Sound 			= Sound("Gunkata.Fire")				-- This is the sound of the weapon, when you shoot.
SWEP.Primary.Damage		= 110
SWEP.Primary.Automatic			= true					-- Automatic/Semi Auto
SWEP.Primary.Delay				= 60 / 700					-- This is in Rounds Per Minute / RPM
SWEP.Primary.ClipSize			= 36					-- This is the size of a clip
SWEP.Primary.DefaultClip			= 396 			-- This is the number of bullets the gun gives you, counting a clip as defined directly above.
SWEP.Primary.Ammo			= "pistol"


SWEP.ViewModel			= "models/weapons/tfa_cso/c_rainbowkata.mdl" --Viewmodel path
SWEP.ViewModelFOV			= 85		-- This controls how big the viewmodel looks.  Less is more.
SWEP.ViewModelFlip			= true		-- Set this to true for CSS models, or false for everything else (with a righthanded viewmodel.)
SWEP.UseHands = true --Use gmod c_arms system.

SWEP.WorldModel			= "models/weapons/tfa_cso/w_rainbowkata.mdl" -- Worldmodel path

SWEP.HoldType 				= "duel"

SWEP.WElements = {
	["otherpist"] = { type = "Model", model = "models/weapons/tfa_cso/w_rainbowkata.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(6.479, 1.812, 2.755), angle = Angle(0, 75.515, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.Offset = { --Procedural world model animation, defaulted for CS:S purposes.
	Pos = {
		Up = -2.8,
		Right = 1.25,
		Forward = 5.5,
	},
	Ang = {
		Up = -100,
		Right = 0,
		Forward = 175
	},
	Scale = 1
}

SWEP.IronSightsPos = Vector(6.519, 0, -1.601)
SWEP.IronSightsAng = Vector(3.296, 0.289, -1.89)


SWEP.MuzzleAttachment			= "0" 		-- Should be "1" for CSS models or "muzzle" for hl2 models

SWEP.ConDamageMultiplier = 1
local fires = 6

DEFINE_BASECLASS("tfa_gun_base" )
function SWEP:PrimaryAttack()
--TFA.Enum.IDLE_DISABLED = no idle, TFA.Enum.IDLE_LUA = lua idle, TFA.Enum.IDLE_ANI = mdl idle, TFA.Enum.IDLE_BOTH = TFA.Enum.IDLE_ANI + TFA.Enum.IDLE_LUA
if self:Clip1() <= 0 then return end
if self.rd-1 > CurTime() then return end

local VModel = self.Owner:GetViewModel()
local Seq = VModel:LookupSequence("shoot")
local Seq2 = VModel:LookupSequence("shoot2")
local Seq3 = VModel:LookupSequence("shoot_last")
local Seq4 = VModel:LookupSequence("shoot2_last")
if self:Clip1()%6 == 0 or self:Clip1()%6 == 5   then 
VModel:SendViewModelMatchingSequence( Seq )
self.MuzzleAttachment = "0"
end
if  self:Clip1()%6 == 4 then
VModel:SendViewModelMatchingSequence( Seq3)
self.MuzzleAttachment = "0"
self.Hand = 2
end
if  self:Clip1()%6 == 3 or self:Clip1()%6 == 2   then 
VModel:SendViewModelMatchingSequence( Seq2 )
self.MuzzleAttachment = "2"
end
if  self:Clip1()%6 == 1 then
VModel:SendViewModelMatchingSequence( Seq4)
self.MuzzleAttachment = "2"

self.Hand = 1
end
BaseClass.PrimaryAttack(self)
self.nextidle = CurTime() + 0.4
end
------
SWEP.rd = 0
function SWEP:Reload()

if self:Ammo1() <= 0 then return end
if self:Clip1() >= self.Primary.ClipSize then return end
if self.rd > CurTime() then return end


self.rd = CurTime() + 3
self.nextidle = CurTime() + 2
self:SetNextPrimaryFire(CurTime() + 2)
self:SetNextSecondaryFire(CurTime() + 2)

if SERVER then
local VModel = self.Owner:GetViewModel()
local Seq1 = VModel:LookupSequence("reload")
local Seq2 = VModel:LookupSequence("reload2")
if self.Hand == 1 then
VModel:SendViewModelMatchingSequence( Seq1 )
else
VModel:SendViewModelMatchingSequence( Seq2 )
end
end
timer.Simple(2,function() 
if self:IsValid() and  self.Owner:GetActiveWeapon():GetClass() ==  "tfa_cso_rainbowkata" then
self:CompleteReload()
self.Hand = 1
end
end)
if SERVER then
self.Owner:SetAnimation(PLAYER_RELOAD )
end
end
function SWEP:Think()
BaseClass.Think(self)
local VModel = self.Owner:GetViewModel()
local Seq1 = VModel:LookupSequence("idle")
local Seq2 = VModel:LookupSequence("idle2")

if self.nextidle <= CurTime() and self.idle then


self.idle = false

end

if self.nextidle > CurTime()  then
self.idle = true
end

skill = 1
end
function SWEP:Deploy()
self.nextidle = CurTime() + 1
BaseClass.Deploy(self)
local VModel = self.Owner:GetViewModel()
local Seq1 = VModel:LookupSequence("draw")
local Seq2 = VModel:LookupSequence("draw2")
if self.Hand == 2 then

VModel:SendViewModelMatchingSequence( Seq2 )
    return true
else
VModel:SendViewModelMatchingSequence( Seq1 )
    return true
end
end
local function SetEntityStuff( ent1, ent2 ) -- Transfer most of the set things on entity 2 to entity 1
	if !IsValid( ent1 ) or !IsValid( ent2 ) then return false end
	ent1:SetModel("models/weapons/tfa_cso/ef_rainbowkata_man.mdl" )
	
    local 	ang =  ent2:GetAngles()
    ang.x = 0
	ent1:SetAngles(ang )

	ent1:SetSkin( ent2:GetSkin() )
	ent1:SetRenderMode(2)
	ent1:SetColor( Color(255, 255, 255, 100) ) 
	
	

end

local skillt = 0
local skill = 0
local skilltime = 0
local skilltime1 = 0
function SWEP:SecondaryAttack()
self:SetNextPrimaryFire( CurTime() + 0.1)

if  self:Clip1()%6 == 4 then


self.Hand = 2
end

if  self:Clip1()%6 == 1 then

self.Hand = 1
end


if self:Clip1() <= 0 then return end
local VModel = self.Owner:GetViewModel()


if self:Clip1() > 1 then
self:SetNextSecondaryFire(CurTime() + 0.1)




self.Owner:AnimRestartGesture(0, ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE, true)


if skilltime < CurTime() then

skill = skill + 1
if skill > 5 then

skill = 1
end


local Seq = VModel:LookupSequence("skill_0"..skill)

VModel:SendViewModelMatchingSequence( Seq )
skilltime = CurTime() + 0.5






end


if skilltime1 < CurTime() then

skillt = skillt + 1
if skillt > 5 then

skillt = 0
end
--[[if CLIENT then
local rag = ClientsideModel(self.Owner:GetModel())

SetEntityStuff(rag,self.Owner)
if self.Owner:Crouching() then
rag:SetSequence(rag:LookupSequence("crouch_skill"..skillt))
rag:SetPos( self.Owner:GetPos() + self.Owner:GetUp()*25)
else
rag:SetSequence(rag:LookupSequence("skill"..skillt))
rag:SetPos( self.Owner:GetPos() + self.Owner:GetUp()*40)
end
timer.Simple(0.8,function() 

if rag:IsValid() then rag:Remove() end end)

end]]--
skilltime1 = CurTime() + 0.2

end













timer.Create( "gunkatadeploy",1, 1, function() 

if not self.Owner:KeyPressed(IN_ATTACK2) then
self:Deploy()

end


end )



if SERVER then
	for k,v in pairs(ents.FindInSphere(self.Owner:GetPos(),225)) do
		if GetConVar( "sv_tfa_cso_dmg_gunslingers_player" ):GetInt() == 0 then
			if v != self.Owner and (v:IsNPC() or v:IsNextBot() or v:GetClass() == "func_prop" ) then
				if v:Health() > 0 then
					v:TakeDamage( GetConVar( "sv_tfa_cso_dmg_gunslinger_gs_rb" ):GetInt() , self.Owner, self.Entity )
					v:EmitSound("Gunkata.Hit2")
				end
			end
		else
			if v != self.Owner and (v:IsNPC() or v:IsNextBot() or v:IsPlayer() or v:GetClass() == "func_prop" ) then
				if v:Health() > 0 then
					v:TakeDamage( GetConVar( "sv_tfa_cso_dmg_gunslinger_gs_rb" ):GetInt() , self.Owner, self.Entity )
					v:EmitSound("Gunkata.Hit2")
				end
			end	
		end
	end
end
self:TakePrimaryAmmo(1)

elseif self:Clip1() <= 1 then
local Seq1 = VModel:LookupSequence("skill_last")
VModel:SendViewModelMatchingSequence( Seq1 )
self:TakePrimaryAmmo(1)
if SERVER then
timer.Simple(0.5,function()












self:EmitSound("weapons/tfa_cso/gunkata/skill_last_exp.wav")
local effectdata = EffectData()
        effectdata:SetEntity(self.Owner)
		effectdata:SetOrigin(self.Owner:GetPos())
		effectdata:SetAngles(Angle(0,0,0))

	util.Effect("exp_gunkata_rs", effectdata)








    local radius = 225
	local phys_force = 1500
	local push_force = 1024

	for k, target in pairs( ents.FindInSphere( self.Owner:GetPos(), radius ) ) do

		if IsValid( target ) then
			local tpos = target:LocalToWorld( target:OBBCenter() )
			local dir = ( tpos - self.Owner:GetPos() ):GetNormal()
			local phys = target:GetPhysicsObject()

			if target != self.Owner and ( target:IsPlayer() && !target:IsFrozen() && ( !target.was_pushed || target.was_pushed.t != CurTime() ) or target:IsNPC() or target:IsNextBot() ) then

				dir.z = math.abs( dir.z ) + 1

				local push = dir * push_force

				local vel = target:GetVelocity() + push
				vel.z = math.min( vel.z, push_force / 3 )

				target:SetVelocity( vel )

				target.was_pushed = { att=self.Owner, t=CurTime(), wep="weapon_fraggrenade" }

			elseif IsValid( phys ) then
				phys:ApplyForceCenter( dir * -1 * phys_force )
			end
		end
	end


end)

timer.Simple(1,function() 
if self:IsValid() and  self.Owner:GetActiveWeapon():GetClass() ==  "tfa_cso_rainbowkata" then
self:CompleteReload()
self.Hand = 1
self:Deploy()
end
end)

self.Owner:SetAnimation(PLAYER_RELOAD )
end
end
end
if CLIENT then
	SWEP.WepSelectIconCSO = Material("vgui/killicons/tfa_cso_rainbowkata")
	SWEP.DrawWeaponSelection = TFA_CSO_DrawWeaponSelection
end
