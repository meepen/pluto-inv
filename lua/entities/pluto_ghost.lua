AddCSLuaFile()

ENT.Base = "base_nextbot"
ENT.Spawnable = true

local size = 10
local maxs = Vector(size, size, size)
local mins = -maxs

function ENT:Initialize()
	self:SetModel "models/custom_prop/plutogg/ghost/ghost.mdl"
	self:PhysicsInitBox(mins, maxs)
	self:SetSpeed(300)
end

function ENT:SetupDataTables()
	self:NetworkVar("Float", 0, "Speed")
	self:NetworkVar("Float", 1, "Start")
	self:NetworkVar("Vector", 0, "NextPos")
	self:NetworkVar("Vector", 1, "LastPos")
end

function ENT:RunBehaviour()
	while (true) do
		local pos
		while not pos do
			for i = 1, 100 do
				pos = pluto.currency.randompos()
				local mins, maxs = vector_origin, vector_origin
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
			coroutine.wait(0.1)
		end

		self.NextPos = pos
		self:SetStart(CurTime())
		self:SetLastPos(self:GetPos())
		self:SetNextPos(pos)
		
		while ((CurTime() - self:GetStart()) / (self:GetLastPos():Distance(self:GetNextPos()) / self:GetSpeed()) < 1) do
			coroutine.yield()
		end

		coroutine.yield()
	end
end

function ENT:AdvancePos(pos)
	pos = pos + vector_up * size / 2 + vector_up * size * math.sin(CurTime() * 5) / 2
	pos = pos + (self:GetNextPos() - self:GetLastPos()):Angle():Right() * -size * math.sin(CurTime() * 3.5) / 2
	if (SERVER) then
		self:SetPos(pos)
	else
		self:SetRenderOrigin(pos)
	end
end

function ENT:Think()
	local first, next = self:GetLastPos(), self:GetNextPos()
	local frac = (CurTime() - self:GetStart()) / (first:Distance(next) / self:GetSpeed())

	frac = math.Clamp(frac, 0, 1)

	self:AdvancePos(first + (next - first) * frac)
end
