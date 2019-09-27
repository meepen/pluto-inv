include "shared.lua"
AddCSLuaFile "shared.lua"

util.AddNetworkString "pluto_wpn_db"
DEFINE_BASECLASS "weapon_tttbase_old"

function SWEP:Initialize()
	BaseClass.Initialize(self)
	self:PlutoInitialize()

	if (pluto.weapons.valid[self:GetClass()]) then
		local item = pluto.weapons.generatetier(nil, self:GetClass())
		self:SetInventoryItem(item)
		--[[
		if (IsValid(player.GetHumans()[1])) then
			pluto.weapons.save(item, player.GetHumans()[1], function(succ)
				if (succ) then
					pprintf("Saved weapon!!!! ID: %s", item.Snowflake)
				else
					pwarnf("Failed to save weapon :(")
				end
			end)
		end]]
	end
	self.PlutoData = self.PlutoData or {}

	hook.Add("PlayerInitialSpawn", self, self.SendData)
end

function SWEP:SendData(ply)
	local gun = self.PlutoGun
	if (not gun) then
		return
	end

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
		net.WriteInt(self:GetPlutoID(), 32)
		net.WriteString(gun.Tier.Name)
		self.PlutoData.Tier = gun.Tier.Name
		self.PlutoData.Mods = modifiers

		if (gun.Mods.prefix) then
			net.WriteUInt(#gun.Mods.prefix, 8)
			for ind, item in ipairs(gun.Mods.prefix) do
				modifiers.prefix[ind] = self:WriteMod(item)
			end
		else
			net.WriteUInt(0, 8)
		end

		if (gun.Mods.suffix) then
			net.WriteUInt(#gun.Mods.suffix, 8)
			for ind, item in ipairs(gun.Mods.suffix) do
				modifiers.suffix[ind] = self:WriteMod(item)
			end
		else
			net.WriteUInt(0, 8)
		end

	if (ply) then
		net.Send(ply)
	else
		net.Broadcast()
	end
end

function SWEP:WriteMod(item)
	local mod = pluto.mods.byname[item.Mod]
	local rolls = pluto.mods.getrolls(mod, item.Tier, item.Roll)

	local name = pluto.mods.formataffix(mod.Type, mod.Name)
	local tier = item.Tier
	local desc = mod:GetDescription(rolls)

	net.WriteString(name)
	net.WriteUInt(tier, 4)
	net.WriteString(desc)

	if (mod.ModifyWeapon) then
		net.WriteBool(true)
		net.WriteFunction(mod.ModifyWeapon)
		net.WriteUInt(#rolls, 8)
		for i = 1, #rolls do
			net.WriteDouble(rolls[i])
		end
	else
		net.WriteBool(false)
	end

	return {
		Name = name,
		Tier = tier,
		Description = desc,
		Mod = mod,
		Rolls = mod.ModifyWeapon and rolls or nil
	}
end

function SWEP:SetInventoryItem(gun)
	self.PlutoData = {}
	self.PlutoGun = gun

	self:SendData()
	
	pluto.wpn_db[self:GetPlutoID()] = self.PlutoData

	self:ReceivePlutoData()
end


function SWEP:GetInventoryItem()
	return self.PlutoData
end