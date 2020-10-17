AddCSLuaFile()

ENT.Base = "base_anim"
ENT.Spawnable = true

local size = 15
local maxs = Vector(size, size, size)

function ENT:Initialize()
	self:SetModel "models/custom_prop/plutogg/ghost/ghost.mdl"
	self:PhysicsInitBox(-maxs, maxs)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSpeed(200)
	self:SetHealth(1)

	self:SetNextPos(self:GetPos())
	self:SetLastPos(self:GetPos())

	if (SERVER) then
		self:SetLagCompensated(true)
	end
end

function ENT:SetupDataTables()
	self:NetworkVar("Float", 0, "Speed")
	self:NetworkVar("Float", 1, "Start")
	self:NetworkVar("Vector", 0, "NextPos")
	self:NetworkVar("Vector", 1, "LastPos")
end

function ENT:OnTakeDamage(dmg)
	if (SERVER and pluto.ghost_killed(self, dmg)) then
		self:Remove()
	end
end

function ENT:GetPosition()
	local first, next = self:GetLastPos(), self:GetNextPos()
	local frac = (CurTime() - self:GetStart()) / (first:Distance(next) / self:GetSpeed())

	frac = math.Clamp(frac, 0, 1)

	local pos = first + (next - first) * frac

	pos = pos + vector_up * size / 2 + vector_up * size * math.sin(CurTime() * 5) / 2
	pos = pos + (self:GetNextPos() - self:GetLastPos()):Angle():Right() * -size * math.sin(CurTime() * 3.5) / 2

	local ang = (self:GetLastPos() - self:GetNextPos()):Angle()
	ang.p = 0

	return pos, ang
end

if (CLIENT) then
	return
end

function ENT:Think()
	if (SERVER and (CurTime() - self:GetStart()) / (self:GetLastPos():Distance(self:GetNextPos()) / self:GetSpeed()) >= 1) then
		local pos = self:GetNextPos()
		for _, nav in RandomPairs(navmesh.GetAllNavAreas()) do
			if (nav:Contains(pos)) then
				local next = table.Random(nav:GetAdjacentAreas())

				if (not next) then
					next = nav
				end

				for i = 1, 100 do
					pos = next:GetRandomPoint()
					local mins, maxs = Vector(0.01, 0.01, 0.01), Vector(0.01, 0.01, 0.01)
					if (not util.TraceHull {
						start = pos,
						endpos = pos,
						mins = mins,
						maxs = maxs,
						collisiongroup = COLLISION_GROUP_PLAYER,
						mask = MASK_PLAYERSOLID,
					}.StartSolid) then
						break
					end
				end
			end
		end

		self:SetStart(CurTime())
		self:SetLastPos(self:GetNextPos())
		self:SetNextPos(pos)
	end

	local pos, ang = self:GetPosition()
	self:SetPos(pos + vector_up * 20)
	self:SetAngles(ang)

	self:NextThink(CurTime())
	return true
end