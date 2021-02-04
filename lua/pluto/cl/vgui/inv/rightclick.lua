
function pluto.ui.rightclickmenu(item, pre)
	local rightclick_menu = DermaMenu()

	if (pre) then
		pre(rightclick_menu)
	end

	rightclick_menu:AddOption("Upload item stats", function()
		local StatsRT = GetRenderTarget("ItemStatsRT" .. ScrW() .. "_" ..  ScrH(), ScrW(), ScrH())
		OVERRIDE_DETAILED = true
		local show = pluto.ui.showcase(item)
		pluto.ui.showcasepnl = nil
		show:SetPaintedManually(true)
		local item_name = item:GetPrintName()
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
				
				imgur.image(data, "gun", string.format("%s's %s", LocalPlayer():Nick(), item_name)):next(function(data)
					SetClipboardText(data.data.link)
					chat.AddText("Screenshot link made! Paste from your clipboard.")
				end):catch(function()
				end)
			end)
		end)
	end):SetIcon("icon16/camera.png")

--[[
	rightclick_menu:AddOption("Copy item JSON", function()
		SetClipboardText(util.TableToJSON(item))
	end)]]

	if (not item.Locked and item.Nickname) then
		rightclick_menu:AddOption("Remove name (100 hands)", function()
			item.Nickname = nil
			pluto.inv.message()
				:write("unname", item.ID)
				:send()
		end):SetIcon("icon16/cog_delete.png")
	end

	rightclick_menu:AddOption("Copy Chat Link", function()
		SetClipboardText("{item:" .. item.ID .. "}")
	end):SetIcon("icon16/book.png")

	if (item.Type ~= "Shard") then
		rightclick_menu:AddOption("Toggle locked", function()
			pluto.inv.message()
				:write("itemlock", item.ID)
				:send()
		end):SetIcon("icon16/lock.png")
	end

	if (item.Type == "Weapon") then
		rightclick_menu:AddOption("Open Constellations", function()
			pluto.ui.showconstellations(item)
		end):SetIcon "icon16/star.png"
	end

	if (not item.Untradeable) then
		rightclick_menu:AddOption("Sell in Divine Market", function()
			if (IsValid(PLUTO_LIST_TEST)) then
				PLUTO_LIST_TEST:Remove()
			end
			PLUTO_LIST_TEST = vgui.Create "tttrw_base"
			local pnl = vgui.Create "pluto_list_auction_item"
			pnl:SetItem(item)

			PLUTO_LIST_TEST:AddTab("List Auction Item", pnl)

			PLUTO_LIST_TEST:SetSize(640, 400)
			PLUTO_LIST_TEST:Center()
			PLUTO_LIST_TEST:MakePopup()
		end):SetIcon("icon16/money.png")
	end

	if (LocalPlayer():GetUserGroup() == "developer" or LocalPlayer():GetUserGroup() == "meepen") then
		local dev = rightclick_menu:AddSubMenu "Developer"
		dev:AddOption("Duplicate", function()
			RunConsoleCommand("pluto_item_dupe", item.ID)
		end):SetIcon("icon16/cog_add.png")
		dev:AddOption("Copy ID", function()
			SetClipboardText(item.ID)
		end):SetIcon("icon16/cog_edit.png")
	end

	rightclick_menu:Open()
	rightclick_menu:SetPos(input.GetCursorPos())--s
end