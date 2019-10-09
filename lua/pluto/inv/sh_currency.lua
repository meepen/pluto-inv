pluto.currency = {
	list = {
		{
			InternalName = "dice",
			Name = "Reflective Die",
			Icon = "pluto/currencies/dice.png",
			Description = "Randomize the rolls on an item",
			SubDescription = "Arizor lost this die in a bet with a farmer long ago. That farmer won a bet with Yuowi later, and gave him the power to create these at will",
		},
		{
			InternalName = "droplet",
			Name = "Magic Droplet",
			Icon = "pluto/currencies/droplet.png",
			Description = "Removes all modifiers, and adds new ones",
			SubDescription = "It's said this magic droplet was formed from one of Yuowi's former lovers",
		},
		{
			InternalName = "hand",
			Name = "Yuowi's Taking",
			Icon = "pluto/currencies/goldenhand.png",
			Description = "Takes a modifier away from a weapon",
			SubDescription = "One of the many hands of Yuowi's victims",
		},
		{
			InternalName = "tome",
			Name = "Arizor's Tome",
			Icon = "pluto/currencies/tome.png",
			Description = "Increases the tier of two random modifiers, and lowers the tier of another",
			SubDescription = "Arizor hands these out to promising gunsmiths to augment their weapons and further their goals",
		},
		{
			InternalName = "mirror",
			Name = "Mara's Mirror",
			Icon = "pluto/currencies/brokenmirror.png",
			Description = "Creates an unmodifiable second version of an item",
			SubDescription = "Mara threw this mirror out after seeing what she had become",
		},
		{
			InternalName = "heart",
			Name = "Mara's Heart",
			Icon = "pluto/currencies/heart.png",
			Description = "Adds a modifier to an item",
			SubDescription = "Mara gives her heart to people who have shown compassion in their time of need",
		},
	},
	byname = {},
}

for _, item in pairs(pluto.currency.list) do
	pluto.currency.byname[item.InternalName] = item
end

if (SERVER) then
	include "sv_currency.lua"
end