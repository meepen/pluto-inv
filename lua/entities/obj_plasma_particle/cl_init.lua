include('shared.lua')

language.Add("obj_plasma_particle", "Plasma")
function ENT:Draw()
end

local mat = Material("effects/plasma_particle")
ENT.nextBlend = 0
ENT.flBlend = 1
function ENT:Initialize()
	local lifeTime = 0.5
	local deathDelay = CurTime() +lifeTime
	local iIndex = self:EntIndex()
	hook.Add("RenderScreenspaceEffects", "Effect_PlasmaParticleOverlay" .. iIndex, function()
		if !IsValid(self) then
			hook.Remove("RenderScreenspaceEffects", "Effect_PlasmaParticleOverlay" .. iIndex)
			return
		end
		local ent = self:GetNetworkedEntity("hitent")
		if !IsValid(ent) then return end
		cam.Start3D(EyePos(), EyeAngles())
			if util.IsValidModel(ent:GetModel()) then
				render.SetBlend(self.flBlend)
				render.MaterialOverride(mat)
					ent:DrawModel()
				render.MaterialOverride(0)
				render.SetBlend(1)
			end
			if ent:IsPlayer() && ent:GetViewModel() != nil && IsValid(ent:GetViewModel()) then
				if util.IsValidModel(ent:GetViewModel():GetModel()) then
					render.SetBlend(self.flBlend)
					render.MaterialOverride(mat)
					ent:GetViewModel():DrawModel()
					render.MaterialOverride(0)
					render.SetBlend(1)
				end
			end
		cam.End3D()
		if CurTime() >= self.nextBlend then
			self.nextBlend = CurTime() +0.05
			if self.flBlend > 0 then
				local flBlendAdd = 0.05
				if CurTime() >= deathDelay then
					flBlendAdd = flBlendAdd +math.Clamp(((CurTime() -deathDelay) /100), 0, 0.05)
				end
				self.flBlend = self.flBlend -(lifeTime /(lifeTime ^2)) *flBlendAdd
			end
		end
	end)
end