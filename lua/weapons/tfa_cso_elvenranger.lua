SWEP.Base = "weapon_tttbase"
SWEP.Category = "TFA CS:O"
SWEP.Author = "Anri"
SWEP.Spawnable = false
SWEP.AdminSpawnable = false
SWEP.DrawCrosshair = true
SWEP.PrintName = "AWP Elven Ranger"
SWEP.Slot = 2

SWEP.Primary.Sound = Sound("ElvenRanger.Fire")
SWEP.Primary.Damage = 45
SWEP.HeadshotMultiplier = 100

SWEP.Primary.ClipSize = 4
SWEP.Primary.DefaultClip = 8
SWEP.Primary.Delay = 1.7

SWEP.ReloadSpeed = 0.5

SWEP.AmmoEnt               = "item_ammo_357_ttt"
SWEP.Primary.Ammo          = "357"

SWEP.ViewModel = "models/weapons/tfa_cso/c_elven_ranger.mdl"
SWEP.ViewModelFOV = 90
SWEP.ViewModelFlip = true
SWEP.UseHands = true

SWEP.WorldModel = "models/weapons/tfa_cso/w_elven_ranger.mdl"

SWEP.HoldType 				= "ar2"
SWEP.Offset = {
	Pos = {
		Up = -6,
		Right = 1,
		Forward = 11.5,
	},
	Ang = {
		Up = 90,
		Right = 0,
		Forward = 190
	},
	Scale = 1.25
}

SWEP.HasScope = true
SWEP.Secondary.ScopeTable = {
	["ScopeMaterial"] =  Material("scope/elven_ranger/elven_ranger_scope.png", "smooth"),
	["ScopeBorder"] = Color(0,0,0,255),
	["ScopeCrosshair"] = { ["r"] = 0, ["g"]  = 0, ["b"] = 0, ["a"] = 255, ["s"] = 0 }
}

SWEP.IronSightsPos = Vector(5.84, 0, 2)
SWEP.IronSightsAng = Vector(0, 0, 0)

SWEP.Tracer				= 0
SWEP.TracerName 		= "cso_tra_elv_rng"

SWEP.Ironsights = {
	Pos = Vector(0, 0, -10),
	Angle = Vector(0, 0, 0),
	TimeTo = 0.1,
	TimeFrom = 0.1,
	SlowDown = 0.3,
	Zoom = 0.35,
}

SWEP.RecoilInstructions = {
	Interval = 1,
	Angle(-200),
}
SWEP.Primary.RecoilTiming  = 0.09

function SWEP:GetReloadDuration(speed)
	return 2 / speed + 0.1
end

function SWEP:DoFireBullets()
	self:PenetrateBullet(self:GetOwner():GetAimVector(), self:GetOwner():GetShootPos(), 8192, 4, self:GetDamage(),
		0.99, 50, 8000)
end

-- TODO: Make this not do this????
local PenetrationValues = {}

local function set(values, ...)
	for i = 1, select("#", ...) do
		PenetrationValues[select(i, ...)] = values
	end
end
-- flPenetrationModifier, flDamageModifier
-- flDamageModifier should always be less than flPenetrationModifier
set({0.3, 0.1},  MAT_CONCRETE, MAT_METAL)
set({0.8, 0.7},  MAT_FOLIAGE, MAT_SAND, MAT_GRASS, MAT_DIRT, MAT_FLESH, MAT_GLASS, MAT_COMPUTER, MAT_TILE, MAT_WOOD, MAT_PLASTIC, MAT_SLOSH, MAT_SNOW)
set({0.5, 0.45}, MAT_FLESH, MAT_ALIENFLESH, MAT_ANTLION, MAT_BLOODYFLESH, MAT_SLOSH, MAT_CLIP)
set({1, 0.99},   MAT_GRATE)
set({0.5, 0.45}, MAT_DEFAULT)
function SWEP:TraceToExit(start, dir, endpos, stepsize, maxdistance)

	local flDistance = 0
	local last = start

	while (flDistance < maxdistance) do
		flDistance = flDistance + stepsize

		endpos:Set(start + flDistance *dir)

		if bit.band(util.PointContents(endpos), MASK_SOLID) == 0 then
			return true, endpos
		end
	end

	return false

end
function SWEP:ImpactTrace(tr)
	local e = EffectData()
	e:SetOrigin(tr.HitPos)
	e:SetStart(tr.StartPos)
	e:SetSurfaceProp(tr.SurfaceProps)
	e:SetDamageType(DMG_BULLET)
	e:SetHitBox(0)
	if CLIENT then
		e:SetEntity(game.GetWorld())
	else
		e:SetEntIndex(0)
	end
	util.Effect("Impact", e)
end

DEFINE_BASECLASS(SWEP.Base)
function SWEP:PenetrateBullet(dir, vecStart, flDistance, iPenetration, iDamage,
	flRangeModifier, fPenetrationPower, flPenetrationDistance, flCurrentDistance, alreadyHit)
	alreadyHit = alreadyHit or {}
	flCurrentDistance = flCurrentDistance or 0
	self:SetBulletsShot(self:GetBulletsShot() + 1)

	self:FireBullets {
		AmmoType = self.Primary.Ammo,
		Distance = flDistance,
		Tracer = 1,
		Attacker = self:GetOwner(),
		Damage = iDamage,
		Src = vecStart,
		Dir = dir,
		Spread = vector_origin,
		Num = 1,
		IgnoreEntity = lasthit,
		Callback = function( hitent , trace , dmginfo )
			--TODO: penetration
			--unfortunately this can't be done with a static function or we'd need to set global variables for range and shit

			if flRangeModifier then
				--Jvs: the damage modifier valve actually uses
				local flCurrentDistance = trace.Fraction * flDistance
				dmginfo:SetDamage( dmginfo:GetDamage() * math.pow( flRangeModifier, ( flCurrentDistance / 500 ) ) )
			end

			if (alreadyHit[trace.Entity]) then
				dmginfo:SetDamage(0)
			end
			alreadyHit[trace.Entity] = true

			if (IsValid(self)) then
				self:FireBulletsCallback(trace, dmginfo)
			end

			if (trace.Fraction == 1) then
				return
			end
			-- TODO: convert this to physprops? there doesn't seem to be a way to get penetration from those

			local flPenetrationModifier, flDamageModifier = unpack(PenetrationValues[trace.MatType] or PenetrationValues[MAT_DEFAULT])

			flCurrentDistance = flCurrentDistance + trace.Fraction * (trace.HitPos - vecStart):Length()
			iDamage = iDamage * flRangeModifier ^ (flCurrentDistance / 500)

			if (flCurrentDistance > flPenetrationDistance && iPenetration > 0) then
				iPenetration = 0;
			end

			if iPenetration == 0 and not trace.MatType == MAT_GRATE then
				return
			end

			if iPenetration < 0 then
				return
			end

			local penetrationEnd = Vector()

			if not self:TraceToExit(trace.HitPos, dir, penetrationEnd, 24, 128) then
				return
			end

			local tr = util.TraceLine{
				start = penetrationEnd + trace.Normal * 2,
				endpos = trace.HitPos,
				mask = MASK_SHOT,
				collisiongroup = COLLISION_GROUP_NONE,
			}

			bHitGrate = tr.MatType == MAT_GRATE and bHitGrate

			local iExitMaterial = tr.MatType

			if (iExitMaterial == trace.MatType) then
				if (iExitMaterial == MAT_WOOD or iExitMaterial == MAT_METAL) then
					flPenetrationModifier = flPenetrationModifier * 2
				end
			end

			local flTraceDistance = tr.HitPos:Distance(trace.HitPos)

			if (flTraceDistance > (fPenetrationPower * flPenetrationModifier)) then
				return
			end
			self:ImpactTrace(tr)
			fPenetrationPower = fPenetrationPower - flTraceDistance / flPenetrationModifier
			flCurrentDistance = flCurrentDistance + flTraceDistance

			vecStart = tr.HitPos
			flDistance = (flDistance - flCurrentDistance) * .5

			iDamage = iDamage * flDamageModifier

			iPenetration = iPenetration - 1

			self:PenetrateBullet(dir, vecStart, flDistance, iPenetration, iDamage, flRangeModifier, fPenetrationPower, flPenetrationDistance, flCurrentDistance, alreadyHit)
		end
	}
end