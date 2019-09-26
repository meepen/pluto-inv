include "shared.lua"
AddCSLuaFile "shared.lua"

util.AddNetworkString "pluto_wpn_db"
DEFINE_BASECLASS "weapon_tttbase_old"

function SWEP:Initialize()
	BaseClass.Initialize(self)

	self.GetDamage_Old = self.GetDamage_Old or self.GetDamage
	self.GetDamage = self.GetDamageOverride

	if (pluto.weapons.valid[self:GetClass()]) then
		self:SetInventoryItem(pluto.weapons.generatetier(nil, self:GetClass()))
	end
	self.PlutoData = self.PlutoData or {}
	self.PlutoGun = self.PlutoGun or {}
end


function SWEP:SetInventoryItem(gun)
	self.PlutoData = {}
	self.PlutoGun = {}
	
	for type, list in pairs(gun.Mods) do
		for _, item in ipairs(list) do
			local mod = pluto.mods.byname[item.Mod]
			local rolls = pluto.mods.getrolls(mod, item.Tier, item.Roll)
			table.insert(self.PlutoGun, {
				Mod = mod,
				Rolls = rolls
			})
		end
	end


	local modifiers = {
		prefix = {},
		suffix = {},
	}

	net.Start "pluto_wpn_db"
		net.WriteInt(self:GetHandle(), 32)
		net.WriteString(gun.Tier.Name)
		self.PlutoData.Tier = gun.Tier.Name
		self.PlutoData.Mods = modifiers

		if (gun.Mods.prefix) then
			net.WriteUInt(#gun.Mods.prefix, 8)
			for ind, item in ipairs(gun.Mods.prefix) do
				local mod = pluto.mods.byname[item.Mod]
				local rolls = pluto.mods.getrolls(mod, item.Tier, item.Roll)

				local name = pluto.mods.formataffix(mod.Type, mod.Name)
				local tier = item.Tier
				local desc = mod:GetDescription(rolls)

				modifiers.prefix[ind] = {
					Name = name,
					Tier = tier,
					Description = desc,
					Mod = mod
				}

				net.WriteString(name)
				net.WriteUInt(tier, 4)
				net.WriteString(desc)
			end
		else
			net.WriteUInt(0, 8)
		end

		if (gun.Mods.suffix) then
			net.WriteUInt(#gun.Mods.suffix, 8)
			for ind, item in ipairs(gun.Mods.suffix) do
				local mod = pluto.mods.byname[item.Mod]
				local rolls = pluto.mods.getrolls(mod, item.Tier, item.Roll)

				local name = pluto.mods.formataffix(mod.Type, mod.Name)
				local tier = item.Tier
				local desc = mod:GetDescription(rolls)

				modifiers.suffix[ind] = {
					Name = name,
					Tier = tier,
					Description = desc,
					Mod = mod
				}

				net.WriteString(name)
				net.WriteUInt(tier, 4)
				net.WriteString(desc)
			end
		else
			net.WriteUInt(0, 8)
		end

		net.WriteFunction(function()
			print "hello"
		end)

	net.Broadcast()
	
	pluto.wpn_db[self:GetHandle()] = self.PlutoData
end

function SWEP:GetDamageOverride()
	return self:GetDamage_Old() * self:GetDamageMult()
end


function SWEP:GetDamageMult()
	local mult = 1
	for _, item in pairs(self.PlutoGun) do
		if (item.Mod.AddDamageMult) then
			mult = mult + item.Mod:AddDamageMult(item.Rolls)
		end
	end
	return 1
end