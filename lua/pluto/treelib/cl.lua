
local mat = CreateMaterial("pluto_node_line_real", "UnlitGeneric", {
	["$basetexture"] = "sprites/xbeam2",
	["$additive"] = 1
})
local sun = CreateMaterial("pluto_glow_unlit_real", "UnlitGeneric", {
	["$vertexcolor"] = "1",
	["$vertexalpha"] = "1",
	["$translucent"] = "1"
})
local backgrounds = {
	Material "pluto/hubble.png",
	Material "pluto/eppen_stars.png",
	Material "pluto/colorful.png",
	Material "pluto/hound1.png",
	Material "pluto/hound2.png",
}

local matr = Matrix()
local circles = include "pluto/thirdparty/circles.lua"

local circle_cache = {}

local function GetHoveredNode(tree, offx, offy, size)
	local low_dist, best_node = math.huge
	local mx, my = gui.MousePos()
	mx = mx - offx
	my = my - offy
	for i, node in ipairs(tree) do
		local dx, dy = (size / 2 + node.x * size / 2) - mx, (size / 2 + node.y * size / 2) - my
		local dist = math.sqrt(dx ^ 2 + dy ^ 2)

		if (dist < low_dist) then
			low_dist, best_node = dist, node
		end
	end

	return best_node, low_dist
end

local function DrawTree(generated, x, y, size, hovered)
	local c = circle_cache[size]
	local outline = 4
	if (not c) then
		c = {
			stencil = circles.New(CIRCLE_FILLED, size / 2, size / 2, size / 2),
			outline = circles.New(CIRCLE_OUTLINED, size / 2, size / 2, size / 2, outline)
		}
		c.stencil:SetColor(Color(0, 0, 0, 255))
		circle_cache[size] = c
	end
	matr:SetTranslation(Vector(x, y))
	cam.PushModelMatrix(matr)
		render.SetStencilEnable(true)
		render.ClearStencil()
			render.SetStencilCompareFunction(STENCIL_ALWAYS)
			render.SetStencilFailOperation(STENCIL_ZERO)
			render.SetStencilZFailOperation(STENCIL_ZERO)
			render.SetStencilPassOperation(STENCIL_INCR)
			render.SetStencilReferenceValue(1)

			c.stencil()

			render.SetStencilCompareFunction(STENCIL_EQUAL)
			sun:SetTexture("$basetexture", Material "pluto/star3.png":GetTexture "$basetexture")
			local bg = backgrounds[generated.background]
			surface.SetMaterial(bg)
			surface.SetDrawColor(255, 255, 255, 255)
			local img_w, img_h = bg:GetInt "$realwidth", bg:GetInt "$realheight"
			local img_x, img_y = (img_w - size) * generated.x + size / 2, (img_h - size) * generated.y + size / 2
			local u_size = size / img_w
			local v_size = size / img_h
			local su = (img_x - size / 2) * generated.x / img_w
			local sv = (img_y - size / 2) * generated.y / img_h
			surface.DrawTexturedRectUV(0, 0, size, size, su, sv, su + u_size, sv + v_size)
		render.SetStencilEnable(false)

		surface.SetMaterial(mat)
		local thicc = 3

		for i, nodes in ipairs(generated.connections) do
			local nx, ny = nodes[1]:ToScreen(size, outline * 2)
			local cx, cy = nodes[2]:ToScreen(size, outline * 2)

			local ang = math.atan2(cy - ny, cx - nx)
			local deg = math.rad(math.deg(ang) + 90)
			local dc, ds = math.cos(deg) * thicc, math.sin(deg) * thicc

			surface.SetDrawColor(0, 0, 255, 255)
			local centerx, centery = (nx + cx) / 2, (ny + cy) / 2
			local points = {
				{ x = nx - dc, y = ny - ds, u = 1, v = 0 },
				{ x = nx + dc, y = ny + ds, u = 0, v = 1 },
				{ x = cx - dc, y = cy - ds, u = 1, v = 0 },
				{ x = cx + dc, y = cy + ds, u = 0, v = 1 },
			}
			table.sort(points, function(a, b)
				local aa = a.ang
				local ba = b.ang

				if (not aa) then
					aa = math.deg(math.atan2(a.y - centery, a.x - centerx))
					a.ang = aa
				end
				if (not ba) then
					ba = math.deg(math.atan2(b.y - centery, b.x - centerx))
					b.ang = ba
				end

				return aa < ba
			end)
			surface.DrawPoly(points)
		end

		surface.SetMaterial(sun)
		surface.SetDrawColor(255, 255, 200, 255)

		for i, node in ipairs(generated) do
			local nx, ny = node:ToScreen(size, outline * 2)
			local size = node.size * (hovered == node and 1.5 or 1)
			surface.DrawTexturedRect(nx - size / 2, ny - size / 2, size, size)
			surface.DrawTexturedRect(nx - size / 2, ny - size / 2, size, size)
			surface.DrawTexturedRect(nx - size / 2, ny - size / 2, size, size)
		end

		draw.NoTexture()

		surface.SetDrawColor(11, 12, 13, 255)
		c.outline()
	cam.PopModelMatrix()
end


local PANEL = {}

function PANEL:Paint(w, h)
	local bubbles = self.bubbles
	if (not bubbles) then
		return
	end

	local offx, offy = self:LocalToScreen(0, 0)
	local centerx, centery = w / 2, h / 2

	local center = bubbles.trees[1]
	local hovered, node_dist = GetHoveredNode(center, offx + centerx - center.size / 2, offy + centery - center.size / 2, center.size)
	for i = 2, #bubbles.trees do
		local tree = bubbles.trees[i]
		local ang = math.rad(tree.ang)
		local dc, ds = math.cos(ang), math.sin(ang)
		local dist = center.size / 2 + tree.size / 2
		local node, _dist = GetHoveredNode(tree, offx + centerx + dist * dc - tree.size / 2, offy + centery + dist * ds - tree.size / 2, tree.size)
		if (_dist < node_dist) then
			hovered, node_dist = node, _dist
		end
	end

	if (node_dist > 40) then
		hovered = nil
	end

	DrawTree(center, centerx - center.size / 2, centery - center.size / 2, center.size, hovered)
	for i = 2, #bubbles.trees do
		local tree = bubbles.trees[i]
		local ang = math.rad(tree.ang)
		local dc, ds = math.cos(ang), math.sin(ang)
		local dist = center.size / 2 + tree.size / 2
		DrawTree(tree, centerx + dist * dc - tree.size / 2, centery + dist * ds - tree.size / 2, tree.size, hovered)
	end

	if (hovered) then
		surface.SetTextColor(white_text)
		surface.SetFont "BudgetLabel"
		surface.SetTextPos(2, 3)
		local star = self.constellations and self.constellations[hovered.bubble.id][hovered.node_id]
		local w, h = surface.GetTextSize(star.Name)
		surface.DrawText(star.Name)
		surface.SetTextPos(2, 5 + h)
		surface.DrawText(star.Desc)
	end
end

vgui.Register("pluto_tree", PANEL, "EditablePanel")
