pluto.ui = pluto.ui or {}

local pad = 0

local active_text = Color(205, 203, 203)
local inactive_text = Color(130, 130, 136)

local function curve(level)
	return math.ceil((8 + level * 2) / 2)
end
pluto.ui.curve = curve

local bg_color = Color(36, 36, 37)
local light_color = Color(84, 89, 89)

local count = 6

local PANEL = {}

local lock = Material "icon16/lock.png"
local colour = Material "models/debug/debugwhite"
DEFINE_BASECLASS "DImage"

local function ColorToHSL(col)
	local r = col.r / 255
	local g = col.g / 255
	local b = col.b / 255
	local max = math.max(r, g, b)
	local min = math.min(r, g, b)
	local d = max - min

	local h
	if (d == 0) then 
		h = 0
	elseif (max == r) then
		h = (g - b) / d % 6
	elseif (max == g) then
		h = (b - r) / d + 2
	elseif (max == b) then
		h = (r - g) / d + 4
	end
	local l = (min + max) / 2
	local s = d == 0 and 0 or d / (1 - math.abs(2 * l - 1))

	return h * 60, s, l
end

local function hue2rgb(p, q, t)
	if (t < 0) then
		t = t + 1
	elseif (t > 1) then
		t = t - 1
	end

	if (t < 1 / 6) then
		return p + (q - p) * 6 * t
	end

	if (t < 0.5) then
		return q
	end

	if (t < 2 / 3) then
		return p + (q - p) * (2 / 3 - t) * 6
	end

	return p
end

local function HSLToColor(h, s, l)
	local c = (1 - math.abs(2 * l - 1)) * s
	local hp = h / 60.0
	local x = c * (1 - math.abs((hp % 2) - 1))
	local rgb1;
	if (h ~= h) then
		rgb1 = {[0] = 0, 0, 0}
	elseif (hp <= 1) then
		rgb1 = {[0] = c, x, 0}
	elseif (hp <= 2) then
		rgb1 = {[0] = x, c, 0}
	elseif (hp <= 3) then
		rgb1 = {[0] = 0, c, x}
	elseif (hp <= 4) then
		rgb1 = {[0] = 0, x, c}
	elseif (hp <= 5) then
		rgb1 = {[0] = x, 0, c}
	elseif (hp <= 6) then
		rgb1 = {[0] = c, 0, x}
	end
	local m = l - c * 0.5;
	return Color(
		math.Round(255 * (rgb1[0] + m)),
		math.Round(255 * (rgb1[1] + m)),
		math.Round(255 * (rgb1[2] + m))
	)
end

local function Brightness(col)
	local r, g, b = col.r / 255, col.g / 255, col.b / 255

	return math.sqrt(r * r * 0.241 + g * g * 0.691 + b * b * 0.068)
end

function pluto.inv.colors(col)
	local _h, s, l = ColorToHSL(col)
	s = math.Clamp(s, 0, 0.6)
	l = 0.5
	local col = HSLToColor(_h, s, l)

	_h, s, l = ColorToHSL(col)
	local num = (math.Clamp(Brightness(col), 0.25, 0.75) - 0.25) * 2
	return col, HSLToColor(_h, s + num * 0.3, l + 0.3)
end

function PANEL:Init()
	self.Random = math.random()
	self:SetKeyboardInputEnabled(false)
	self:SetMouseInputEnabled(false)

	self:SetCurve(2)
	self:SetColor(Color(0,0,0,0))
end

local newshard = Material "pluto/newshard.png"
local newshardadd = Material "pluto/newshardbg.png"

function PANEL:SetShard()
	self.RealImage = newshard
	self.RealImageAdd = newshardadd
	self.RealColor, self.AddColor = pluto.inv.colors(self.Item.Color)

	local h, s, v = ColorToHSL(self.RealColor)

	self.RealColor = HSLToColor(h, 0.4, v)
end

function PANEL:SetItem(item)
	self.PlutoMaterial = nil
	self.Item = item
	if (IsValid(self.Model)) then
		self.Model = nil
	end

	self.RealImage = nil

	if (not item) then
		self.MaterialColor = nil
		self.Type = nil
		self:SetColor(Color(0,0,0,0))
		return
	end

	self.Type = item.Type

	local maincol, matcol = pluto.inv.colors(item.Color or color_white)
	self:SetColor(maincol)

	self.MaterialColor = matcol:ToVector()

	if (self.Type == "Weapon") then
		self:SetWeapon(item)
	elseif (self.Type == "Model") then
		self:SetModel(item)
	elseif (self.Type == "Shard") then
		self:SetShard()
	else
		pwarnf("Unknown type: %s", tostring(self.Type))
		return
	end
end

pluto.ui_cache = pluto.ui_cache or {}

function pluto.cached_model(mdl)
	local m = pluto.ui_cache[mdl]
	if (not m or not IsValid(m)) then
		m = ClientsideModel(mdl)
		m:SetNoDraw(true)
		pluto.ui_cache[mdl] = m
	end
	return m
end

local mech_bg = Material "pluto/item_bg_mech.png"
local item_bg = Material "pluto/item_bg_real.png"
local model_bg = Material "pluto/bg_paint7.png"

function PANEL:SetWeapon(item)
	local w = baseclass.Get(item.ClassName)
	if (not w) then
		return
	end
	if (item.Crafted) then
		self.Material = mech_bg
	elseif (item.BackgroundMaterial) then
		self.Material = Material(item.BackgroundMaterial)
	else
		self.Material = item_bg
	end

	if (w.PlutoIcon) then
		self.RealImage = Material(w.PlutoIcon)
		self.RealColor = color_white
	else
		self.Model = pluto.cached_model(w.PlutoModel or w.WorldModel)
		self.PlutoMaterial = w.PlutoMaterial
	end

	self.Class = w.ClassName
end

function PANEL:SetModel(item)
	self.Material = model_bg
	local mdl = item.Model
	self.Model = pluto.cached_model(mdl.Model)
	if (IsValid(self.Model)) then
		self.Model:SetNoDraw(true)
		self.Model:ResetSequence(self.Model:LookupSequence "idle_all_01")
	end
end

DEFINE_BASECLASS "ttt_curved_panel"

function PANEL:FullPaint(w, h)
	if (self.norender or pluto.ui.ghost == self:GetParent() and not pluto.ui.ghost.paintover) then
		return
	end

	if (self.RealImage) then
		self.RealImage:SetVector("$color", self.RealColor:ToVector())
		if (self.RealImageAdd) then
			self.RealImageAdd:SetVector("$color", self.AddColor:ToVector())
		end
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(self.RealImage)
		surface.DrawTexturedRect(0, 0, w, h)
		if (self.RealImageAdd) then
			surface.SetMaterial(self.RealImageAdd)
			surface.DrawTexturedRect(0, 0, w, h)
		end
		return
	end

	render.SetStencilWriteMask(1)
	render.SetStencilTestMask(1)
	render.SetStencilReferenceValue(1)
	render.SetStencilCompareFunction(STENCIL_ALWAYS)
	render.SetStencilPassOperation(STENCIL_REPLACE)
	render.SetStencilFailOperation(STENCIL_KEEP)
	render.SetStencilZFailOperation(STENCIL_KEEP)
	render.ClearStencil()

	render.SetStencilEnable(true)
		BaseClass.Paint(self, w, h)

		render.SetStencilPassOperation(STENCIL_KEEP)
		render.SetStencilCompareFunction(STENCIL_EQUAL)
		local r, g, b = render.GetColorModulation()
		render.SetColorModulation(1, 1, 1)
		local err = self.Model
		local typ = self.Type
		local class = self.Class

		if (self.MaterialColor) then
			if (self.Material) then
				self.Material:SetVector("$color", self.MaterialColor)
				surface.SetMaterial(self.Material)
				surface.SetDrawColor(255, 255, 255, err ~= self.DefaultModel and 255 or 1)
				surface.DrawTexturedRect(0, 0, w, h)
			end
		end

		if (not IsValid(err)) then
			err = self.DefaultModel
			typ = self.DefaultType
			class = self.DefaultClass
			render.SetBlend(0.5)
		end

		if (IsValid(err)) then
			if (self.PlutoMaterial) then
				err:SetMaterial(self.PlutoMaterial)
			else
				err:SetMaterial()
			end
			if (typ == "Weapon") then
				local lookup = baseclass.Get(class).Ortho or {0, 0}

				local x, y = self:LocalToScreen(0, 0)
				local mins, maxs = err:GetModelBounds()
				local angle = Angle(0, -90)
				local size = mins:Distance(maxs) / 2.5 * (lookup.size or 1) * 1.1

				cam.Start3D(vector_origin, lookup.angle or angle, 90, x, y, w, h)
					cam.StartOrthoView(lookup[1] + -size, lookup[2] + size, lookup[1] + size, lookup[2] + -size)
						render.SuppressEngineLighting(true)
							err:SetAngles(Angle(-40, 10, 10))
							render.PushFilterMin(TEXFILTER.ANISOTROPIC)
							render.PushFilterMag(TEXFILTER.ANISOTROPIC)
								self:Scissor()
									err:DrawModel()
								render.SetScissorRect(0, 0, 0, 0, false)
							render.PopFilterMag()
							render.PopFilterMin()
						render.SuppressEngineLighting(false)
					cam.EndOrthoView()
				cam.End3D()
			elseif (typ == "Model") then
				local mins, maxs = err:GetModelBounds()
				local x, y = self:LocalToScreen(0, 0)

				cam.Start3D(Vector(50, 0, (maxs.z - mins.z) / 2), Angle(0, -180), 90, x, y, self:GetSize())
					render.SuppressEngineLighting(true)

						err:SetAngles(Angle(0, (-50 * CurTime()) % 360))
						err:DrawModel()

					render.SuppressEngineLighting(false)
				cam.End3D()
			end
		elseif (typ == "Shard") then
			local shard = self.DefaultMaterial
			shard:SetVector("$color", Vector(0.2, 0.2, 0.2))

			surface.DrawTexturedRect(0, 0, w, h)
			surface.SetDrawColor(255, 255, 255, 128)
			surface.SetMaterial(shard)
			surface.DrawTexturedRect(0, 0, w, h)
		end

		render.SetColorModulation(r, g, b)
		render.SetBlend(1)
	render.SetStencilEnable(false)
end

function PANEL:Paint(w, h)
	self:FullPaint(w, h)

	if (self.Item and self.Item.Locked and (pluto.ui.ghost == self:GetParent() and pluto.ui.ghost.paintover or pluto.ui.ghost ~= self:GetParent())) then
		surface.SetDrawColor(color_white)
		surface.SetMaterial(lock)
		surface.DrawTexturedRect(w - 15, 5, 10, 10)
	end
end

function PANEL:SetDefault(class)
	local str
	local type = pluto.inv.itemtype(class)
	if (type == "Weapon") then
		str = baseclass.Get(class).WorldModel
	elseif (type == "Model") then
		str = pluto.models[class:match"model_(.+)"].Model
	elseif (type == "Shard") then
		self.DefaultMaterial = newshard
	end

	if (str) then
		self.DefaultModel = pluto.cached_model(str)

		if (IsValid(self.DefaultModel) and type == "Model") then
			self.DefaultModel:ResetSequence(self.DefaultModel:LookupSequence "idle_all_01")
		end
	end

	self.DefaultType = type
	self.DefaultClass = class
end

function PANEL:OnRemove()
	if (IsValid(self.DefaultModel)) then
		self.DefaultModel:Remove()
	end
end

function PANEL:GetScissor()
	return self:GetParent():GetScissor()
end

vgui.Register("pluto_item", PANEL, "ttt_curved_panel")

local PANEL = {}
DEFINE_BASECLASS "ttt_curved_panel"

function PANEL:Init()
	self:SetColor(Color(78, 88, 88))
	self:SetCurve(2)

	self.Image = self:Add "pluto_item"
	self.Image:Dock(FILL)
	self.Image:SetVisible(false)

	self:SetCursor "arrow"

	hook.Add("PlutoTabUpdate", self, self.PlutoTabUpdate)
	hook.Add("PlutoItemUpdate", self, self.PlutoItemUpdate)
	hook.Add("PlutoItemDelete", self, self.PlutoItemDelete)
end

function PANEL:PlutoItemDelete(item)
	if (self.Item and self.Item.ID == item) then
		self.Tab.Items[self.TabIndex] = nil
		self:SetItem()
	end
end

function PANEL:SetDefault(c)
	self.Image:SetDefault(c)
end

function PANEL:PlutoItemUpdate(item)
	if (self.Tab and self.Item and self.Item.ID == item.ID) then
		self:SetItem(item)
	end
end

function PANEL:PlutoTabUpdate(tabid, tabindex, item)
	if (self.Tab and self.Tab.ID == tabid and self.TabIndex == tabindex) then
		self:SetItem(item)
	end
end

function PANEL:Paint(w, h)
	if (self.norender or pluto.ui.ghost == self and self.paintover) then
		return
	end

	if (not self.Tab.Active) then
		return
	end

	BaseClass.Paint(self, w, h)
end

function PANEL:Showcase(item)
	self.showcasepnl = pluto.ui.showcase(item)
	local x, y = self:LocalToScreen(0, self:GetTall())
	x = math.min(ScrW() - self.showcasepnl:GetWide(), x)
	self.showcasepnl:SetPos(x, y)
	self.showcase_version = item.Version
end

function PANEL:OnRemove()
	if (IsValid(self.showcasepnl)) then
		self.showcasepnl:Remove()
	end
end

function PANEL:SetItem(item, tab)
	if (tab) then
		self.TabID = tab.ID
		self.Tab = tab
	end

	self.Item = item
	self.Image:SetItem(item)
	self:OnSetItem(item)

	if (not item) then
		self:SetCursor "arrow"
		self.Image:SetVisible(self.Image.DefaultType)
		return
	end

	self:SetCursor "hand"
	self.Image:SetVisible(true)
	self.Image:SetItem(item)

	if (IsValid(self.showcasepnl)) then
		self:Showcase(item)
	end
end

function PANEL:OnSetItem(item)
end

function PANEL:OnCursorEntered()
	if (self.Item) then
		self:Showcase(self.Item)
	end
end

function PANEL:OnCursorExited()
	if (IsValid(self.showcasepnl)) then
		self.showcasepnl:Remove()
	end
end

function PANEL:OnMousePressed(code)
	if (self.NoMove) then
		return
	end

	if (self.Item and not IsValid(pluto.ui.ghost)) then
		if (code == MOUSE_LEFT and not self.NoMove) then
			pluto.ui.ghost = self
		elseif (code == MOUSE_RIGHT and self.Item.ID) then
			if (self.Tab and self.Tab.ID == 0) then
				if (self.RightClick) then
					self:RightClick()
				end
				return
			end
			local tabele, t
			for _, tab in pairs(pluto.cl_inv) do
				if (tab.Type == "equip" and IsValid(tab.CurrentElement)) then
					tabele = tab.CurrentElement
					t = tab
					break
				end
			end

			local tabtype = pluto.tabs.equip
			if (not IsValid(tabele) or not tabtype) then
				return
			end
			local rightclick_menu = DermaMenu()
			if (self.Tab.Type ~= "equip") then
				rightclick_menu:AddOption("Equip",function()
					local thistab = pluto.tabs[self.Tab.Type]

					for i = 1, tabtype.size do
						if (tabtype.canaccept(i, self.Item) and (not t.Items[self.TabIndex] or thistab.canaccept(self.TabIndex, t.Items[self.TabIndex]))) then
							self:SwitchWith(tabele.Items[i])
						end
					end
				end):SetIcon("icon16/add.png")
			end

			rightclick_menu:AddOption("Upload item stats", function()
				local StatsRT = GetRenderTarget("ItemStatsRT" .. ScrW() .. "_" ..  ScrH(), ScrW(), ScrH())
				OVERRIDE_DETAILED = true
				local show = pluto.ui.showcase(self.Item)
				pluto.ui.showcasepnl = nil
				show:SetPaintedManually(true)
				local item_name = self.Item:GetPrintName()
				timer.Simple(0, function()
					hook.Add("PostRender", "Upload", function()
						hook.Remove("PostRender", "Upload")
						OVERRIDE_DETAILED = false
						cam.Start2D()
						render.PushRenderTarget(StatsRT)
						if (not pcall(show.PaintManual, show)) then
							Derma_Message("Encountered an error while generating the image! Please try again.", "Upload failed", "Thanks")

							render.Clear(0, 0, 0, 0)
							render.PopRenderTarget(StatsRT)
							cam.End2D()
							show:Remove()
						return end
						local data = render.Capture {
							format = "png",
							quality = 100,
							h = show:GetTall(),
							w = show:GetWide(),
							x = 0,
							y = 0,
							alpha = false,
						}
						render.Clear(0, 0, 0, 0)
						render.PopRenderTarget(StatsRT)
						cam.End2D()
						show:Remove()
						HTTP {
							url = "https://api.imgur.com/3/album",
							method = "post",
							headers = {
								Authorization = "Client-ID 3693fd6ea039830",
							},
							success = function(_, c, _, _)
								local album = util.JSONToTable(c)
								if (not album.success) then
									Derma_Message("Your upload was not successful! Please try again.", "Upload failed", ":(")
									return
								end

								HTTP {
									url = "https://api.imgur.com/3/image",
									method = "post",
									headers = {
										Authorization = "Client-ID 3693fd6ea039830"
									},
									success = function(_, b, _, _)
										b = util.JSONToTable(b)
										if (b.success) then
											Derma_Message("Your picture of your stats has been uploaded and copied to your clipboard!\nYou can now simply paste it anywhere, like our Discord! discord.gg/pluto", "Upload success", "Thanks!")
											SetClipboardText("https://imgur.com/a/" .. album.data.id)
										else
											Derma_Message("Your upload was not successful! Please try again.", "Upload failed", "Thanks")
										end
									end,
									failed = function(a) 
										Derma_Message("Imgur appears to be having some issues, please wait and try again!", "Upload failed", "Ok")
									end,
									parameters = {
										image = util.Base64Encode(data),
										album = album.data.deletehash
									},
								}
							end,
							failed = function(a)
								Derma_Message("Your upload was not successful! Please try again.", "Upload failed", "Ok")
							end,
							parameters = {
								title = string.format("%s's %s", LocalPlayer():Nick(), item_name),
								description = string.format("Taken by %s https://steamcommunity.com/profiles/%s\nDiscord: https://discord.gg/pluto\nWebsite: https://pluto.gg\n\n%s", LocalPlayer():Nick(), LocalPlayer():SteamID64(), self.Item:GetTextMessage()), 
							},
						}
					end)
				end)
			end):SetIcon("icon16/camera.png")

			if (self.Item.Type ~= "Shard") then
				rightclick_menu:AddOption("Toggle locked", function()
					pluto.inv.message()
						:write("itemlock", self.Item.ID)
						:send()
				end):SetIcon("icon16/lock.png")
			end

			if (not self.Item.Locked and self.Item.Nickname) then
				rightclick_menu:AddOption("Remove name (100 hands)", function()
					self.Item.Nickname = nil
					pluto.inv.message()
						:write("unname", self.Item.ID)
						:send()
				end):SetIcon("icon16/cog_delete.png")

			end

			rightclick_menu:Open()
			rightclick_menu:SetPos(input.GetCursorPos())--s
		end
	end
end

function PANEL:SwitchWith(other)
	local i = self.Item
	local o = other.Item
	self:SetItem(o)
	other:SetItem(i)

	pluto.inv.message()
		:write("tabswitch", self.Tab.ID, self.TabIndex, other.Tab.ID, other.TabIndex)
		:send()
end

function PANEL:GhostClick(p, m)
	if (self == p and m == MOUSE_LEFT) then
		pluto.ui.unsetghost()
		return
	end

	if (not p or p.NoMove) then
		return
	end

	if (m == MOUSE_RIGHT) then
		pluto.ui.unsetghost()
		return
	end

	if (m == MOUSE_LEFT and p.ClassName == "pluto_inventory_garbage") then
		if (self.Tab.ID == 0) then
			local p = vgui.Create "pluto_falling_text"
			p:SetText "You cannot delete the buffer items on the bottom row! They will delete themselves"
			p:SetPos(gui.MousePos())
		end
		return self.Tab.ID ~= 0
	end

	if (m == MOUSE_LEFT and p.ClassName == "pluto_inventory_item" and self.Tab) then
		local parent = self
		local gparent = p

		if (self.Tab.ID == 0 and gparent.Tab.ID == 0) then
			return
		end

		if (self.Tab.ID == 0 and gparent.Tab.Items and gparent.Tab.ID ~= 0) then
			local can, err = pluto.canswitchtabs(parent.Tab, gparent.Tab, parent.TabIndex, gparent.TabIndex)

			if (not can) then
				pwarnf("err: %s", err)
				return false
			end

			local oi = gparent.Tab.Items[gparent.TabIndex]

			if (oi) then
				return
			end

			pluto.inv.message()
				:write("claimbuffer", parent.Item.ID, gparent.Tab.ID, gparent.TabIndex)
				:send()

			table.remove(pluto.buffer, parent.TabIndex)

			for i = parent.TabIndex, 5 do
				self:GetParent().Items[i]:SetItem(pluto.buffer[i])
			end

			pluto.ui.unsetghost()
		elseif (gparent.Tab.ID == 0 and gparent.SwitchWith and gparent.Tab.Type) then
			gparent:SwitchWith(self)
		elseif (gparent.Tab.ID ~= 0) then
			local can, err = pluto.canswitchtabs(parent.Tab, gparent.Tab, parent.TabIndex, gparent.TabIndex)

			if (not can) then
				pwarnf("err: %s", err)
				return false
			end
			self:SwitchWith(gparent)
		end
	
		if (self.Item and p ~= self and pluto.ui.ghost) then
			pluto.ui.ghost = self
		else
			pluto.ui.unsetghost()
		end
	end

	return false
end

function PANEL:Think()
	if (self.Item and self.Item.Version ~= self.showcase_version and IsValid(self.showcasepnl)) then
		self:Showcase(self.Item)
	end
end

function PANEL:SetNoMove()
	self.NoMove = true
end

vgui.Register("pluto_inventory_item", PANEL, "ttt_curved_panel")

local PANEL = {}
DEFINE_BASECLASS "pluto_inventory_base"
function PANEL:Init()
	BaseClass.Init(self)
	
	self.Layout = self:Add "DIconLayout"
	self.Layout:Dock(FILL)

	self.Items = {}

	for i = 1, count * count do
		local p = self.Layout:Add "pluto_inventory_item"
		p.TabIndex = i
		self.Items[i] = p
	end
end

function PANEL:PerformLayout(w, h)
	local size = math.Round(w / (count + 2))
	local divide = (w - size * count) / (count + 2)

	for _, item in ipairs(self.Items) do
		item:SetSize(size, size)
	end

	self.Layout:SetSpaceX(divide)
	self.Layout:SetSpaceY(divide)

	self:DockPadding(divide * 1.5, divide * 1.5, divide * 1.5, divide * 1.5)
end

function PANEL:SetTab(tab)
	for i = 1, count * count do
		self.Items[i]:SetItem(tab.Items[i], tab)
	end
end

vgui.Register("pluto_inventory_items", PANEL, "pluto_inventory_base")

local PANEL = {}

function PANEL:SetPlutoModel(m, i)
	self:RemoveWeapon()
	self:SetModel(m.Model)

	pluto.updatemodel(self:GetEntity(), i)

	if (self.WeaponItem) then
		self:SetPlutoWeapon(self.WeaponItem)
	end
end

function PANEL:SetStance(s)
	local seq = self:GetEntity():LookupSequence(s)
	if (seq == -1) then
		return false
	end

	self:GetEntity():ResetSequence(seq)

	self.Stance = s

	return true
end

function PANEL:SetPlutoWeapon(item)
	if (IsValid(self.Weapon)) then
		self.Weapon:Remove()
	end

	if (not item or item.Type ~= "Weapon") then
		self:SetStance "idle_all_01"
		return
	end

	local stored = baseclass.Get(item.ClassName)

	if (not stored) then
		return
	end

	self.WeaponItem = item

	local set = false
	if (stored.HoldType == "ar2") then
		set = self:SetStance "idle_passive"
	end

	if (not set) then
		self:SetStance "idle_all_01"
	end

	self.Weapon = ClientsideModel(stored.WorldModel, stored.RenderGroup)
	if (IsValid(self.Weapon)) then
		self.Weapon:SetNoDraw(true)
		self.Weapon:SetParent(self:GetEntity())
		self.Weapon:AddEffects(EF_BONEMERGE + EF_BONEMERGE_FASTCULL)
		table.Merge(self.Weapon, stored)
		self.Weapon.RenderOverride = self.Weapon.DrawWorldModel
	end
end

function PANEL:PreDrawModel()
	if (IsValid(self.Weapon)) then
		self.Weapon:DrawModel()
	end

	return true
end

function PANEL:LayoutEntity(e)
	if (self.bAnimated) then
		self:RunAnimation()
	end

	if (self.OverrideRotate) then
		local now_x = input.GetCursorPos()
		local last_x = self.LastX or now_x

		e:SetAngles(e:GetAngles() - Angle(0, .3) * (last_x - now_x))

		self.LastX = now_x
	elseif (not self.StopRotate) then
		e:SetAngles(e:GetAngles() - Angle(0, 50) * FrameTime())
	end
end

function PANEL:DragMousePress(mcode)
	if (mcode == MOUSE_RIGHT) then
		self.StopRotate = not self.StopRotate
	elseif (mcode == MOUSE_LEFT) then
		self.OverrideRotate = true
	end
end

function PANEL:DragMouseRelease()
	if (self.OverrideRotate) then
		self.OverrideRotate = false
		self.LastX = nil
	end
end

function PANEL:RemoveWeapon()
	if (IsValid(self.Weapon)) then
		self.Weapon:Remove()
	end
end

DEFINE_BASECLASS "DModelPanel"
function PANEL:OnRemove()
	self:RemoveWeapon()
	BaseClass.OnRemove(self)
end

vgui.Register("PlutoPlayerModel", PANEL, "DModelPanel")

local PANEL = {}
DEFINE_BASECLASS "pluto_inventory_base"
function PANEL:Init()
	BaseClass.Init(self)

	self.Items = {}

	self.Left = self:Add "EditablePanel"
	self.Left:Dock(LEFT)
	self.Right = self:Add "EditablePanel"
	self.Right:Dock(RIGHT)

	for i = 1, 12, 2 do
		local p = self.Left:Add "pluto_inventory_item"
		p.TabIndex = i
		self.Items[i] = p
		p:Dock(TOP)
	end

	for i = 2, 12, 2 do
		local p = self.Right:Add "pluto_inventory_item"
		p.TabIndex = i
		self.Items[i] = p
		p:Dock(TOP)
	end

	self.PlayerModelBG = self:Add "ttt_curved_panel"
	self.PlayerModelBG:SetColor(Color(0,0,0,100))

	self.PlayerModel = self.PlayerModelBG:Add "PlutoPlayerModel"
	self.PlayerModel:Dock(FILL)

	self.PlayerModel:SetPlutoModel(pluto.models.default)
	self.PlayerModel:SetFOV(30)

	self.Items[1]:SetDefault "weapon_ttt_m4a1"
	self.Items[2]:SetDefault "weapon_ttt_pistol"
	self.Items[3]:SetDefault "model_default"
	self.Items[4]:SetDefault "weapon_ttt_crowbar"
	self.Items[5]:SetDefault "weapon_ttt_sticky_grenade"
	self.Items[6]:SetDefault "weapon_ttt_unarmed"
	self.Items[7]:SetDefault "weapon_ttt_magneto"

	self.Items[1].OnSetItem = function(s, i)
		self.PlayerModel:SetPlutoWeapon(i)
	end

	self.Items[3].OnSetItem = function(s, i)
		self.PlayerModel:SetPlutoModel(i and i.Model or pluto.models.default, i)
		self.PlayerModel:SetFOV(30)
	end
end

function PANEL:PerformLayout(w, h)
	local size = math.Round(w / (count + 2))
	local divide = (w - size * count) / (count + 2)
	self.PlayerModelBG:SetTall(h - divide * 3)
	self.PlayerModelBG:SetWide(size * 3.5)
	self.PlayerModelBG:Center()

	for i, item in ipairs(self.Items) do
		item:SetSize(size, size)
		item:DockMargin(0,  i <= 2 and 0 or divide / 2, 0, divide / 2)
	end

	self.Left:SetWide(size)
	self.Right:SetWide(size)

	self:DockPadding(divide * 1.5, divide * 1.5, divide * 1.5, divide * 1)
end

function PANEL:SetTab(tab)
	for i, item in ipairs(self.Items) do
		item:SetItem(tab.Items[i], tab)
	end
end

vgui.Register("pluto_inventory_equip", PANEL, "pluto_inventory_base")

local PANEL = {}
DEFINE_BASECLASS "ttt_curved_panel_outline"

function PANEL:Init()
	self.Image = self:Add "DImage"
	--self.Image:Dock(FILL)
	local paint = self.Image.Paint
	self.Image.Paint = function(self, w, h)
		if (self:GetParent() ~= pluto.ui.ghost or self:GetParent().paintover) then
			paint(self, w, h)
		end
	end
	-- self:SetColor(ColorAlpha(light_color, 200))
	self.Image:SetImage "pluto/currencies/goldenhand.png"
	self:SetCursor "hand"
	self.HoverAnim = 0.05
	self.HoverTime = SysTime() - self.HoverAnim
	self.Hovered = true -- idk whatever
end

function PANEL:OnMousePressed(mouse)
	if (pluto.cl_currency[self.Currency] > 0) then
		local curtype = pluto.currency.byname[self.Currency]
		if (curtype and curtype.NoTarget) then
			if (curtype.ClientsideUse) then
				curtype.ClientsideUse()
			else
				Derma_Query("Really use " .. curtype.Name .. "? " .. curtype.Description, "Confirm use", "Yes", function()
					pluto.inv.message()
						:write("currencyuse", self.Currency)
						:send()
				end, "No", function() end)
			end
		else
			pluto.ui.ghost = self
		end
	end
end

function PANEL:ToggleHover()
	self.HoverTime = SysTime() - self.HoverAnim * (1 - math.Clamp((SysTime() - self.HoverTime) / self.HoverAnim, 0, 1))
	self.Hovered = not self.Hovered
end

function PANEL:GetHoverPercent()
	if (self == pluto.ui.ghost and pluto.ui.ghost.paintover) then
		return 1
	end

	local pct = math.Clamp((SysTime() - self.HoverTime) / self.HoverAnim, 0, 1)
	if (self.Hovered) then
		pct = 1 - pct
	end

	return pct
end

function PANEL:OnCursorExited()
	self:ToggleHover()
	self:OnRemove()
end

function PANEL:OnCursorEntered()
	self:Showcase()
	self:ToggleHover()
end

function PANEL:Think()
	local width_biggening = self:GetWide() / 5
	local size = self:GetWide() - width_biggening + width_biggening * ((pluto.cl_currency[self.Currency] or 0) <= 0 and 0 or self:GetHoverPercent())

	self.Image:SetSize(size, size)
	self.Image:Center()
end

function PANEL:SetCurrency(cur)
	self.Currency = cur
	self.Image:SetImage(pluto.currency.byname[cur].Icon)
end

function PANEL:GhostClick(p)
	if (p.Item) then
		if (not p.Item.ID) then
			-- TODO(meep): popup thingy
			return
		end
		local currency = pluto.currency.byname[self.Currency]

		if (currency and currency.ClientsideUse) then
			currency.ClientsideUse(p.Item)
		else
			pluto.inv.message()
				:write("currencyuse", self.Currency, p.Item)
				:send()
		end
	end
	if (not input.IsKeyDown(KEY_LSHIFT)) then
		pluto.ui.unsetghost()
	end
	return false
end

function PANEL:PaintAt(x, y)
	self.Image:PaintAt(x, y)
end

function PANEL:Showcase()
	self.showcasepnl = pluto.ui.showcase(pluto.currency.byname[self.Currency])
	self.showcasepnl:SetPos(self:LocalToScreen(self:GetWide(), 0))
end

function PANEL:OnRemove()
	if (IsValid(self.showcasepnl)) then
		self.showcasepnl:Remove()
	end
end

vgui.Register("pluto_inventory_currency_image", PANEL, "EditablePanel")

local PANEL = {}

function PANEL:Init()
	self.Background = self:Add "ttt_curved_panel"

	self.Image = self:Add "pluto_inventory_currency_image"

	self.Background:Dock(BOTTOM)
	local pad = 2
	self.Background:DockPadding(pad / 2, pad / 2, pad / 2, pad / 2)
	self.Background:SetCurve(pad)
	self.Background:SetColor(light_color)

	self.Text = self.Background:Add "DLabel"

	self.Text:Dock(FILL)
	self.Text:SetContentAlignment(3)
	self.Text:SetText "0"
end

function PANEL:Think()
	self.Text:SetText(tostring(pluto.cl_currency[self.Currency] or 0))
end

local LastHeight = 0

function PANEL:PerformLayout(w, h)
	self.Background:SetTall(h * 0.7)

	if (LastHeight ~= h) then
		surface.CreateFont("pluto_inventory_currency", {
			font = "Roboto",
			size = math.floor(math.max(h * 0.45, 16) / 2) * 2,
		})
	end

	self.Text:SetFont "pluto_inventory_currency"

	local edge = 0.02
	h = h
	self.Image:SetSize(h * (1 - edge * 2), h * (1 - edge * 2))
	self.Image:SetPos(h * (edge + 0.1), h * edge)
end

function PANEL:SetCurrency(cur)
	self.Currency = cur
	self.Image:SetCurrency(cur)
end

vgui.Register("pluto_inventory_currency", PANEL, "EditablePanel")

local PANEL = {}

DEFINE_BASECLASS "pluto_inventory_base"
function PANEL:Init()
	BaseClass.Init(self)

	self.Layout = self:Add "DIconLayout"
	self.Layout:Dock(FILL)

	self.Currencies = {}

	for _, item in ipairs(pluto.currency.list) do
		if (item.Fake) then
			continue
		end

		local p = self.Layout:Add "pluto_inventory_currency"
		p:SetCurrency(item.InternalName)
		self.Currencies[item.InternalName] = p
	end
end

function PANEL:PerformLayout(w, h)
	local count = 3
	local d = 1
	local size = math.floor(w / (count + d) / count) * count
	local divide = size / (count + 2)

	for _, item in pairs(self.Currencies) do
		item:SetSize(size, size * 0.4)
	end

	self.Layout:SetSpaceX(divide)
	self.Layout:SetSpaceY(divide)

	self:DockPadding(divide * 1.5, divide * 1.5, divide * 1.5, divide * 1.5)
end

function PANEL:SetTab(tab)
end

vgui.Register("pluto_inventory_currencies", PANEL, "pluto_inventory_base")

local PANEL = {}

function PANEL:Init()
	self:SetCurve(4)
	self.Color = outline
end

function PANEL:SetColor(c)
	self.InnerColor = c
end

function PANEL:DrawInner(w, h)
	local curve = self:GetCurve() / 2
	surface.SetDrawColor(self.InnerColor or solid_color)
	surface.DrawRect(curve, curve, w - curve * 2, h - curve * 2)
end

vgui.Register("pluto_inventory_base", PANEL, "ttt_curved_panel_outline")
vgui.Register("pluto_inventory_base_button", table.Copy(PANEL), "ttt_curved_outline_button")

local PANEL = {}
function PANEL:Init()
	self.Tab = self:GetParent().Tab

	if (type(self.Tab.Name) == "string") then
		self:SetText(self.Tab.Name)
	else -- convar
		self:SetText(self.Tab.Name:GetString())
	end
	self:SetFont "pluto_inventory_tab"
	self:SetSkin "tttrw"
	self:DockMargin(pad - 4, 0, pad - 4, 0)

	pluto.ui.pnl:SetKeyboardInputEnabled(true)
end

function PANEL:AllowInput(t)
	local t = self:GetText() .. t
	if (utf8.len(t) > 16) then
		return true
	end
	self:GetParent():SetText(t)
	return false
end

function PANEL:OnFocusChanged(gained)
	if (not gained) then
		self:GetParent():SetText(self:GetText())
		if (type(self.Tab.Name) == "string") then
			pluto.inv.message()
				:write("tabrename", self.Tab.ID, self:GetText())
				:send()
		else
			self.Tab.Name:SetString(self:GetText())
		end

		local p = self:GetParent()
		self:Remove()
		pluto.ui.pnl:SetKeyboardInputEnabled(false)
	end
end

vgui.Register("pluto_inventory_rename_tab", PANEL, "DTextEntry")

local PANEL = {}
DEFINE_BASECLASS "pluto_inventory_base"
function PANEL:Init()
	BaseClass.Init(self)
	self:SetCursor "hand"
	self:SetCurveBottomRight(false)
	self:SetCurveBottomLeft(false)

	self.Text = self:Add "DLabel"
	self.Text:Dock(FILL)
	self.Text:SetContentAlignment(5)
	self.Text:SetZPos(0)
	self.Text:SetTextColor(white_text)
end
function PANEL:SetText(t)
	self.Text:SetText(t)
	surface.SetFont(self.Text:GetFont())
	local w = surface.GetTextSize(t)
	self.Text:SetWide(w + pad * 2)
end
function PANEL:OnMousePressed(key)
	self:DoClick()
	if (key == MOUSE_RIGHT) then
		self.Entry = self:Add "pluto_inventory_rename_tab"
		self.Entry:Dock(FILL)
		self.Entry:SetZPos(1)
		self.Entry:RequestFocus()
	end
end

function PANEL:DoClick()
	self:GetParent():Select(self)
end

function PANEL:DoSelect()
	if (self.Tab) then
		self:GetParent():SetTab(self.Tab)
	end
end

function PANEL:Unselect()
end

local LastHeight = 0

function PANEL:PerformLayout(w, h)
	h = self:GetParent():GetTall()
	if (LastHeight ~= h) then
		LastHeight = h
		surface.CreateFont("pluto_inventory_tab", {
			font = "Lato",
			extended = true,
			size = 18
		})
	end

	self.Text:SetFont "pluto_inventory_tab"

	surface.SetFont(self.Text:GetFont())
	local w = surface.GetTextSize(self.Text:GetText())
	self:SetWide(w + pad * 2)
	self:SetTall(h + 4)
end

function PANEL:SetTab(tab)
	self.Tab = tab
	if (type(tab.Name) == "string") then
		self:SetText(tab.Name)
	else -- convar
		self:SetText(tab.Name:GetString())
	end
	self:SetColor(solid_color)

	if (self:GetParent().Current == self and tab) then
		self:GetParent():SetTab(tab)
	end

	local tabtype = pluto.tabs[tab.Type] or {element = "pluto_invalid_tab"}

	pprintf("Creating tab %s (%s)...", tab.Type, tabtype.element)

	self.Items = self:Add(tabtype.element)

	if (not IsValid(self.Items)) then
		self.Items = self:Add "pluto_invalid_tab"
	end

	self.Items:SetVisible(false)
	self.Items:Dock(TOP)
	self.Items:SetZPos(1)
	self.Items:SetTab(tab)

	tab.CurrentElement = self.Items
	tab.CurrentParent = self

	self.Tab = tab
end

vgui.Register("pluto_inventory_tab", PANEL, "pluto_inventory_base")

local PANEL = {}

function PANEL:Init()
	self.Tabs = {}
	self.CurPos = 0
end

function PANEL:SetTab(tab)
	self:GetParent():SetTab(tab)
end

function PANEL:SetTabs(tabs)
	table.sort(tabs, function(a, b)
		if (a.FakeID or b.FakeID) then
			if (a.FakeID and not b.FakeID) then
				return false
			elseif (b.FakeID and not a.FakeID) then
				return true
			else
				return a.FakeID > b.FakeID
			end
		end
		return a.ID < b.ID
	end)
	for _, tab in ipairs(tabs) do
		self:AddTab("pluto_inventory_tab", tab)
	end
end

local function PerformLayoutHack(self, w, h)
	if (self.OldPerformLayout) then
		self:OldPerformLayout(w, h)
	end

	if (IsValid(self.Before)) then
		self.Position = self.Before.Position + self.Before:GetWide() + pad / 2
	else
		self.Position = 0
	end

	self:GetParent():Recalculate(self)
end

function PANEL:Recalculate(tab)
	tab:SetPos(tab.Position - self.CurPos, 0)
	if (IsValid(tab.Next)) then
		tab.Next.Position = tab.Position + tab:GetWide() + pad / 2
		return self:Recalculate(tab.Next)
	end
end

function PANEL:Select(tab)
	if (IsValid(self.Current)) then
		self.Current:SetColor(inactive_tab)
		self.Current:Unselect()
	end

	self.Current = tab
	if (tab.Position < self.CurPos) then
		self.CurPos = tab.Position
		self:Recalculate(tab)
	end

	if (tab.Position + tab:GetWide() > self.CurPos + self:GetWide()) then
		self:Recalculate(self.Next)
	end

	tab:SetColor(solid_color)

	tab:DoSelect()
end

function PANEL:AddTab(class, tabt)
	local tab = self:Add(class)
	tab:SetTab(tabt)
	tab:SetWide(100)

	table.insert(self.Tabs, tab)
	tab:SetZPos(#self.Tabs)

	tab.Before = self.Last
	if (IsValid(self.Last)) then
		self.Last.Next = tab
	end
	if (not IsValid(self.Next)) then
		self.Next = tab
	else
		tab:SetColor(inactive_tab)
	end
	self.Last = tab

	tab.OldPerformLayout = tab.PerformLayout
	tab.PerformLayout = PerformLayoutHack

	tab:InvalidateLayout(true)

	if (not IsValid(self.Current)) then
		self.Current = tab
		self:Select(tab)
	end

	return tab
end

function PANEL:OnMouseWheeled(delta)
	local totalwide = self.Last.Position + self.Last:GetWide() - self:GetWide()
	if (totalwide < 0) then
		return
	end

	self.CurPos = math.Clamp(self.CurPos - delta * 30, 0, totalwide)

	self:Recalculate(self.Next)
end

vgui.Register("pluto_inventory_tabs", PANEL, "EditablePanel")

local PANEL = {}

function PANEL:Init()
	self:SetCurveBottomLeft(false)
	self:SetCurveBottomRight(false)
	self:SetColor(inactive_tab)
	self:SetWide(20)
end

vgui.Register("pluto_inventory_tab_selector", PANEL, "pluto_inventory_base")

local PANEL = {}

function PANEL:Init()
	self.Tabs = self:Add "pluto_inventory_tabs"
	self.Tabs:Dock(FILL)

	--self.Controller = self:Add "pluto_inventory_tab_selector"
	--self.Controller:Dock(RIGHT)
	--self.Controller:DockMargin(pad / 2, 0, 0, 0)

	self:DockMargin(curve(2), 0, curve(2), 0)
end

function PANEL:SetTab(tab)
	self:GetParent():SetTab(tab)
end

function PANEL:SetTabs(tabs)
	self.Tabs:SetTabs(tabs)
end

vgui.Register("pluto_inventory_tab_controller", PANEL, "EditablePanel")

local PANEL = {}
function PANEL:Init()
	self.Label = self:Add "DLabel"
	self.Label:Dock(FILL)
	self.Label:SetFont "BudgetLabel"
	self.Label:SetText "INVALID TAB"
	self.Label:SetContentAlignment(5)
end

function PANEL:SetTab(tab)
	self.Label:SetText("INVALID TAB: " .. tab.Type)
end

vgui.Register("pluto_invalid_tab", PANEL, "pluto_inventory_base")

local PANEL = {}
DEFINE_BASECLASS "DImage"

function PANEL:OnMousePressed(mouse)
	if (IsValid(pluto.ui.ghost)) then
		if (pluto.ui.ghost.Item and pluto.ui.ghost.Item.Locked) then
			local p = vgui.Create "pluto_falling_text"
			p:SetText "That item is locked!"
			p:SetPos(gui.MousePos())
			return
		end

		-- assume is inventory item
		self.Deleting = {
			TabID = pluto.ui.ghost.TabID,
			TabIndex = pluto.ui.ghost.TabIndex,
			Item = pluto.ui.ghost.Item.ID,
			Time = CurTime(),
			EndTime = CurTime() + 1,
		}
	else
		local p = vgui.Create "pluto_falling_text"
		p:SetText "Hold an item on this to delete it!"
		p:SetPos(gui.MousePos())
	end
end

function PANEL:Think()
	if (IsValid(pluto.ui.ghost) and self.Deleting) then
		if (self.Deleting.EndTime < CurTime()) then

			pluto.inv.message()
				:write("itemdelete", self.Deleting.TabID, self.Deleting.TabIndex, self.Deleting.Item)
				:send()

			pluto.cl_inv[self.Deleting.TabID].Items[self.Deleting.TabIndex] = nil

			hook.Run("PlutoItemDelete", self.Deleting.Item)

			self:StopIfDeleting()
		end
	end
end
function PANEL:StopIfDeleting()
	if (self.Deleting) then
		local pct = (CurTime() - self.Deleting.Time) / (self.Deleting.EndTime - self.Deleting.Time)

		if (pct <= 0.1) then
			local p = vgui.Create "pluto_falling_text"
			p:SetText "Hold the item down to delete it!"
			p:SetPos(gui.MousePos())
		end

		pluto.ui.unsetghost()
		self.Deleting = nil
	end
end

function PANEL:GhostMove(p, x, y, w, h)

	if (self.Deleting) then
		local pct = (CurTime() - self.Deleting.Time) / (self.Deleting.EndTime - self.Deleting.Time)

		x = x + (math.random() - 0.5) * pct * w * 0.25
		y = y + (math.random() - 0.5) * pct * h * 0.25
	end

	return x, y
end

function PANEL:GhostPaint(p, x, y, w, h)
	if (self.Deleting) then
		local pct = (CurTime() - self.Deleting.Time) / (self.Deleting.EndTime - self.Deleting.Time)

		local midx, midy = x + w / 2, y + h / 2

		render.SetScissorRect(midx - w / 2 * pct, midy - h / 2 * pct, midx + w / 2 * pct, midy + h / 2 * pct, true)
		surface.SetDrawColor(255,0,0,200)
		surface.DrawRect(x, y, w, h)
		render.SetScissorRect(0, 0, 0, 0, false)
	end
end

function PANEL:OnMouseReleased(mouse)
	self:StopIfDeleting()
end
function PANEL:OnCursorExited()
	self:StopIfDeleting()
end

function PANEL:Paint(w, h)
	local x, y = 8, 8

	w = w - x * 2
	h = h - y * 2

	local ow, oh = w, h
	local im_w, im_h = self.Image:GetInt "$realwidth", self.Image:GetInt "$realheight"

	if (not im_w) then
		surface.SetDrawColor(0, 255, 0, 255)
		surface.DrawRect(0, 0, w, h)
		return
	end

	if (im_w > im_h) then
		h = h * (im_h / im_w)
		y = y + (oh - h) / 2
	elseif (im_h > im_w) then
		w = w * (im_w / im_h)
		x = x + (ow - w) / 2
	end

	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(self.Image)

	surface.DrawTexturedRect(x, y, w, h)
end

local trash = Material "materials/pluto/trashcan_128.png"

function PANEL:Init()
	self.Image = trash
end

vgui.Register("pluto_inventory_garbage", PANEL, "EditablePanel")

local PANEL = {}

function PANEL:Init()
	self.Garbage = self:Add "pluto_inventory_garbage"
	self.Garbage:Dock(RIGHT)

	self.Items = {}

	self.FakeTab = {
		ID = 0,
		Active = true,
		Items = pluto.buffer,
	}

	for i = 1, 5 do
		local t = self:Add "pluto_inventory_item"
		t:Dock(RIGHT)
		t.TabIndex = i
		t:SetItem(pluto.buffer[i], self.FakeTab)

		self.Items[i] = t
	end

	hook.Add("PlutoBufferChanged", self, self.PlutoBufferChanged)

	self.Items[6] = self.Garbage
end

function PANEL:PlutoBufferChanged()
	for i = 1, 5 do
		self.Items[i]:SetItem(pluto.buffer[i])
		if (self.Items[i] == pluto.ui.ghost) then
			pluto.ui.unsetghost()
		end
	end
end

function PANEL:PerformLayout(w, h)
	local size = math.Round(w / (count + 2))
	local divide = (w - size * count) / (count + 2)

	for i, item in ipairs(self.Items) do
		item:SetSize(size, size)
		local left, right = divide / 2, divide / 2
		if (i == 0) then
			left = 0
		elseif (i == 6) then
			right = 0
		end
		item:DockMargin(left, 0, right, 0)
	end

	self:DockPadding(divide * 1.5, (h - size) / 2, divide * 1.5, (h - size) / 2)
end

vgui.Register("pluto_inventory_bar", PANEL, "pluto_inventory_base")

local PANEL = {}

function PANEL:Init()
	self.Tabs = self:Add "pluto_inventory_tab_controller"
	self.Tabs:Dock(TOP)
	self.Tabs:SetZPos(0)
	self.Close = self:Add "ttt_close_button"
	self.Close:SetSize(24, 24)
	self.Close:SetColor(Color(37, 173, 125))
	function self.Close:DoClick()
		self:GetParent():GetParent():Remove()
	end
end

function PANEL:SetTab(tab)
	if (IsValid(self.Items)) then
		self.Items:SetParent(self.Tab.CurrentParent)
		self.Items:SetVisible(false)
		self.Tab.Active = false
	end

	self.Items = tab.CurrentElement
	self.Items:SetParent(self)
	self.Items:SetVisible(true)

	local old = self.Tab

	self.Tab = tab
	tab.Active = true

	self:GetParent():TabChanged(self, old)
end

function PANEL:SetTabs(tabs, addtrade)
	local t = {}
	for k,v in pairs(tabs) do
		t[k] = v
	end


	if (addtrade) then
		table.insert(t, pluto.tradetab)
		table.insert(t, pluto.crafttab)
		table.insert(t, pluto.questtab)
		table.insert(t, pluto.passtab)
	end

	self.Tabs:SetTabs(t)
end

function PANEL:SetWhere(leftright)
	self.Where = leftright

	if (not self.Where) then
		self.Close:Remove()
	end
end

function PANEL:PerformLayout(w, h)
	local real_h = w * 0.07

	self.Items:SetTall(h - real_h - pad)

	self.Tabs:SetTall(28)

	pad = w * 0.05
	pluto.ui.pad = pad
	local smol_pad = pad * 2 / 3
	if (self.Where ~= nil) then
		self:DockPadding(self.Where and smol_pad or pad, smol_pad, self.Where and pad or smol_pad, 0)
	else
		self:DockPadding(pad, smol_pad, pad, 0)
	end

	if (IsValid(self.Close)) then
		self.Close:SetPos(self:GetWide() - self.Close:GetWide() * 1.5, self.Close:GetWide() * 0.5)
	end
end

vgui.Register("pluto_inventory_control", PANEL, "EditablePanel")

local PANEL = {}
function PANEL:Init()
	self:SetColor(main_color)
	self:SetCurve(6)

	self.Control1 = self:Add "pluto_inventory_control"
	self.Control1:Dock(FILL)
	self.Control1:SetZPos(1)

	local w = math.floor(math.min(500, math.max(400, ScrW() / 3)) / 2) * 2
	local real_w = w
	local h = w * 1.2

	if (ScrW() >= 800) then
		w = math.min(w * 2, ScrW())
		self.Control2 = self:Add "pluto_inventory_control"
		self.Control1:SetWhere(true)
		self.Control2:SetWhere(false)

		local tabs1, tabs2 = {}, {}

		for k, tab in pairs(pluto.cl_inv) do
			local d = tabs1
			if (tab.Type == "equip" or tab.Type == "currency") then
				d = tabs2
			end

			d[#d + 1] = tab
		end

		self.Control1:SetTabs(tabs1)
		self.Control2:SetTabs(tabs2, true)

		self.Control2:Dock(LEFT)
		self.Control2:SetWide(w / 2)
		self.Control2:SetZPos(3)
	else
		self.Control1:SetTabs(pluto.cl_inv, true)
	end

	self:SetSize(w, h)
	self:Center()
	self:InvalidateChildren(true)

	self:MakePopup()
	self:SetPopupStayAtBack(true)
	self:SetKeyboardInputEnabled(false)

	self.Bottom = self:Add "EditablePanel"
	self.Bottom:SetZPos(1)
	self.Bottom:Dock(BOTTOM)
	self.Bottom:SetTall(h * 0.15)
	self.Bottom:InvalidateParent(true)
	pad = real_w * 0.05
	pluto.ui.pad = pad
	local smol_pad = pad * 2 / 3
	self.Bottom:DockPadding(0, smol_pad / 2, 0, smol_pad / 2)

	self.ControlBar = self.Bottom:Add "pluto_inventory_bar"
	self.ControlBar:SetZPos(2)
	self.ControlBar:SetTall(self.Bottom:GetTall() - smol_pad)
	self.ControlBar:SetWide(real_w - pad * 1.5)
	self.ControlBar:Center()

	pluto.inv.message()
		:write("ui", true)
		:send()
end

DEFINE_BASECLASS "pluto_inventory_base"
function PANEL:OnRemove()
	if (BaseClass.OnRemove) then
		BaseClass.OnRemove(self)
	end

	pluto.inv.message()
		:write("ui", false)
		:send()
end

function PANEL:TabChanged(ele, old)
	if (not IsValid(self.Bottom)) then
		return
	end

	if (old and old.Type ~= "trade" and ele.Tab.Type == "trade") then
		self.Bottom:SetZPos(4)
	elseif (old and old.Type == "trade" and ele.Tab.Type ~= "trade") then
		self.Bottom:SetZPos(1)
	end
	self.Bottom:InvalidateParent(true)

	self.ControlBar:Center()
	ele:InvalidateParent(true)
end

vgui.Register("pluto_inventory", PANEL, "pluto_inventory_base")


if (IsValid(pluto.ui.pnl)) then
	pluto.ui.pnl:Remove()
	pluto.ui.pnl = vgui.Create "pluto_inventory"
end

hook.Add("PlayerButtonDown", "pluto_inventory_ui", function(_, key)
	if (IsFirstTimePredicted() and key == KEY_I and pluto.inv.status == "ready") then
		if (IsValid(pluto.ui.pnl)) then
			pluto.ui.pnl:Remove()
		else
			pluto.ui.pnl = vgui.Create "pluto_inventory"
		end
	end
end)

--[[
	item showcase
	shows an item (lol)
]]

local PANEL = {}

function PANEL:Init()
	self.Text = "Label"
	self.Font = "DermaDefault"
	self.Children = {}
	self.Color = white_text
end

function PANEL:AddLine(line)
	local pnl = self:Add "DLabel"
	pnl:SetFont(self.Font)
	pnl:SetTextColor(self.Color)
	pnl:SetText(line)
	pnl:SetContentAlignment(5)
	pnl:Dock(TOP)
	pnl:SetZPos(#self.Children)
	local _, h = surface.GetTextSize(line)
	pnl:SetTall(h)
	self.Tall = self.Tall + h
	table.insert(self.Children, pnl)
end

function PANEL:PerformLayout(w, h)
	self:DoLayout(w, h)
end

function PANEL:DoLayout(_w, _h)
	local text = self.Text or "Label"
	if (self.LastText == text and self.LastWide == _w) then
		return
	end
	self.LastText = text
	self.LastWide = _w
	for _, child in pairs(self.Children) do
		child:Remove()
	end

	self.Children = {}

	local cur = {}
	surface.SetFont(self.Font)
	self.Tall = 0

	local last_newline = false
	for word, spaces in text:gmatch("([^%s]+)(%s*)") do
		cur[#cur + 1] = word
		local w, h = surface.GetTextSize(table.concat(cur, " "))
		if (w > _w or last_newline) then
			if (#cur == 1) then
				self:AddLine(word)
				cur = {}
			else
				cur[#cur] = nil
				self:AddLine(table.concat(cur, " "))
				local w, h = surface.GetTextSize(word)
				if (w > _w) then
					self:AddLine(word)
					cur = {}
				else
					cur = {word}
				end
			end
		end
		last_newline = spaces:find "\n"
	end

	if (#cur > 0) then
		self:AddLine(table.concat(cur, " "))
	end

	self:SetTall(self.Tall)
end

function PANEL:SetTextColor(col)
	self.Color = col
	for _, child in pairs(self.Children) do
		child:SetTextColor(col)
	end
end

function PANEL:SetFont(font)
	self.Font = font
	self:InvalidateLayout(true)
end

function PANEL:SetText(text)
	self.Text = text
	self:DoLayout(self:GetSize())
end

vgui.Register("pluto_centered_wrap", PANEL, "EditablePanel")

local PANEL = {}


function PANEL:AddImplicit(mod_data, item)
	local mod = pluto.mods.byname[mod_data.Mod]

	local z = self.ZPos or 3

	local p = self:Add "DLabel"
	p:SetContentAlignment(5)
	p:SetFont "pluto_item_showcase_impl"
	p:SetZPos(z)
	p:Dock(TOP)

	p:SetTextColor(mod.Color or white_text)
	p:SetText(pluto.mods.formatdescription(mod_data, item))

	self.ZPos = z + 1
	self.Last = pnl

	return p
end

function PANEL:AddMod(mod_data, item)
	local mod = pluto.mods.byname[mod_data.Mod]
	local z = self.ZPos or 3

	local pnl = self:Add "EditablePanel"
	pnl:SetZPos(z)
	pnl:Dock(TOP)

	local p = pnl:Add "DLabel"
	p:SetFont "pluto_item_showcase_smol"
	p:SetText(mod:GetTierName(mod_data.Tier))
	p:SetTextColor(white_text)
	p:Dock(LEFT)
	p:SetContentAlignment(7)
	p:SetZPos(0)

	pnl.Label = p

	local p = pnl:Add "DLabel"
	p:SetFont "pluto_item_showcase_desc"
	p:SetTextColor(white_text)
	p:SetWrap(true)
	p:SetAutoStretchVertical(true)
	p:Dock(RIGHT)
	p:SetZPos(1)

	DEFINE_BASECLASS "DLabel"

	function p:Think()
		local fmt
		if ((OVERRIDE_DETAILED or LocalPlayer():KeyDown(IN_DUCK))) then
			fmt = pluto.mods.format(mod_data, item)
			local minmaxs = pluto.mods.getminmaxs(mod_data, item)

			for i = 1, #fmt do
				fmt[i] = string.format("%s (%s to %s)", fmt[i], minmaxs[i].Mins, minmaxs[i].Maxs)
			end
		end

		local desc = pluto.mods.formatdescription(mod_data, item, fmt)

		if (self.LastDesc ~= desc) then
			self:SetText(desc)
			self:SizeToContentsY()
			self:InvalidateLayout(true)
		end

		BaseClass.Think(self)

		if (self.LastDesc ~= desc) then
			local p = self:GetParent():GetParent()

			p:Resize()
			self.LastDesc = desc
		end
	end

	pnl.Desc = p

	function pnl.Desc:PerformLayout(w, h)
		self:GetParent():SetTall(h)
		--self:GetParent():GetParent():Resize()
	end

	function pnl:PerformLayout(w, h)
		self.Label:SetWide(w / 4)
		self.Desc:SetWide(math.Round(w * 3 / 5))
	end

	self.ZPos = z + 1
	self.Last = pnl

	return pnl
end

function PANEL:SetItem(item)
	self.ItemName:SetTextColor(color_black)
	self.OriginalOwner:SetTextColor(color_black)
	self.Untradeable:SetTextColor(Color(240, 20, 30))
	self.ItemID:SetTextColor(color_black)
	self.Experience:SetTextColor(color_black)
	if (item.GetPrintName) then -- item
		self.ItemName:SetText(item:GetPrintName())
		if (item.Nickname) then
			self.ItemName:SetFont "pluto_item_showcase_header_italic"
		end
		if (item.Type == "Weapon") then
			self.ItemName:SetContentAlignment(4)
		else
			self.ItemName:SetContentAlignment(5)
		end
	else -- currency???
		self.ItemName:SetText(item.Name)
		self.ItemName:SetContentAlignment(5)
	end

	if (item.Untradeable) then
		surface.SetFont(self.Untradeable:GetFont())
		local w, h = surface.GetTextSize "A"
		self.UntradeableBackground:SetTall(h * 1.8)
		self.Untradeable:SetText("Not able to be traded")
		self.Untradeable:SizeToContentsY()
	else
		self.UntradeableBackground:SetTall(0)
	end

	if (item.OriginalOwnerName) then
		surface.SetFont(self.OriginalOwner:GetFont())
		local w, h = surface.GetTextSize "A"
		self.OriginalOwnerBackground:SetTall(h * 1.8)
		self.OriginalOwner:SetText("Originally " .. (item.Crafted and "crafted" or "found") .. " by " .. item.OriginalOwnerName)
		self.OriginalOwner:SizeToContentsY()

		local h, s, l = ColorToHSL(item.Color)
		l = l * 0.85

		self.OriginalOwnerBackground:SetColor(HSLToColor(h, s, l))
	else
		self.OriginalOwnerBackground:SetTall(0)
	end

	if (item.ID) then
		self.ItemID:SetText(item.ID)
	else
		self.ItemID:SetText ""
	end
	self.ItemID:SizeToContentsY()

	if (item.Experience) then
		self.Experience:SetText("EXP: " .. item.Experience)
	else
		self.Experience:SetText ""
	end
	self.Experience:SizeToContentsY()

	self.ItemName:SizeToContentsY()
	self.ItemBackground:SetTall(self.ItemName:GetTall() * 1.5)
	local pad = self.ItemName:GetTall() * 0.25
	self.ItemBackground:DockPadding(pad, pad, pad, pad)
	self.ItemBackground:SetColor(item.Color)

	self.ItemDesc:SetText(item.Description or "")
	local subdesc = item.SubDescription or ""
	if (item.AffixMax) then
		subdesc = subdesc .. "\n" .. "You can get up to " .. item.AffixMax .. " modifiers on this item."
	end

	if (item.ClassName) then
		self.ItemDesc:DockMargin(0, pad, 0, 0)
	else
		self.ItemDesc:DockMargin(0, pad, 0, pad / 2)
	end

	self.ItemSubDesc:SetText(subdesc)
	if (self.ItemSubDesc:GetText() ~= "") then
		self.ItemSubDesc:DockMargin(0, pad / 2, 0, pad)
	end

	self.Last = self.ItemSubDesc

	if (item.Mods and item.Mods.implicit) then
		for _, mod in ipairs(item.Mods.implicit) do
			self:AddImplicit(mod, item):DockMargin(pad, pad / 2, pad, pad / 2)
		end
	end

	if (item.Mods and item.Mods.prefix) then
		for _, mod in ipairs(item.Mods.prefix) do
			self:AddMod(mod, item):DockMargin(pad, pad / 2, pad, pad / 2)
		end
	end

	if (item.Mods and item.Mods.suffix) then
		for _, mod in ipairs(item.Mods.suffix) do
			self:AddMod(mod, item):DockMargin(pad, pad / 2, pad, pad / 2)
		end
	end

	self:Resize()
end

function PANEL:Resize()
	self:InvalidateLayout(true)
	self:InvalidateChildren(true)
	self:SizeToChildren(true, true)
	self:SetTall(self:GetTall() + pad / 2)
	self:GetParent():SizeToChildren(true, true)
end

local h = 720

surface.CreateFont("pluto_item_showcase_header", {
	font = "Lato",
	extended = true,
	size = math.max(30, h / 28),
	weight = 1000,
})

surface.CreateFont("pluto_item_showcase_header_italic", {
	font = "Lato",
	extended = true,
	italic = true,
	size = math.max(30, h / 28),
	weight = 1000,
})

surface.CreateFont("pluto_item_showcase_id", {
	font = "Roboto",
	extended = true,
	size = math.max(10, h / 50),
	weight = 1000,
})

surface.CreateFont("pluto_item_owner_font", {
	font = "Roboto",
	extended = true,
	size = math.max(10, h / 50),
	weight = 1000,
})

surface.CreateFont("pluto_item_showcase_desc", {
	font = "Roboto",
	extended = true,
	size = math.max(20, h / 35)
})

surface.CreateFont("pluto_item_showcase_impl", {
	font = "Roboto",
	extended = true,
	italic = true,
	size = math.max(20, h / 35)
})

surface.CreateFont("pluto_item_showcase_smol", {
	font = "Roboto",
	extended = true,
	size = math.max(h / 50, 16),
	italic = true,
})

surface.CreateFont("pluto_item_chat_smol", {
	font = "Roboto",
	extended = true,
	size = math.max(h / 50, 16),
	italic = true,
})

function PANEL:Init()
	local w = math.min(500, math.max(400, ScrW() / 3))
	pad = w * 0.05
	pluto.ui.pad = pad

	self:SetColor(solid_color)
	self.ItemBackground = self:Add "ttt_curved_panel"
	self.ItemBackground:SetCurve(2)
	self.ItemBackground:Dock(TOP)
	self.ItemBackground:SetCurveBottomLeft(false)
	self.ItemBackground:SetCurveBottomRight(false)

	self.ItemName = self.ItemBackground:Add "DLabel"
	self.ItemName:Dock(FILL)
	self.ItemName:SetFont "pluto_item_showcase_header"

	self.OriginalOwnerBackground = self:Add "ttt_curved_panel"
	self.OriginalOwnerBackground:Dock(TOP)

	self.OriginalOwner = self.OriginalOwnerBackground:Add "DLabel"
	self.OriginalOwner:Dock(FILL)
	self.OriginalOwner:SetFont "pluto_item_owner_font"
	self.OriginalOwner:SetContentAlignment(5)

	self.UntradeableBackground = self:Add "EditablePanel"
	self.UntradeableBackground:Dock(TOP)
	self.UntradeableBackground.Material = stripes

	self.Untradeable = self.UntradeableBackground:Add "DLabel"
	self.Untradeable:Dock(FILL)
	self.Untradeable:SetFont "pluto_item_owner_font"
	self.Untradeable:SetContentAlignment(5)

	self.ItemID = self.ItemName:Add "DLabel"
	self.ItemID:Dock(FILL)
	self.ItemID:SetContentAlignment(3)
	self.ItemID:SetFont "pluto_item_showcase_id"

	self.Experience = self.ItemName:Add "DLabel"
	self.Experience:Dock(TOP)
	self.Experience:SetContentAlignment(9)
	self.Experience:SetFont "pluto_item_showcase_id"

	self.ItemDesc = self:Add "pluto_centered_wrap"
	self.ItemDesc:SetFont "pluto_item_showcase_desc"
	self.ItemDesc:Dock(TOP)

	self.ItemSubDesc = self:Add "pluto_centered_wrap"
	self.ItemSubDesc:SetFont "pluto_item_showcase_smol"
	self.ItemSubDesc:Dock(TOP)
end

vgui.Register("pluto_item_showcase_inner", PANEL, "ttt_curved_panel")

local PANEL = {}

function PANEL:Init()
	self.Inner = self:Add "pluto_item_showcase_inner"
	self.Inner:Dock(FILL)
	self:SetCurve(4)
	self:SetColor(color_black)
	local pad = curve(0) / 2
	self.Inner:SetCurve(pad)
	self:DockPadding(pad, pad, pad, pad)
end

function PANEL:SetItem(item)
	self:SetWide(math.max(300, math.min(600, ScrW() / 3)))
	self.Inner:SetWide(math.max(300, math.min(500, ScrW() / 3)))
	self.Inner:SetItem(item)
end

vgui.Register("pluto_item_showcase", PANEL, "ttt_curved_panel_outline")

function pluto.ui.showcase(item)
	if (IsValid(pluto.ui.showcasepnl)) then
		pluto.ui.showcasepnl:Remove()
	end

	pluto.ui.showcasepnl = vgui.Create "pluto_item_showcase"
	pluto.ui.showcasepnl:MakePopup()
	pluto.ui.showcasepnl:SetKeyboardInputEnabled(false)
	pluto.ui.showcasepnl:SetMouseInputEnabled(false)

	pluto.ui.showcasepnl:SetItem(item)

	return pluto.ui.showcasepnl
end

local PANEL = {}

function PANEL:Init()
	self.Text = self:Add "pluto_centered_wrap"
	self.Text:SetFont "pluto_item_showcase_desc"
	self.Text:Dock(TOP)
	self.Text:SetTextColor(color_white)
	local pad = pad / 2
	self:DockPadding(pad, pad, pad, pad)
	self:SetWide(200)
	function self.Text:PerformLayout(w, h)
		self:SetWide(self:GetParent():GetWide() - pad * 2)
		self:GetParent():SetTall(h + pad * 2)
		self:DoLayout(self:GetSize())
	end
	self.Start = CurTime()
	self.Ends = CurTime() + 2
	self:SetCurve(4)

	self:MakePopup()
	self:SetKeyboardInputEnabled(false)
	self:SetMouseInputEnabled(false)
end

function PANEL:SetText(t)
	self.Text:SetText(t)
end

function PANEL:Think()
	self.OriginalY = self.OriginalY or select(2, self:GetPos())
	local frac = (self.Ends - CurTime()) / (self.Ends - self.Start)
	if (frac <= 0) then
		self:Remove()
	end
	local x, y = self:GetPos()
	self:SetPos(x, self.OriginalY + 100 * (1 - frac))
	self:SetColor(Color(17, 15, 13, frac * 255))
	self.Text:SetTextColor(ColorAlpha(white_text, frac * 255))
end

vgui.Register("pluto_falling_text", PANEL, "ttt_curved_panel")

hook.Add("PreRender", "pluto_ghost", function()
	if (IsValid(pluto.ui.ghost)) then
		local p = pluto.ui.ghost
		local mi, ki = p:IsMouseInputEnabled(), p:IsKeyboardInputEnabled()
		pluto.ui.ghost.paintover = true
		p:PaintAt(p:LocalToScreen(0, 0)) -- this resets mouseinput / keyboardinput???
		pluto.ui.ghost.paintover = false
		p:SetMouseInputEnabled(mi)
		p:SetKeyboardInputEnabled(ki)
	end
end)

hook.Add("PostRenderVGUI", "pluto_ghost", function()
	if (IsValid(pluto.ui.ghost)) then
		local p = pluto.ui.ghost

		if ((input.IsMouseDown(MOUSE_RIGHT) or input.IsMouseDown(MOUSE_LEFT)) and not IsValid(vgui.GetHoveredPanel())) then
			pluto.ui.unsetghost()
			return
		end

		local hover = vgui.GetHoveredPanel()

		local w, h = p:GetSize()
		local x, y = gui.MousePos()
		x = x - w / 2
		y = y - h / 2

		if (IsValid(hover) and hover.GhostMove) then
			x, y = hover:GhostMove(p, x, y, w, h)
		end

		local b

		if (p.SetScissor) then
			b = p:GetScissor()
			p:SetScissor(false)
		end

		local mi, ki = p:IsMouseInputEnabled(), p:IsKeyboardInputEnabled()

		pluto.ui.ghost.paintover = true
		p:PaintAt(x, y) -- this resets mouseinput / keyboardinput???
		pluto.ui.ghost.paintover = false
		p:SetMouseInputEnabled(mi)
		p:SetKeyboardInputEnabled(ki)

		if (IsValid(hover) and hover.GhostPaint) then
			hover:GhostPaint(p, x, y, w, h)
		end

		if (p.SetScissor) then
			p:SetScissor(b)
		end
	end
end)


function pluto.inv.remakefake()
	pluto.tradetab = {
		Type = "trade",
		Name = CreateConVar("pluto_tradetab_name", "Trade", {FCVAR_UNLOGGED, FCVAR_ARCHIVE}, "Trade tab name"),
		ID = 0,
		Items = {},
		Currency = {},
		FakeID = 2,
	}

	pluto.crafttab = {
		Type = "craft",
		Name = CreateConVar("pluto_crafttab_name", "Craft", {FCVAR_UNLOGGED, FCVAR_ARCHIVE}, "Craft tab name"),
		ID = 0,
		Items = {},
		Currency = {},
		FakeID = 1,
	}

	pluto.questtab = {
		Type = "quest",
		Name = CreateConVar("pluto_questtab_name", "Quests", {FCVAR_UNLOGGED, FCVAR_ARCHIVE}, "Quest tab name"),
		ID = 0,
		Items = {},
		Currency = {},
		FakeID = 3,
	}

	pluto.passtab = {
		Type = "pass",
		Name = CreateConVar("pluto_passtab_name", "Mara's Request", {FCVAR_UNLOGGED, FCVAR_ARCHIVE}, "Pass tab name"),
		ID = 0,
		Items = {},
		Currency = {},
		FakeID = 4,
	}
end

pluto.inv.remakefake()

hook.Add("VGUIMousePressAllowed", "pluto_ghost", function(mouse)
	if (IsValid(pluto.ui.ghost)) then
		local g = pluto.ui.ghost

		local hover = vgui.GetHoveredPanel()

		if (g.GhostClick and hover.ClassName ~= "pluto_inventory_tab") then
			return not g:GhostClick(hover, mouse)
		end
	end
end)

hook.Add("PlutoBufferChanged", "pluto_buffer", function()
	if (pluto.inv.status ~= "ready") then
		return
	end
	local p = vgui.Create "pluto_item_showcase"
	p:MakePopup()
	p:SetKeyboardInputEnabled(false)
	p:SetMouseInputEnabled(false)

	p:SetItem(pluto.buffer[#pluto.buffer])

	local think = p.Think
	p.Start = CurTime()
	function p:Think()
		local x, y = ScrW(), ScrH() / 3

		local diff = CurTime() - self.Start
		local frac = 1
		if (diff < 0.2) then
			frac = (diff / 0.2) ^ 0.5
		elseif (diff > 3) then
			self:Remove()
		elseif (diff > 2.8) then
			frac = 1 - ((diff - 2.8) / 0.2) ^ 0.5
		end

		x = x - self:GetWide() * frac

		self:SetPos(x, y)

		return think and think(self) or nil
	end
end)

function pluto.ui.unsetghost()
	if (pluto.ui.ghost) then
		pluto.ui.ghost:PaintAt(pluto.ui.ghost:LocalToScreen(0, 0))
		pluto.ui.ghost = nil
	end
end