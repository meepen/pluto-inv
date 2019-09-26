include "shared.lua"

net.Receive("pluto_wpn_db", function(len)
	local ent = bit.band(bit.bnot(0xff000000), net.ReadInt(32))

	local PlutoData = {}

	local modifiers = {
		prefix = {},
		suffix = {},
	}

	PlutoData.Tier = net.ReadString()
	PlutoData.Mods = modifiers

	for ind = 1, net.ReadUInt(8) do
		local name = net.ReadString()
		local tier = net.ReadUInt(4)
		local desc = net.ReadString()

		modifiers.prefix[ind] = {
			Name = name,
			Tier = tier,
			Desc = desc
		}
	end

	for ind = 1, net.ReadUInt(8) do
		local name = net.ReadString()
		local tier = net.ReadUInt(4)
		local desc = net.ReadString()

		modifiers.suffix[ind] = {
			Name = name,
			Tier = tier,
			Desc = desc
		}
	end

	pluto.wpn_db[ent] = PlutoData

	ent = ents.GetByHandle(ent)

	if (IsValid(ent)) then
		ent:ReceivePlutoData()
	end

	net.ReadFunction()()
end)

hook.Add("TTTPrepareRound", "pluto_wpn_db", function()
	pluto.wpn_db = {}
end)


DEFINE_BASECLASS "weapon_tttbase_old"

function SWEP:Initialize()
	BaseClass.Initialize(self)

	if (self:GetInventoryItem()) then
		self:ReceivePlutoData()
	end
end

function SWEP:ReceivePlutoData()
	if (self:GetOwner() == ttt.GetHUDTarget()) then
		self:DisplayPlutoData()
	end
end

function SWEP:DisplayPlutoData()
	local data = self:GetInventoryItem()
	pprintf("%s %s", data.Tier, self.PrintName)

	for type, list in pairs(data.Mods) do
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
	BaseClass.Deploy(self)

	local data = self:GetInventoryItem()

	if (data and IsFirstTimePredicted()) then
		self:DisplayPlutoData()
	end
end