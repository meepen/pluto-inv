AddCSLuaFile()
ENT.Base = "pluto_currency"
DEFINE_BASECLASS(ENT.Base)

function ENT:Think()
	self:SetPos(self:GetPos() - vector_up * FrameTime() * 80)
	if (SERVER and self:GetPos().z < -1000) then
		self:Remove()
	end
	return BaseClass.Think(self)
end
