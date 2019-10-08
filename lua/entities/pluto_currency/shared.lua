AddCSLuaFile()
ENT.Base = "ttt_point_info"
ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "Icon")
end

function ENT:Initialize()
	self.Size = 20
	local maxs = Vector(self.Size / 2, self.Size / 2, self.Size / 2)
	self:SetCollisionBounds(-maxs, maxs)
	if (SERVER) then
		self:SV_Initialize()
	end

	self.random = math.random()
end