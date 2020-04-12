-- 'Borrowed' from Zombie Survival's tracer_cosmos effect
-- https://github.com/JetBoom/zombiesurvival/blob/master/gamemodes/zombiesurvival/entities/effects/tracer_cosmos.lua
-- Partially based on the Railgun from AS:S, and the Gluon

EFFECT.LifeTime = 1

function EFFECT:GetDelta()
	return math.Clamp(self.DieTime - CurTime(), 0, self.LifeTime) / self.LifeTime
end

function EFFECT:Init(data)
	self.StartPos = self:GetTracerShootPos(data:GetStart(), data:GetEntity(), data:GetAttachment())
	self.EndPos = data:GetOrigin()
	self.HitNormal = data:GetNormal() * -1
	self.Color = Color(255,255,0)
	self.DieTime = CurTime() + self.LifeTime

	local emitter = ParticleEmitter(self.EndPos)
	emitter:SetNearClip(24, 32)

	local r, g, b = self.Color.r, self.Color.g, self.Color.b
	local randmin, randmax = -40, 40
	local normal = (self.EndPos - self.StartPos)
	normal:Normalize()
	for i = -100, self.EndPos:Distance(self.StartPos), 20 do
		local pos = self.StartPos + normal * i + VectorRand():GetNormalized() * math.Rand(randmin, randmax)
		local dietime = math.Rand(1, 2)
		local startsize = 1 + math.Rand(0.5, 1.5) * 2
		local rolldelta = math.Rand(-16, 16)
		local roll = math.Rand(0, 360)
		local vel = math.Rand(192, 256) * normal
	end

	self.QuadPos = self.EndPos + self.HitNormal

	emitter:Finish()
end

function EFFECT:Think()
	return CurTime() < self.DieTime
end

local matBeam2 = Material("trails/smoke")
local matGlow = Material("effects/select_ring")
local matFlare = Material("sprites/glow04_noz")
function EFFECT:Render()
	local delta = self:GetDelta()
	if delta <= 0 then return end
	self.Color.a = delta * 155

	local startpos = self.StartPos
	local endpos = self.QuadPos

	local size = delta * 35
	render.SetMaterial(matBeam2)
	render.DrawBeam(startpos, endpos, size * 0.35, 1, 0, self.Color)
	--render.DrawBeam(startpos, endpos, size, 1, 0, self.Color)

end
