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

function PANEL:PaintInner(pnl, w, h, x, y)
	x = x or 0
	y = y or 0

	local sx, sy = x, y
	if (IsValid(pnl)) then
		sx, sy = pnl:LocalToScreen(x, y)
		sx = sx - 1
		sy = sy - 1
	end

	if (not self.Item or self == pluto.ui.realpickedupitem and IsValid(pnl)) then
		surface.SetDrawColor(default_color)
		ttt.DrawCurvedRect(x, y, w, h, self:GetCurve())
		return
	end


	surface.SetDrawColor(self.Item:GetColor())
	ttt.DrawCurvedRect(x, y, w, h, self:GetCurve())
	
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
			ttt.DrawCurvedRect(x, y, w, h, self:GetCurve())
		render.OverrideColorWriteEnable(false, true)
		render.SetStencilCompareFunction(STENCIL_EQUAL)
		render.SetStencilPassOperation(STENCIL_KEEP)
		surface.SetMaterial(GetCachedMaterial(self.Item.BackgroundMaterial or "pluto/item_bg.png"))
		surface.SetDrawColor(ColorModulateForBackground(self.Item:GetColor()))
		surface.DrawTexturedRect(x, y, w, h)
	render.SetStencilEnable(false)

	local r, g, b = render.GetColorModulation()

	cam.IgnoreZ(true)
	local mdl = self:GetCachedCurrentModel()

	render.SetColorModulation(1, 1, 1)
	if (IsValid(mdl) and self.Item.Type == "Weapon") then
		local mins, maxs = mdl:GetModelBounds()
		local lookup = weapons.GetStored(self.Item.ClassName).Ortho or baseclass.Get(self.Item.ClassName).Ortho or {0, 0}

		local angle = Angle(0, -90)
		local size = mins:Distance(maxs) / 2.5 * (lookup.size or 1) * 1.1

		cam.Start3D(vector_origin, lookup.angle or angle, 90, sx, sy, w, h)
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
		local RealColor, AddColor = pluto.inv.colors(self.Item.Color)
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
	if (self.Item == item and IsValid(self.Showcase)) then
		self:RemoveShowcase()
		self:StartShowcase()
	end

	if (tabid == self.TabID and tabindex == self.TabIndex) then
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

	pluto.ui.rightclickmenu(self.Item)
	-- derma menu??? idk
end

function PANEL:OnLeftClick()
	-- derma menu??? idk
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