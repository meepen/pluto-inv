pluto.chat = pluto.chat or {}
pluto.chat.type = {}
pluto.chat.type.TEXT = 0
pluto.chat.type.COLOR = 1
pluto.chat.type.PLAYER = 2
pluto.chat.type.ITEM = 3
pluto.chat.type.CURRENCY = 4
pluto.chat.type.IMAGE = 5
pluto.chat.type.NONE = 6

pluto.chat.channels = {
	{
		Name = "Server",
		Prefix = "//"
	},
	{
		Name = "Admin",
		Prefix = "@",
		Relay = {
			"Server",
		}
	},
	{
		Name = "Cross",
		Prefix = "#",
	},
	byname = {}
}

for _, channel in ipairs(pluto.chat.channels) do
	pluto.chat.channels.byname[channel.Name] = channel
end

local function override()
	FindMetaTable "Player".ChatPrint = function(self, ...)
		if (SERVER) then
			pluto.inv.message(self)
				:write("chatmessage", {...})
				:send()
		elseif (LocalPlayer() == self) then
			pluto.chat.Add(content, "Server", false)
		end
	end
end

override()

hook.Add("PostGamemodeLoaded", "OverrideChatPrint", override)

local discord_emojis = util.JSONToTable [=[[{"name":"pluto","url":"https://cdn.discordapp.com/emojis/595959931350286336.png"},{"name":"frogthinking","url":"https://cdn.discordapp.com/emojis/608992649856155649.png"},{"name":"pepega","url":"https://cdn.discordapp.com/emojis/609013412508467200.png"},{"name":"monkaS","url":"https://cdn.discordapp.com/emojis/609013412692754433.png"},{"name":"PepeHands","url":"https://cdn.discordapp.com/emojis/609013412823040000.png"},{"name":"PepeHeart","url":"https://cdn.discordapp.com/emojis/609013413150064651.png"},{"name":"PepoWhy","url":"https://cdn.discordapp.com/emojis/609013413166841864.png"},{"name":"PepoGun","url":"https://cdn.discordapp.com/emojis/609013413175230495.png"},{"name":"OkayMan","url":"https://cdn.discordapp.com/emojis/609013413212979226.png"},{"name":"PepoThink","url":"https://cdn.discordapp.com/emojis/609013413217042453.png"},{"name":"Poggers","url":"https://cdn.discordapp.com/emojis/609013413225693184.png"},{"name":"PepeHype","url":"https://cdn.discordapp.com/emojis/609013413301190657.png"},{"name":"SukaDog","url":"https://cdn.discordapp.com/emojis/609013707011260427.png"},{"name":"pikalul","url":"https://cdn.discordapp.com/emojis/609015651897573404.png"},{"name":"Pebbles","url":"https://cdn.discordapp.com/emojis/609029488734371855.png"},{"name":"Venus","url":"https://cdn.discordapp.com/emojis/609035753124790272.png"},{"name":"angeryboye","url":"https://cdn.discordapp.com/emojis/609058414101922000.png"},{"name":"sadcat","url":"https://cdn.discordapp.com/emojis/609059263733825546.png"},{"name":"Smiel","url":"https://cdn.discordapp.com/emojis/609103618326528099.png"},{"name":"Sood","url":"https://cdn.discordapp.com/emojis/609103800044748846.png"},{"name":"pepemouse","url":"https://cdn.discordapp.com/emojis/609170615542349835.png"},{"name":"pepesadmouse","url":"https://cdn.discordapp.com/emojis/609170992064888832.png"},{"name":"B1","url":"https://cdn.discordapp.com/emojis/609175025953800202.png"},{"name":"GunLeft","url":"https://cdn.discordapp.com/emojis/609312250167033858.png"},{"name":"f_","url":"https://cdn.discordapp.com/emojis/609312250339000320.png"},{"name":"noot","url":"https://cdn.discordapp.com/emojis/609312250423148544.png"},{"name":"GunRight","url":"https://cdn.discordapp.com/emojis/609312250536263680.png"},{"name":"pphonk","url":"https://cdn.discordapp.com/emojis/609312250586726431.png"},{"name":"Mara","url":"https://cdn.discordapp.com/emojis/609312751805923345.png"},{"name":"Doger","url":"https://cdn.discordapp.com/emojis/609312751814443018.png"},{"name":"box","url":"https://cdn.discordapp.com/emojis/609316432953606155.png"},{"name":"cake","url":"https://cdn.discordapp.com/emojis/609316433045880874.png"},{"name":"winner","url":"https://cdn.discordapp.com/emojis/609316433192681513.png"},{"name":"pill","url":"https://cdn.discordapp.com/emojis/609316433268178954.png"},{"name":"heart","url":"https://cdn.discordapp.com/emojis/609316433297539073.png"},{"name":"star","url":"https://cdn.discordapp.com/emojis/609316433318510602.png"},{"name":"bug","url":"https://cdn.discordapp.com/emojis/609316433431625738.png"},{"name":"ZweerdKnife","url":"https://cdn.discordapp.com/emojis/609330842598113320.png"},{"name":"SukaCursed","url":"https://cdn.discordapp.com/emojis/609374961475387392.png"},{"name":"Beans","url":"https://cdn.discordapp.com/emojis/609395314637537301.png"},{"name":"jubjubb","url":"https://cdn.discordapp.com/emojis/609435900551757824.png"},{"name":"Rocko","url":"https://cdn.discordapp.com/emojis/609475226035814420.png"},{"name":"MalkButt","url":"https://cdn.discordapp.com/emojis/609716614010634251.png"},{"name":"MalkConfused","url":"https://cdn.discordapp.com/emojis/609716634399277066.png"},{"name":"MalkCreepin","url":"https://cdn.discordapp.com/emojis/609716648378761230.png"},{"name":"MalkFrown","url":"https://cdn.discordapp.com/emojis/609716660760477706.png"},{"name":"MalkFunny","url":"https://cdn.discordapp.com/emojis/609716674538635284.png"},{"name":"MalkGasm","url":"https://cdn.discordapp.com/emojis/609716685913718794.png"},{"name":"MalkKiss","url":"https://cdn.discordapp.com/emojis/609716730884784188.png"},{"name":"MalkLick","url":"https://cdn.discordapp.com/emojis/609716795619803137.png"},{"name":"MalkMelt","url":"https://cdn.discordapp.com/emojis/609716797662560256.png"},{"name":"MalkSmile","url":"https://cdn.discordapp.com/emojis/609716806403358720.png"},{"name":"MalkShock","url":"https://cdn.discordapp.com/emojis/609716806462078996.png"},{"name":"MalkWhat","url":"https://cdn.discordapp.com/emojis/609716807410122754.png"},{"name":"MalkSatisfied","url":"https://cdn.discordapp.com/emojis/609716807548272643.png"},{"name":"Camille","url":"https://cdn.discordapp.com/emojis/609784972424773633.png"},{"name":"VStea","url":"https://cdn.discordapp.com/emojis/609794685346512897.png"},{"name":"pepehiss","url":"https://cdn.discordapp.com/emojis/610080444742107156.png"},{"name":"WeirdCat","url":"https://cdn.discordapp.com/emojis/610210144059523092.png"},{"name":"bigh","url":"https://cdn.discordapp.com/emojis/610871684785766420.png"},{"name":"agrea","url":"https://cdn.discordapp.com/emojis/612016833461092385.png"},{"name":"HamsterScream","url":"https://cdn.discordapp.com/emojis/612017714738888780.png"},{"name":"disagrea","url":"https://cdn.discordapp.com/emojis/612023390231986207.png"},{"name":"what","url":"https://cdn.discordapp.com/emojis/612546200025038849.png"},{"name":"wack","url":"https://cdn.discordapp.com/emojis/612977585869160458.png"},{"name":"LUL","url":"https://cdn.discordapp.com/emojis/613439297869316105.png"},{"name":"verytoxic","url":"https://cdn.discordapp.com/emojis/614172419455975455.png"},{"name":"bort","url":"https://cdn.discordapp.com/emojis/616988848274276363.png"},{"name":"MadPatrick","url":"https://cdn.discordapp.com/emojis/617209923847323648.png"},{"name":"agree","url":"https://cdn.discordapp.com/emojis/617473160563916810.png"},{"name":"maybe","url":"https://cdn.discordapp.com/emojis/617473160652259357.png"},{"name":"disagree","url":"https://cdn.discordapp.com/emojis/617473160849129522.png"},{"name":"Shoek","url":"https://cdn.discordapp.com/emojis/620717772141232128.png"},{"name":"Smuuch","url":"https://cdn.discordapp.com/emojis/620724457845162007.png"},{"name":"peepohappy","url":"https://cdn.discordapp.com/emojis/621755897122783252.png"},{"name":"mhahartmahsole","url":"https://cdn.discordapp.com/emojis/626113895186038794.png"},{"name":"PepeDoubt","url":"https://cdn.discordapp.com/emojis/628992352018759700.png"},{"name":"goerge","url":"https://cdn.discordapp.com/emojis/630865161934077974.png"},{"name":"pepocoffee","url":"https://cdn.discordapp.com/emojis/631817668147806218.png"},{"name":"pepoNO","url":"https://cdn.discordapp.com/emojis/631817668235755557.png"},{"name":"marasheart","url":"https://cdn.discordapp.com/emojis/632330196996980751.png"},{"name":"arizorstome","url":"https://cdn.discordapp.com/emojis/632330197223342090.png"},{"name":"magicdroplet","url":"https://cdn.discordapp.com/emojis/632330197227667486.png"},{"name":"reflectivedie","url":"https://cdn.discordapp.com/emojis/632330197273673770.png"},{"name":"yuowistaking","url":"https://cdn.discordapp.com/emojis/632330197282324503.png"},{"name":"gorge_owo","url":"https://cdn.discordapp.com/emojis/633682657120878598.png"},{"name":"gorge_happy","url":"https://cdn.discordapp.com/emojis/633682657368211466.png"},{"name":"gorge_moneyman","url":"https://cdn.discordapp.com/emojis/633682657401634826.png"},{"name":"gorge_monkeybrain","url":"https://cdn.discordapp.com/emojis/633682657481457684.png"},{"name":"gorge_angerism","url":"https://cdn.discordapp.com/emojis/633682657590378496.png"},{"name":"gorge_tipsy","url":"https://cdn.discordapp.com/emojis/633682657833910292.png"},{"name":"gorge_sad","url":"https://cdn.discordapp.com/emojis/633682657871527947.png"},{"name":"gorge_toofast","url":"https://cdn.discordapp.com/emojis/633682660157292569.png"},{"name":"coin","url":"https://cdn.discordapp.com/emojis/640035079497973762.png"},{"name":"present","url":"https://cdn.discordapp.com/emojis/654994734556774401.png"},{"name":"aneye","url":"https://cdn.discordapp.com/emojis/655120672942456842.png"},{"name":"blobthumbsup","url":"https://cdn.discordapp.com/emojis/664392182060548107.png"},{"name":"plutocraft","url":"https://cdn.discordapp.com/emojis/666270446408433695.png"},{"name":"marasmirror","url":"https://cdn.discordapp.com/emojis/666575525422039041.png"},{"name":"blobkissheart","url":"https://cdn.discordapp.com/emojis/668733340722921477.png"},{"name":"cursed_stare","url":"https://cdn.discordapp.com/emojis/672752503284039690.png"},{"name":"cursed_stare2","url":"https://cdn.discordapp.com/emojis/672752592543023125.png"},{"name":"glassquill","url":"https://cdn.discordapp.com/emojis/679985869146292241.png"},{"name":"doodoofart","url":"https://cdn.discordapp.com/emojis/686452257784463371.png"},{"name":"soontm","url":"https://cdn.discordapp.com/emojis/687772960299548690.png"},{"name":"blue_egg","url":"https://cdn.discordapp.com/emojis/693752384333021195.png"},{"name":"orange_egg","url":"https://cdn.discordapp.com/emojis/693752384744325180.png"},{"name":"toiletpaper","url":"https://cdn.discordapp.com/emojis/694956945353736215.png"},{"name":"uhohstinky","url":"https://cdn.discordapp.com/emojis/694967278936260610.png"},{"name":"consumed_pink_egg","url":"https://cdn.discordapp.com/emojis/698942598844252191.png"},{"name":"Soonglasses","url":"https://cdn.discordapp.com/emojis/719453198926086195.png"},{"name":"toberenamed","url":"https://cdn.discordapp.com/emojis/732893018558038046.png"},{"name":"hahayes","url":"https://cdn.discordapp.com/emojis/760929025719533578.png"},{"name":"wait_wtf","url":"https://cdn.discordapp.com/emojis/760929057965080577.png"},{"name":"helpme","url":"https://cdn.discordapp.com/emojis/765560084133969920.png"},{"name":"brain_egg","url":"https://cdn.discordapp.com/emojis/772334363224047627.png"},{"name":"stardust","url":"https://cdn.discordapp.com/emojis/786221390386561085.png"},{"name":"xmas2020","url":"https://cdn.discordapp.com/emojis/789573209833472030.png"},{"name":"chancedice","url":"https://cdn.discordapp.com/emojis/789573287549468762.png"},{"name":"Sillychamp","url":"https://cdn.discordapp.com/emojis/790020175503294504.png"},{"name":"sadge","url":"https://cdn.discordapp.com/emojis/790022204037136434.png"},{"name":"PogCarp","url":"https://cdn.discordapp.com/emojis/790539372595773440.png"},{"name":"dogcomfy","url":"https://cdn.discordapp.com/emojis/814357346918596618.png"},{"name":"dasher","url":"https://cdn.discordapp.com/emojis/818640975147696148.png"},{"name":"jester","url":"https://cdn.discordapp.com/emojis/818640975290564639.png"}]]=]

pluto.chat.images = {}
for _, emoji in pairs(discord_emojis) do
	pluto.chat.images[emoji.name:lower()] = {
		URL = "http://va1.pluto.gg:3000/pluto/emojis/" .. emoji.url:GetFileFromFilename():sub(1, -5)
	}
end

for name, emoji in pairs(pluto.chat.images) do
	emoji.Name = name
	emoji.Type = "emoji"
end
