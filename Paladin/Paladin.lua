function vr.pal.test()
    vr.log.Action("invoking vr.pal.test()")
    --print('isHolyShockReady():' .. tostring(isHolyShockReady()))

    
    -- vr.log.Log("vr.api.LastSpellCast:" .. vr.api.LastSpellCast);
    -- --vr.log.Log("time():" .. time());

    -- local i, j = vr.api.Modf(vr.api.LastSpellCast);

    -- o = vr.api.SecondsSince(i);

    -- vr.log.Log("just the tip maam:" .. o);

    -- ss = vr.pal.SecondsSinceLastCrusaderStikeHit();
    -- vr.log.Log("vr.pal.SecondsSinceLastCrusaderStikeHit():" .. ss);

    --SetCVar("autoSelfCast", 0)
    --time = GetTime();
    --vr.pal.CheckCrusaderStike();

    -- function vr.ListTalents()
    --     for _, talent in ipairs(vr.talents) do
    --         jgp(talent)
    --     end
    -- end

    --jgp(tostring(vr.talents[PALHOLY]))

    -- if vr.trinkets.HaveTrinket("Second Wind") then
    --     vr.log.Log('i got what you need!')
    -- else
    --     vr.log.Log('is there something else i can help you with?')
    -- end

    -- if UnitExists("target") then
    --     local targetName = UnitName('target')
    --     if vr.mobdb.Match(targetName) then
    --         vr.log.Log(targetName .. " is listed in Mobdb.")
    --     end
    -- end

    --vr.api.GeneralOptionsFrameShow()

    --vr.api.InitGeneralOptionsFrame()

    --print('milli: ' .. vr.api.MilliSecondsSince(vr.pal.lastAutoQuickHeal))
    --print('mana: ' .. UnitMana("player"))

    --vr.pal.haveHolyShield

    --vr.log.Debug('HS: ' .. tostring(vr.pal.haveHolyShield) .. ' /HSA:' .. tostring(isHolyShieldActive()))

    -- vr.api.ListBuffs("Player")

    -- if vr.api.HasBuff("Player", "Blessing of Sanctuary") then
    --     print('have bos')
    -- else
    --     print('do NOT have BOS')
    -- end

    -- if isHammerOfJusticeReady() then
    --     print('hoj ready')
    -- end

    local number = vr.api.MilliSecondsSince(vr.pal.lastHoJSpamNotification)

    if number > 2000 then
        print('number: ' .. tostring(number))
        vr.pal.lastHoJSpamNotification = GetTime()
    end
end

--region    ---- INIT

---[ vr.pal.GetDistance ]----------------------------------------------------------
-- Returns estimated distance from target
function vr.pal.GetDistance()
    if vr.wr.isRunning then
        return vr.wr.distance
    end

    if vr.api.WoWVersionCheck("vanilla") then
        if vr.class.talent == vr.talents.PALHOLY then

            --vr.log.Debug(" /Yard10:" .. tostring(Yard10) .. " /Yard20:" .. tostring(Yard20));

            if not UnitCanAttack("player", "target") then
                return 100 -- invalid target
            elseif Yard10 and IsActionInRange(Yard10) == 1 then
                return 10 -- 8 - 10 yards
            elseif Yard20 and IsActionInRange(Yard20) == 1 then
                return 20 -- 11 - 25 yards
            else
                return 100
            end
            return 100 -- 31 - <na> yards
        end
        if vr.class.talent == vr.talents.PALPROT then

            --vr.log.Debug(" /Yard10:" .. tostring(Yard10) .. " /Yard20:" .. tostring(Yard20));

            if not UnitCanAttack("player", "target") then
                return 100 -- invalid target
            elseif Yard10 and IsActionInRange(Yard05) == 1 then
                return 5 -- 5 yards
            elseif Yard10 and IsActionInRange(Yard10) == 1 then
                return 10 -- 8 - 10 yards
            elseif Yard20 and IsActionInRange(Yard20) == 1 then
                return 20 -- 11 - 25 yards
            else
                return 100
            end
            return 100 -- 31 - <na> yards
        end
        if vr.class.talent == vr.talents.PALRET then

            --vr.log.Debug(" /Yard10:" .. tostring(Yard10) .. " /Yard20:" .. tostring(Yard20));

            if not UnitCanAttack("player", "target") then
                return 100 -- invalid target
            elseif Yard05 and IsActionInRange(Yard05) == 1 then
                return 5 -- 5 yards
            elseif Yard10 and IsActionInRange(Yard10) == 1 then
                return 10 -- 8 - 10 yards
            elseif Yard20 and IsActionInRange(Yard20) == 1 then
                return 20 -- 11 - 25 yards
            else
                return 100
            end
            return 100 -- 31 - <na> yards
        end
    end

    if vr.api.WoWVersionCheck("twow") then
        if vr.class.talent == vr.talents.PALHOLY then

            --vr.log.Debug(" /Yard10:" .. tostring(Yard10) .. " /Yard20:" .. tostring(Yard20));

            if not UnitExists("target") then --need variant for hostile/friendly
                return 100 -- invalid target
            elseif Yard05 and IsActionInRange(Yard05) == 1 then
                return 5 -- 5 yards
            elseif Yard10 and IsActionInRange(Yard10) == 1 then
                return 10 -- 8 - 10 yards
            elseif Yard20 and IsActionInRange(Yard20) == 1 then
                return 20 -- 11 - 25 yards
            else
                return 100
            end
            return 100 -- 31 - <na> yards
        end
        if vr.class.talent == vr.talents.PALPROT then

            --vr.log.Debug(" /Yard10:" .. tostring(Yard10) .. " /Yard20:" .. tostring(Yard20));

            if not UnitExists("target") then
                return 100 -- invalid target
            elseif Yard05 and IsActionInRange(Yard05) == 1 then
                return 5 -- 5 yards
            elseif Yard10 and IsActionInRange(Yard10) == 1 then
                return 10 -- 8 - 10 yards
            elseif Yard20 and IsActionInRange(Yard20) == 1 then
                return 20 -- 11 - 25 yards
            else
                return 100
            end
            return 100 -- 31 - <na> yards
        end
        if vr.class.talent == vr.talents.PALRET then

            --vr.log.Debug(" /Yard10:" .. tostring(Yard10) .. " /Yard20:" .. tostring(Yard20));

            if not UnitExists("target") then
                return 100 -- invalid target
            elseif Yard05 and IsActionInRange(Yard05) == 1 then
                return 5 -- 5 yards
            elseif Yard10 and IsActionInRange(Yard10) == 1 then
                return 10 -- 8 - 10 yards
            elseif Yard20 and IsActionInRange(Yard20) == 1 then
                return 20 -- 11 - 25 yards
            else
                return 100
            end
            return 100 -- 31 - <na> yards
        end
    end

end

---[ vr.api.SyncClassData ]--------------------------------------------------------
function vr.pal.SyncClassData()

    vr.pal.InitDistance()
    vr.pal.GetDistance()

    vr.pal.lastCrusaderStrikeHit = GetTime();
    vr.pal.lastJudgementOfTheCrusader = GetTime();
    vr.pal.lastSealOfCommand = GetTime();
    vr.pal.lastSealOfRighteousness = GetTime();

    vr.pal.lastAutoQuickHeal = GetTime();
    vr.pal.lastAutoAttackNotification = GetTime();

    vr.pal.lastCastHoJ = GetTime()

    vr.pal.lastCastBoP = GetTime()
    vr.pal.lastBoPTarget = ''

    vr.pal.lastCastLoH = GetTime()
    vr.pal.lastLoHTarget = ''

    vr.pal.lastCastBoF = GetTime()
    vr.pal.lastBoFTarget = ''

    vr.class.talent = vr.pal.ScanTalents()
    
    if vr.class.talent == vr.talents.PALHOLY then
        vr.pal.InitHolyPaladinData()
    elseif vr.class.talent == vr.talents.PALPROT then
        vr.pal.InitProtPaladinData()
    elseif vr.class.talent == vr.talents.PALRET then
        vr.pal.InitRetPaladinData()
    end

    vr.log.Debug("Scanning Talent Tree");

    if vr.api.WoWVersionCheck("vanilla") then

        -- Check for Divine Favor
        local _, _, _, _, currRank = GetTalentInfo(1, 11)
        if currRank > 0 then
            vr.log.Debug("+Divine Favor")
            vr.api.XMLSetText("AbilitiesFrame", "_DivineFavor", "Divine Favor: yes")
            vr.pal.haveDivineFavor = true;
        else
            vr.api.XMLSetText("AbilitiesFrame", "_DivineFavor", "Divine Favor: no")
            vr.pal.haveDivineFavor = false;
        end

        -- Check for Holy Shock
        local _, _, _, _, currRank = GetTalentInfo(1, 14)
        if currRank > 0 then
            vr.log.Debug("+Holy Shock")
            vr.api.XMLSetText("AbilitiesFrame", "_HolyShock", "Holy Shock: yes")
            vr.pal.haveHolyShock = true;
        else
            vr.api.XMLSetText("AbilitiesFrame", "_HolyShock", "Holy Shock: no")
            vr.pal.haveHolyShock = false;
        end

        -- Check for Holy Shield
        local _, _, _, _, currRank = GetTalentInfo(2, 15)
        if currRank > 0 then
            vr.log.Debug("+Holy Shield")
            vr.api.XMLSetText("AbilitiesFrame", "_HolyShield", "Holy Shield: yes")
            vr.pal.haveHolyShield = true;
        else
            vr.api.XMLSetText("AbilitiesFrame", "_HolyShield", "Holy Shield: no")
            vr.pal.haveHolyShield = false;
        end

        -- Check for Improved Judgement
        local name, iconPath, tier, column, currRank = GetTalentInfo(3, 3)
        if currRank > 0 then
            vr.log.Debug("+Improved Judgement")
        end
        vr.api.XMLSetText("AbilitiesFrame", "_ImprovedJudgement", "Improved Judgement: " .. currRank)
        vr.pal.haveImprovedJudgement = currRank;

    elseif vr.api.WoWVersionCheck("twow") then

        -- Check for Blessing of Sanctuary
        local _, _, _, _, currRank = GetTalentInfo(1, 6)
        if currRank > 0 then
            vr.log.Debug("+Blessing of Sanctuary")
            vr.api.XMLSetText("AbilitiesFrame", "_BlessingOfSanctuary", "Blessing of Sanctuary: yes")
            vr.pal.haveBlessingOfSanctuary = true;
        else
            vr.api.XMLSetText("AbilitiesFrame", "_BlessingOfSanctuary", "Blessing of Sanctuary: no")
            vr.pal.haveBlessingOfSanctuary = false;
        end

        -- Check for Divine Favor
        local _, _, _, _, currRank = GetTalentInfo(1, 11)
        if currRank > 0 then
            vr.log.Debug("+Divine Favor")
            vr.api.XMLSetText("AbilitiesFrame", "_DivineFavor", "Divine Favor: yes")
            vr.pal.haveDivineFavor = true;
        else
            vr.api.XMLSetText("AbilitiesFrame", "_DivineFavor", "Divine Favor: no")
            vr.pal.haveDivineFavor = false;
        end

        -- Check for Holy Shock
        local _, _, _, _, currRank = GetTalentInfo(1, 14)
        if currRank > 0 then
            vr.log.Debug("+Holy Shock")
            vr.api.XMLSetText("AbilitiesFrame", "_HolyShock", "Holy Shock: yes")
            vr.pal.haveHolyShock = true;
        else
            vr.api.XMLSetText("AbilitiesFrame", "_HolyShock", "Holy Shock: no")
            vr.pal.haveHolyShock = false;
        end

        -- Check for Holy Shield
        local _, _, _, _, currRank = GetTalentInfo(2, 12)
        if currRank > 0 then
            vr.log.Debug("+Holy Shield")
            vr.api.XMLSetText("AbilitiesFrame", "_HolyShield", "Holy Shield: yes")
            vr.pal.haveHolyShield = true;
        else
            vr.api.XMLSetText("AbilitiesFrame", "_HolyShield", "Holy Shield: no")
            vr.pal.haveHolyShield = false;
        end

        -- Check for Improved Judgement
        local name, iconPath, tier, column, currRank = GetTalentInfo(3, 3)
        if currRank > 0 then
            vr.log.Debug("+Improved Judgement")
        end
        vr.api.XMLSetText("AbilitiesFrame", "_ImprovedJudgement", "Improved Judgement: " .. currRank)
        vr.pal.haveImprovedJudgement = currRank;

        -- Check for Sanctified Command

    end



end

---[ vr.api.InitDistance ]---------------------------------------------------------
-- Detects distance from target by gauging spell icons
function vr.pal.InitDistance()
    --vr.log.Debug(">>> /v:" .. tostring(vr.api.WoWVersionCheck("vanilla")) .. " /c:" .. vr.class.talent)
    if vr.api.WoWVersionCheck("twow") then
        if vr.class.talent == vr.talents.PALHOLY then

            local found = 0
            Yard20 = nil
            Yard10 = nil
            Yard05 = nil
            for i = 1, 120 do
                local t = GetActionTexture(i)
                if t then
                    --print(tostring(t));
                    if not Yard20 then --Holy Shock
                        --if string.find(t, "Ability_Warrior_Charge") -- Charge
                        --        or string.find(t, "Ability_Rogue_Sprint") then -- Intercept
                        if string.find(t, "Spell_Holy_SearingLight") then -- Intercept

                            --vr.log.Debug("found holy shock")

                            Yard20 = i
                            vr.log.Debug("20 yard: "..t)
                            found = found + 1
                        end
                    end
                    if not Yard10 then --Judgement
                        --if string.find(t, "Ability_GolemThunderClap")
                        --        or string.find(t, "Spell_Nature_ThunderClap") then -- Thunder Clap
                        if string.find(t, "Spell_Holy_RighteousFury") then

                            --vr.log.Debug("found judgement")

                            Yard10 = i
                            vr.log.Debug("10 yard: "..t)
                            found = found + 1
                        end
                    end
                    if not Yard05 then --Crusader Strike
                        --if string.find(t, "Ability_GolemThunderClap")
                        --        or string.find(t, "Spell_Nature_ThunderClap") then -- Thunder Clap
                        if string.find(t, "Spell_Holy_CrusaderStrike") then

                            --vr.log.Debug("found crusader strike")

                            Yard05 = i
                            vr.log.Debug("05 yard: "..t)
                            found = found + 1
                        end
                    end
                    if found == 3 then
                        vr.log.Debug("Found all distance check spells ("..i..")")
                        return
                    end
                end
            end
            -- -- Print if any distance check spell is missing
            -- if not yard30 or not yard08 then
            --     Print(CHAT_MISSING_SPELL_SHOOT_THROW_FURY)
            -- end
            -- if not yard25 then
            --     Print(CHAT_MISSING_SPELL_INTERCEPT_CHARGE_FURY)
            -- end
            -- if not yard10 then
            --     Print(CHAT_MISSING_SPELL_THUNDERCLAP_FURY)
            -- end
            -- if not yard05 then
            --     Print(CHAT_MISSING_SPELL_PUMMEL_FURY)
            -- end
        end
    end

    if vr.api.WoWVersionCheck("vanilla") then
        if vr.class.talent == vr.talents.PALHOLY then

            local found = 0
            Yard20 = nil
            Yard10 = nil
            for i = 1, 120 do
                local t = GetActionTexture(i)
                if t then
                    --print(tostring(t));
                    if not Yard20 then --Holy Shock
                        --if string.find(t, "Ability_Warrior_Charge") -- Charge
                        --        or string.find(t, "Ability_Rogue_Sprint") then -- Intercept
                        if string.find(t, "Spell_Holy_SearingLight") then -- Intercept

                            --vr.log.Debug("found holy shock")

                            Yard20 = i
                            vr.log.Debug("20 yard: "..t)
                            found = found + 1
                        end
                    end
                    if not Yard10 then --Judgement
                        --if string.find(t, "Ability_GolemThunderClap")
                        --        or string.find(t, "Spell_Nature_ThunderClap") then -- Thunder Clap
                        if string.find(t, "Spell_Holy_RighteousFury") then

                            --vr.log.Debug("found judgement")

                            Yard10 = i
                            vr.log.Debug("10 yard: "..t)
                            found = found + 1
                        end
                    end
                    if found == 2 then
                        vr.log.Debug("Found all distance check spells ("..i..")")
                        return
                    end
                end
            end
            -- -- Print if any distance check spell is missing
            -- if not yard30 or not yard08 then
            --     Print(CHAT_MISSING_SPELL_SHOOT_THROW_FURY)
            -- end
            -- if not yard25 then
            --     Print(CHAT_MISSING_SPELL_INTERCEPT_CHARGE_FURY)
            -- end
            -- if not yard10 then
            --     Print(CHAT_MISSING_SPELL_THUNDERCLAP_FURY)
            -- end
            -- if not yard05 then
            --     Print(CHAT_MISSING_SPELL_PUMMEL_FURY)
            -- end
        end
    end








end

---[ vr.api.InitHolyPaladinData ]--------------------------------------------------
function vr.pal.InitHolyPaladinData()
    vr.log.Debug("I am " .. vr.class.talent)
    local playerName = UnitName("player")
    vr.api.XMLSetText("AbilitiesFrame", "_Spec", vr.talents.PALHOLY)
    ClassSpec = "VRPALHOLY"
end

---[ vr.api.InitProtPaladinData ]--------------------------------------------------
function vr.pal.InitProtPaladinData()
    vr.log.Debug("I am " .. vr.class.talent)
    local playerName = UnitName("player")
    vr.api.XMLSetText("AbilitiesFrame", "_Spec", vr.talents.PALPROT)
    ClassSpec = "VRPALPROT"
end

---[ vr.api.InitRetPaladinData ]---------------------------------------------------
function vr.pal.InitRetPaladinData()
    vr.log.Debug("I am " .. vr.class.talent)
    local playerName = UnitName("player")
    vr.api.XMLSetText("AbilitiesFrame", "_Spec", vr.talents.PALRET)
    ClassSpec = "VRPALRET"
end

---[ vr.pal.InitRole ]-----------------------------------------------------
function vr.pal.InitRole()
    --print('invoking vr.war.InitRole()')
    -- Depending on [MODE_HEADER_PROT], [MODE_HEADER_MITITHREAT] and [MODE_HEADER_AOE], trigger weapon set change
    --vr.pal.InitWeapon()

    -- Initialize BlessIt API Variables
    -- vr.api.Attack = nil
    -- vr.api.AttackEnd = GetTime()
    -- vr.api.Combat = nil
    -- vr.api.CombatEnd = GetTime()
    vr.api.CombatTotal = 0
    vr.api.EnemySpellcast = nil
    vr.api.InterruptSpell = nil
    vr.api.LastSpellCast = 0
    -- vr.api.Mount = false

    -- Initialize Paladin Variables
    -- if not vr.war.ChargeLastCast then
    --     vr.war.ChargeLastCast = GetTime()
    -- end
    -- vr.war.ExecuteSwapped = false
    -- vr.war.OldStance = nil
    -- vr.war.RevengeReadyUntil = 0

end

---[ vr.api.ScanTalents ]----------------------------------------------------------
function vr.pal.ScanTalents()
    local _, _, pointsSpentInHoly = GetTalentTabInfo(1)
    local _, _, pointsSpentInProt = GetTalentTabInfo(2)
    local _, _, pointsSpentInRet = GetTalentTabInfo(3)
    
    if pointsSpentInProt > pointsSpentInRet and pointsSpentInProt > pointsSpentInHoly then
        --vr.log.Log("bork: " .. tostring(vr.talents.PALRET));
        return vr.talents.PALPROT
    elseif pointsSpentInHoly > pointsSpentInRet and pointsSpentInHoly > pointsSpentInProt then
        --vr.log.Log("dabu: " .. tostring(vr.talents.PALHOLY));
        return vr.talents.PALHOLY
    elseif pointsSpentInRet > pointsSpentInHoly and pointsSpentInRet > pointsSpentInProt then
        --vr.log.Log("arse: " .. tostring(vr.talents.PALRET));
        return vr.talents.PALRET
    end
end

--endregion ---- INIT

--region    ---- CLASS




---[ vr.api.CrusaderStrikeStacks ]-------------------------------------------------
-- TODO
function vr.pal.CrusaderStrikeStacks(unit, stacks)

	if not UnitExists(unit) then
		return false;
	end

	local s = Zorlen_GetDebuffStack("Spell_Holy_CrusaderStrike", unit)
	if s < stacks then
		--print(UnitName('target') .. " has " .. s .. " stacks of Crusader Strike");
		return true
	elseif s == stacks then
		-- if vr.pal.CheckCrusaderStrike() then
        --     return true
		-- end
	else
		return false
	end
end

--endregion ---- CLASS

--region    ---- ROTATIONS

--endregion ---- ROTATIONS

--region    ---- EVENTS

---[ vr.pal.CHAT_MSG_SPELL_SELF_BUFF ]---------------------------------------------
function vr.pal.CHAT_MSG_SPELL_SELF_BUFF(event, arg1)
    vr.log.LogEvent(vr.log.Damage(event, arg1));
end

---[ vr.pal.CHAT_MSG_SPELL_SELF_DAMAGE ]-------------------------------------------
function vr.pal.CHAT_MSG_SPELL_SELF_DAMAGE(event, arg1)

    -- Holy Shock
    if string.find(arg1, ".*Holy Shock.*") then
        if string.find(arg1, ".*is parried.*") 
            or string.find(arg1, ".*was dodged.*")
            or string.find(arg1, ".*missed.*")
            or string.find(arg1, ".*was resisted.*") then
                --vr.log.Log("HOLY SHOCK FAILED...")
        else
            --vr.log.Log("HOLY SHOCK HIT!!!")
        end
    end

    -- Crusader Strike
    if string.find(arg1, ".*Crusader Strike.*") then
        if string.find(arg1, ".*is parried.*") 
            or string.find(arg1, ".*was dodged.*")
            or string.find(arg1, ".*missed.*")
            or string.find(arg1, ".*was resisted.*") then
                --vr.log.Log("CRUSADER STRIKE FAILED...")
        else
            --vr.log.Log("CRUSADER STRIKE HIT!!!")
            vr.pal.lastCrusaderStrikeHit = GetTime();
        end
    end

    --vr.log.Log(" /e:" .. event .. " /a:" .. arg1)

    vr.log.LogEvent(vr.log.Damage(event, arg1));
end

--endregion ---- EVENTS

---[ vr.pal.SlashCommands ]----------------------------------------------------
