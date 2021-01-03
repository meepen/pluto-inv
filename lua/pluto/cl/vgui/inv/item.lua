local PANEL = {}

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
	self.Inner:SetColor(Color(53, 53, 60))
	self.Inner:SetMouseInputEnabled(false)

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

function PANEL:PaintInner(pnl, w, h, x, y)
	if (not self.Item) then
		return
	end

	surface.SetDrawColor(self.Item:GetColor())
	surface.DrawRect(x or 0, y or 0, w, h)

	local mdl = self:GetCachedCurrentModel()
	if (not IsValid(mdl)) then
		return
	end

	if (not x or not y) then
		x, y = pnl:LocalToScreen(0, 0)
	end

	local mins, maxs = mdl:GetModelBounds()

	if (self.Item.Type == "Weapon") then
		local lookup = weapons.GetStored(self.Item.ClassName).Ortho or {0, 0}

		local angle = Angle(0, -90)
		local size = mins:Distance(maxs) / 2.5 * (lookup.size or 1) * 1.1

		cam.Start3D(vector_origin, lookup.angle or angle, 90, x, y, w, h)
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
	elseif (self.Item.Type == "Model") then
		cam.Start3D(Vector(50, 0, (maxs.z - mins.z) / 2), Angle(0, -180), 90, x, y, w, h)
			render.SuppressEngineLighting(true)

				mdl:SetAngles(Angle(0, (30 * CurTime()) % 360))
				mdl:DrawModel()

			render.SuppressEngineLighting(false)
		cam.End3D()
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
	if (self.CanPickup and m == MOUSE_LEFT and not IsValid(pluto.ui.pickedupitem)) then
		pluto.ui.pickupitem(self)
	end

	if (m == MOUSE_RIGHT) then
		print "b"
	end
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

function PANEL:ClickedWith(other)
end

vgui.Register("pluto_inventory_item", PANEL, "EditablePanel")

function pluto.ui.pickupitem(item)
	if (IsValid(pluto.ui.pickedupitem)) then
		pluto.ui.pickedupitem:Dropdown()
		pluto.ui.pickedupitem = nil
	end

	pluto.ui.pickedupitem = item
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

hook.Add("VGUIMousePressAllowed", "pluto_item_pickup", function( m)
	if (not IsValid(pluto.ui.pickedupitem)) then
		return
	end

	local pnl = vgui.GetHoveredPanel()

	if (IsValid(pnl) and pnl.ClassName == "pluto_inventory_item") then
		local other = pluto.ui.pickedupitem
		if (pnl:CanClickWith(other) and other:CanClickOn(pnl)) then
			other:ClickedOn(pnl)
			pnl:ClickedWith(other)
		else
			return true
		end
	end

	pluto.ui.pickupitem(nil)
	return true
end)