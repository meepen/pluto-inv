local PANEL = {}

local default_color = Color(53, 53, 60)
function PANEL:Init()
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

	self.Inner = self.InnerBorder:Add "ttt_curved_panel"
	self.Inner:Dock(FILL)
	self.Inner:SetColor(default_color)
	self.Inner:SetMouseInputEnabled(false)

	local perform = self.Inner.PerformLayout
	function self.Inner.PerformLayout(s, w, h)
		if (IsValid(self.ItemBackground)) then
			self.ItemBackground:Destroy()
		end

		self.ItemBackground = hud.BuildCurvedMesh(s:GetCurve() or 0, 0, 0, w, h, s:GetNoCurveTopLeft(), s:GetNoCurveTopRight(), s:GetNoCurveBottomLeft(), s:GetNoCurveBottomRight(), color_white)
		if (perform) then
			perform(s, w, h)
		end
	end

	self.ItemPanel = self.Inner:Add "EditablePanel"
	self.ItemPanel:Dock(FILL)
	self.ItemPanel:DockMargin(1, 1, 1, 1)
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
local translate = Matrix()
local color_mat = Material "color"

function PANEL:PaintInner(pnl, w, h, x, y)
	if (not self.Item) then
		return
	end

	if (self == pluto.ui.realpickedupitem and IsValid(pnl)) then
		return
	end

	x = x or 0
	y = y or 0

	local sx, sy = x, y
	if (IsValid(pnl)) then
		sx, sy = pnl:LocalToScreen(x, y)
		sx = sx - 1
		sy = sy - 1
	end
	local r, g, b = render.GetColorModulation()

	translate:SetTranslation(Vector(sx, sy))
	color_mat:SetVector("$color", self.Item:GetColor():ToVector())
	render.SetColorMaterial()
	cam.PushModelMatrix(translate)
	self.ItemBackground:Draw()
	cam.PopModelMatrix(translate)

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
	self.Inner:SetCurve(curve)
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
	hook.Add("PlutoItemUpdate", self, self.PlutoItemUpdate)
end

function PANEL:PlutoItemUpdate(item)
	local tab = pluto.cl_inv[self.TabID]
	if (not tab) then
		return
	end

	local cur_item = tab.Items[self.TabIndex]
	if (cur_item ~= item) then
		return
	end

	if (item ~= self.Item) then
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

function PANEL:SetCanPickup()
	self.CanPickup = true
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

	self.Showcase = pluto.ui.newshowcase(self.Item)

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
	if (IsValid(self.ItemBackground)) then
		self.ItemBackground:Destroy()
	end

	self:RemoveShowcase()
end

vgui.Register("pluto_inventory_item", PANEL, "EditablePanel")

function pluto.ui.pickupitem(item)
	local itemdata, tabid, tabidx, clickedon, clickedwith, canclickon, canclickwith

	if (IsValid(item)) then
		itemdata, tabid, tabidx = item.Item, item.TabID, item.TabIndex
		clickedon, clickedwith = item.ClickedWithReal or item.ClickedWith, item.ClickedOnReal or item.ClickedOn
		canclickon, canclickwith = item.CanClickOn, item.CanClickWith
	end

	if (IsValid(pluto.ui.pickedupitem)) then
		pluto.ui.pickedupitem:Remove()
		pluto.ui.pickedupitem = nil
		pluto.ui.realpickedupitem = nil
	end

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
	else
		pluto.ui.realpickedupitem = nil
		pluto.ui.pickedupitem = nil
	end
end

hook.Add("PostRenderVGUI", "pluto_item_pickup", function()
	if (not IsValid(pluto.ui.pickedupitem)) then
		return
	end

	local w, h = pluto.ui.pickedupitem.ItemPanel:GetSize()
	local x, y = gui.MousePos()
	x = x - w / 2
	y = y - h / 2

	pluto.ui.pickedupitem:PaintInner(nil, w, h, x, y)
end)

hook.Add("VGUIMousePressAllowed", "pluto_item_pickup", function(m)
	if (not IsValid(pluto.ui.pickedupitem)) then
		return
	end

	local pnl = vgui.GetHoveredPanel()

	if (pnl == pluto.ui.pickedupitem or pnl == pluto.ui.realpickedupitem) then
		pluto.ui.pickupitem(nil)
		return true
	end


	if (m == MOUSE_LEFT and IsValid(pnl) and pnl.ClassName == "pluto_inventory_item") then
		local other = IsValid(pluto.ui.realpickedupitem) and pluto.ui.realpickedupitem or pluto.ui.pickedupitem
		if (pnl:CanClickWith(other) and other:CanClickOn(pnl)) then
			other:ClickedOn(pnl)
			pnl:ClickedWith(other)

			if (pnl.CanPickup and other.Item) then
				pluto.ui.pickupitem(other)
				return true
			end
		else
			return true
		end
	end

	if (not pnl.AllowClickThrough) then
		pluto.ui.pickupitem(nil)
		return true
	end
end)