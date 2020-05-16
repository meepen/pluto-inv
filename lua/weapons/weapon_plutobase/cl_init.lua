include "shared.lua"

net.Receive("pluto_wpn_db", function(len)
	local ent = net.ReadInt(32)

	local PlutoData = {
		Type = "Weapon",
	}

	if (net.ReadBool()) then
		PlutoData.ID = net.ReadUInt(32)
	end

	pluto.inv.readbaseitem(PlutoData)

	pluto.wpn_db[ent] = PlutoData

	for _, e in pairs(ents.GetAll()) do
		if (e.GetPlutoID and e:GetPlutoID() == ent) then
			e:ReceivePlutoData()
			break
		end
	end
end)

hook.Add("TTTPrepareRound", "pluto_wpn_db", function()
	pluto.wpn_db = {}
end)


DEFINE_BASECLASS "weapon_tttbase_old"

function SWEP:GetPlutoPrintName()
	local item = self:GetInventoryItem()
	if (item) then
		return item.PrintName
	end
end

function SWEP:Initialize()
	BaseClass.Initialize(self)
	self:PlutoInitialize()

	local data = pluto.wpn_db[self:GetPlutoID()]

	if (data) then
		self:ReceivePlutoData(data)
	end
end

function SWEP:DisplayPlutoData()
	local data = self:GetInventoryItem()
	data.ClassName = self:GetClass()
	pprintf("%s %s", data.Tier, self.PrintName)

	for type, list in pairs(data.Mods or {}) do
		if (#list == 0) then
			continue
		end

		pprintf("    %s", type)

		for _, item in ipairs(list) do
			pprintf("        %s tier %i - %s", item.Name, item.Tier, item.Desc)
		end
	end
	MsgN ""
end

function SWEP:Deploy()
	local data = self:GetInventoryItem()

	if (data and IsFirstTimePredicted()) then
		self:DisplayPlutoData()
	end

	return BaseClass.Deploy(self)
end

function SWEP:Holster(w)
	if (IsValid(self.Showcase)) then
		self.Showcase:Remove()
	end

	return BaseClass.Holster(self, w)
end


concommand.Add("+inspect", function()
	local self = ttt.GetHUDTarget():GetActiveWeapon()

	if (not IsValid(self) or not self.GetInventoryItem) then
		return
	end

	local data = self:GetInventoryItem()

	if (not data) then
		return
	end

	self.Showcase = pluto.ui.showcase(data)
	self.Showcase.Start = CurTime()

	local t = self.Showcase.Think
	function self.Showcase:Think()
		if (t) then
			t(self)
		end

		local diff = CurTime() - self.Start
		local frac = 1
		if (diff < 0.2) then
			frac = (diff / 0.2) ^ 0.5
		elseif (diff > 2) then
			frac = 0
			self:Remove()
		elseif (diff > 1.8) then
			frac = 1 - ((diff - 1.8) / 0.2) ^ 0.5
		end

		self:SetPos(ScrW() * 2 / 3 - self:GetWide() / 2, ScrH() - self:GetTall() * frac)
	end
end)

concommand.Add("-inspect", function(ply, cmd, args)
end)