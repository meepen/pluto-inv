
local mat = CreateMaterial("pluto_node_line_real", "UnlitGeneric", {
	["$basetexture"] = "sprites/xbeam2",
	["$additive"] = 1
})

function pluto.getsuntexture()
	if (pluto.suntexture) then
		return pluto.suntexture
	end
	pluto.suntexture = CreateMaterial("pluto_glow_unlit_real", "UnlitGeneric", {
		["$vertexcolor"] = "1",
		["$vertexalpha"] = "1",
		["$translucent"] = "1"
	})
	
	pluto.suntexture:SetTexture("$basetexture", Material "pluto/star3.png":GetTexture "$basetexture")

	return pluto.suntexture
end

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

local enabled_color = Color(255, 255, 200, 255)
local disabled_color = Color(255, 155, 120, 100)
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

			if (nodes[1].node_unlocked or nodes[2].node_unlocked) then

				local ang = math.atan2(cy - ny, cx - nx)
				local deg = math.rad(math.deg(ang) + 90)
				local dc, ds = math.cos(deg) * thicc, math.sin(deg) * thicc

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
			else
				surface.SetDrawColor(255, 100, 120, 180)
				surface.DrawLine(nx, ny, cx, cy)
			end
		end

		surface.SetMaterial(pluto.getsuntexture())

		for i, node in ipairs(generated) do
			if (node.node_unlocked) then
				surface.SetDrawColor(enabled_color)
			else
				surface.SetDrawColor(disabled_color)
			end
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

function PANEL:Init()
	hook.Add("PlutoItemUpdate", self, self.PlutoItemUpdate)
end

function PANEL:GetHoveredNode()
	local hovered = vgui.GetHoveredPanel()
	if (IsValid(hovered) and hovered:GetParent() == self) then
		return nil
	end

	local bubbles = self.bubbles
	if (not bubbles) then
		return
	end

	local offx, offy = self:LocalToScreen(0, 0)
	local centerx, centery = self:GetWide() / 2, self:GetTall() / 2

	local center = bubbles.trees[1]
	local hovered, node_dist = GetHoveredNode(center, offx + centerx - center.size / 2, offy + centery - center.size / 2, center.size)
	local nodetree = 1

	for i = 2, #bubbles.trees do
		local tree = bubbles.trees[i]
		local ang = math.rad(tree.ang)
		local dc, ds = math.cos(ang), math.sin(ang)
		local dist = center.size / 2 + tree.size / 2
		local node, _dist = GetHoveredNode(tree, offx + centerx + dist * dc - tree.size / 2, offy + centery + dist * ds - tree.size / 2, tree.size)
		if (_dist < node_dist) then
			hovered, node_dist = node, _dist
			nodetree = i
		end
	end

	if (node_dist > 40) then
		hovered = nil
		nodetree = nil
	end

	return hovered, nodetree
end

function PANEL:Paint(w, h)
	local bubbles = self.bubbles
	if (not bubbles) then
		return
	end

	local offx, offy = self:LocalToScreen(0, 0)
	local centerx, centery = w / 2, h / 2

	local center = bubbles.trees[1]
	local hovered, node_dist = self:GetHoveredNode()

	DrawTree(center, centerx - center.size / 2, centery - center.size / 2, center.size, hovered)
	for i = 2, #bubbles.trees do
		local tree = bubbles.trees[i]
		local ang = math.rad(tree.ang)
		local dc, ds = math.cos(ang), math.sin(ang)
		local dist = center.size / 2 + tree.size / 2
		DrawTree(tree, centerx + dist * dc - tree.size / 2, centery + dist * ds - tree.size / 2, tree.size, hovered)
	end

	if (hovered) then
		local star = self.constellations and self.constellations[hovered.bubble.id][hovered.node_id]
		if (self.last_hovered ~= star) then
			self.showcase = pluto.ui.showcase {
				Name = star.Name,
				Description = star.Desc,
				Color = hovered.node_unlocked and enabled_color or disabled_color,
				Experience = not hovered.node_unlocked and star.Experience or nil,
			}
			self.showcase:SetPos(PLUTO_TREE:LocalToScreen(PLUTO_TREE:GetWide() / 2 - self.showcase:GetWide() / 2, PLUTO_TREE:GetTall()))
			self.last_hovered = star
		end
	elseif (IsValid(self.showcase)) then
		self.showcase:Remove()
		self.last_hovered = nil
	end
end

function PANEL:OnMousePressed(code)
	if (code ~= MOUSE_LEFT) then
		return
	end

	local bubbles = self.bubbles
	if (not bubbles) then
		return
	end

	local hovered, nodetree = self:GetHoveredNode()

	if (hovered and not hovered.node_unlocked) then
		pluto.inv.message()
			:write("unlocknode", self.Item, nodetree, hovered)
			:send()
	end
end

function PANEL:SetItem(item)
	self.bubbles = tree.make_bubbles(item.constellations, item.ID, item.ClassName)
	self.constellations = item.constellations

	self.Opens = self.Opens or {}
	for _, p in ipairs(self.Opens) do
		p:Remove()
	end

	local center = self.bubbles[1]
	for i = 1, 4 do
		local ang = math.rad((i - 1) * 90)
		local c, s = math.cos(ang), math.sin(ang)

		self.Opens[i] = self:Add "pluto_open_tree"
		local p = self.Opens[i]
		p:SetSize(48, 48)
		local dist = 150
		p:SetPos(self:GetWide() / 2 + c * dist - p:GetWide() / 2, self:GetTall() / 2 + s * dist - p:GetTall() / 2)
		p:SetDirection(i)

		local t1, t2 = self.constellations[i + 1][1], self.constellations[(i - 2) % 4 + 2][1]
		
		p:SetText(t1.Experience + t2.Experience)

		function p.DoClick()
			pluto.inv.message()
				:write("unlockmajors", self.Item, i)
				:send()
		end
	end
	self.Item = item
end

function PANEL:PlutoItemUpdate(item)
	if (item == self.Item) then
		self:SetItem(item)
	end
end

vgui.Register("pluto_tree", PANEL, "EditablePanel")

local PANEL = {}

function PANEL:Init()
	self:SetCursor "hand"
end

function PANEL:SetDirection(dir)
	self.direction = dir
	self.Text = ""
end

function PANEL:Paint(w, h)
	draw.NoTexture()
	surface.SetTextColor(12, 13, 15)
	surface.SetFont "pluto_item_showcase_id"
	local tw, th = surface.GetTextSize(self.Text)
	local p1, p2, p3
	if (self.direction == 1) then
		p1 = {x = 0, y = 0}
		p2 = {x = w, y = h / 2}
		p3 = {x = 0, y = h}

		surface.SetTextPos(2, h / 2 - th / 2)
		tx, ty = 0, w / 3
	elseif (self.direction == 2) then
		p1 = {x = 0, y = 0}
		p2 = {x = w, y = 0}
		p3 = {x = w / 2, y = h}

		surface.SetTextPos(w / 2 - tw / 2, h / 5 - th / 2)
	elseif (self.direction == 3) then
		p1 = {x = w, y = 0}
		p2 = {x = w, y = h}
		p3 = {x = 0, y = h / 2}

		surface.SetTextPos(w - tw - 2, h / 2 - th / 2)
	elseif (self.direction == 4) then
		p1 = {x = 0, y = h}
		p2 = {x = w / 2, y = 0}
		p3 = {x = w, y = h}

		surface.SetTextPos(w / 2 - tw / 2, h * 4 / 5 - th / 2)

	else
		return
	end

	surface.SetDrawColor(disabled_color)
	surface.DrawPoly {
		p1, p2, p3
	}

	surface.DrawText(self.Text)
end

function PANEL:OnMousePressed(mouse)
	if (mouse ~= MOUSE_LEFT) then
		return
	end

	self:DoClick()
end

function PANEL:SetText(t)
	self.Text = t
end

vgui.Register("pluto_open_tree", PANEL, "EditablePanel")