
local test_frame, last_item

local pluto_hover_enabled = CreateConVar("pluto_hover_enabled", 1, FCVAR_ARCHIVE, "Enable gun hover image")
local pluto_hover_percent = CreateConVar("pluto_hover_pct", 0.1, FCVAR_ARCHIVE, "Size percent for the image of gun hovers", 0.01, 0.5)

local extents = Vector(4, 4, 4)
hook.Add("PostDrawTranslucentRenderables", "pluto_hover", function()
	if (not pluto_hover_enabled:GetBool()) then
		return
	end

	local pct = pluto_hover_percent:GetFloat()

	local ang = EyeAngles()
	local tr = util.TraceHull {
		start = EyePos(),
		endpos = EyePos() + ang:Forward() * 100,
		maxs = extents,
		mins = -extents,
		ignoreworld = true,
		filter = function(e)
			return e:IsWeapon()
		end
	}
	local item = tr.Entity
	if (not IsValid(item) or not item:IsWeapon() or not item:GetInventoryItem()) then
		return
	end
	item = item:GetInventoryItem()
	if (last_item ~= item) then
		last_item = item
		if (IsValid(test_frame)) then
			test_frame:Remove()
		end
		test_frame = vgui.Create "pluto_item_showcase"
		test_frame:SetItem(item)
	end

	local pos = tr.Entity:GetPos() + vector_up * test_frame:GetTall() * pct * 0.5 - ang:Right() * test_frame:GetWide() * pct / 2 + vector_up * 30
	ang:RotateAroundAxis(ang:Up(), 90)
	ang:RotateAroundAxis(ang:Forward(), -90)
	ang:RotateAroundAxis(ang:Up(), 180)
	--ang.r = 60

	cam.IgnoreZ(true)
		vgui.Start3D2D(pos, ang, pct)
			test_frame:Paint3D2D()
		vgui.End3D2D()
	cam.IgnoreZ(false)
end)