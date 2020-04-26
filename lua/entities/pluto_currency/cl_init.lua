include "shared.lua"

net.Receive("pluto_currency", function()
	local pitch = 128
	sound.Play("garrysmod/balloon_pop_cute.wav", net.ReadVector(), 75, math.random(pitch - 10, pitch + 10), 1)
end)

function ENT:GetImage()
	if (not self.Material or self.MaterialStr ~= self:GetIcon()) then
		self.Material = Material(self:GetIcon(), "noclamp")
		self.MaterialStr = self:GetIcon()
	end

	return self.Material
end

function ENT:PostDrawTranslucentRenderables()
	if (self:IsDormant()) then
		return
	end

	local throughwalls = self:ShouldSeeThroughWalls()
	if (throughwalls) then
		cam.IgnoreZ(true)
	end
	
	render.SetMaterial(self:GetImage())
	local pos = self:GetPos()
	local size = self.Size * 0.75

	local wait = 1.5
	local timing = 1 - (((wait * self.random) + CurTime()) % wait) / wait * 2
	
	pos = pos + vector_up * (math.sin(timing * math.pi) + 1) / 2 * self.Size * 0.25

	render.DrawSprite(pos, size, size, color_white)

	if (throughwalls) then
		cam.IgnoreZ(false)
	end
end

function ENT:ShouldSeeThroughWalls()
	local dist = math.min(16000, LocalPlayer():GetCurrencyDistance())
	return LocalPlayer():GetCurrencyTime() > CurTime() and dist > self:GetPos():Distance(LocalPlayer():GetPos())
end

function ENT:Think()
	local was = self.ThroughWalls
	self.ThroughWalls = self:ShouldSeeThroughWalls()
	if (self.ThroughWalls) then
		self:SetRenderBounds(Vector(1, 1, 1), Vector(1, 1, 1), Vector(dist, dist, dist))
	elseif (was) then
		self:SetRenderBounds(Vector(1, 1, 1), Vector(1, 1, 1), Vector(1, 1, 1))
	end
end