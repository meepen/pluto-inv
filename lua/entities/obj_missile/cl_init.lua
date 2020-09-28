include('shared.lua')

language.Add("obj_missile", "Missile")
function ENT:Draw()
	self:DrawModel()
end
 
function ENT:OnRemove()
end
 
function ENT:Think()
end