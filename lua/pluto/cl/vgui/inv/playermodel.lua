--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]

local PANEL = {}

function PANEL:SetPlutoModel(m, i)
	self:RemoveWeapon()
	self:SetModel(m.Model)

	pluto.updatemodel(self:GetEntity(), i)

	if (self.WeaponItem) then
		self:SetPlutoWeapon(self.WeaponItem)
	end
end

function PANEL:SetStance(s)
	local seq = self:GetEntity():LookupSequence(s)
	if (seq == -1) then
		return false
	end

	self:GetEntity():ResetSequence(seq)

	self.Stance = s

	return true
end

function PANEL:SetPlutoWeapon(item)
	if (IsValid(self.Weapon)) then
		self.Weapon:Remove()
	end

	if (not item or item.Type ~= "Weapon") then
		self:SetStance "idle_all_01"
		return
	end

	local stored = baseclass.Get(item.ClassName)

	if (not stored) then
		return
	end

	self.WeaponItem = item

	local set = self:SetStance("idle_" .. stored.HoldType)

	if (not set) then
		self:SetStance "idle_passive"
	end

	self.Weapon = ClientsideModel(stored.WorldModel, stored.RenderGroup)
	if (IsValid(self.Weapon)) then
		self.Weapon:SetNoDraw(true)
		self.Weapon:SetParent(self:GetEntity())
		self.Weapon:AddEffects(EF_BONEMERGE + EF_BONEMERGE_FASTCULL)
		table.Merge(self.Weapon, stored)
		self.Weapon.RenderOverride = self.Weapon.DrawWorldModel
	end
end

function PANEL:PreDrawModel()
	if (IsValid(self.Weapon)) then
		self.Weapon:DrawModel()
	end

	return true
end

function PANEL:LayoutEntity(e)
	if (self.bAnimated) then
		self:RunAnimation()
	end

	if (self.OverrideRotate) then
		local now_x = input.GetCursorPos()
		local last_x = self.LastX or now_x

		e:SetAngles(e:GetAngles() - Angle(0, .3) * (last_x - now_x))

		self.LastX = now_x
	elseif (not self.StopRotate) then
		e:SetAngles(e:GetAngles() - Angle(0, -30) * FrameTime())
	end
end

function PANEL:DragMousePress(mcode)
	if (mcode == MOUSE_RIGHT) then
		self.StopRotate = not self.StopRotate
	elseif (mcode == MOUSE_LEFT) then
		self.OverrideRotate = true
	end
end

function PANEL:DragMouseRelease()
	if (self.OverrideRotate) then
		self.OverrideRotate = false
		self.LastX = nil
	end
end

function PANEL:RemoveWeapon()
	if (IsValid(self.Weapon)) then
		self.Weapon:Remove()
	end
end

DEFINE_BASECLASS "DModelPanel"
function PANEL:OnRemove()
	self:RemoveWeapon()
	BaseClass.OnRemove(self)
end

vgui.Register("pluto_inventory_playermodel", PANEL, "DModelPanel")