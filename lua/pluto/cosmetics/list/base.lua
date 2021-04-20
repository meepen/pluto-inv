local COSMETIC = pluto.cosmetics.byname "base"
COSMETIC.Model = "models/balloons/balloon_star.mdl"
COSMETIC.MountData = {
	Type = "bone",
	Bone = "ValveBiped.Bip01_Head1"
}

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
	self.ModelInstance:SetModelScale(0.15, 0)
	self.ModelInstance:SetMaterial "models/player/shared/gold_player"
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

function COSMETIC:Think()
	local rotate_time = 3
	local rotate_time2 = 4
	local time = CurTime() + self.rand
	local ang = Angle((time % rotate_time) / rotate_time * 360, (time % rotate_time2) / rotate_time2 * 360)
	self.ModelInstance:SetAngles(ang)

	local center_offset = Vector(0, 0, 1)
	center_offset:Rotate(ang)
	local offset = Vector(0, 8, 4)

	local bpos = self:GetMountPosition()
	local base = LocalToWorld(offset, angle_zero, bpos, self.Parent:EyeAngles())

	self.ModelInstance:SetPos(base - center_offset)
end