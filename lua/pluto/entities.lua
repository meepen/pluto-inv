local ENTITY = FindMetaTable "Entity"

function ENTITY:GetHandle()
	if (game.GetWorld() == NULL) then
		return -1
	end
	game.GetWorld():SetNW2Entity("_", self)
	return game.GetWorld():GetNW2Int("_")
end

function ents.GetByHandle(handle)
	if (CLIENT) then
		handle = bit.band(bit.bnot(0xff000000), handle)
	end
	if (game.GetWorld() == NULL) then
		return NULL
	end
	game.GetWorld():SetNW2Int("_", handle)
	return game.GetWorld():GetNW2Entity "_"
end