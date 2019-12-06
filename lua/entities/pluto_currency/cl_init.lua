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

function ENT:DrawTranslucent()
	render.SetMaterial(self:GetImage())
	local pos = self:GetPos()
	local size = self.Size * 0.75

	local wait = 1.5
	local timing = 1 - (((wait * self.random) + CurTime()) % wait) / wait * 2
	
	pos = pos + vector_up * (math.sin(timing * math.pi) + 1) / 2 * self.Size * 0.25

	render.DrawSprite(pos, size, size, color_white)
end
