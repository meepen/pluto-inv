local CURRENCY = pluto.currency.object_mt.__index
local error_mat = Material "error"

net.Receive("pluto_currency", function()
	local pitch = 128
	sound.Play("garrysmod/balloon_pop_cute.wav", net.ReadVector(), 75, math.random(pitch - 10, pitch + 10), 1)
end)

function CURRENCY:GetMaterial()
	local obj = pluto.currency.byname[self:GetCurrencyType()]
	if (not obj) then
		return error_mat
	end

	if (not obj.Material) then
		obj.Material = Material(self:GetIcon(), "noclamp")
	end

	return obj.Material
end

function pluto.inv.readcurrencyspawn()
	local id = net.ReadUInt(32)

	if (net.ReadBool()) then -- delete
		pluto.currency.object_list[id] = nil
		return
	end

	local cur = pluto.currency.object_list[id]
	if (not cur) then
		cur = setmetatable({}, pluto.currency.object_mt)
		pluto.currency.object_list[id] = cur
	end

	cur:SetID(id)

	cur:SetNetworkedPosition(net.ReadVector())
	cur:SetNetworkedPositionTime(net.ReadFloat())
	cur:SetMovementType(net.ReadUInt(4))
	cur:SetMovementVector(net.ReadVector())
	cur:SetSize(net.ReadFloat())
	cur:SetCurrencyType(net.ReadString())
end

local function getlist()
	local t = {}
	local n = 1
	local lpos = LocalPlayer():GetPos()
	for _, obj in pairs(pluto.currency.object_list) do
		obj.CurrentDistance = obj:GetPos():Distance(lpos)
		t[n] = obj
		n = n + 1
	end

	table.sort(t, function(a, b)
		return a.CurrentDistance > b.CurrentDistance
	end)

	return t
end

hook.Add("PostDrawTranslucentRenderables", "pluto_new_currency_render", function()
	local wait = 1.5
	local timing = 1 - ((wait + CurTime()) % wait) / wait * 2
	local up_offset = vector_up * (math.sin(timing * math.pi) + 1) / 2 * 15 * 0.25

	local dist = math.min(16000, LocalPlayer():GetCurrencyDistance())

	for _, self in pairs(getlist()) do
		cam.IgnoreZ(LocalPlayer():GetCurrencyTime() > CurTime() and dist > self:GetPos():Distance(LocalPlayer():GetPos()))

		render.SetMaterial(self:GetMaterial())
		local pos = self:GetPos()
		
		pos = pos + up_offset
		local size = self:GetSize()

		render.DrawSprite(pos, size, size, color_white)
	end
	cam.IgnoreZ(false)
end)