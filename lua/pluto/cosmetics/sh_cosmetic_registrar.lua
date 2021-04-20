pluto.cosmetics = {}
pluto.cosmetics.byname = pluto.cosmetics.byname or {}
pluto.cosmetics.mt = pluto.cosmetics.mt or {}

-- called in initialization files
function pluto.cosmetics.mt:__call(self, data)
	local mt = self.mt
	table.Empty(self)
	table.Merge(self, data)
	self.mt = mt
	print "SAVED"
end
print "SAVED"

setmetatable(pluto.cosmetics.byname, {
	__call = function(self, name)
		print(name)
		local dat = self[name]
		if (not dat) then
			dat = {
				mt = {}
			}
			dat.mt.__index = dat
			self[name] = dat
			dat.MetaName = name
		end

		return dat
	end
})