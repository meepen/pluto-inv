local ENT = FindMetaTable "Entity"
local mt0 = {
	__index = function(self, k)
		local ret = {}
		self[k] = ret
		return ret
	end
}
pluto.hitbox_overrides = setmetatable({}, {
	__index = function(self, k)
		local ret = setmetatable({}, mt0)
		self[k] = ret
		return ret
	end
})

ENT.RealGetHitBoxHitGroup = ENT.RealGetHitBoxHitGroup or ENT.GetHitBoxHitGroup
function ENT:GetHitBoxHitGroup(hitbox, hitboxset)
	local data = pluto.hitbox_overrides[self:GetModel()][hitboxset][hitbox]

	return data or self:RealGetHitBoxHitGroup(hitbox, hitboxset)
end

local env = setmetatable({
	c = function(name)
		return function(data)
			if (data.HitboxOverride) then
				for hitboxset, setchanges in pairs(data.HitboxOverride) do
					for hitbox, changes in pairs(setchanges) do
						pluto.hitbox_overrides[data.Model][hitboxset][hitbox] = changes.HitGroup
					end
				end
			end
			pluto.model(name)(data)
		end
	end,
	rare = Color(190, 0, 0),
	rand = function(seed)
		seed = (1103515245 * seed + 12345) % (2^31)
		return seed
	end,
	BodyGroupRand = function(data, seed)
		local ret = {}
		for bodygroup, allowed in SortedPairs(data) do
			seed = rand(seed)
			local randf = seed / (2^31 + 1)
			ret[bodygroup] = istable(allowed) and allowed[math.floor(randf * #allowed) + 1] or math.floor(randf * allowed)
		end
		return ret
	end,
	GenerateBodygroups = function(max)
		return function(item)
			local id = rand(item.RowID or item.ID)
			local t = {}
	
			for i = 1, #max do
				local name = max[i][1]
				local amt = max[i][2]
				t[name] = id % amt
				id = math.floor(id / amt)
			end
	
			return t
		end
	end
}, {__index = _G})

for _, fn in pairs(env) do
	if (isfunction(fn)) then
		setfenv(fn, env)
	end
end

local function runfile(filename)
	AddCSLuaFile(filename)
	local fn = CompileFile(filename)
	if (not fn) then
		pwarnf("Couldn't find file %s", filename)
		return
	end

	setfenv(fn, env)
	fn()
end
runfile "lists/blueegg.lua"
runfile "lists/christmas2019.lua"
runfile "lists/easter2020.lua"
runfile "lists/geralt.lua"
runfile "lists/halloween2020.lua"
runfile "lists/meepen.lua"
runfile "lists/orangeegg.lua"
runfile "lists/random.lua"

function pluto.updatemodel(ent, item)
	if (not item or not item.Model) then
		return
	end


	if (item.Model.GenerateSkin) then
		ent:SetSkin(item.Model.GenerateSkin(item))
	else
		ent:SetSkin(0)
	end

	if (item.Model.GenerateBodygroups) then
		local bg = item.Model.GenerateBodygroups(item)

		for _, d in pairs(ent:GetBodyGroups()) do
			ent:SetBodygroup(d.id, 0)
		end

		for name, id in pairs(bg or {}) do
			local bgid = isnumber(name) and name or ent:FindBodygroupByName(name)
			if (bgid == -1) then
				pwarnf("Couldn't find %s on %s", name, item.Model.Model)
				continue
			end

			ent:SetBodygroup(bgid, id)
		end
	end
end