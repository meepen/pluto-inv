MOD.Type = "suffix"
MOD.Name = "The Eagle"
MOD.Color = Color(211, 180, 3)
MOD.Tags = {
	"vision",
}

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:CanRollOn(class)
	return not not class.Ironsights
end

function MOD:FormatModifier(index, roll)
	return string.format("%.01f", roll)
end

MOD.Description = "Shows everything within %s meters after aiming down sights for 2 seconds. Each penetration point removes 0.1 meters."

MOD.Tiers = {
	{ 15, 20 },
	{ 10, 15 },
	{ 5, 10 },
}

function MOD:ModifyWeapon(wep, rolls)
	local old = wep.GetSlowdown
	function wep:GetSlowdown()
		local m
		if (old) then
			m = old(self)
		else
			m = 1
		end

		return m * (self:GetIronsights() and 0.4 or 1)
	end

	if (not CLIENT) then
		return
	end

	local dist = rolls[1] * 39.37

	local ang = math.cos(math.rad(15))
	hook.Add("PostDrawOpaqueRenderables", wep, function(self)
		local dist = dist - self:GetPenetration() * 0.1 * 39.37
		if (not self:GetIronsights() or self:GetIronsightsTime() + 2 > CurTime()) then
			return
		end

		local owner = self:GetOwner()
		if (ttt.GetHUDTarget() ~= owner) then
			return
		end

		if (owner:GetActiveWeapon() ~= self) then
			return
		end

		local es = ents.FindInCone(owner:GetShootPos(), owner:GetAimVector(), dist, ang)

		for i = #es, 1, -1 do
			local e = es[i]
			if (not e:IsPlayer() or not e:Alive()) then
				table.remove(es, i)
				continue
			end
		end
	
		render.SetStencilEnable(true)
		render.ClearStencil()
		render.SuppressEngineLighting(true)
		render.OverrideColorWriteEnable(true, false)
		render.SetBlend(2 / 255)
	
	
		-- first pass: mark pixels
		render.SetStencilWriteMask(0xff)
		render.SetStencilTestMask(0xff)
		render.SetStencilReferenceValue(0)
		render.SetStencilCompareFunction(STENCIL_EQUAL)
		render.SetStencilPassOperation(STENCIL_INVERT)
		render.SetStencilFailOperation(STENCIL_KEEP)
		render.SetStencilZFailOperation(STENCIL_KEEP)
	
		for _, ent in pairs(es) do
			ent:DrawModel()
		end
	
		-- second pass: z check
	
		
		render.SetStencilPassOperation(STENCIL_KEEP)
		render.SetStencilFailOperation(STENCIL_KEEP)
		render.SetStencilZFailOperation(STENCIL_INCR)
		for _, ent in pairs(es) do
			ent:DrawModel()
		end
	
		render.OverrideColorWriteEnable(false)
		render.SetBlend(1)
	
		-- second pass: draw pixels
		render.SetStencilReferenceValue(1)
		render.SetStencilCompareFunction(STENCIL_EQUAL)
		render.SetStencilPassOperation(STENCIL_KEEP)
		render.SetStencilFailOperation(STENCIL_KEEP)
		render.SetStencilZFailOperation(STENCIL_KEEP)
	
		render.SetColorMaterial()
	
		render.DrawScreenQuad()
	
		render.SetStencilEnable(false)
		render.SuppressEngineLighting(false)
	end)
end

return MOD