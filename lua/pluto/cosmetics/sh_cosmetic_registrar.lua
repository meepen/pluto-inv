pluto.cosmetics = pluto.cosmetics or {}
pluto.cosmetics.byname = pluto.cosmetics.byname or {}
pluto.cosmetics.mt = pluto.cosmetics.mt or {}

-- called in initialization files
function pluto.cosmetics.mt:__call(self, data)
	local mt = self.mt
	table.Empty(self)
	table.Merge(self, data)
	self.mt = mt
end

setmetatable(pluto.cosmetics.byname, {
	__call = function(self, name, parent)
		local dat = self[name]
		if (not dat) then
			dat = {
				mt = {}
			}
			dat.mt.__index = function(self, k)
				if (dat[k]) then
					return dat[k]
				end

				local parent_table = pluto.cosmetics.byname[parent]
				if (parent_table) then
					return parent_table.mt.__index(parent_table.mt, k)
				end
			end
			self[name] = dat
			dat.MetaName = name
		end

		return dat
	end
})