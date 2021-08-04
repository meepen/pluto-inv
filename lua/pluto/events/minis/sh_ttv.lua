-- Author: add___123

local name = "ttv"

if (SERVER) then
    util.AddNetworkString("pluto_mini_" .. name)
    local power_mult = 1.5
    local finisher_powered = false
    local redeemer_powered = false

    local function checkforpowerups()
        if (#round.GetActivePlayersByRole "traitor" <= 1 and not finisher_powered) then
            local finishers = round.GetActivePlayersByRole "Finisher"
            if (#finishers >= 1) then
                finisher_powered = true
                pluto.rounds.Notify("The Traitorous Finisher has been powered up!", ttt.roles.Finisher.Color)
                for k, ply in ipairs(finishers) do
                    if (IsValid(ply) and ply:Alive()) then
                        ply:SetMaxHealth(150)
                        ply:SetHealth(150)
                        ply:SetJumpPower(ply:GetJumpPower() + 25)
                        pluto.rounds.speeds[ply] = (pluto.rounds.speeds[ply] or 1) + 0.25
                        net.Start "mini_speed"
                            net.WriteFloat(pluto.rounds.speeds[ply])
                        net.Send(ply)
                    end
                end
            end
        end
        
        if (#round.GetActivePlayersByRole "innocent" <= 1 and not redeemer_powered) then
            local redeemers = round.GetActivePlayersByRole "Redeemer"
            if (#redeemers >= 1) then
                redeemer_powered = true
                pluto.rounds.Notify("The Innocent Redeemer has been powered up!", ttt.roles.Redeemer.Color)
                for k, ply in ipairs(redeemers) do
                    if (IsValid(ply) and ply:Alive()) then
                        ply:SetMaxHealth(150)
                        ply:SetHealth(150)
                        ply:SetJumpPower(ply:GetJumpPower() + 25)
                        pluto.rounds.speeds[ply] = (pluto.rounds.speeds[ply] or 1) + 0.25
                        net.Start "mini_speed"
                            net.WriteFloat(pluto.rounds.speeds[ply])
                        net.Send(ply)
                    end
                end
            end
        end
    end

    local try_give = function(ply, class)
        local eq = ttt.Equipment.List[class]

        if (not eq) then
            return false
        end

        if (eq.Limit and ply.TTTRWEquipmentTracker and ply.TTTRWEquipmentTracker[class] and ply.TTTRWEquipmentTracker[class] >= eq.Limit) then
            return false
        end

        if (eq:OnBuy(ply)) then
            ply.TTTRWEquipmentTracker = ply.TTTRWEquipmentTracker or {}
            ply.TTTRWEquipmentTracker[class] = (ply.TTTRWEquipmentTracker[class] or 0) + 1
            return true
        end
    end

    local role_inits = {
        Finisher = function(ply, role)
            pluto.rounds.Notify("You are a Finisher! If all your teammates die, you will be powered up!", ttt.roles[role].Color, ply)
        end,
        ["Nearly a Destroyer"] = function(ply, role)
            pluto.rounds.Notify("You are Nearly a Destroyer! In 30 seconds, you will be powered up and your role revealed!", ttt.roles[role].Color, ply)
            timer.Create("pluto_mini_destroyer", 30, 1, function()
                if (IsValid(ply) and ply:Alive()) then
                    ply:SetMaxHealth(150)
                    ply:SetHealth(150)
                    ply:SetJumpPower(ply:GetJumpPower() + 25)
                    pluto.rounds.speeds[ply] = (pluto.rounds.speeds[ply] or 1) + 0.25
                    net.Start "mini_speed"
                        net.WriteFloat(pluto.rounds.speeds[ply])
                    net.Send(ply)
                    ply:SetRole("Destroyer")
                    pluto.rounds.Notify(string.format("%s has been powered up as the Traitorous Destroyer!", ply:Nick()), ttt.roles[role].Color)
                end
            end)
        end,
        Shapeshifter = function(ply, role)
            pluto.rounds.Notify("You are a Shapeshifter! Killing people to steal their models!", ttt.roles[role].Color, ply)
        end,
        ["Soulbound Red"] = function(ply, role)
            pluto.rounds.Notify("You are a Soulbound Red! Your fate is tied to the innocent Soulbound Green!", ttt.roles[role].Color, ply)
        end,
        ["Savage Seer"] = function(ply, role)
            pluto.rounds.Notify("You are a Savage Seer! You can see all hidden innocent roles!", ttt.roles[role].Color, ply)
        end,
        --[[Infiltrator = function(ply, role)
            pluto.rounds.Notify("You are an Infiltrator! See Buddies and pretend to be an innocent Wannabe!", ttt.roles[role].Color, ply)
        end,--]]
        Assassin = function(ply, role)
            pluto.rounds.Notify("You are an Assassin! Deal more damage to Detectives/Deputies and less to others!", ttt.roles[role].Color, ply)
        end,
        Hoarder = function(ply, role)
            pluto.rounds.Notify("You are a Hoarder! Enjoy the bonus equipment credits!", ttt.roles[role].Color, ply)
            ply:SetCredits(ply:GetCredits() + 3)
        end,
        ["Yaari Spy"] = function(ply, role)
            pluto.rounds.Notify("You are a Yaari Spy! You can see the Descendant and are immune to their scanner!", ttt.roles[role].Color, ply)
        end,
        Buddy = function(ply, role)
            pluto.rounds.Notify("You are a Buddy, with a Buddy! Pair up with them to survive!", ttt.roles[role].Color, ply)
        end,
        --[[Wannabe = function(ply, role)
            pluto.rounds.Notify("You are a Wannabe! See the roles of the Buddies, but they don't see yours!", ttt.roles[role].Color, ply)
        end,--]]
        ["True Innocent"] = function(ply, role)
            pluto.rounds.Notify("You are a True Innocent! Your role is seen by all!", ttt.roles[role].Color, ply)
        end,
        ["Private Investigator"] = function(ply, role)
            pluto.rounds.Notify("You are a Private Investigator! Use radars and a scanner to find the traitors!", ttt.roles[role].Color, ply)
            try_give(ply, "ttt_radar")
            try_give(ply, "ttt_body_finder")
            ply:Give("weapon_ttt_dna")
        end,
        Redeemer = function(ply, role)
            pluto.rounds.Notify("You are a Redeemer! If all teammates die, you will be powered up!", ttt.roles[role].Color, ply)
        end,
        Listener = function(ply, role)
            pluto.rounds.Notify("You are a Listener! When people die, listen and be informed!", ttt.roles[role].Color, ply)
        end,
        ["Soulbound Green"] = function(ply, role)
            pluto.rounds.Notify("You are a Soulbound Green! Your fate is tied to the traitor Soulbound Red!", ttt.roles[role].Color, ply)
        end,
        Deputy = function(ply, role)
            pluto.rounds.Notify("You are a Deputy! Detectives see your role, so you can help them!", ttt.roles[role].Color, ply)
        end,
        Coward = function(ply, role)
            pluto.rounds.Notify("You are a Coward! Take armor and a wink and get running!", ttt.roles[role].Color, ply)
            try_give(ply, "ttt_bodyarmor")
            ply:Give "weapon_ttt_wink"
        end,
        ["Silent Seer"] = function(ply, role)
            pluto.rounds.Notify("You are a Silent Seer! You see all roles but nobody can hear you!", ttt.roles[role].Color, ply)
            ply:StripWeapons()
            ply:StripAmmo()
            ply:Give "weapon_ttt_fists"
        end,
        Descendant = function(ply, role)
            pluto.rounds.Notify("You are a Descendant! Use your role scanner but beware the immune Yaari Spy!", ttt.roles[role].Color, ply)
            ply:Give "weapon_ttt_descendant"
        end,
        Defector = function(ply, role)
            pluto.rounds.Notify("You are a Defector! Survive 60 seconds as an innocent to defect!", ttt.roles[role].Color, ply)
            timer.Create("pluto_mini_defector", 60, 1, function()
                if (IsValid(ply) and ply:Alive()) then
                    ply:SetRole("Defected")
                    pluto.rounds.Notify("An innocent has defected and joined the traitors!", ttt.roles[role].Color)
                end
            end)
        end,
    }

    hook.Add("TTTBeginRound", "pluto_mini_" .. name, function()
        if (not pluto.rounds.minis[name]) then
            return
        end

		pluto.rounds.minis[name] = nil

        pluto.rounds.Notify("Welcome to TTVillage! Extra roles, extra goals.", Color(0, 102, 92))

        local priority_innocents = {}
        local single_innocents = table.shuffle({"Defector", "True Innocent", "Deputy", "Silent Seer"})
        local extra_innocents = {--[["Wannabe", --]]"Private Investigator", "Listener", "Coward", "Redeemer"}

        local priority_traitors = {}
        local single_traitors = table.shuffle({"Nearly a Destroyer", "Savage Seer", "Assassin"})
        local extra_traitors = {--[["Infiltrator", --]]"Finisher", "Shapeshifter", "Hoarder"}

        if (math.random() > 0.6) then
            table.insert(priority_innocents, "Soulbound Green")
            table.insert(priority_traitors, "Soulbound Red")
        end

        if (math.random() > 0.3) then
            table.insert(priority_innocents, "Buddy")
            table.insert(priority_innocents, "Buddy")
        end

        timer.Simple(1, function()
            for k, ply in ipairs(table.shuffle(round.GetActivePlayersByRole "Innocent")) do
                if (not IsValid(ply) or not ply:Alive()) then
                    continue
                end

                if (#priority_innocents > 0) then
                    ply:SetRole(table.remove(priority_innocents))
                elseif (#single_innocents > 0 and math.random() > 0.25) then
                    ply:SetRole(table.remove(single_innocents))
                else
                    ply:SetRole(extra_innocents[math.random(#extra_innocents)])
                end
            end

            for k, ply in ipairs(table.shuffle(round.GetActivePlayersByRole "Traitor")) do
                if (not IsValid(ply) or not ply:Alive()) then
                    continue
                end

                if (#priority_traitors > 0) then
                    ply:SetRole(table.remove(priority_traitors))
                elseif (#single_traitors > 0 and math.random() > 0.25) then
                    ply:SetRole(table.remove(single_traitors))
                else
                    ply:SetRole(extra_traitors[math.random(#extra_traitors)])
                end
            end

            for k, ply in ipairs(player.GetAll()) do
                if (not IsValid(ply) or not ply:Alive()) then
                    continue
                end

                local role = ply:GetRole()

                if (role_inits[role]) then
                    role_inits[role](ply, role)
                end
            end
        end)

        finisher_powered = false
        redeemer_powered = false

        hook.Add("EntityTakeDamage", "pluto_mini_" .. name, function(vic, dmg)
            if (not IsValid(vic) or not vic:IsPlayer() or not vic:Alive() or not dmg) then
                return 
            end

            local att = dmg:GetAttacker()

            if (IsValid(att) and att:IsPlayer()) then
                if ((att:GetRole() == "Finisher" and finisher_powered) or (att:GetRole() == "Redeemer" and redeemer_powered)) then
                    dmg:SetDamage(dmg:GetDamage() * power_mult)       
                end

                if (att:GetRole() == "Assassin") then  
                    if (vic:GetRole() == "Detective" or vic:GetRole() == "Deputy") then
                        dmg:SetDamage(dmg:GetDamage() * power_mult)
                    else
                        dmg:SetDamage(dmg:GetDamage() / power_mult)
                    end
                end

                if (att:GetRole() == "Destroyer") then
                    dmg:SetDamage(dmg:GetDamage() * power_mult)
                end
            end

            if (vic:GetRole() == "Soulbound Red") then
                for k, ply in ipairs(round.GetActivePlayersByRole "Soulbound Green") do
                    if (IsValid(ply) and ply:Alive()) then
                        ply:SetHealth(ply:Health() - dmg:GetDamage())
                        if (ply:Health() <= 0) then
                            ply:Kill()
                        end
                    end
                end
            end

            if (vic:GetRole() == "Soulbound Green") then
                for k, ply in ipairs(round.GetActivePlayersByRole "Soulbound Red") do
                    if (IsValid(ply) and ply:Alive()) then
                        ply:SetHealth(ply:Health() - dmg:GetDamage())
                        if (ply:Health() <= 0) then
                            ply:Kill()
                        end
                    end
                end
            end
        end)

        hook.Add("PlayerDeath", "pluto_mini_" .. name, function(vic, inf, atk)
            if (not IsValid(vic)) then
                return
            end

            if (IsValid(atk) and atk:Alive() and atk:GetRole() == "Shapeshifter") then
                atk:SetModel(vic:GetModel())
                for k, group in ipairs(vic:GetBodyGroups()) do
                    atk:SetBodygroup(group.id, vic:GetBodygroup(group.id))
                end
                atk:SetupHands()
            end

            for k, ply in ipairs(round.GetActivePlayersByRole "Listener") do
                print("PlayerDeath notifying")
                pluto.rounds.Notify(string.format("Listen, and behold: %s, with the role of %s, has been eliminated!", vic:Nick(), vic:GetRole()), ttt.roles.Listener.Color, ply)
            end

            timer.Simple(1, function()
                checkforpowerups()
            end)
        end)

        hook.Add("PlayerDisconnected", "pluto_mini_" .. name, function(ply)
            if (IsValid(ply)) then
                for k, _ply in ipairs(round.GetActivePlayersByRole "Listener") do
                    pluto.rounds.Notify(string.format("Listen, and behold: %s, with the role of %s, has been eliminated!", ply:Nick(), ply:GetRole()), ttt.roles.Listener.Color, _ply)
                end
            end

            timer.Simple(1, function()
                checkforpowerups()
            end)
        end)

        hook.Add("PlayerCanPickupWeapon", "pluto_mini_" .. name, function(ply, wep)
            if (ply:GetRole() == "Silent Seer" and wep:GetClass() ~= "weapon_ttt_fists") then
                return false
            end
        end)

        hook.Add("PlayerCanHearPlayersVoice", "pluto_mini_" .. name, function(listener, speaker)
            if (IsValid(speaker) and IsValid(listener) and speaker:Alive() and listener:Alive()) then
                if (speaker:GetRole() == "Silent Seer") then
                    return false
                end
            end
        end)

        hook.Add("PlayerCanSeePlayersChat", "pluto_mini_" .. name, function(text, _, listener, speaker)
            if (IsValid(speaker) and IsValid(listener) and speaker:Alive() and listener:Alive()) then
                if (speaker:GetRole() == "Silent Seer") then
                    return false
                end
            end
        end)

        hook.Add("TTTEndRound", "pluto_mini_" .. name, function()
            hook.Remove("TTTEndRound", "pluto_mini_" .. name)
            hook.Remove("PlayerTakeDamage", "pluto_mini_" .. name)
            hook.Remove("PlayerDeath", "pluto_mini_" .. name)
            hook.Remove("PlayerDisconnected", "pluto_mini_" .. name)
            hook.Remove("PlayerCanPickupWeapon", "pluto_mini_" .. name)
            hook.Remove("PlayerCanHearPlayersVoice", "pluto_mini_" .. name)
            hook.Remove("PlayerCanSeePlayersChat", "pluto_mini_" .. name)
        end)
    end)
else

end

hook.Add("TTTRoleSeesRole", "pluto_mini_" .. name, function(role, sees)
    if (role == "traitor") then
        table.insert(sees, "Silent Seer")
    end

    if (role == "innocent") then
        table.insert(sees, "Silent Seer")
        table.insert(sees, "Savage Seer")
    end
end)

hook.Add("TTTPrepareRoles", "pluto_mini_" .. name, function(Team, Role)
	Role("Finisher", "traitor")
		:SetCalculateAmountFunc(function(total_players)
			return 0
		end)
        :SetColor(103, 21, 22)

    Role("Nearly a Destroyer", "traitor")
        :SetCalculateAmountFunc(function(total_players)
			return 0
		end)
        :SetColor(204, 0, 0)

    Role("Destroyer", "traitor")
        :SetCalculateAmountFunc(function(total_players)
			return 0
		end)
        :SetColor(204, 0, 0)
        :SeenByAll()

    Role("Shapeshifter", "traitor")
        :SetCalculateAmountFunc(function(total_players)
			return 0
		end)
        :SetColor(131, 79, 0)

    Role("Soulbound Red", "traitor")
        :SetCalculateAmountFunc(function(total_players)
			return 0
		end)
        :SetColor(109, 73, 0)
        :SeenBy {"Soulbound Green"}

    Role("Savage Seer", "traitor")
        :SetCalculateAmountFunc(function(total_players)
			return 0
		end)
        :SetColor(220, 90, 90)

    --[[Role("Infiltrator", "traitor")
        :SetCalculateAmountFunc(function(total_players)
			return 0
		end)
        :SetColor(221, 88, 0)--]]

    Role("Assassin", "traitor")
        :SetCalculateAmountFunc(function(total_players)
			return 0
		end)
        :SetColor(163, 0, 121)

    Role("Hoarder", "traitor")
        :SetCalculateAmountFunc(function(total_players)
			return 0
		end)
        :SetColor(255, 179, 0)

    Role("Defected", "traitor")
        :SetCalculateAmountFunc(function(total_players)
			return 0
		end)
        :SetColor(179, 59, 0)
        :SeenBy {}

    -- Traitor who revives as a zombie after death?

    Role("Buddy", "innocent")
        :SetCalculateAmountFunc(function(total_players)
			return 0
		end)
        :SetColor(19, 188, 77)
        :SeenBy {"Buddy",--[["Wannabe", "Infiltrator"--]]}

    --[[Role("Wannabe", "innocent")
        :SetCalculateAmountFunc(function(total_players)
			return 0
		end)
        :SetColor(100, 171, 100)
        :SeenBy {}--]]

    Role("True Innocent", "innocent")
        :SetCalculateAmountFunc(function(total_players)
			return 0
		end)
        :SetColor(100, 255, 100)
        :SeenByAll()

    Role("Private Investigator", "innocent")
        :SetCalculateAmountFunc(function(total_players)
			return 0
		end)
        :SetColor(5, 142, 113)
        :SeenBy {}

    Role("Redeemer", "innocent")
        :SetCalculateAmountFunc(function(total_players)
			return 0
        end)
        :SetColor(22, 125, 22)
        :SeenBy {}
    
    Role("Listener", "innocent")
        :SetCalculateAmountFunc(function(total_players)
			return 0
        end)
        :SetColor(148, 213, 149)
        :SeenBy {}

    Role("Soulbound Green", "innocent")
        :SetCalculateAmountFunc(function(total_players)
			return 0
		end)
        :SetColor(89, 93, 0)
        :SeenBy {"Soulbound Red"}

    Role("Deputy", "innocent")
        :SetCalculateAmountFunc(function(total_players)
			return 0
		end)
        :SetColor(5, 142, 153)
        :SeenBy {"Detective", "Assassin"}
		:TeamChatSeenBy "Detective"
		:SetVoiceChannel "Detective"

    Role("Coward", "innocent")
        :SetCalculateAmountFunc(function(total_players)
			return 0
		end)
        :SetColor(47, 106, 18)
        :SeenBy {}

    Role("Silent Seer", "innocent")
        :SetCalculateAmountFunc(function(total_players)
			return 0
		end)
        :SetColor(23, 75, 18)
        :SeenBy {}
        :SetSeeTeammateOutlines(true)

    Role("Defector", "innocent")
        :SetCalculateAmountFunc(function(total_players)
			return 0
		end)
        :SetColor(149, 179, 0)
        :SeenBy {}
end)