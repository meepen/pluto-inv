local pluto_inspect_toggle = CreateConVar("pluto_inspect_toggle", 1, FCVAR_ARCHIVE, "Makes the +inspect toggleable")
local pluto_inspect_toggle_autoclose = CreateConVar("pluto_inspect_toggle_autoclose", 2, FCVAR_ARCHIVE, "Toggle mode +inspect auto close time", 0, 10)
local pluto_inspect_lifespan = CreateConVar("pluto_inspect_lifespan", 0.2, FCVAR_ARCHIVE, "Lifespan of +inspect menu", 0, 1)

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
		if (item.Nickname) then
			return "'" .. item.Nickname .. "'"
		end
	end
end

function SWEP:GetPrintNameColor()
	local item = self:GetInventoryItem()
	if (item) then
		if (item.Color) then
			return (pluto.inv.colors(item.Color))
		end
	end

	return white_text
end

function SWEP:Initialize()
	BaseClass.Initialize(self)

	self.Pluto = {}

	local data = pluto.wpn_db[self:GetPlutoID()]

	if (data) then
		self:ReceivePlutoData(data)
	end
end

function SWEP:DisplayPlutoData()
	if (GetConVar("pluto_print_console"):GetBool()) then
		return
	end

	local data = self:GetInventoryItem()
	data.ClassName = self:GetClass()

	MsgC(data:GetColor(), data:GetTextMessage())
end

function SWEP:Deploy()
	local data = self:GetInventoryItem()

	if (data and IsFirstTimePredicted()) then
		self:DisplayPlutoData()
	end

	return BaseClass.Deploy(self)
end

function SWEP:Holster(w)
	if (IsValid(pluto.Showcase)) then
		pluto.Showcase:Remove()
	end

	return BaseClass.Holster(self, w)
end

concommand.Add("+inspect", function()
	if (IsValid(pluto.Showcase) and pluto.Showcase.Death) then
		pluto.Showcase:Remove()
	end

	local self = ttt.GetHUDTarget():GetActiveWeapon()

	if (not IsValid(self) or not self.GetInventoryItem) then
		return
	end

	local data = self:GetInventoryItem()

	if (not data) then
		return
	end

	if (IsValid(pluto.Showcase)) then
		pluto.Showcase.Death = RealTime()
		return
	else
		pluto.Showcase = pluto.ui.showcase(data)
		pluto.Showcase.Start = RealTime()
	end
	if (pluto_inspect_toggle:GetBool()) then
		local delay = pluto_inspect_toggle_autoclose:GetFloat()
		if (delay > 0) then
			local cur = pluto.Showcase
			timer.Simple(delay, function()
				if (pluto.Showcase == cur and IsValid(cur)) then
					cur.Death = RealTime()
				end
			end)
		end
	end

	local t = pluto.Showcase.Think
	function pluto.Showcase:Think()
		if (t) then
			t(self)
		end
		local lifespan = pluto_inspect_lifespan:GetFloat()

		if (self.Death) then
			frac = math.max(0, (self.Death + lifespan - RealTime()) / lifespan)
			if (frac == 0) then
				self:Remove()
			end
		else
			frac = math.min(1, 1 - (self.Start + lifespan - RealTime()) / lifespan)
		end


		self:SetPos(ScrW() * 2 / 3 - self:GetWide() / 2, ScrH() - self:GetTall() * frac)
	end
end)

concommand.Add("-inspect", function(ply, cmd, args)
	if (IsValid(pluto.Showcase) and not pluto_inspect_toggle:GetBool()) then
		pluto.Showcase.Death = RealTime()
	end
end)