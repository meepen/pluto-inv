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

	self.Item = self.Inner:Add "EditablePanel"
	self.Item:Dock(FILL)
	self.Item:DockMargin(1, 1, 1, 1)
	self.Item:SetMouseInputEnabled(false)

	self.Item.Paint = function(s, w, h)
		self:PaintInner(s, w, h)
	end

	self:SetCurve(4)
	self:SetMouseInputEnabled(true)
end

function PANEL:PaintInner(pnl, w, h)
	if (not self.Item) then
		return
	end

	local mdl = self:GetCachedCurrentModel()
	if (not IsValid(mdl)) then
		return
	end

	surface.SetDrawColor(self.Item:GetColor())
	surface.DrawRect(0, 0, w, h)

	local x, y = pnl:LocalToScreen(0, 0)
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
		cam.Start3D(Vector(50, 0, (maxs.z - mins.z) / 2), Angle(0, -180), 90, x, y, pnl:GetSize())
			render.SuppressEngineLighting(true)

				mdl:SetAngles(Angle(0, (-50 * CurTime()) % 360))
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
end

function PANEL:GetCurrentModel()
	local item = self.Item
	if (not item) then
		return
	end

	if (item.Type == "Weapon") then
		return baseclass.Get(item.ClassName).WorldModel
	elseif (item.Type == "Model") then
		return item.Model.Model
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
	if (IsValid(mdl) and self.PlutoMaterial) then
		mdl:SetMaterial(self.PlutoMaterial)
	elseif (IsValid(mdl)) then
		mdl:SetMaterial()
	end

	if (self.Item.Type == "Model") then
		pluto.updatemodel(mdl, self.Item)
	end

	return mdl
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

function PANEL:OnCursorEntered()
	self:StartShowcase()
end

function PANEL:OnCursorExited()
	self:RemoveShowcase()
end

vgui.Register("pluto_inventory_item", PANEL, "EditablePanel")