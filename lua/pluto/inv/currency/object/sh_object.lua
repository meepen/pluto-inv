pluto.currency.object_mt = pluto.currency.object_mt or {
	__index = {}
}
pluto.currency.object_list = pluto.currency.object_list or {}

local CURRENCY = pluto.currency.object_mt.__index

AccessorFunc(CURRENCY, "ID", "ID", FORCE_NUMBER)
AccessorFunc(CURRENCY, "NetworkedPosition", "NetworkedPosition")
AccessorFunc(CURRENCY, "NetworkedPositionTime", "NetworkedPositionTime")
AccessorFunc(CURRENCY, "MovementType", "MovementType", FORCE_NUMBER)
AccessorFunc(CURRENCY, "Currency", "CurrencyType", FORCE_STRING)
AccessorFunc(CURRENCY, "Size", "Size", FORCE_NUMBER)
AccessorFunc(CURRENCY, "ShouldSeeThroughWalls", "ShouldSeeThroughWalls", FORCE_BOOLEAN)

function CURRENCY:IsValid()
	return pluto.currency.object_list[self:GetID()]
end

function CURRENCY:BoundsWithin(e)
	local ourpos = self:GetPos() - vector_up * self.Size
	local epos, emins, emaxs = e:GetPos(), e:GetCollisionBounds()
	emins = emins - Vector(self.Size, self.Size, self.Size)
	emaxs = emaxs + Vector(self.Size, self.Size, self.Size)
	
	local diff = ourpos - epos
	return diff:WithinAABox(emins, emaxs)
end

CURRENCY_MOVESTILL = 0
CURRENCY_MOVEDOWN = 1
CURRENCY_MOVEMAX = 16

local movements = {
	[CURRENCY_MOVESTILL] = function(self) return self:GetNetworkedPosition() end,
	[CURRENCY_MOVEDOWN] = function(self)
		return self:GetNetworkedPosition() - vector_up * 80 * (CurTime() - self:GetNetworkedPositionTime())
	end,
}

function CURRENCY:GetPos()
	local movement = movements[self:GetMovementType()] or movements[CURRENCY_MOVESTILL]
	return movement(self)
end

function CURRENCY:SetPos(pos)
	self:SetNetworkedPosition(pos)
	self:SetNetworkedPositionTime(CurTime())
end

function CURRENCY:GetIcon()
	return pluto.currency.byname[self:GetCurrencyType()].Icon
end

hook.Add("SetupPlayerNetworking", "pluto_currency", function(ply)
	ply:NetworkVar("CurrencyTime", "Float")
	ply:NetworkVar("CurrencyDistance", "Float")
end)
