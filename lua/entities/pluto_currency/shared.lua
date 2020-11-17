AddCSLuaFile()
ENT.Base = "ttt_point_info"
ENT.Type = "point"
ENT.RenderGroup = RENDERGROUP_OPAQUE

if (CLIENT) then
	pluto_currencies = pluto_currencies or setmetatable({}, {__mode = "v"})
end

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "Icon")
end

function ENT:Initialize()
	self.Size = 20
	if (SERVER) then
		self:SV_Initialize()
	end

	self:SetMoveType(MOVETYPE_NONE)
	self:SetCollisionGroup(COLLISION_GROUP_NONE)

	if (CLIENT) then
		table.insert(pluto_currencies, self)
	end
end

hook.Add("SetupPlayerNetworking", "pluto_currency", function(ply)
	ply:NetworkVar("CurrencyTime", "Float")
	ply:NetworkVar("CurrencyDistance", "Float")
end)