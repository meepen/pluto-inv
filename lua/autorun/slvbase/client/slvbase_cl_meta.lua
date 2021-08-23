local meta = FindMetaTable("NPC")
function meta:slvGetWeapon(class)
	for k, v in ipairs(ents.FindByClass(class)) do
		if v.Owner == self then
			return v
		end
	end
	return NULL
end
