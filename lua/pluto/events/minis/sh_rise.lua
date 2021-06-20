-- Author: add___123

if (SERVER) then
    hook.Add("TTTBeginRound", "pluto_mini_rise", function()
        if (ttt.GetCurrentRoundEvent() ~= "") then
            return
        end

        if (not pluto.rounds or not pluto.rounds.minis) then
            return
        end

        if (not pluto.rounds.minis.rise --[[ and math.random(50) ~= 1--]]) then
            return
        end

        pluto.rounds.minis.rise = nil

        pluto.rounds.Notify("Rise, dead, and strike down your enemies!", Color(0, 100, 0))

        local risen = {}

        hook.Add("DoPlayerDeath", "pluto_mini_rise", function(ply, att, dmg)
            if (not IsValid(ply) or risen[ply]) then
                return
            end

            risen[ply] = true
            local rise_at = ply:GetPos()

            timer.Simple(0.1, function()
                pluto.rounds.Notify("Rise and fight for one last moment!", Color(0, 100, 0), ply)

                if (not IsValid(ply) or not rise_at) then
                    return
                end

                ttt.ForcePlayerSpawn(ply)
                ply:SetPos(rise_at)
                ply:Give "weapon_ttt_fists"
                ply:SetModel "models/player/zombie_classic.mdl"
                ply:SetupHands()
                ply:SetMaxHealth(250)
                ply:SetHealth(250)
                pluto.rounds.speeds[ply] = (pluto.rounds.speeds[ply] or 1) + 0.4
                net.Start "mini_speed"
                    net.WriteFloat(pluto.rounds.speeds[ply])
                net.Send(ply)
            end)
        end)

        hook.Add("EntityTakeDamage", "pluto_mini_rise", function(att, dmg)
            local att = dmg:GetAttacker()

            if (not IsValid(att) or not att:IsPlayer() or not risen[att]) then
                return
            end

            pluto.statuses.heal(att, 25, 1)
        end)

        hook.Add("PlayerCanPickupWeapon", "pluto_mini_rise", function(ply, wep)
            if (risen[ply] and wep:GetClass() ~= "weapon_ttt_fists") then
                return false
            end
        end)

        hook.Add("PlayerCanHearPlayersVoice", "pluto_mini_rise", function(listener, speaker)
            if (IsValid(speaker) and IsValid(listener) and risen[speaker] and speaker:Alive() and listener:Alive()) then
                return listener == speaker
            end
        end)

        hook.Add("PlayerCanSeePlayersChat", "pluto_mini_rise", function(text, _, listener, speaker)
            if (IsValid(speaker) and IsValid(listener) and risen[speaker] and speaker:Alive() and listener:Alive()) then
                return listener == speaker
            end
        end)

        timer.Create("pluto_mini_rise", 1, 0, function()
            for _, ply in ipairs(player.GetAll()) do
                if (not IsValid(ply) or not ply:Alive() or not risen[ply]) then
                    continue
                end

                local dmg = DamageInfo()
                dmg:SetDamageType(DMG_POISON)
                dmg:SetDamage(25)
                ply:TakeDamageInfo(dmg)                
            end
        end)
    end)

    hook.Add("TTTEndRound", "pluto_mini_rise", function()
        hook.Remove("DoPlayerDeath", "pluto_mini_rise")
        hook.Remove("EntityTakeDamage", "pluto_mini_rise")
        hook.Remove("PlayerCanPickupWeapon", "pluto_mini_rise")
        hook.Remove("PlayerCanHearPlayersVoice", "pluto_mini_rise")
        hook.Remove("PlayerCanSeePlayersChat", "pluto_mini_rise")
        timer.Remove("pluto_mini_rise")
    end)
else

end