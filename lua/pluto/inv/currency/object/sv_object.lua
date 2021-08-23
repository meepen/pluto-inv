--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
local CURRENCY = pluto.currency.object_mt.__index
AccessorFunc(CURRENCY, "RoundDie", "DieRound", FORCE_NUMBER)

util.AddNetworkString "pluto_currency"

function CURRENCY:Update()
	pluto.inv.message(self.Listeners)
		:write("currencyspawn", self)
		:send()
end

function CURRENCY:TryReward(e)
	local cur = pluto.currency.byname[self:GetCurrencyType()]
	if (not cur) then
		self:Remove()
		return true
	end

	hook.Run("PlutoCurrencyPickup", self, e)

	if (cur.Pickup) then
		if (not cur.Pickup(e, self)) then
			return false
		end
	end

	net.Start "pluto_currency"
		net.WriteVector(self:GetPos())
	net.Send(e)

	if (not cur.Fake) then
		local grounddata = cur.GroundData or cur
		pluto.db.instance(function(db)
			local succ, err = pluto.inv.addcurrency(db, e, cur.InternalName, grounddata.Amount or 1)
			if (not IsValid(e)) then
				return
			end

			if (not succ) then
				e:ChatPrint("i tried to add currency but it didn't work, tell meepen you lost: " .. cur.InternalName)
			end
		end)
		if ((grounddata.Amount or 1) > 1) then
			e:ChatPrint(cur.Color, "+ ", white_text, "You have found ", cur, " × ", grounddata.Amount, ".")
		else
			e:ChatPrint(cur.Color, "+ ", white_text, "You have found ", startswithvowel(cur.Name) and "an " or "a ", cur, ".")
		end
	end

	self:Remove()

	return true
end

function CURRENCY:Remove()
	if (self.Removed) then
		return
	end

	self.Removed = true
	pluto.currency.object_list[self:GetID()] = nil

	pluto.inv.message(self.Listeners)
		:write("currencyspawn", self)
		:send()
end

function CURRENCY:AddListener(ply)
	if (not istable(ply)) then
		ply = {ply}
	end

	for _, p in pairs(ply) do
		table.insert(self.Listeners, p)
	end

	pluto.inv.message(ply)
		:write("currencyspawn", self)
		:send()
end

function pluto.inv.writecurrencyspawn(ply, cur)
	net.WriteUInt(cur:GetID(), 32)
	if (cur.Removed) then
		net.WriteBool(true)
		return
	end

	net.WriteBool(false)

	net.WriteVector(cur:GetNetworkedPosition())
	net.WriteFloat(cur:GetNetworkedPositionTime())
	net.WriteUInt(cur:GetMovementType(), 4)
	net.WriteVector(cur:GetMovementVector() or vector_up)
	net.WriteFloat(cur:GetSize())
	net.WriteString(cur:GetCurrencyType())
end

pluto.currency.object_id = pluto.currency.object_id or 0

function pluto.currency.entity()
	local id = pluto.currency.object_id
	pluto.currency.object_id = id + 1

	local ent = setmetatable({
		Listeners = {},
	}, pluto.currency.object_mt)
	ent:SetID(id)

	ent:SetSize(20)
	ent:SetNetworkedPosition(vector_origin)
	ent:SetNetworkedPositionTime(CurTime())
	ent:SetMovementType(CURRENCY_MOVESTILL)
	ent:SetCurrencyType "unknown"
	ent:SetDieRound(ttt.GetRoundNumber() + 3)

	pluto.currency.object_list[id] = ent

	return ent
end

local tick_since_check = 0
hook.Add("Tick", "pluto_new_currency_pickup", function()
	tick_since_check = tick_since_check + 1
	if (tick_since_check < 4) then
		return
	end

	tick_since_check = 0


	for id, cur in pairs(pluto.currency.object_list) do
		local got = false
		for _, e in pairs(cur.Listeners) do
			if (not IsValid(e) or not e:Alive()) then
				continue
			end

			if (cur:BoundsWithin(e)) then
				if (cur:TryReward(e)) then
					got = true
					break
				end
			end
		end
		if (got) then
			continue
		end

		local mins = game.GetWorld():GetModelBounds()
		if (cur:GetPos().z < mins.z) then
			cur:Remove()
		end
	end
end)

function pluto.statuses.greed(ply, dist, time)
	ply:SetCurrencyTime(time + CurTime())
	ply:SetCurrencyDistance(dist)
end

hook.Add("PlayerSpawn", "pluto_currency", function(p)
	p:SetCurrencyTime(-math.huge)
end)

hook.Add("TTTPrepareRound", "pluto_new_currency_die", function()
	local round = ttt.GetRoundNumber()

	for id, cur in pairs(pluto.currency.object_list) do
		if (cur:GetDieRound() <= round) then
			cur:Remove()
		end
	end
end)

concommand.Add("pluto_spawn_cur", function(ply, cmd, args)
	if (not pluto.cancheat(ply)) then
		return
	end

	local pos = ply:GetEyeTrace().HitPos

	local target = ply

	for i = 2, #args do
		local arg = args[i]
		if (arg == "global") then
			target = player.GetAll()
		end
	end

	local ent = pluto.currency.entity()
	ent:SetSize(22)
	ent:SetPos(pos + vector_up * ent:GetSize())
	ent:SetCurrencyType(args[1] or "droplet")
	ent:AddListener(target)
end)
