pluto.currency = {
	list = {
		{
			InternalName = "dice",
			Name = "Reflective Die",
			Icon = "pluto/currencies/dice.png",
			Description = "Randomize the rolls on an item",
			SubDescription = "Arizor lost this die in a bet with a farmer long ago. That farmer won a bet with Yuowi later, and gave him the power to create these at will",
			Shares = 700,
			Use = function(item)
			end,
		},
		{
			InternalName = "droplet",
			Name = "Magic Droplet",
			Icon = "pluto/currencies/droplet.png",
			Description = "Removes all modifiers, and adds new ones",
			SubDescription = "It's said this magic droplet was formed from one of Yuowi's former lovers",
			Shares = 5000,
			Use = function(item)
			end,
		},
		{
			InternalName = "hand",
			Name = "Yuowi's Taking",
			Icon = "pluto/currencies/goldenhand.png",
			Description = "Takes a modifier away from a weapon",
			SubDescription = "One of the many hands of Yuowi's victims",
			Shares = 400,
			Use = function(item)
			end,
		},
		{
			InternalName = "tome",
			Name = "Arizor's Tome",
			Icon = "pluto/currencies/tome.png",
			Description = "Increases the tier of two random modifiers, and lowers the tier of another",
			SubDescription = "Arizor hands these out to promising gunsmiths to augment their weapons and further their goals",
			Shares = 300,
			Use = function(item)
			end,
		},
		{
			InternalName = "mirror",
			Name = "Mara's Mirror",
			Icon = "pluto/currencies/brokenmirror.png",
			Description = "Creates an unmodifiable second version of an item",
			SubDescription = "Mara threw this mirror out after seeing what she had become",
			Shares = 1,
			Use = function(item)
			end,
		},
		{
			InternalName = "heart",
			Name = "Mara's Heart",
			Icon = "pluto/currencies/heart.png",
			Description = "Adds a modifier to an item",
			SubDescription = "Mara gives her heart to people who have shown compassion in their time of need",
			Shares = 5,
			Use = function(item)
			end,
		},
	},
	byname = {},
	shares = 0,
}

for _, item in pairs(pluto.currency.list) do
	pluto.currency.shares = pluto.currency.shares + item.Shares
	pluto.currency.byname[item.InternalName] = item

	resource.AddFile("materials/" .. item.Icon)
end


function pluto.currency.random(n)
	if (not n) then
		n = math.random()
	end

	n = n * pluto.currency.shares

	for _, item in ipairs(pluto.currency.list) do
		n = n - item.Shares
		if (n <= 0) then
			return item
		end
	end
end

pluto.currency.navs = {
	total = 0,
}

for _, nav in pairs(navmesh.GetAllNavAreas()) do
	local dist = nav:GetCorner(2):Distance(nav:GetCorner(0))

	table.insert(pluto.currency.navs, {
		Size = dist,
		Nav = nav
	})

	pluto.currency.navs.total = pluto.currency.navs.total + dist
end

function pluto.currency.randompos()
	local rand = math.random() * pluto.currency.navs.total

	for _, item in pairs(pluto.currency.navs) do
		rand = rand - item.Size
		if (rand <= 0) then
			return item.Nav:GetRandomPoint()
		end
	end

	error "WHAT"
end

function pluto.currency.spawnfor(ply, currency, pos)
	local e = ents.Create "pluto_currency"

	if (not pos) then
		pos = pluto.currency.randompos()
	end

	if (not currency) then
		currency = pluto.currency.random()
	end

	e:SetPos(pos + 20 * vector_up)
	e:SetOwner(ply)
	e:SetCurrency(currency)
	e:Spawn()

	return e
end