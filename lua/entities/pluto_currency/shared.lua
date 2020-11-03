AddCSLuaFile()
ENT.Base = "ttt_point_info"
ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_OPAQUE

if (CLIENT) then
	pluto_currencies = pluto_currencies or setmetatable({}, {__mode = "v"})
end

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "Icon")
end

function ENT:Initialize()
	self:SetModel "models/hunter/misc/sphere025x025.mdl"
	self.Size = 20
	local maxs = Vector(self.Size / 2, self.Size / 2, self.Size / 2)
	self:SetCollisionBounds(-maxs, maxs)
	if (SERVER) then
		self:SV_Initialize()
	end

	self.random = math.random()
	hook.Add("ShouldCollide", self, self.ShouldCollide)
	self:CollisionRulesChanged()

	self:SetMoveType(MOVETYPE_NONE)

	if (CLIENT) then
		table.insert(pluto_currencies, self)
	end
end

function ENT:ShouldCollide(e1, e2)
	if (e1 ~= self and e2 ~= self) then
		return
	end

	local other = e1 == self and e2 or e1

	return other == self:GetOwner()
end

hook.Add("SetupPlayerNetworking", "pluto_currency", function(ply)
	ply:NetworkVar("CurrencyTime", "Float")
	ply:NetworkVar("CurrencyDistance", "Float")
end)