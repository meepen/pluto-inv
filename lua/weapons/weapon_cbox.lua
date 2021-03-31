SWEP.Base = "weapon_tttbase"
SWEP.PrintName = "Cardboard Box"
SWEP.Instructions = "Primary: !\nSecondary: Toggle stealth mode\nCrouch: Cardboard box"

SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.AllowDrop = false

SWEP.UseHands = false

SWEP.ViewModel = "models/weapons/v_hands.mdl"
SWEP.WorldModel = "models/gmod_tower/stealth box/box.mdl"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.HoldType = "normal"

SWEP.Slot = 5

SWEP.m_WeaponDeploySpeed = 10 -- very fast, so we don't wind up waiting for the hands animation to play

DEFINE_BASECLASS(SWEP.Base)

function SWEP:Initialize()
	self:DrawShadow( false )
	hook.Add("ShouldDrawLocalPlayer", self, self.ShouldDrawLocalPlayer)

	return BaseClass.Initialize(self)
end

function SWEP:SetupDataTables()
	return BaseClass.SetupDataTables(self)
end

function SWEP:IsUnderBox()
	return self.Owner:Crouching()
end

function SWEP:EquipNoise()
	self.Owner:EmitSound "cbox/equip.wav"
end

function SWEP:Alert()
	local effect = EffectData()
	effect:SetOrigin( self.Owner:GetPos() )
	effect:SetEntity( self.Owner )
	
	util.Effect( "MGSAlert", effect, true, true )
end

function SWEP:PrimaryAttack()
	if (CLIENT) then
		return
	end

	self:Alert()
	self:SetNextPrimaryFire( CurTime() + 5 )
end

function SWEP:Holster()
	if (IsFirstTimePredicted()) then
		self.UnderBox = false
		self.LerpMul = 1
	end
	
	return BaseClass.Holster(self)
end

function SWEP:IsHiding()
	return self:IsUnderBox() and self.LerpMul < 0.1
end

SWEP.LerpMul = 1
function SWEP:DrawWorldModel()
	if not IsValid( self.Owner ) then self:DrawModel() return end
	if (not self:IsUnderBox()) then return end

	local pos = self.Owner:GetPos()
	local ang = Angle( 0, self.Owner:EyeAngles().y, 0 )
	
	pos = pos + ( ang:Forward() * 10 )
	
	local bone_pos, bone_ang = self.Owner:GetBonePosition( self.Owner:LookupBone( "ValveBiped.Bip01_Spine1" ) )
	
	bone_pos = bone_pos + ( ang:Forward() * 10 )
	bone_pos.z = bone_pos.z - 15
	
	bone_ang:RotateAroundAxis( bone_ang:Forward(), 90 )
	bone_ang:RotateAroundAxis( bone_ang:Right(), -40 )
	bone_ang.y = ang.y -- box will spin around really fast in certain angles unless we make it the same in both
	
	if self:IsUnderBox() then
		local vel = self.Owner:GetVelocity():Length2D()
		local mul = math.Clamp( vel / 40, 0, 1 )
		self.LerpMul = Lerp( FrameTime() * 10, self.LerpMul, mul )
	else
		self.LerpMul = Lerp( FrameTime() * 10, self.LerpMul, 1 )
	end
	
	self:SetRenderOrigin( pos * ( 1 - self.LerpMul ) + bone_pos * self.LerpMul )
	self:SetRenderAngles( ang * ( 1 - self.LerpMul ) + bone_ang * self.LerpMul )
	self:SetModelScale( 1.2, 0 )
	
	self:DrawModel()
end

function SWEP:ShouldDrawViewModel()
	return false
end

function SWEP:ShouldDrawLocalPlayer(pl)
	if (pl == self:GetOwner() and self:IsUnderBox() and pl:GetActiveWeapon() == self) then
		return true
	end
end

local extents = Vector(5, 5, 5)
function SWEP:CalcView(pl, origin, angles, fov)
	if (self:IsUnderBox()) then
		local tr = util.TraceHull {
			start = origin,
			endpos = origin - angles:Forward() * 100,
			filter = pl,
			mask = MASK_VISIBLE,
			mins = -extents,
			maxs = extents
		}
		return tr.HitPos, angles, fov
	end

	return BaseClass.CalcView(self, pl, origin, angles, fov)
end

-- SWEP:Think only gets called serverside and clientside with the owner.
-- We need it to fire on all players. Garry is stupid.
hook.Add("Think", "CBoxThink", function()
	for _, pl in ipairs( player.GetAll() ) do
		local wep = pl:GetActiveWeapon()
		
		if (IsValid(wep) and wep:GetClass() == "weapon_cbox" and
			wep:IsUnderBox() ~= wep.UnderBox) then

			wep.UnderBox = wep:IsUnderBox()
			
			if wep.UnderBox then
				wep.LerpMul = 1
			end
		end
	end
end)

hook.Add("PrePlayerDraw", "CBoxStealth", function(pl)
	local wep = pl:GetActiveWeapon()
	if (IsValid(wep) and wep:GetClass() == "weapon_cbox") then
		pl:DrawShadow(false)
	end
end)

hook.Add("PostPlayerDraw", "weapon_cbox", function(pl)
	local wep = pl:GetActiveWeapon()
	if (IsValid(wep) and wep:GetClass() == "weapon_cbox") then
		pl:DrawShadow(true)
	end
end)