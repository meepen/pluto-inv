local COSMETIC = pluto.cosmetics.byname "base"
COSMETIC.Model = "models/balloons/balloon_star.mdl"
COSMETIC.MountData = {
	Type = "bone",
	Bone = "ValveBiped.Bip01_Head1"
}
COSMETIC.Scale = 0.15
COSMETIC.Offset = Vector(-2, 0, -1.3)
COSMETIC.Angle = Angle(0, 0, 0)

function COSMETIC:ValidForModel(ent)
	if (self.MountData) then
		local mount = self.MountData
		if (mount.Type == "bone") then
			local bone = ent:LookupBone(mount.Bone)
			if (not bone) then
				return false
			end
		else -- TODO(meep): attachments?
			return false
		end
	end

	return true
end

function COSMETIC:Init(ent)
	if (not self:ValidForModel(ent)) then
		return true
	end

	self.Parent = ent
	self.ModelInstance = ClientsideModel(self.Model)
	self.ModelInstance:CallOnRemove(tostring(self.ModelInstance), function()
		if (IsValid(self.ModelInstance)) then
			self.ModelInstance:Remove()
		end
	end)
	self.ModelInstance:SetModelScale(self.Scale, 0)
	if (self.Material) then
		self.ModelInstance:SetMaterial(self.Material)
	end
	self.rand = math.random()

	self:OnParentChanged()
end

function COSMETIC:OnParentChanged()
	if (self.MountData) then
		local mount = self.MountData
		if (mount.Type == "bone") then
			local bone = self.Parent:LookupBone(mount.Bone)
			if (not bone) then
				return false -- wtf
			end

			self.BoneID = bone
		else
		end
	end
end

function COSMETIC:GetMountPosition()
	if (self.MountData.Type == "bone") then
		return self.Parent:GetBonePosition(self.BoneID)
	end
end

function COSMETIC:OnRenderStateChanged(on)
	self.ModelInstance:SetNoDraw(not on)
end

function COSMETIC:Remove()
	if (IsValid(self.ModelInstance)) then
		self.ModelInstance:Remove()
	end

	return true
end

function COSMETIC:GetPosition(pos, ang)
	return pos, ang
end

function COSMETIC:GetOffset()
	local offset = self.Offset * 1
	local set = self.Parent:GetHitboxSet()
	for hitbox = 0, self.Parent:GetHitBoxCount(set) - 1 do
		local bone = self.Parent:GetHitBoxBone(hitbox, set)
		if (bone == self.BoneID) then
			local mins, maxs = self.Parent:GetHitBoxBounds(hitbox, set)
			local what = "x"
			offset[what] = offset[what] - mins[what] + maxs[what]
			break
		end
	end
	return offset
end

function COSMETIC:Think()
	local pos, ang = self:GetPosition(self:GetMountPosition())

	local bpos, bang = LocalToWorld(self:GetOffset(), self.Angle, pos, ang)

	self.ModelInstance:SetAngles(bang)
	self.ModelInstance:SetPos(bpos)
end