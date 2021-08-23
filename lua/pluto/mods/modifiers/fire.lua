--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
MOD.Type = "suffix"
MOD.Name = "The Inferno"
MOD.Tags = {
	"damage", "fire", "dot"
}

MOD.Color = Color(211, 111, 3)

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:FormatModifier(index, roll)
	return string.format("%.01f%%", roll)
end

MOD.Description = "Spawns a flame that does %s of this gun's damage per second"

MOD.Tiers = {
	{ 25, 35 },
	{ 15, 25 },
	{ 5, 15 },
}

function MOD:ModifyWeapon(wep, rolls)
	if (not SERVER) then
		return
	end

	local damage = math.min(100, rolls[1] * wep:GetDamage() * wep:GetDelay())

	hook.Add("EntityFireBullets", wep, function(self, wep, data)
		if (self ~= wep) then
			return
		end

		local cb = data.Callback
		local has_fired = false
		function data.Callback(atk, tr, dmg)
			if (cb) then
				cb(atk, tr, dmg)
			end

			if (tr.HitregHitregCallback or has_fired) then
				return
			end

			has_fired = true

			local dmgowner = self:GetOwner()

			local flame = ents.Create "ttt_flame"
			flame.Avoidable = true
			flame:SetPos(tr.HitPos)
			if (IsValid(dmgowner) and dmgowner:IsPlayer()) then
				flame:SetDamageParent(dmgowner)
				flame:SetOwner(dmgowner)
			end
		
			flame.fire_damage = damage * engine.TickInterval()
			flame.hurt_interval = engine.TickInterval()
			flame.fireparams = {size=80 * self:GetDelay(), growth=0}
			flame:SetExplodeOnDeath(false)
			flame:SetDieTime(CurTime() + math.max(engine.TickInterval() * 2, self:GetDelay() * 5))

			flame:Spawn()
			flame:PhysWake()
		
			local phys = flame:GetPhysicsObject()
			if IsValid(phys) then
				-- the balance between mass and force is subtle, be careful adjusting
				phys:SetMass(2)
			end
		end
	end)
end


return MOD