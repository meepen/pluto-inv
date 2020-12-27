AddCSLuaFile()

ENT.PrintName = "Map Blocker"

ENT.Type = "anim"

function ENT:SetupDataTables()
	self:NetworkVar("Vector", 0, "Mins")
	self:NetworkVar("Vector", 1, "Maxs")
end

function ENT:Initialize()
    self:AddEFlags(EFL_FORCE_CHECK_TRANSMIT)
	self:SetCollisionBounds(self:GetMins(), self:GetMaxs())

    if (SERVER) then
        self:PhysicsInitBox(self:GetMins(), self:GetMaxs())
        self:SetSolid(SOLID_VPHYSICS)
        self:PhysWake()
	else
        self:SetRenderBounds(self:GetMins(), self:GetMaxs())
    end

	self:CollisionRulesChanged()

    self:EnableCustomCollisions(true)
	self:DrawShadow(false)

	local p = self:GetPhysicsObject()
	if (IsValid(p)) then
		p:EnableMotion(false)
	end

	self.Collider = CreatePhysCollideBox(self:GetMins(), self:GetMaxs())
end

function ENT:TestCollision(spos, delta, isbox, extents, mask)
	if (not IsValid(self.Collider)) then
		return
	end

    local max = extents
    local min = -extents
    max.z = max.z - min.z
	min.z = 0

	local hit, norm, frac = self.Collider:TraceBox(vector_origin, angle_zero, spos, spos + delta, min, max)

	if (hit) then
		return {
			HitPos = hit,
			Normal = norm,
			Fraction = frac
		}
	end
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end

function ENT:Draw()
	if (GetConVar "developer":GetInt() > 0) then
		render.DrawWireframeBox(vector_origin, self:GetAngles(), self:GetMins(), self:GetMaxs(), Color(255, 0, 0), true)
	end
end

hook.Add("TTTAddPermanentEntities", "pluto_block", function(list)
	table.insert(list, "pluto_block")
end)