include "shared.lua"
AddCSLuaFile "shared.lua"

util.AddNetworkString "pluto_wpn_db"
DEFINE_BASECLASS "weapon_tttbase_old"

local function _hook(name, self, fn)
	hook.Add(name, self, function(...)
		self[fn or name](...)
	end)
end

function SWEP:Initialize()
	BaseClass.Initialize(self)
	self:PlutoInitialize()

	local item = pluto.NextWeaponSpawn
	pluto.NextWeaponSpawn = nil

	if (item == false) then
		return
	end

	if (pluto.weapons.valid[self:GetClass()]) then
		if (not item) then
			item = pluto.weapons.generatetier(nil, self:GetClass())
			item.Type = "Weapon"
		end
		self:SetInventoryItem(item)
	end
	self.PlutoData = self.PlutoData or {}

	_hook("PlayerInitialSpawn", self, "SendData")
	_hook("DoPlayerDeath", self, "PlutoDoPlayerDeath")
end

function SWEP:PlutoDoPlayerDeath(ply, atk, dmg)
	if (not IsValid(self:GetOwner()) or dmg:GetInflictor() ~= self or not self.RunModFunctionSequence) then
		return
	end

	if (self.PlutoGun and self.PlutoGun.Owner == self:GetOwner():SteamID64()) then
		if (atk:GetRoleTeam() ~= ply:GetRoleTeam()) then -- add experience to weapon
			pluto.inv.addexperience(self.PlutoGun.RowID, (atk:GetRole() == "Innocent" and 75 or 150) + math.random(0, 25))
		end
	end

	self:RunModFunctionSequence("Kill", nil, self:GetOwner(), ply)
end

function SWEP:RunModFunctionSingle(funcname, ...)
	local gun = self.PlutoGun
	if (not gun) then
		return
	end

	for type, list in pairs(gun.Mods) do
		for _, item in ipairs(list) do
			local mod = pluto.mods.byname[item.Mod]
			if (mod[funcname]) then
				local rolls = pluto.mods.getrolls(mod, item.Tier, item.Roll)
				mod[funcname](mod, self, rolls, ...)
			end
		end
	end
end

function SWEP:RunModFunctionSequence(funcname, state, ...)
	local args = {n = select("#", ...) + 1, ...}
	args[args.n] = state or {}

	self:RunModFunctionSingle("Pre" .. funcname, unpack(args, 1, args.n))
	self:RunModFunctionSingle("On" .. funcname, unpack(args, 1, args.n))
	self:RunModFunctionSingle("Post" .. funcname, unpack(args, 1, args.n))
end

function SWEP:DoFireBullets()
	self:RunModFunctionSequence("Fire", nil, tr, dmginfo)
	BaseClass.DoFireBullets(self)
end

function SWEP:FireBulletsCallback(tr, dmginfo)
	BaseClass.FireBulletsCallback(self, tr, dmginfo)

	if (not tr.IsFake) then
		self:RunModFunctionSequence("Shoot", nil, tr, dmginfo)
	end
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
		implicit = {},
		prefix   = {},
		suffix   = {},
	}

	net.Start "pluto_wpn_db"
		net.WriteInt(self:GetPlutoID(), 32)
		net.WriteString(gun.Tier.Name)
		net.WriteColor(gun.Tier.Color)

		net.WriteString(gun:GetPrintName())
		self.PlutoData.Tier = gun.Tier.Name
		self.PlutoData.Mods = modifiers

		if (gun.Mods.prefix) then
			net.WriteUInt(#gun.Mods.prefix, 8)
			for ind, item in ipairs(gun.Mods.prefix) do
				modifiers.prefix[ind] = self:WriteMod(item, gun)
			end
		else
			net.WriteUInt(0, 8)
		end

		if (gun.Mods.suffix) then
			net.WriteUInt(#gun.Mods.suffix, 8)
			for ind, item in ipairs(gun.Mods.suffix) do
				modifiers.suffix[ind] = self:WriteMod(item, gun)
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

function SWEP:WriteMod(item, wep)
	local mod = pluto.mods.byname[item.Mod]
	local rolls = pluto.mods.getrolls(mod, item.Tier, item.Roll)

	local name = pluto.mods.formataffix(mod.Type, mod.Name)
	local tier = item.Tier
	
	local fmt = {}
	for i, roll in ipairs(rolls) do
		fmt[i] = mod:FormatModifier(i, math.abs(roll), self:GetClass())
	end

	local desc = string.format(mod.Description or mod:GetDescription(rolls), unpack(fmt))

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

hook.Add("EntityTakeDamage", "pluto_dmg_mods", function(targ, dmg)
	if (dmg:GetDamage() <= 0 or bit.band(dmg:GetDamageType(), DMG_BULLET) ~= DMG_BULLET) then
		return
	end

	if (not hook.Run("PlayerShouldTakeDamage", targ, dmg:GetAttacker())) then
		return
	end

	local self = dmg:GetInflictor()
	if (not IsValid(self) or not self.RunModFunctionSequence) then
		return
	end

	self:RunModFunctionSequence("Damage", nil, targ, dmg)
end)