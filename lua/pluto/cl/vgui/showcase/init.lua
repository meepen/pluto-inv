surface.CreateFont("pluto_showcase_name", {
	font = "Roboto",
	size = 20,
	weight = 450,
})

surface.CreateFont("pluto_showcase_name_real", {
	font = "Roboto",
	size = 14,
	weight = 450,
})

surface.CreateFont("pluto_showcase_small", {
	font = "Roboto Lt",
	size = 12,
	weight = 450,
})

surface.CreateFont("pluto_showcase_suffix_text", {
	font = "Roboto",
	size = 14,
	weight = 450,
})

function pluto.ui.showcase(item)
	if (item.Type == "Weapon") then
		-- do

		local container = vgui.Create "pluto_showcase_weapon"
		container:SetItem(item)

		return container
	else
		return pluto.ui.oldshowcase(item)
	end
end