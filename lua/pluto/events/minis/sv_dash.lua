-- Author: add___123
local devs = {
	["76561198050165746"] = true, -- Meepen
	["76561198055769267"] = true, -- Jared
	["76561198188070674"] = true, -- CROSSMAN
	["76561198110055555"] = true, -- add___123
}

local nextdev

hook.Add("TTTEndRound", "pluto_prompt_dash", function()
	if (ttt.GetNextRoundEvent() ~= "") then
		return
	end

	if (not pluto.rounds.minis.dash and math.random(100) ~= 1) then
		return
	end

    pluto.rounds.minis.dash = nil

    for k, ply in ipairs(table.shuffle(player.GetHumans())) do
        if (devs[ply:SteamID64()]) then
            nextdev = ply
            nextdev:ChatPrint(ttt.roles.Traitor.Color, "You will be the Dashing Developer next round! Everyone will try to kill you!")
        end
    end

    hook.Remove("PlayerCanPickupWeapon", "pluto_dev_dash")
    hook.Remove("DoPlayerDeath", "pluto_dev_dash")
end)

hook.Add("TTTBeginRound", "pluto_dev_dash", function()
    local curdev = nextdev
    nextdev = nil

	if (not IsValid(curdev) or not curdev:Alive()) then
		return
	end

    curdev:SetMaxHealth(250)
    curdev:SetHealth(250)
    curdev:SetJumpPower(curdev:GetJumpPower() + 100)
    curdev:StripWeapons()
	pluto.NextWeaponSpawn = false
	curdev:Give "weapon_ttt_unarmed"
    
    pluto.rounds.speeds[curdev] = (pluto.rounds.speeds[curdev] or 1) + 0.75
    net.Start "mini_speed"
        net.WriteFloat(pluto.rounds.speeds[curdev])
    net.Send(curdev)

	ttt.chat(ttt.roles.Traitor.Color, curdev:Nick(), " has stolen your models! Kill them to get back your look!")

    local models = {}

    for _, ply in pairs(player.GetAll()) do
        if (not ply:Alive() or ply == curdev) then
            continue
        end

        models[ply] = ply:GetModel()
        ply:SetModel(curdev:GetModel())
    end

    hook.Add("PlayerCanPickupWeapon", "pluto_dev_dash", function(ply, wep)
        if (ply == curdev) then
            return wep:GetClass() == "weapon_ttt_unarmed"
        end
    end)

    hook.Add("DoPlayerDeath", "pluto_dev_dash", function(ply, att, dmg)
        if (not IsValid(ply) or ply ~= curdev) then
            return
        end
        
	    ttt.chat(ttt.roles.Traitor.Color, curdev:Nick(), " has been vanquished! Your model has been returned.")

        for _, ply in ipairs(player.GetAll()) do
            if (IsValid(ply) and ply:Alive() and models[ply]) then
                ply:SetModel(models[ply])
            end
        end

        hook.Remove("DoPlayerDeath", "pluto_dev_dash")
    end)
end)