local test_item


local mat_white = Material("vgui/white")
local textures = {
	galaxy = {
		scale = 0.3,
		texture = Material("pluto/seamless/galaxy.png", "noclamp"),
		speed = Vector(0.03, 0.02)
	},
	bullets = {
		scale = 0.6,
		texture = Material("pluto/seamless/bullets.png", "noclamp"),
		speed = Vector(-0.01, -0.09)
	},
	blackhole = {
		scale = true,
		texture = Material("pluto/seamless/blackhole.png", "noclamp"),
		speed = Vector(0, 0),
		rotate = 90,
	},
}

for k, texture in pairs(textures) do
	if (isnumber(k)) then
		continue
	end

	table.insert(textures, texture)
end

local rands = setmetatable({}, {
	__index = function(self, k)
		local rands = {
			x = math.random(),
			y = math.random(),
			rotate = math.random(),
		}
		self[k] = rands
		return rands
	end,
	__mode = "k"
})

local function DrawMovingTexture(item, x, y, w, h)
	local rand = rands[item]
	local img = textures[item:GetBackgroundTexture()]
	if (not img) then
		return false
	end
	local tex = img.texture
	local scale = img.scale

	local tw, th = tex:GetInt "$realwidth", tex:GetInt "$realheight"
	if (scale == true) then
		tw, th = w, h
	else
		tw, th = tw * scale, th * scale
	end

	local xdur = 1 / img.speed.x
	local ydur = 1 / img.speed.y

	local su, sv = (CurTime() + rand.x * xdur % xdur) / xdur, (CurTime() + rand.y * ydur % ydur) / ydur

	if (su ~= su) then
		su = 0
	end
	if (sv ~= sv) then
		sv = 0
	end

	local eu, ev = su + w / tw, sv + h / th

	if (img.rotate and img.rotate ~= 0) then
		su, sv = (su - 0.5), (sv - 0.5)
		eu, ev = (eu - 0.5), (ev - 0.5)

		local rdur = 360 / img.rotate
		local rot =  ((CurTime() + rand.rotate * rdur) % rdur) / rdur * math.pi * 2
		local s = math.sin(rot)
		local c = math.cos(rot)


		local nsu = su * c - sv * s
		local nsv = su * s + sv * c

		local neu = eu * c - ev * s
		local nev = eu * s + ev * c

		su, sv = (nsu + 0.5), (nsv + 0.5)
		eu, ev = (neu + 0.5), (nev + 0.5)
	end


	local col = 150
	surface.SetDrawColor(col, col, col)
	surface.SetMaterial(tex)
	surface.DrawTexturedRectUV(x, y, w, h, su, sv, eu, ev)

	return true
end

--[[
	create render target
	clear 0 0 0 0
	override alpha write enable
	override color write disable

	draw model

	material with $alphatest set $basetexture to rendertarget

	create new rendertarget
]]
local function ceilpow2(x)
	return 2 ^ math.ceil(math.log(x) / math.log(2))
end

local function GetRTForSize(w, h, which)
	local cw, ch = ceilpow2(w), ceilpow2(h)
	local rt = GetRenderTarget("pluto_rt_" .. cw .. "x" .. ch .. "x" .. (which or 0), cw, ch)
	return rt, cw, ch
end

local err = ClientsideModel "error"
err:SetNoDraw(true)

local function CreateTextureFromDraw(w, h, draw)
	local rt, cw, ch = GetRTForSize(w, h)

	render.PushRenderTarget(rt)
	render.Clear(0, 255, 0, 255, true, true)

	render.SetStencilWriteMask(0xFF)
	render.SetStencilTestMask(0xFF)
	render.SetStencilReferenceValue(0)
	render.SetStencilCompareFunction(STENCIL_ALWAYS)
	render.SetStencilPassOperation(STENCIL_KEEP)
	render.SetStencilFailOperation(STENCIL_KEEP)
	render.SetStencilZFailOperation(STENCIL_KEEP)

	render.SetStencilEnable(true)
		render.SetStencilReferenceValue(1)
		render.SetStencilCompareFunction(STENCIL_ALWAYS)
		render.SetStencilPassOperation(STENCIL_REPLACE)
		
		draw()
		
		render.SetStencilCompareFunction(STENCIL_NOTEQUAL)
		render.SetStencilPassOperation(STENCIL_KEEP)

		render.ClearBuffersObeyStencil(0, 0, 0, 0, true)

		render.SetStencilCompareFunction(STENCIL_EQUAL)
		render.ClearBuffersObeyStencil(255, 255, 255, 255, true)
	render.SetStencilEnable(false)
	render.PopRenderTarget(rt)

	return rt, w / cw, h / ch
end

local alphatest = CreateMaterial("pluto_alphatest", "UnlitGeneric", {
	["$alphatest"] = 1,
})

local additive = Material "pp/add"

local cached = {}
local function GetCachedMaterial(mat)
	if (not cached[mat]) then
		cached[mat] = Material(mat)
	end
	return cached[mat]
end

local function ColorModulateForBackground(col)
	local h, s, v = ColorToHSV(col)

	return HSVToColor(h, s, v / 5 * 4)
end

local PANEL = {}

local default_color = Color(53, 53, 60)
function PANEL:Init()
	hook.Add("PlutoItemUpdate", self, self.PlutoItemUpdate)
	self:SetSize(56, 56)

	self.OuterBorder = self:Add "ttt_curved_panel"
	self.OuterBorder:Dock(FILL)
	self.OuterBorder:SetColor(Color(95, 96, 102))
	self.OuterBorder:DockPadding(1, 1, 1, 1)
	self.OuterBorder:SetMouseInputEnabled(false)

	self.InnerBorder = self.OuterBorder:Add "ttt_curved_panel"
	self.InnerBorder:Dock(FILL)
	self.InnerBorder:SetColor(Color(41, 43, 54))
	self.InnerBorder:DockPadding(1, 1, 1, 1)
	self.InnerBorder:SetMouseInputEnabled(false)

	self.ItemPanel = self.InnerBorder:Add "EditablePanel"
	self.ItemPanel:Dock(FILL)
	self.ItemPanel:DockPadding(1, 1, 1, 1)
	self.ItemPanel:SetMouseInputEnabled(false)

	self.ItemPanel.Paint = function(s, w, h, x, y)
		self:PaintInner(s, w, h, x, y)
	end

	self:SetCurve(4)
	self:SetMouseInputEnabled(true)
end

local newshard = Material "pluto/newshard.png"
local newshardadd = Material "pluto/newshardbg.png"
local lock = Material "icon16/lock.png"

function PANEL:DrawItemBackground(x, y, sx, sy, w, h)
	if (DrawMovingTexture(self.Item, x, y, w, h)) then
		return
	end

	local col1, col3 = self.Item:GetGradientColors()
	local col2 = ColorLerp(0.5, col1, col3)

	render.SetMaterial(mat_white)
	mesh.Begin(MATERIAL_TRIANGLES, 2)
		mesh.Color(col2.r, col2.g, col2.b, col2.a)
		mesh.Position(Vector(sx, sy))
		mesh.AdvanceVertex()

		mesh.Color(col2.r, col2.g, col2.b, col2.a)
		mesh.Position(Vector(sx + w, sy + h))
		mesh.AdvanceVertex()

		mesh.Color(col1.r, col1.g, col1.b, col1.a)
		mesh.Position(Vector(sx, sy + h))
		mesh.AdvanceVertex()

		mesh.Color(col2.r, col2.g, col2.b, col2.a)
		mesh.Position(Vector(sx, sy))
		mesh.AdvanceVertex()

		mesh.Color(col3.r, col3.g, col3.b, col3.a)
		mesh.Position(Vector(sx + w, sy))
		mesh.AdvanceVertex()

		mesh.Color(col2.r, col2.g, col2.b, col2.a)
		mesh.Position(Vector(sx + w, sy + h))
		mesh.AdvanceVertex()
	mesh.End()
end

function PANEL:DrawItemOverlay(x, y, sx, sy, w, h)
	if (not self.Item or not self.Item:GetOverlayFunction()) then
		return
	end

	self.Item:GetOverlayFunction()(x, y, sx, sy, w, h, 0)
end

function PANEL:PaintGradientBorder(x, y, sx, sy, w, h, bordercol)
	local outlinesize = 2
	surface.SetDrawColor(self.Item:GetColor())
	ttt.DrawCurvedRect(x, y, w, h, self:GetCurve())

	sx = sx + outlinesize
	sy = sy + outlinesize
	w = w - outlinesize * 2
	h = h - outlinesize * 2
	
	render.SetStencilWriteMask(0xFF)
	render.SetStencilTestMask(0xFF)
	render.SetStencilReferenceValue(0)
	render.SetStencilCompareFunction( STENCIL_ALWAYS)
	render.SetStencilPassOperation(STENCIL_KEEP)
	render.SetStencilFailOperation(STENCIL_KEEP)
	render.SetStencilZFailOperation(STENCIL_KEEP)
	render.ClearStencil()

	render.SetStencilEnable(true)
		render.SetStencilReferenceValue(1)
		render.SetStencilCompareFunction(STENCIL_ALWAYS)
		render.SetStencilPassOperation(STENCIL_REPLACE)
		
		render.OverrideColorWriteEnable(true, false)
			ttt.DrawCurvedRect(x + outlinesize, y + outlinesize, w, h, self:GetCurve())
		render.OverrideColorWriteEnable(false)
		render.SetStencilCompareFunction(STENCIL_EQUAL)
		render.SetStencilPassOperation(STENCIL_KEEP)

		self:DrawItemBackground(x + outlinesize, y + outlinesize, sx, sy, w, h)
		self:DrawItemOverlay(x + outlinesize, y + outlinesize, sx, sy, w, h)
	render.SetStencilEnable(false)
end

function PANEL:PaintInner(pnl, w, h, x, y)
	x = x or 0
	y = y or 0

	local sx, sy = x, y
	if (IsValid(pnl)) then
		sx, sy = pnl:LocalToScreen(x, y)
		sx = sx
		sy = sy
		surface.SetDrawColor(default_color)
		ttt.DrawCurvedRect(x, y, w, h, self:GetCurve())
	end


	if (not self.Item or self == pluto.ui.realpickedupitem and IsValid(pnl)) then
		return
	end

	self:PaintGradientBorder(x, y, sx, sy, w, h, Color(252, 68, 152))

	local r, g, b = render.GetColorModulation()

	cam.IgnoreZ(true)
	render.ClearDepth()
	local mdl = self:GetCachedCurrentModel()
	

	render.SetColorModulation(1, 1, 1)
	if (IsValid(mdl) and self.Item.Type == "Weapon") then

		local mins, maxs = mdl:GetModelBounds()
		local lookup = weapons.GetStored(self.Item.ClassName).Ortho or baseclass.Get(self.Item.ClassName).Ortho or {0, 0}

		local angle = lookup.angle or Angle(0, -90)
		local size = mins:Distance(maxs) / 2.5 * (lookup.size or 1) * 1.1

		local tex, u, v = CreateTextureFromDraw(w, h, function()
			cam.Start3D(vector_origin, angle, 90, 0, 0, w, h)
				cam.StartOrthoView(lookup[1] + -size, lookup[2] + size, lookup[1] + size, lookup[2] + -size)
					render.SuppressEngineLighting(true)
						mdl:SetAngles(Angle(-40, 10, 10))
						render.PushFilterMin(TEXFILTER.ANISOTROPIC)
						render.PushFilterMag(TEXFILTER.ANISOTROPIC)
							mdl:DrawModel()
						render.PopFilterMag()
						render.PopFilterMin()
					render.SuppressEngineLighting(false)
				cam.EndOrthoView()
			cam.End3D()
		end)

		local rt, cw, ch = GetRTForSize(w, h, 1)
		alphatest:SetTexture("$basetexture", tex)

		render.PushRenderTarget(rt)
			render.Clear(0, 0, 0, 255, true, true)
			local big = 2
			cam.Start2D()
				for x = -big, big do
					for y = -big, big do
						surface.SetMaterial(alphatest)
						surface.SetDrawColor(255, 255, 255)
						surface.DrawTexturedRectUV(x, y, w, h, 0, 0, u, v)
					end
				end
			cam.End2D()
			render.BlurRenderTarget(rt, 5, 5, 4)
		render.PopRenderTarget()

		additive:SetTexture("$basetexture", rt)
		additive:SetVector("$color", self.Item:GetColor():ToVector())
		surface.SetMaterial(additive)
		surface.DrawTexturedRectUV(x, y, w, h, 0, 0, u, v)

		
		render.ClearDepth()
		cam.Start3D(vector_origin, angle, 90, sx, sy, w, h)
			cam.StartOrthoView(lookup[1] + -size, lookup[2] + size, lookup[1] + size, lookup[2] + -size)
				render.SuppressEngineLighting(true)
					mdl:SetAngles(Angle(-40, 10, 10))
					render.PushFilterMin(TEXFILTER.ANISOTROPIC)
					render.PushFilterMag(TEXFILTER.ANISOTROPIC)
						mdl:DrawModel()
					render.PopFilterMag()
					render.PopFilterMin()
				render.SuppressEngineLighting(false)
			cam.EndOrthoView()
		cam.End3D()

	elseif (IsValid(mdl) and self.Item.Type == "Model") then
		local mins, maxs = mdl:GetModelBounds()
		cam.Start3D(Vector(50, 0, (maxs.z - mins.z) / 2), Angle(0, -180), 90, sx, sy, w, h)
			render.SuppressEngineLighting(true)

				mdl:SetAngles(Angle(0, (30 * CurTime()) % 360))
				mdl:DrawModel()

			render.SuppressEngineLighting(false)
		cam.End3D()
	elseif (self.Item.Type == "Shard") then
		local RealColor, AddColor = pluto.inv.colors(self.Item.Color or Color(255, 255, 255))
		newshard:SetVector("$color", RealColor:ToVector())
		newshardadd:SetVector("$color", AddColor:ToVector())
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(newshard)
		surface.DrawTexturedRect(x, y, w, h)
		surface.SetMaterial(newshardadd)
		surface.DrawTexturedRect(x, y, w, h)
	end
	render.SetColorModulation(r, g, b)
	cam.IgnoreZ(false)

	if (self.Item.Locked) then
		surface.SetDrawColor(color_white)
		surface.SetMaterial(lock)
		surface.DrawTexturedRect(x + w - 15, y + 5, 10, 10)
	end

	if (self.Item.constellations) then
		surface.SetDrawColor(color_white)
		surface.SetMaterial(pluto.getsuntexture(0))
		surface.DrawTexturedRect(x + 3, y + 3, 12, 12)
	end
end

function PANEL:SetCurve(curve)
	self.InnerBorder:SetCurve(curve)
	self.OuterBorder:SetCurve(curve)
	self.Curve = curve / 2
end

function PANEL:GetCurve()
	return self.Curve or 0
end

function PANEL:SetItem(item)
	if (item ~= self.Item) then
		self:RemoveShowcase()
	end

	self.Item = item

	if (item) then
		self:SetCursor "hand"
	else
		self:SetCursor "arrow"
	end

	self:OnSetItem(item)
end

function PANEL:GetItem()
	return self.Item
end

function PANEL:OnSetItem(item)
end

function PANEL:GetCurrentModel()
	local item = self.Item
	if (not item) then
		return
	end

	if (item.Type == "Weapon") then
		local class = baseclass.Get(item.ClassName)
		return class.PlutoModel or class.WorldModel
	elseif (item.Type == "Model") then
		return item.Model.Model
	end
end

function PANEL:GetCurrentModelMaterial()
	local item = self.Item
	if (not item) then
		return
	end

	if (item.Type == "Weapon") then
		local class = baseclass.Get(item.ClassName)
		return class.PlutoMaterial
	end
end

function PANEL:SetUpdateFrom(tabid, tabidx)
	self.TabID, self.TabIndex = tabid, tabidx
end

function PANEL:PlutoItemUpdate(item, tabid, tabindex)
	local had_showcase = false
	if (self.Item == item and IsValid(self.Showcase)) then
		self:RemoveShowcase()
		had_showcase = true
	end

	local tab = pluto.cl_inv[tabid]
	if (tab and tab.Type == "buffer") then
		return
	end

	if (self.TabID and self.TabIndex and self.Item == item and (tabid ~= self.TabID or tabindex ~= self.TabIndex)) then
		self:SetItem()
	elseif (had_showcase) then
		self:StartShowcase()
	end

	if (self.TabID and self.TabIndex and tabid == self.TabID and tabindex == self.TabIndex) then
		self:SetItem(item)
	end
end

function PANEL:GetCachedCurrentModel()
	local mdl = self:GetCurrentModel()
	if (not mdl) then
		return
	end

	mdl = pluto.cached_model(mdl, self.Item.Type)
	local mat = self:GetCurrentModelMaterial()

	if (IsValid(mdl) and mat) then
		mdl:SetMaterial(mat)
	elseif (IsValid(mdl)) then
		mdl:SetMaterial()
	end

	if (self.Item.Type == "Model") then
		pluto.updatemodel(mdl, self.Item)
	end

	return mdl
end

function PANEL:SetCanPickup(b)
	self.CanPickup = b
end

function PANEL:RemoveShowcase()
	if (IsValid(self.Showcase)) then
		self.Showcase:Remove()
	end
end

function PANEL:StartShowcase()
	if (IsValid(self.Showcase) or not self.Item) then
		return
	end

	self.Showcase = pluto.ui.showcase(self.Item)

	local x, y = self:LocalToScreen(self:GetWide(), 0)
	if (x + self.Showcase:GetWide() > ScrW()) then
		x = self:LocalToScreen(0) - self.Showcase:GetWide()
	end
	if (y + self.Showcase:GetTall() > ScrH()) then
		y = ScrH() - self.Showcase:GetTall()
	end
	self.Showcase:SetPos(x, y)
end

function PANEL:OnMousePressed(m)
	if (self.CanPickup and m == MOUSE_LEFT and not IsValid(pluto.ui.pickedupitem) and self.Item) then
		pluto.ui.pickupitem(self)
	elseif (m == MOUSE_LEFT and not self.CanPickup) then
		self:OnLeftClick()
	end

	if (m == MOUSE_RIGHT) then
		self:OnRightClick()
	end
end

function PANEL:OnRightClick()
	if (not self.Item) then
		return
	end

	pluto.ui.rightclickmenu(self.Item, function(menu, item)
		if (self.TabIndex) then
			menu:AddOption("Equip", function()
				pluto.inv.equip(item)
			end):SetIcon "icon16/add.png"
		end
	end)
end

function PANEL:OnLeftClick()
end

function PANEL:OnCursorEntered()
	self:StartShowcase()
end

function PANEL:OnCursorExited()
	self:RemoveShowcase()
end

function PANEL:Dropdown()
end

function PANEL:CanClickOn(other)
	return true
end

function PANEL:CanClickWith(other)
	return true
end

function PANEL:ClickedOn(other)
end

function PANEL:ClickedWith(other)
	if (not self.TabID or not other.TabID) then
		return
	end

	pluto.inv.message()
		:write("tabswitch", self.TabID, self.TabIndex, other.TabID, other.TabIndex)
		:send()

	local item = self.Item
	self:SetItem(other.Item)
	other:SetItem(item)
end

function PANEL:OnRemove()
	self:RemoveShowcase()
end

function PANEL:GetPickupSize()
	return self.ItemPanel:GetSize()
end

vgui.Register("pluto_inventory_item", PANEL, "EditablePanel")

function pluto.ui.unsetpickup()
	if (IsValid(pluto.ui.pickedupitem)) then
		pluto.ui.pickedupitem:Remove()
		pluto.ui.pickedupitem = nil
		pluto.ui.realpickedupitem = nil
	end
end

function pluto.ui.pickupitem(item)
	local itemdata, tabid, tabidx, clickedon, clickedwith, canclickon, canclickwith

	if (IsValid(item)) then
		itemdata, tabid, tabidx = item.Item, item.TabID, item.TabIndex
		clickedon, clickedwith = item.ClickedWithReal or item.ClickedWith, item.ClickedOnReal or item.ClickedOn
		canclickon, canclickwith = item.CanClickOn, item.CanClickWith
	end

	pluto.ui.unsetpickup()

	if (itemdata) then
		pluto.ui.realpickedupitem = item
		pluto.ui.pickedupitem = vgui.Create "pluto_inventory_item"
		local p = pluto.ui.pickedupitem
		p:SetPaintedManually(true)
		p:SetItem(itemdata)

		p.CanClickOn = canclickon
		p.CanClickWith = canclickwith
		p.TabID, p.TabIndex = tabid, tabidx
		p.ClickedWithReal = clickedwith
		p.ClickedOnReal = clickedon

		function p:ClickedOn(other)
			if (IsValid(item) and other ~= item and item.TabID == tabid and item.TabIndex == tabidx) then
				self.ClickedOnReal(item, other)
			end
		end


		function p:ClickedWith(other)
			if (IsValid(item) and other ~= item and item.TabID == tabid and item.TabIndex == tabidx) then
				self.ClickedWithReal(item, other)
			end
		end


		local start = CurTime()
		hook.Add("Think", p, function(self)
			if (start > CurTime() - 0.1) then
				if (not input.IsMouseDown(MOUSE_LEFT)) then
					hook.Remove("Think", p)
				end
				return
			end

			-- TODO(meep): drag
		end)

		return p
	end
end

hook.Add("PostRenderVGUI", "pluto_item_pickup", function()
	if (not IsValid(pluto.ui.pickedupitem)) then
		return
	end

	local w, h = pluto.ui.pickedupitem:GetPickupSize()
	local x, y = gui.MousePos()
	x = x - w / 2
	y = y - h / 2

	pluto.ui.pickedupitem:PaintInner(nil, w, h, x, y)
end)

hook.Add("VGUIMousePressAllowed", "pluto_item_pickup", function(m)
	if (not IsValid(pluto.ui.pickedupitem)) then
		return
	end

	local hovered = vgui.GetHoveredPanel()

	if (hovered == pluto.ui.pickedupitem or hovered == pluto.ui.realpickedupitem) then
		pluto.ui.unsetpickup()
		return true
	end

	if (m == MOUSE_LEFT and IsValid(hovered) and hovered.ClassName == "pluto_inventory_item") then
		if (pluto.ui.pickedupitem.ClassName == "pluto_inventory_item") then
			local holding = IsValid(pluto.ui.realpickedupitem) and pluto.ui.realpickedupitem or pluto.ui.pickedupitem

			if (hovered:CanClickWith(holding) and holding:CanClickOn(hovered)) then
				if (hovered.CanPickup and holding.Item) then
					pluto.ui.pickupitem(holding)
				end

				hovered:ClickedWith(holding)
				holding:ClickedOn(hovered)

				if (hovered.CanPickup and holding.Item) then
					return true
				end
			else
				return true
			end
		elseif (pluto.ui.pickedupitem.ClassName == "pluto_inventory_currency_item") then
			pluto.ui.pickedupitem:ItemSelected(hovered.Item)

			if (not input.IsKeyDown(KEY_LSHIFT)) then
				pluto.ui.unsetpickup()
			end
			return true
		end
	end

	if (not hovered.AllowClickThrough) then
		pluto.ui.unsetpickup()
		return true
	end
end)