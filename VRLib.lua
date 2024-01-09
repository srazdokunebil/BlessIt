vr.api = { }



--region    ----    AURAS

---[ vr.api.CancelSalvation ]-----------------------------------------------------
function vr.api.CancelSalvation()
	local buff = {"Spell_Holy_SealOfSalvation", "Spell_Holy_GreaterBlessingofSalvation"}
	local counter = 0
	while GetPlayerBuff(counter) >= 0 do
		local index, untilCancelled = GetPlayerBuff(counter)
		if untilCancelled ~= 1 then
			local i =1
			while buff[i] do
				if string.find(GetPlayerBuffTexture(index), buff[i]) then
					CancelPlayerBuff(index);
					UIErrorsFrame:Clear();
					UIErrorsFrame:AddMessage("Salvation Removed");
                    --vr.log.Warn('Salvation Removed.')
                    vr.log.LogThrottle('AntiSalv', 'Salvation Removed.', 2000)
					return
				end
				i = i + 1
			end
		end
		counter = counter + 1
	end
	return nil
end

---[ vr.api.CheckDebuffs ]-----------------------------------------------------
function vr.api.CheckDebuffs(unit, list)
    for _, v in pairs(list) do
        if vr.api.HasDebuff(unit, v) then
            return true
        end
    end
    return nil
end

---[ vr.api.HasAntiStealthDebuff ]---------------------------------------------
function vr.api.HasAntiStealthDebuff()
    --Detect anti-stealth debuffs
    --Rend, Deep Wounds, Serpent Sting, Immolate, Curse of Agony , Garrote, Rupture, Deadly Poison, Fireball, Ignite, Pyroblast, Corruption, Siphon Life, Faerie Fire, Moonfire, Rake, Rip, Pounce, Insect Swarm, Holy Fire, Wyvern Sting, Devouring Plague
    return vr.api.CheckDebuffs("target", {
        "Ability_Gouge",
        "Ability_Hunter_Quickshot",
        "Spell_Fire_Immolation",
        "Spell_Shadow_CurseOfSargeras",
        "Ability_Rogue_Garrote",
        "Ability_Rogue_Rupture",
        "Ability_Rogue_DualWeild",
        "Spell_Shadow_ShadowWordPain",
        "Spell_Fire_FlameBolt",
        "Spell_Fire_Incinerate",
        "Spell_Fire_Fireball02",
        "Spell_Shadow_AbominationExplosion",
        "Spell_Shadow_Requiem",
        "Spell_Nature_FaerieFire",
        "Spell_Nature_StarFall",
        "Ability_Druid_Disembowel",
        -- "Ability_GhoulFrenzy", -- triggered on fury warrs Flurry
        "Ability_Druid_SurpriseAttack",
        "Spell_Nature_InsectSwarm",
        "Spell_Holy_SearingLight",
        "INV_Spear_02",
        "Spell_Shadow_BlackPlague"
    })
end

---[ vr.api.HasBuff ]----------------------------------------------------------
-- Detect if unit has buff
function vr.api.HasBuff(unit, spellname)
    local id = 1
    while UnitBuff(unit, id) do
        local buffTexture = UnitBuff(unit, id)
        if string.find(buffTexture, Textures[spellname]) then
            return true
        end
        id = id + 1
    end
    return nil
end

---[ vr.api.ListBuffs ]--------------------------------------------------------
-- List units' buff textures
function vr.api.ListBuffs(unit)
    for i = 1, 40 do
        print('aura: ' .. tostring(UnitBuff(unit, i)))
    end
    return nil
end

---[ vr.api.HasBuffId ]--------------------------------------------------------
-- Detect if unit has buff id
function vr.api.HasBuffId(unit, spellId)
    for i = 1, 40 do
        if select(11, UnitBuff(unit, i)) == spellId then
            return true
        end
    end
    return nil
end

---[ vr.api.HasDebuff ]--------------------------------------------------------
-- Detect if unit has specific number of debuffs
function vr.api.HasDebuff(unit, texturename, amount)
    local id = 1
    while UnitDebuff(unit, id) do
        local debuffTexture, debuffAmount = UnitDebuff(unit, id)
        if string.find(debuffTexture, texturename) then
            if (amount
                    or 1) <= debuffAmount then
                return true
            else
                return false
            end
        end
        id = id + 1
    end
    return nil
end

---[ vr.api.HasDebuffType ]----------------------------------------------------
-- Check if unit has debuff of specific type
function vr.api.HasDebuffType(unit, type)
    local id = 1
    if not type then
        return nil
    end
    while UnitDebuff(unit, id) do
        local _,_,debuffType = UnitDebuff(unit, id)
        if type
          and debuffType ==  type then
            return true
        end
        id = id + 1
    end
    return nil
end

---[ vr.api.HasImmobilizingDebuff ]--------------------------------------------
function vr.api.HasImmobilizingDebuff()
    return vr.api.CheckDebuffs("player", {
        "Spell_Frost_FrostNova",
        "Spell_Nature_StrangleVines",
        "Entangling Roots",
    })
end

---[ vr.api.HasSnareDebuff ]---------------------------------------------------
function vr.api.HasSnareDebuff(unit)
    -- Detect snaring debuffs
    -- Hamstring, Wing Clip, Curse of Exhaustion, Crippling Poison, Frostbolt, Cone of Cold, Frost Shock, Piercing Howl
    return vr.api.CheckDebuffs(unit, {
        "Ability_ShockWave",
        "Ability_Rogue_Trip",
        "Spell_Shadow_GrimWard",
        "Ability_PoisonSting",
        "Spell_Frost_FrostBolt02",
        "Spell_Frost_Glacier",
        "Spell_Shadow_DeathScream",
        "Spell_Frost_FrostShock"
    })
end

--endregion ----    AURAS

--region    ----    DEBUG

---[ vr.api.DebugGroup ]----------------------------------------------------------
function vr.api.DebugGroup()
    vr.log.Debug(" /vr.api.AmSolo():" .. tostring(vr.api.AmSolo()) .. " /vr.api.AmInParty():" .. tostring(vr.api.AmInParty()) .. " /vr.api.AmInRaid():" .. tostring(vr.api.AmInRaid()))
end

function vr.api.DebugRotationParameters(fightType, rota)
	vr.log.Debug("/t:" .. vr.api.GetClassAndSpec() .. " /r:"  .. rota .. " /f:" .. fightType .. " /g:" .. vr.group.type .. " /v:" .. vr.api.GetWoWVersion());
end

--endregion ----    DEBUG

--region    ----    INVENTORY

---[ vr.api.CheckCooldown ]----------------------------------------------------
function vr.api.CheckCooldown(slot)
    local start, duration = GetInventoryItemCooldown("player", slot)
    if duration > 30 then
        -- Alllow duration for 30 seconds since it's when you equip the item
        local item = GetInventoryItemLink("player", slot)
        if item then
            local _, _, itemCode = strfind(item, "(%d+):")
            local itemName = GetItemInfo(itemCode)
            return itemName
        end
    end
    return nil
end

---[ vr.api.GetOffhandName ]--------------------------------------------------------
-- Returns item name sting
function vr.api.GetOffhandName()
    if vr.api.HasDebuff("player", "Ability_Warrior_Disarm") then
        return nil
    end
    local item = GetInventoryItemLink("player", 17)
    if item then
        local _, _, itemCode = strfind(item, "(%d+):")
        local name, _, _, _, _, itemType = GetItemInfo(itemCode)
        -- if itemType == ITEM_TYPE_SHIELDS_FURY
        --   and not GetInventoryItemBroken("player", 17) then
        --     return true
        -- end
        if name then
            return name;
        end
    end
    return nil
end

---[ vr.api.HasShield ]--------------------------------------------------------
-- Detect if a shield is present
function vr.api.HasShield()
    if vr.api.HasDebuff("player", "Ability_Warrior_Disarm") then
        return nil
    end
    local item = GetInventoryItemLink("player", 17)
    if item then
        local _, _, itemCode = strfind(item, "(%d+):")
        local _, _, _, _, _, itemType = GetItemInfo(itemCode)
        if itemType == ITEM_TYPE_SHIELDS_FURY
          and not GetInventoryItemBroken("player", 17) then
            return true
        end
    end
    return nil
end

---[ vr.api.HaveShield ]-----------------------------------------------------------
-- Detect if a shield is equipped
function vr.api.HaveShield()
    if vr.api.HasDebuff("player", "Ability_Warrior_Disarm") then
        return nil
    end
    local item = GetInventoryItemLink("player", 17)
    if item then
        local _, _, itemCode = strfind(item, "(%d+):")
        local _, _, _, _, _, itemType = GetItemInfo(itemCode)
        if itemType == "Shields"
                and not GetInventoryItemBroken("player", 17) then
            return true
        end
    end
    return nil
end

---[ vr.api.HasWeapon ]--------------------------------------------------------
-- Detect if a suitable weapon (not a skinning knife/mining pick and not broken) is present
function vr.api.HasWeapon()
    if vr.api.HasDebuff("player", "Ability_Warrior_Disarm") then
        return nil
    end
    local item = GetInventoryItemLink("player", 16)
    if item then
        local _, _, itemCode = strfind(item, "(%d+):")
        local itemName, itemLink, _, _, itemType = GetItemInfo(itemCode)
        if itemLink ~= "item:7005:0:0:0" -- Skining knife
                and itemLink ~= "item:2901:0:0:0" -- Mining pick
                and not GetInventoryItemBroken("player", 16) then
            return true
        end
    end
    return nil
end

---[ vr.api.IsEquippedAndReady ]---------------------------------------------------
function vr.api.IsEquippedAndReady(slot, name)
    local item = GetInventoryItemLink("player", slot)
    if item then
        local _, _, itemCode = strfind(item, "(%d+):")
        local itemName = GetItemInfo(itemCode)
        if itemName == name
                and GetInventoryItemCooldown("player", slot) == 0 then
            return true
        end
    end
    return nil
end

---[ vr.api.IsItemReady ]----------------------------------------------------------
function vr.api.IsItemReady(item)
    if vr.api.ItemExists(item) == false then
        return false
    end
    local _, duration, _ = GetItemCooldown(item)
    if duration == 0 then
        return true
    end
    return false
end

---[ vr.api.ItemExists ]-----------------------------------------------------------
function vr.api.ItemExists(itemName)
    for bag = 4, 0, -1 do
        for slot = 1, GetContainerNumSlots(bag) do
            local _, itemCount = GetContainerItemInfo(bag, slot)
            if itemCount then
                local itemLink = GetContainerItemLink(bag,slot)
                local _, _, itemParse = strfind(itemLink, "(%d+):")
                local queryName, _, _, _, _, _ = GetItemInfo(itemParse)
                if queryName
                        and queryName ~= "" then
                    if queryName == itemName then
                        return true
                    end
                end
            end
        end
    end
    return false
end

---[ vr.api.IsTrinketEquipped ]----------------------------------------------------
-- Return trinket slot if trinket is equipped and not on cooldown
function vr.api.IsTrinketEquipped(name)
    for slot = 13, 14 do
        local item = GetInventoryItemLink("player", slot)
        if item then
            local _, _, itemCode = strfind(item, "(%d+):")
            local itemName = GetItemInfo(itemCode)
            if itemName == name
                    and GetInventoryItemCooldown("player", slot) == 0 then
                return slot
            end
        end
    end
    return nil
end

---[ vr.api.Ranged ]---------------------------------------------------------------
--Detect if a ranged weapon is equipped and return type
function vr.api.Ranged()

    local item = GetInventoryItemLink("player", 18)
    if item then
        local _, _, itemCode = strfind(item, "(%d+):")
        local _, _, _, _, _, itemType = GetItemInfo(itemCode)
        return itemType
    end
    return nil
end

---[ vr.api.UseContainerItemByNameOnPlayer ]---------------------------------------
-- Use item on player
function vr.api.UseContainerItemByNameOnPlayer(name)
    for bag = 0, 4 do
        for slot = 1,GetContainerNumSlots(bag) do
            local item = GetContainerItemLink(bag, slot)
            if item then
                local _, _, itemCode = strfind(item, "(%d+):")
                local itemName = GetItemInfo(itemCode)
                if itemName == name then
                    UseContainerItem(bag, slot)
                    if SpellIsTargeting() then
                        SpellTargetUnit("player")
                    end
                end
            end
        end
    end
end

--endregion ----    INVENTORY

--region    ----    GPS

function vr.api.GetDistance()
    --with wr
    -- if vr.va.isRunning then
    --     if UnitExists("target") then
    --         GeneralOptionsFrame_Distance:SetText(vr.va.distance);
    --         return;
    --     else
    --         GeneralOptionsFrame_Distance:SetText("No Target");
    --         return;
    --     end
    -- end    

    -- without wr
    local class = UnitClass('player');
    if class == "Druid" then
        return vr.dru.GetDistance();
    elseif class == "Hunter" then
        return vr.hun.GetDistance();
    elseif class == "Mage" then
        return vr.mag.GetDistance();
    elseif class == "Paladin" then
        return vr.pal.GetDistance();
    elseif class == "Priest" then
        return vr.pri.GetDistance();
    elseif class == "Rogue" then
        return vr.rog.GetDistance();
    elseif class == "Shaman" then
        return vr.shm.GetDistance();
    elseif class == "Warrior" then
        return vr.war.GetDistance();
    elseif class == "Warlock" then
        return vr.wlk.GetDistance();
    end

end

---[ vr.api.Subzone ]--------------------------------------------------------------
-- Returns Subzone name string
function vr.api.Subzone()
    print('z:' .. tostring(GetZoneText()) .. ' sz: ' .. tostring(GetSubZoneText()))
    --return GetSubZoneText()
end

---[ vr.api.Zone ]-----------------------------------------------------------------
-- Returns Zone name string
function vr.api.Zone()
    print('zone: ' .. GetZoneText());
end

--endregion ----    GPS

--region    ----    GROUP

---[ vr.api.AmInParty ]------------------------------------------------------------
-- Returns true if the player is in a party or a raid
function vr.api.AmInParty()
    return (vr.api.GroupstatusInt() == 1);
end

---[ vr.api.AmInRaid ]-------------------------------------------------------------
-- Returns true if the player is in a raid group
function vr.api.AmInRaid()
    return (vr.api.GroupstatusInt() == 2);
end

---[ vr.api.AmSolo ]---------------------------------------------------------------
-- Returns true if the player is not in a party or a raid
function vr.api.AmSolo()
    return (vr.api.GroupstatusInt() == 0);
end

---[ vr.api.GroupType ]----------------------------------------------------------
function vr.api.GroupSync()
    local group = "solo"
    if GetNumPartyMembers() > 0 then
        group = "party"
    end
    if GetNumRaidMembers() > 0 then
        group = "raid"
    end
    vr.group.type = group;
    --GeneralOptionsFrame_Title:SetText(group)
end

---[ vr.api.GroupstatusInt ]-------------------------------------------------------
function vr.api.GroupstatusInt()
    local group = 0
    if GetNumPartyMembers() > 0 then
        group = 1
    end
    if GetNumRaidMembers() > 0 then
        group = 2
    end
    return group
end

--endregion ----    GROUP

--region    ----    SPELLCASTING

---[ vr.api.BackstabBugTimeout ]--------------------------------------------------------
function vr.api.BackstabBugTimeout()
    if vr.api.BackstabBugged then
        if vr.api.MilliSecondsSince(vr.api.BackstabBugged) < 2000 then
            return true;
        end
    end
    return false
end

---[ vr.api.CheckCast ]--------------------------------------------------------
function vr.api.CheckCast(spell)
    if not vr.api.IsSpellReady(spell) then
        vr.api.ReportCD(spell, 1000)
    else
        CastSpellByName(spell)
    end
end

---[ vr.api.IsGCD ]------------------------------------------------------------
function vr.api.IsGCD()
    local i = 1
    while true do
        local spellName, spellRank = GetSpellName(i, BOOKTYPE_SPELL);
        --print('slot:' .. tostring(i) ' /spell:' .. tostring(spellName))
        if not spellName or i >= 30 then
            break;
        end

        local start, duration, enabled = GetSpellCooldown(i, BOOKTYPE_SPELL);
        if enabled == 1 and start > 0 and duration > 0 then
            local cooldownLeft = duration - (GetTime() - start)
            --DEFAULT_CHAT_FRAME:AddMessage('i:' .. i .. ' /GCD check for ' .. spellName .. ' ' .. cooldownLeft);
            if (cooldownLeft < 1500 and cooldownLeft ~= 0) then
                return cooldownLeft / 1000;
            end
        end

        i = i + 1;
    end

    return 0;

end

---[ vr.api.IsSpellReady ]-----------------------------------------------------
-- Return true if spell is ready
function vr.api.IsSpellReady(spellname)
    return vr.api.IsSpellReadyIn(spellname) == 0
end

---[ vr.api.IsSpellReadyIn ]---------------------------------------------------
-- Check remaining cooldown on spell (0 - Ready)
function vr.api.IsSpellReadyIn(spellname)
    local id = vr.api.SpellId(spellname)
    if id then
        local start, duration = GetSpellCooldown(id, 0)
        if start == 0
                and duration == 0
                --and vr.api.LastSpellCast + 1 <= GetTime() then
                and vr.api.LastSpellCast + 1 <= GetTime() then
            return 0
        end
        local remaining = duration - (GetTime() - start)
        if remaining >= 0 then
            return remaining
        end
    end
    return 86400 -- return max time (i.e not ready)
end

---[ vr.api.RemoveSpaces ]-----------------------------------------------------
function vr.api.RemoveSpaces(str)
    -- Replace all spaces with nothing (effectively removing them)
    local result = string.gsub(str, " ", "")
    return result
end

---[ vr.api.ReportCD ]---------------------------------------------------------
-- reports time left until spellname is ready, delta = time between spams
function vr.api.ReportCD(spellname, delta)
    --vr.log.Debug('Invoking vr.api.ReportCD(' .. spellname ..','.. delta .. ')')
    local min, sec
    local ttcs = vr.api.TruncateMilliseconds(vr.api.IsSpellReadyIn(spellname))

    --print(tostring(spellname) .. ' is ready in ' .. tostring(vr.api.IsSpellReadyIn(spellname)))

    if ttcs > 1 then
        if ttcs > 60 then
            min, sec = vr.api.Modulo(ttcs, 60)
            if sec < 10 then
                vr.log.Report(vr.api.RemoveSpaces(spellname), spellname .. " ready in  " .. tostring(min) .. ":0" .. tostring(sec), delta)
                return false
            else
                vr.log.Report(vr.api.RemoveSpaces(spellname), spellname .. " ready in  " .. tostring(min) .. ":" .. tostring(sec), delta)
                return false
            end
        else
            min, sec = vr.api.Modulo(ttcs, 60)
            vr.log.Report(vr.api.RemoveSpaces(spellname), spellname .. " ready in  " .. tostring(sec) .. "s", delta)
            return false
        end
    else
        vr.log.Report(vr.api.RemoveSpaces(spellname), spellname .. " ready.", delta)
        return true
    end
end

---[ vr.api.Shoot ]------------------------------------------------------------
function vr.api.Shoot()
    local ranged_type = vr.api.Ranged()
    local spell
    if ranged_type == ITEM_TYPE_BOWS_FURY then
        spell = ABILITY_SHOOT_BOW_FURY
    elseif ranged_type == ITEM_TYPE_CROSSBOWS_FURY then
        spell = ABILITY_SHOOT_CROSSBOW_FURY
    elseif ranged_type == ITEM_TYPE_GUNS_FURY then
        spell = ABILITY_SHOOT_GUN_FURY
    elseif ranged_type == ITEM_TYPE_THROWN_FURY then
        spell = ABILITY_THROW_FURY
    else
        return false
    end
    if vr.api.IsSpellReady(spell) then
        vr.log.Debug(spell)
        CastSpellByName(spell)
        vr.api.LastSpellCast = GetTime()
    end
    return true
end

---[ vr.api.SpellId ]----------------------------------------------------------
-- Get spell id from name
function vr.api.SpellId(spellname)
    local id = 1
    for i = 1, GetNumSpellTabs() do
        local _, _, _, numSpells = GetSpellTabInfo(i)
        for j = 1, numSpells do
            local spellName = GetSpellName(id, BOOKTYPE_SPELL)
            if spellName == spellname then
                return id
            end
            id = id + 1
        end
    end
    return nil
end

--endregion ----    SPELLCASTING

--region    ----    TIME

-- time() returns 
-- GetTime() returns epoch time s.mmm



--- [ vr.api.TimeHours ] -----------------------------------------------------
-- Function that echoes time in hours
function vr.api.TimeHours()
    local hours, minutes = GetGameTime();
    return hours;
end

--- [ vr.api.TimeMinutes ] ----------------------------------------------------
-- Function that echoes time in minutes
function vr.api.TimeMinutes()
    local epoch = time();
    local hours = math.floor(epoch / 3600)
    local minutes = math.floor((epoch - (hours * 3600)) / 60)
    return minutes
end

--- [ vr.api.TimeSeconds ] ----------------------------------------------------
-- Function that echoes time in seconds
function vr.api.TimeSeconds()
    local epoch = time();
    local minutes = math.floor(epoch / 60)
    local seconds = epoch - (minutes * 60)
    return seconds
end

---[ vr.api.MilliSecondsSince ]------------------------------------------------
-- Returns # of milliseconds since <timestamp>
function vr.api.MilliSecondsSince(timestamp)
    local d1 = vr.api.GetTime();
    local d2 = timestamp;

    return math.floor((-1 * (d2 - d1))*1000);
end

---[ vr.api.SecondsSince ]-----------------------------------------------------
-- Returns # of seconds since <timestamp>
function vr.api.SecondsSince(timestamp)

    i, f = vr.api.Modf(GetTime());
    j, k = vr.api.Modf(timestamp)

    local d1 = i; -- convert to seconds
    local d2 = j;

    return (-1 * (d2 - d1));
end

---[ vr.api.SecondsUntil ]-----------------------------------------------------
-- Returns # of seconds until <timestamp>
function vr.api.SecondsUntil(timestamp, delay)
    local d1 = vr.api.GetTime();
    local d2 = timestamp;

    return delay - (-1 * (d2 - d1));
end

---[ vr.api.GetTime ]----------------------------------------------------------
-- Returns the number of seconds since system up
function vr.api.GetTime()
    return GetTime();
end

---[ vr.api.TruncateMilliseconds ]---------------------------------------------
function vr.api.TruncateMilliseconds(num)
    return math.floor(num)
end

--endregion ----   TIME

--region    ----    USERINTERFACE

---[ vr.api.CreateGeneralFrameAndElements ]------------------------------------
function vr.api.CreateGeneralFrameAndElements()
    local class = UnitClass('player');
    if class == "Druid" then
        return vr.dru.CreateGeneralFrameAndElements();
    elseif class == "Hunter" then
        --return vr.hun.CreateGeneralFrameAndElements();
    elseif class == "Mage" then
        --return vr.mag.CreateGeneralFrameAndElements();
    elseif class == "Paladin" then
        --return vr.pal.CreateGeneralFrameAndElements();
    elseif class == "Priest" then
        --return vr.pri.CreateGeneralFrameAndElements();
    elseif class == "Rogue" then
        --return vr.rog.CreateGeneralFrameAndElements();
    elseif class == "Shaman" then
        --return vr.shm.CreateGeneralFrameAndElements();
    elseif class == "Warlock" then
        --return vr.wlk.CreateGeneralFrameAndElements();
    elseif class == "Warrior" then
        return vr.war.CreateGeneralFrameAndElements();
    end
end

---[ vr.api.RefreshGeneralFrameAndElements ]-----------------------------------
function vr.api.RefreshGeneralFrameAndElements()
    local class = UnitClass('player');
    if class == "Druid" then
        --return vr.dru.RefreshGeneralFrameAndElements();
    elseif class == "Hunter" then
        --return vr.hun.RefreshGeneralFrameAndElements();
    elseif class == "Mage" then
        --return vr.mag.RefreshGeneralFrameAndElements();
    elseif class == "Paladin" then
        --return vr.pal.RefreshGeneralFrameAndElements();
    elseif class == "Priest" then
        --return vr.pri.RefreshGeneralFrameAndElements();
    elseif class == "Rogue" then
        --return vr.rog.RefreshGeneralFrameAndElements();
    elseif class == "Shaman" then
        --return vr.shm.RefreshGeneralFrameAndElements();
    elseif class == "Warlock" then
        --return vr.wlk.RefreshGeneralFrameAndElements();
    elseif class == "Warrior" then
        return vr.war.RefreshGeneralFrameAndElements();
    end
end

---[ vr.api.AbilitiesFrameHide ]-----------------------------------------------
function vr.api.Reset()
    BlessIt_SetConfiguration(true)
    vr.log.Warn('Reset BlessIt to its default configuration.')
    vr.api.RefreshGeneralFrameAndElements()
    vr.api.RefreshMANFrameAndElements()
end

function vr.api.SyncTarget()
    if UnitExists("target") then
        vr.api.TargetName = UnitName('target')
        -- if vr.mobdb.Match(vr.api.TargetName) then
        --     if (UnitIsEnemy("player","target")) then
        --         vr.api.XMLSetText("GeneralOptionsFrame", "_Target", vr.log.C("Red") .. "[" .. vr.log.C("LightRed") .. vr.api.TargetName .. vr.log.C("Red") .."]")
        --     elseif (UnitCanAttack("player", "target")) then
        --         vr.api.XMLSetText("GeneralOptionsFrame", "_Target", vr.log.C("Yellow") .. "[" .. vr.log.C("LightYellow") .. vr.api.TargetName .. vr.log.C("Yellow") .."]")
        --     else
        --         vr.api.XMLSetText("GeneralOptionsFrame", "_Target", vr.log.C("Green") .. "[" .. vr.log.C("LightGreen") .. vr.api.TargetName .. vr.log.C("Green") .."]")
        --     end
        -- else
        --     if (UnitIsEnemy("player","target")) then
        --         vr.api.XMLSetText("GeneralOptionsFrame", "_Target", vr.log.C("LightRed") .. vr.api.TargetName)
        --     else
        --         vr.api.XMLSetText("GeneralOptionsFrame", "_Target", vr.log.C("LightGreen") .. vr.api.TargetName)
        --     end
        -- end

    else
        --vr.api.XMLSetText("GeneralOptionsFrame", "_Target", vr.log.C("LightGray") .. "No Target")
    end
end

-- syncs distance display in class General Options panel
function vr.api.SyncDistance()
    --with wr
    -- if vr.va.isRunning then
    --     if UnitExists("target") then
    --         --GeneralOptionsFrame_Distance:SetText(vr.va.distance);
    --         --vr.api.XMLSetText("GeneralOptionsFrame", "_Distance", vr.va.distance)
    --         return;
    --     else
    --         --GeneralOptionsFrame_Distance:SetText("No Target");
    --         --vr.api.XMLSetText("GeneralOptionsFrame", "_Distance", "No Target")
    --         return;
    --     end
    -- end

    -- without wr
    -- if vr.class.talent == vr.talents.DRU then
    --     local distance = vr.dru.GetDistance();
    --     if UnitExists("target") then
    --         vr.api.XMLSetText("GeneralOptionsFrame", "_Distance", distance)
    --     else
    --         vr.api.XMLSetText("GeneralOptionsFrame", "_Distance", "No Target")
    --     end

    -- elseif vr.class.talent == vr.talents.HUNBM or vr.class.talent == vr.talents.HUNMM then
    --     local distance = vr.hun.GetDistance();
    --     if UnitExists("target") then
    --         vr.api.XMLSetText("GeneralOptionsFrame", "_Distance", distance)
    --     else
    --         vr.api.XMLSetText("GeneralOptionsFrame", "_Distance", "No Target")
    --     end

    -- elseif vr.class.talent == vr.talents.MAGFIRE or vr.class.talent == vr.talents.MAGFROST then
    --     local distance = vr.mag.GetDistance();
    --     if UnitExists("target") then
    --         vr.api.XMLSetText("GeneralOptionsFrame", "_Distance", distance)
    --     else
    --         vr.api.XMLSetText("GeneralOptionsFrame", "_Distance", "No Target")
    --     end

    -- elseif vr.class.talent == vr.talents.PALHOLY or vr.class.talent == vr.talents.PALPROT or vr.class.talent == vr.talents.PALRET then
    --     local distance = vr.pal.GetDistance();
    --     if UnitExists("target") then
    --         vr.api.XMLSetText("GeneralOptionsFrame", "_Distance", distance)
    --     else
    --         vr.api.XMLSetText("GeneralOptionsFrame", "_Distance", "No Target")
    --     end

    -- elseif vr.class.talent == vr.talents.PRIHOLY or vr.class.talent == vr.talents.PRISHADOW then
    --     local distance = vr.pri.GetDistance();
    --     if UnitExists("target") then
    --         vr.api.XMLSetText("GeneralOptionsFrame", "_Distance", distance)
    --     else
    --         vr.api.XMLSetText("GeneralOptionsFrame", "_Distance", "No Target")
    --     end

    -- elseif vr.class.talent == vr.talents.ROGCOMBAT or vr.class.talent == vr.talents.ROGSUB then
    --     local distance = vr.rog.GetDistance();
    --     if UnitExists("target") then
    --         vr.api.XMLSetText("GeneralOptionsFrame", "_Distance", distance)
    --     else
    --         vr.api.XMLSetText("GeneralOptionsFrame", "_Distance", "No Target")
    --     end

    -- elseif vr.class.talent == vr.talents.SHMHEAL or vr.class.talent == vr.talents.SHMRDPS or vr.class.talent == vr.talents.SHMTANK then
    --     local distance = vr.shm.GetDistance();
    --     if UnitExists("target") then
    --         vr.api.XMLSetText("GeneralOptionsFrame", "_Distance", distance)
    --     else
    --         vr.api.XMLSetText("GeneralOptionsFrame", "_Distance", "No Target")
    --     end

    -- elseif vr.class.talent == vr.talents.WAR then
    --     local distance = vr.war.GetDistance();
    --     if UnitExists("target") then
    --         vr.api.XMLSetText("GeneralOptionsFrame", "_Distance", distance)
    --     else
    --         vr.api.XMLSetText("GeneralOptionsFrame", "_Distance", "No Target")
    --     end

    -- elseif vr.class.talent == vr.talents.WLKDSR or vr.class.talent == vr.talents.WLKSMR then
    --     local distance = vr.rog.GetDistance();
    --     if UnitExists("target") then
    --         vr.api.XMLSetText("GeneralOptionsFrame", "_Distance", distance)
    --     else
    --         vr.api.XMLSetText("GeneralOptionsFrame", "_Distance", "No Target")
    --     end
    -- end

end

---[ vr.api.AbilitiesFrameHide ]-----------------------------------------------
function vr.api.AbilitiesFrameHide()
    for _, talent in pairs(vr.talents) do
        getglobal("AbilitiesFrame" .. talent):Hide();
    end
end

---[ vr.api.AbilitiesFrameSetText ]--------------------------------------------
function vr.api.AbilitiesFrameSetText(suffix, text)
    for _, talent in pairs(vr.talents) do
        if talent == vr.class.talent then
            getglobal("AbilitiesFrame" .. talent .. suffix):SetText(text);
        end
    end
end

---[ vr.api.AbilitiesFrameShow ]-----------------------------------------------
function vr.api.AbilitiesFrameShow()
    for _, talent in pairs(vr.talents) do
        if talent == vr.class.talent then
            getglobal("AbilitiesFrame" .. talent):Show();
            --jgp(tostring(talent) .. " show yoself")
        else
            getglobal("AbilitiesFrame" .. talent):Hide();
            --jgp(tostring(talent) .. " hide yoself")
        end
    end
end

---[ vr.api.CreateMANFrameAndElements ]----------------------------------------
function vr.api.CreateMANFrameAndElements()

    -- TEST creating Frame:[checkbutton+text] from template
    if not MANFrameElements then
        MANFrameElements = {}
    end

    -- list of VRGO elements we want posted in this frame
    if not VRGOCheckboxesForMANF then
        VRGOCheckboxesForMANF = {
            'WLAction',
            'WLDebug',
            'WLEvent',
            'WLAllEvents',
            'AnnounceActions',
            'VerboseTargeting',
            'SuppressBlessItLogging'
        }
    end

    -- Iterate over VRGO elements matching elements listed in MANFrameElements
    -- ..this way we can include only the data we want to display
    local x = 20
    local y = -40
    local count = 1
    for _, data in next, VRGO do
        --vr.log.Log('searching for ' .. data.name)
        if vr.api.FindStringInArray(VRGOCheckboxesForMANF, data.name) then
            --vr.log.Log('found: ' .. data.name)

            if not MANFrameElements[data.name] then
                MANFrameElements[data.name]
                = CreateFrame('Frame', 'MANF_VRGO_' .. data.name, getglobal('MANF'), 'BlessItCheckboxTemplate')
                --= BlessItCreateCheckbox(data.name, 'MANF')
            end
            y = (count * -15) - 40
            MANFrameElements[data.name]:SetPoint("TOPLEFT", getglobal('MANF'), "TOPLEFT", x, y)


            --print('creating ' .. tostring(data.name) .. ' UI element for: ' .. tostring(getglobal('MANF')))
            --vr.log.Log('PROBE');

            --getglobal("MANF_" .. data.name .. "_Check"):SetID(data.id)
            --getglobal("MANF." .. data.name):SetText("AAA")
            -- getglobal("MANF" .. data.id .. "Check"):SetChecked(GOg(data.name))

            getglobal('MANF_VRGO_' .. data.name .. '_ItemName'):SetText('|cffffffff' .. data.sdesc)

            getglobal('MANF_VRGO_' .. data.name .. '_Check'):SetChecked(data.val)

            vr.api.addButtonOnEnterTooltip(getglobal('MANF_VRGO_' .. data.name .. '_Check'), data.ldesc)

            count = count + 1
            --print('created frame:' .. tostring('MANF_VRGO_' .. data.name))

        end

    end
    print('IS THIS THING ON???')
end

---[ vr.api.RefreshMANFrameAndElements ]---------------------------------------
function vr.api.RefreshMANFrameAndElements()



    -- Iterate over VRGO elements matching elements listed in MANFrameElements
    -- ..this way we can include only the data we want to display
    -- local x = 20
    -- local y = -40
    -- local count = 1
    for _, data in next, VRGO do
        --vr.log.Log('searching for ' .. data.name)
        if vr.api.FindStringInArray(VRGOCheckboxesForMANF, data.name) then
            --vr.log.Log('found: ' .. data.name)

            -- if not MANFrameElements[data.name] then
            --     MANFrameElements[data.name]
            --     = CreateFrame('Frame', 'MANF_VRGO_' .. data.name, getglobal('MANF'), 'BlessItCheckboxTemplate')
            --     --= BlessItCreateCheckbox(data.name, 'MANF')
            -- end
            -- y = (count * -15) - 40
            -- MANFrameElements[data.name]:SetPoint("TOPLEFT", getglobal('MANF'), "TOPLEFT", x, y)

            --vr.log.Log('PROBE');

            --getglobal("MANF_" .. data.name .. "_Check"):SetID(data.id)
            --getglobal("MANF." .. data.name):SetText("AAA")
            -- getglobal("MANF" .. data.id .. "Check"):SetChecked(GOg(data.name))

            --getglobal('MANF_VRGO_' .. data.name .. '_ItemName'):SetText('|cffffffff' .. data.sdesc)

            if getglobal('MANF_VRGO_' .. data.name .. '_Check') then
                getglobal('MANF_VRGO_' .. data.name .. '_Check'):SetChecked(data.val)
            end
            

            -- vr.api.addButtonOnEnterTooltip(getglobal('MANF_VRGO_' .. data.name .. '_Check'), data.ldesc)

            -- count = count + 1
            --print('created frame:' .. tostring('MANF_VRGO_' .. data.name))

        end

    end

end

---[ vr.api.GetWidgetInfo ]----------------------------------------------------
function vr.api.GetWidgetInfo(str_)
    --print('str: ' .. tostring(str))
    local ex = string.split(str_, "_")
    --local ex = strsplit("_", tostring(str))
    --vr.log.Debug('ex1: ' .. tostring(ex[1]) .. ' /ex2: ' .. tostring(ex[2]) .. ' /ex3: ' .. tostring(ex[3]) .. ' /ex4: ' .. tostring(ex[4]))
    return ex[1], ex[2], ex[3], ex[4]
end



---[ vr.api.ToggleCheckbox ]---------------------------------------------------
function vr.api.ToggleCheckbox(addr, check)
    -- first, confirm that name exists?
    local frame, db, name, element = vr.api.GetWidgetInfo(addr)

    for _, data in next, getglobal(db) do
        if data.name == name then
            if check then
                data.val = true
            else
                data.val = false
            end
            getglobal(frame .. '_' .. db .. '_' .. name .. '_' .. element):SetChecked(data.val)
            vr.log.LogBoolVarToggle(name, data.val)
        end
    end

    -- if check then
    --     print('checked: ' .. tostring(db) .. '/' .. tostring(name))
    -- else
    --     print('not checked: ' .. tostring(db) .. '/' .. tostring(name))
    -- end
end

---[ vr.api.AddButton ]--------------------------------------------------------
function vr.api.AddButton(addr)
    -- first, confirm that name exists?
    local frame, db, name, _ = vr.api.GetWidgetInfo(addr)
    for _, data in next, getglobal(db) do
        if data.name == name then
            if data.val ~= data.max then
                data.val = data.val + data.delta
            end
            getglobal(frame .. '_' .. db .. '_' .. name .. '_ItemValue'):SetText('|cffffffff' .. data.val)
            vr.log.LogIntVarChange(name, data.val)
        end
    end
end

---[ vr.api.SubButton ]--------------------------------------------------------
function vr.api.SubButton(addr)
    -- first, confirm that name exists?
    local frame, db, name, _ = vr.api.GetWidgetInfo(addr)
    for _, data in next, getglobal(db) do
        if data.name == name then
            if data.val ~= data.min then
                data.val = data.val - data.delta
            end
            getglobal(frame .. '_' .. db .. '_' .. name .. '_ItemValue'):SetText('|cffffffff' .. data.val)
            vr.log.LogIntVarChange(name, data.val)
        end
    end
end

---[ vr.api.SwitchButton ]-----------------------------------------------------
function vr.api.SwitchButton(addr)
    local frame, db, name, _ = vr.api.GetWidgetInfo(addr)
    for _, data in next, getglobal(db) do
        if data.name == name then

            data.val = not data.val

            if data.val then
                getglobal(frame .. '_' .. db .. '_' .. name .. '_Button'):SetText(vr.log.C("LightGreen") .. data.name)
            else
                getglobal(frame .. '_' .. db .. '_' .. name .. '_Button'):SetText(vr.log.C("LightGray") .. data.name)
            end

            vr.log.LogBoolVarToggle(name, data.val)

        end
    end
end

---[ vr.api.TwoInputSwitchButton1 ]--------------------------------------------
function vr.api.TwoInputSwitchButton1(addr)
    local frame, db, name, _ = vr.api.GetWidgetInfo(addr)
    for _, data in next, getglobal(db) do
        if data.name == name then
            getglobal(frame .. '_' .. db .. '_' .. name .. '_State1'):SetText(vr.log.C("LightGreen") .. data.state1)
            getglobal(frame .. '_' .. db .. '_' .. name .. '_State2'):SetText(vr.log.C("Gray") .. data.state2)
            data.val = true
            vr.log.LogBoolVarToggle(name, data.val)

            -- Warrior
            if name == MODE_HEADER_PROT then
                vr.war.WAToggleRole(Cg(MODE_HEADER_PROT), Cg(MODE_HEADER_MITITHREAT))
            elseif name == MODE_HEADER_MITITHREAT then
                vr.war.WAToggleRole(Cg(MODE_HEADER_PROT), Cg(MODE_HEADER_MITITHREAT))
            elseif name == MODE_HEADER_AOE then
                vr.war.WAToggleAoe(Cg(MODE_HEADER_AOE))
            end
        end
    end
end

---[ vr.api.TwoInputSwitchButton2 ]--------------------------------------------
function vr.api.TwoInputSwitchButton2(addr)
    local frame, db, name, _ = vr.api.GetWidgetInfo(addr)
    for _, data in next, getglobal(db) do
        if data.name == name then
            getglobal(frame .. '_' .. db .. '_' .. name .. '_State1'):SetText(vr.log.C("Gray") .. data.state1)
            getglobal(frame .. '_' .. db .. '_' .. name .. '_State2'):SetText(vr.log.C("LightGreen") .. data.state2)
            data.val = false
            vr.log.LogBoolVarToggle(name, data.val)

            -- Warrior
            if name == MODE_HEADER_PROT then
                vr.war.WAToggleRole(Cg(MODE_HEADER_PROT), Cg(MODE_HEADER_MITITHREAT))
            elseif name == MODE_HEADER_MITITHREAT then
                vr.war.WAToggleRole(Cg(MODE_HEADER_PROT), Cg(MODE_HEADER_MITITHREAT))
            elseif name == MODE_HEADER_AOE then
                vr.war.WAToggleAoe(Cg(MODE_HEADER_AOE))
            end
        end
    end
end

---[ vr.api.FourInputSwitchButton1 ]-------------------------------------------
function vr.api.FourInputSwitchButton1(addr)
    local frame, db, name, state = vr.api.GetWidgetInfo(addr)
    for _, data in next, getglobal(db) do
        if data.name == name and state == 'State1' then
            getglobal(frame .. '_' .. db .. '_' .. name .. '_State1'):SetText(vr.log.C("LightGreen") .. data.states[1])
            getglobal(frame .. '_' .. db .. '_' .. name .. '_State2'):SetText(vr.log.C("Gray") .. data.states[2])
            getglobal(frame .. '_' .. db .. '_' .. name .. '_State3'):SetText(vr.log.C("Gray") .. data.states[3])
            getglobal(frame .. '_' .. db .. '_' .. name .. '_State4'):SetText(vr.log.C("Gray") .. data.states[4])
            data.val = data.states[1]
            vr.log.LogStateVarChange(name, data.val)
        end
    end
end

---[ vr.api.FourInputSwitchButton2 ]-------------------------------------------
function vr.api.FourInputSwitchButton2(addr)
    local frame, db, name, state = vr.api.GetWidgetInfo(addr)
    for _, data in next, getglobal(db) do
        if data.name == name and state == 'State2' then
            getglobal(frame .. '_' .. db .. '_' .. name .. '_State1'):SetText(vr.log.C("Gray") .. data.states[1])
            getglobal(frame .. '_' .. db .. '_' .. name .. '_State2'):SetText(vr.log.C("LightGreen") .. data.states[2])
            getglobal(frame .. '_' .. db .. '_' .. name .. '_State3'):SetText(vr.log.C("Gray") .. data.states[3])
            getglobal(frame .. '_' .. db .. '_' .. name .. '_State4'):SetText(vr.log.C("Gray") .. data.states[4])
            data.val = data.states[2]
            vr.log.LogStateVarChange(name, data.val)
        end
    end
end

---[ vr.api.FourInputSwitchButton3 ]-------------------------------------------
function vr.api.FourInputSwitchButton3(addr)
    local frame, db, name, state = vr.api.GetWidgetInfo(addr)
    for _, data in next, getglobal(db) do
        if data.name == name and state == 'State3' then
            getglobal(frame .. '_' .. db .. '_' .. name .. '_State1'):SetText(vr.log.C("Gray") .. data.states[1])
            getglobal(frame .. '_' .. db .. '_' .. name .. '_State2'):SetText(vr.log.C("Gray") .. data.states[2])
            getglobal(frame .. '_' .. db .. '_' .. name .. '_State3'):SetText(vr.log.C("LightGreen") .. data.states[3])
            getglobal(frame .. '_' .. db .. '_' .. name .. '_State4'):SetText(vr.log.C("Gray") .. data.states[4])
            data.val = data.states[3]
            vr.log.LogStateVarChange(name, data.val)
        end
    end
end

---[ vr.api.FourInputSwitchButton4 ]-------------------------------------------
function vr.api.FourInputSwitchButton4(addr)
    local frame, db, name, state = vr.api.GetWidgetInfo(addr)
    for _, data in next, getglobal(db) do
        if data.name == name and state == 'State4' then
            getglobal(frame .. '_' .. db .. '_' .. name .. '_State1'):SetText(vr.log.C("Gray") .. data.states[1])
            getglobal(frame .. '_' .. db .. '_' .. name .. '_State2'):SetText(vr.log.C("Gray") .. data.states[2])
            getglobal(frame .. '_' .. db .. '_' .. name .. '_State3'):SetText(vr.log.C("Gray") .. data.states[3])
            getglobal(frame .. '_' .. db .. '_' .. name .. '_State4'):SetText(vr.log.C("LightGreen") .. data.states[4])
            data.val = data.states[4]
            vr.log.LogStateVarChange(name, data.val)
        end
    end
end




---[ vr.api.SwitchHUDClassFrameTexturedButton ]--------------------------------
function vr.api.SwitchHUDClassFrameTexturedButton(addr)

    --print(tostring(vr.api.GetWidgetInfo(addr)))

    local class = UnitClass('player');
    if class == "Druid" then
        vr.dru.SwitchHUDClassFrameTexturedButton(addr);
    elseif class == "Hunter" then
        vr.hun.SwitchHUDClassFrameTexturedButton(addr);
    elseif class == "Mage" then
        vr.mag.SwitchHUDClassFrameTexturedButton(addr);
    elseif class == "Paladin" then
        vr.pal.SwitchHUDClassFrameTexturedButton(addr);
    elseif class == "Priest" then
        vr.pri.SwitchHUDClassFrameTexturedButton(addr);
    elseif class == "Rogue" then
        vr.rog.SwitchHUDClassFrameTexturedButton(addr);
    elseif class == "Shaman" then
        vr.shm.SwitchHUDClassFrameTexturedButton(addr);
    elseif class == "Warlock" then
        vr.wlk.SwitchHUDClassFrameTexturedButton(addr);
    elseif class == "Warrior" then
        vr.war.SwitchHUDClassFrameTexturedButton(addr);
    end



    -- --
    -- local frame, db, name, _ = vr.api.GetWidgetInfo(addr)

    -- if frame and db and name then
    --     print('frame:' .. tostring(frame) .. ' /db:' .. tostring(db) .. ' /name:' .. tostring(name))
    -- end

    -- for _, data in next, getglobal(db) do
    --     if data.name == name then

    --         data.val = not data.val

    --         -- if data.val then
    --         --     getglobal(frame .. '_' .. db .. '_' .. name .. '_Button'):SetText(vr.log.C("LightGreen") .. data.name)
    --         -- else
    --         --     getglobal(frame .. '_' .. db .. '_' .. name .. '_Button'):SetText(vr.log.C("LightGray") .. data.name)
    --         -- end

    --         vr.log.LogBoolVarToggle(name, data.val)

    --     end
    -- end
end

---[ vr.api.ResetHUDFrame ]----------------------------------------------------
function vr.api.ResetHUDFrame()
    -- if HUDFrame:IsVisible() then
    --     HUDFrame:Hide()
    --     print('hiding HUDFrame')
    -- else
        
    --     print('showing HUDFrame')
    -- end
    HUDFrame:Show()
    HUDFrame:SetPoint("CENTER", 0, 490)  --put HUDFrame dead center
end

---[ vr.api.addButtonOnEnterTooltip ]------------------------------------------
function vr.api.addButtonOnEnterTooltip(frame, desc)

    frame:SetScript("OnEnter", function(self)
        BlessItToolTip:SetOwner(this, "ANCHOR_RIGHT", -(this:GetWidth() / 4), -(this:GetHeight() / 4));
        BlessItToolTip:SetText(desc);
        BlessItToolTip:Show();
    end)
    frame:SetScript("OnLeave", function(self)
        BlessItToolTip:Hide();
    end)
end

---[ vr.api.addTitleOnEnterTooltip ]------------------------------------------
function vr.api.addTitleOnEnterTooltip(frame, desc)

    frame:SetScript("OnEnter", function(self)
        BlessItToolTip:SetOwner(this, "ANCHOR_RIGHT", -(this:GetWidth() / 4), -(this:GetHeight() / 4));
        BlessItToolTip:SetText(desc);
        BlessItToolTip:Show();
    end)
    frame:SetScript("OnLeave", function(self)
        BlessItToolTip:Hide();
    end)
end

function vr.api.InitializeVRGOCheckboxesForMANF()
    for _, data in next, VRGO do
        if data.name == name then
            if check then
                data.val = true
            else
                data.val = false
            end
            vr.log.LogBoolVarToggle(name, data.val)
        end
    end
end

---[ vr.api.GeneralOptionsFrameHide ]------------------------------------------
function vr.api.GeneralOptionsFrameHide()
    for _, talent in pairs(vr.talents) do
        getglobal("GeneralOptionsFrame" .. talent):Hide();
    end
end

---[ vr.api.BlessItConfig_GeneralOptionsSetText ]--------------------------------
function vr.api.BlessItConfig_GeneralOptionsSetText(suffix, text)
    for _, talent in pairs(vr.talents) do
        if talent == vr.class.talent then
            getglobal("GeneralOptionsFrame" .. talent .. suffix):SetText(text);
        end
    end
end

---[ vr.api.GeneralOptionsFrameShow ]------------------------------------------
function vr.api.GeneralOptionsFrameShow()
    for _, talent in pairs(vr.talents) do
        if talent == vr.class.talent then
            getglobal("GeneralOptionsFrame" .. talent):Show();
            --jgp(tostring(talent) .. " show yoself")
        else
            getglobal("GeneralOptionsFrame" .. talent):Hide();
            --jgp(tostring(talent) .. " hide yoself")
        end
    end
end

---[ vr.api.InitGeneralOptionsFrame ]------------------------------------------
function vr.api.InitGeneralOptionsFrame()



    -- only automatically show the UI if class is defined
    local class = UnitClass('player');
    if class == "Druid" then

    elseif class == "Hunter" then

    elseif class == "Mage" then

    elseif class == "Paladin" then

    elseif class == "Priest" then

    elseif class == "Rogue" then

    elseif class == "Shaman" then

    elseif class == "Warrior" then

    elseif class == "Warlock" then

    end

    if not BlessIt_InitGeneralOptionsTab then
        local uiexists
        for _, talent in pairs(vr.talents) do
            if talent == vr.class.talent then
                uiexists = getglobal("GeneralOptionsFrame" .. talent)
            end
        end

        if uiexists then
            for _, talent in pairs(vr.talents) do
                if talent == vr.class.talent then
                    getglobal("GeneralOptionsFrame" .. talent):Show();
                    --jgp(tostring(talent) .. " show yoself")
                else
                    getglobal("GeneralOptionsFrame" .. talent):Hide();
                    --jgp(tostring(talent) .. " hide yoself")
                end
            end
            BlessIt_InitGeneralOptionsTab = true;
        end
    end

    if not BlessIt_ShowGeneralOptionsFrameStart then
        local uiexists = getglobal("BlessItFrame")
        if uiexists then
            --BlessIt_ToggleConfigurationPanel();
            BlessIt_ShowGeneralOptionsFrameStart = true;
        end
    end
end

function vr.api.Notify(notification)
    if not vr.wr.isRunning then
        if notification == "powerup" then
            PlaySoundFile("Interface\\Addons\\BlessIt\\Sound\\smb_powerup.wav")
        end
        if notification == "approved" then
            PlaySoundFile("Interface\\Addons\\BlessIt\\Sound\\approved.wav")
        end
        if notification == "denied" then
            PlaySoundFile("Interface\\Addons\\BlessIt\\Sound\\denied.wav")
        end
    end
end

---[ vr.war.SlashCommands ]----------------------------------------------------
function vr.api.SlashCommands(msg)
    --print('vr.api.SlashCommands(msg):' .. tostring(msg))
    -- MATCH 3 ARGUMENTS
    local _, _, arg1, arg2, arg3 = string.find(msg, "(%w+)%s(%w+)%s(%w+)")

    if arg1 ~= nil and arg2 ~= nil and arg3 ~= nil then
        vr.log.Log(vr.log.Format3Var("[3 args]"," /arg1:", arg1," /arg2:", arg2," /arg3:", arg3))

        -- do things

        return;
    end

    -- MATCH 2 ARGUMENTS
    arg1, arg2 = nil;
    local _, _, arg1, arg2= string.find(msg, "(%w+)%s(%w+)")

    if arg1 ~= nil and arg2 ~= nil then
        --print('[2 args] /msg: ' .. msg .. ' /arg4: ' .. arg4 .. ' /arg5: ' .. arg5)
        --vr.log.Log(vr.log.Format2Var("[2 args]"," /arg1:", arg1," /arg2:", arg2))

        return;
    end

    -- MATCH 1 ARGUMENT
    arg1 = nil;
    local arg1 = string.lower(msg)

    --print('string.lower(msg):' .. tostring(msg))

    if arg1 == "buff" then
        --vr.log.Log(vr.log.Format1Var("[1 args]"," /arg1:", arg1))
        local class = UnitClass('player');
        if class == "Druid" then
            vr.dru.Buff()
        elseif class == "Hunter" then
            --vr.hun.Buff()
        elseif class == "Mage" then
            --vr.mag.Buff()
        elseif class == "Paladin" then
            --vr.pal.Buff()
        elseif class == "Priest" then
            --vr.pri.Buff()
        elseif class == "Rogue" then
            --vr.rog.Buff()
        elseif class == "Shaman" then
            --vr.shm.Buff()
        elseif class == "Warlock" then
            --vr.wlk.Buff()
        elseif class == "Warrior" then
            --vr.war.Buff()
        end
        return;
    end

    if arg1 == "loot" then
        vr.log.Log(vr.log.Format1Var("[1 args]"," /arg1:", arg1))
        vr.api.Loot()
        return;
    end

    if arg1 ~= nil then
        if arg1 == "radar" then
            --vr.log.Log(vr.log.Format1Var("[1 args]"," /arg1:", arg1))
            --vr.rad.ToggleRadar()
            HUDs('Radar', not HUDg('Radar'))
            return;
        end
    end

    if arg1 ~= nil then
        if arg1 == "reset" then
            --vr.log.Log(vr.log.Format1Var("[1 args]"," /arg1:", arg1))
            vr.api.Reset()
            return;
        end
    end

    if arg1 ~= nil then
        if arg1 == "resethud" then
            --vr.log.Log(vr.log.Format1Var("[1 args]"," /arg1:", arg1))
            vr.api.ResetHUDFrame()
            return;
        end
    end
    
end

function vr.api.HUDToggle()

    if HUDFrame:IsShown() then
        HUDFrame:Hide()
        -- vr.war.WAHideMDPSWAAF()
        -- vr.war.WAHideTankWAAF()
        --vr.war.WAHideAll()
    elseif not HUDFrame:IsShown() then
        HUDFrame:Show()
        -- if Cg(MODE_HEADER_PROT) then
        --     vr.war.WAHideAll()
        --     vr.war.WAShowTankWAAF()
        -- else
        --     vr.war.WAHideAll()
        --     vr.war.WAShowMDPSWAAF()
        -- end
    end

end

---[ vr.api.XMLSetText ]-------------------------------------------------------
function vr.api.XMLSetText(prefix, suffix, text)
    for _, talent in pairs(vr.talents) do
        if talent == vr.class.talent then
            getglobal(prefix .. talent .. "_Text" .. suffix):SetText(text);
        end
    end
end

--endregion ----    USERINTERFACE

--region    ----    UTILITIES

---[ vr.api.GetSpec ]----------------------------------------------------------
function vr.api.GetClassAndSpec()
    return vr.class.talent;
end

---[ vr.api.GetWoWVersion ]----------------------------------------------------
function vr.api.DisplayWoWVersionAndWRStatus()
    --BlessItConfig_Text_WoWVersion
    local versionStatus = "WoW version [" .. vr.api.GetWoWVersion(true) .. "] (" .. vr.api.GetWoWVersion() .. ")" .. vr.log.C("LightRed") .. " WR"

    if vr.wr.isRunning then
        versionStatus = "WoW version [" .. vr.api.GetWoWVersion(true) .. "] (" .. vr.api.GetWoWVersion() .. ")" .. vr.log.C("LightGreen") .. " WR"
    end

    BlessItConfig_Text_WoWVersion:SetText(versionStatus)
end

---[ vr.api.GetWoWVersion ]----------------------------------------------------
function vr.api.CheckWoWVersion(version)
    local ClientVersion = GetBuildInfo();
    --print('ClientVersion:' .. tostring(ClientVersion))
    if ClientVersion == "1.12.1" then
        --vr.log.Debug("BlessIt AIO TurtleWoW Macros [v" .. BlessIt_VERSION .. "] Client " .. ClientVersion)
        return "vanilla"==version;
        --vr.log.Log("this is regular-ass vanilla wow")
    --elseif ClientVersion == "1.16.5" then
        --vr.log.Debug("BlessIt AIO VanillaWoW Macros [v" .. BlessIt_VERSION .. "] Client " .. ClientVersion)
        --return "twow"==version;
        --vr.log.Log("this is a server for confused transgender turtles")
    elseif ClientVersion == "1.17.1" then
        --vr.log.Debug("BlessIt AIO VanillaWoW Macros [v" .. BlessIt_VERSION .. "] Client " .. ClientVersion)
        return "twow"==version;
        --vr.log.Log("this is a server for confused transgender turtles")
    else
        --vr.log.Debug("BlessIt AIO VanillaWoW Macros [v" .. BlessIt_VERSION .. "] Client " .. ClientVersion)
        return false;
        --vr.log.Log("this is some wierd-ass server that i'm probably not compatible with")
    end
end

---[ vr.api.FindStringInArray ]----------------------------------------------------
-- Function to find the string in a flat array
function vr.api.FindStringInArray(array, stringToFind)
    for i, value in ipairs(array) do
        if value == stringToFind then
            return i -- Return the index of the matching element
        end
    end
    return nil -- Return nil if the string was not found
end

---[ vr.api.RunLuaCommand ]----------------------------------------------------
function vr.api.RunLuaCommand(command)
    DEFAULT_CHAT_FRAME.editBox:SetText(command)
    ChatEdit_SendText(DEFAULT_CHAT_FRAME.editBox, 0)
end

---[ vr.api.GetWoWVersion ]----------------------------------------------------
function vr.api.GetWoWVersion(number)
    local ClientVersion = GetBuildInfo();
    if not number then
        if ClientVersion == "1.12.1" then
            --vr.log.Debug("BlessIt AIO TurtleWoW Macros [v" .. BlessIt_VERSION .. "] Client " .. ClientVersion)
            return "vanilla";
            --vr.log.Log("this is regular-ass vanilla wow")
        elseif ClientVersion == "1.17.1" then
            --vr.log.Debug("BlessIt AIO VanillaWoW Macros [v" .. BlessIt_VERSION .. "] Client " .. ClientVersion)
            return "twow";
            --vr.log.Log("this is a server for confused transgender turtles")
        else
            --vr.log.Debug("BlessIt AIO VanillaWoW Macros [v" .. BlessIt_VERSION .. "] Client " .. ClientVersion)
            return "invalid";
            --vr.log.Log("this is some wierd-ass server that i'm probably not compatible with")
        end
    else
        return ClientVersion
    end
end

---[ vr.api.IsClassRunning ]---------------------------------------------------
function vr.api.IsClassRunning(currentClass)
    local class = UnitClass('player');
    if class == currentClass then
        return true
    end
    return false
end

---[ vr.api.res ]--------------------------------------------------------------
-- list of targets where resistance is useful
local res = {
    ["fire"] = {
        BOSS_NAX_GRAND_WIDOW_FAERLINA_FURY,
        BOSS_NAX_THANE_KORTH_AZZ_FURY,
        BOXX_MC_RAGNAROS_FURY,
        BOSS_ONYXIA_FURY
    },
    ["frost"] = {
        BOSS_NAX_KEL_THUZAD_FURY,
        BOSS_NAX_SAPPHIRON_FURY
    },
    ["nature"] = {
        BOSS_NAX_HEIGAN_THE_UNCLEAN_FURY,
        BOSS_NAX_LOATHEB_FURY,
        BOSS_AQ40_PRINCESS_HUHURAN_FURY,
        BOSS_AQ40_VISCIDUS_FURY,
    },
    ["shadow"] = {
        BOSS_NAX_LOATHEB_FURY,
        BOSS_STRAT_BARON_RIVENDERE_FURY,
        BOSS_NAX_LADY_BLAUMEUX_FURY
    },
    ["arcane"] = {
        BOSS_NAX_GOTHIK_THE_HARVESTER_FURY,
        BOSS_AQ40_THE_PROPHET_SKERAM_FURY,
        BOSS_AQ40_EMPEROR_VEK_LOR_FURY,
        BOSS_MC_SHAZZRATH_FURY
    },
    ["holy"] = {
        BOSS_NAX_SIR_ZELIEK_FURY
    }
}

---[ vr.api.IsUseRes ]---------------------------------------------------------
-- Check if boss 'requires' resistance of specific type
function vr.api.IsUseRes(type)
    for _, name in pairs(res[type]) do
        if UnitName("target") == name then
            return true
        end
    end
    return false
end

---[ vr.api.Mod ]--------------------------------------------------------------
-- Performs modulo math operation on a % b. returns remainder
function vr.api.Mod(a, b)
    return a - (math.floor(a/b)*b)
end

---[ vr.api.Modulo ]-----------------------------------------------------------
-- Performs modulo math operation on a % b. returns quotient & remainder
function vr.api.Modulo(a, b)
    -- Check if b is not zero to avoid division by zero error
    if b == 0 then
        print("Error: Division by zero")
        return nil, nil
    end

    local quotient = math.floor(a / b)
    local remainder = vr.api.Mod(a, b)
    return quotient, remainder
end

---[ vr.api.Modf ]-------------------------------------------------------------
-- Returns the integral and fractional part of its argument
function vr.api.Modf(number)
    local integralPart = math.floor(number)
    local fractionalPart = number - integralPart
    return integralPart, fractionalPart
end

---[ vr.api.Round ]------------------------------------------------------------
-- Rounds
-- function round(n)
--     return n % 1 >= 0.5 and math.ceil(n) or math.floor(n)
-- end

function vr.api.Round(n)
    --return n % 1 >= 0.5 and math.ceil(n) or math.floor(n)
    return vr.api.Mod(n, 1) >= 0.5 and math.ceil(n) or math.floor(n)
end

---[ vr.api.Set ]--------------------------------------------------------------
function vr.api.Set (list)
    local set = {{}}
    for _, l in ipairs(list) do set[l] = true end
    return set
end

---[ split ]-------------------------------------------------------------------
function string:split(delimiter)
    local result = {}
    local from = 1
    local delim_from, delim_to = string.find(self, delimiter, from)
    while delim_from do
        table.insert(result, string.sub(self, from, delim_from - 1))
        from = delim_to + 1
        delim_from, delim_to = string.find(self, delimiter, from)
    end
    table.insert(result, string.sub(self, from))
    return result
end

---[ vr.api.Stimulus ]---------------------------------------------------------
function vr.api.Stimulus()
    local class = UnitClass('player');
    if class == "Druid" then
        vr.dru.Stimulus();
    elseif class == "Hunter" then
        vr.hun.Stimulus();
    elseif class == "Mage" then
        vr.mag.Stimulus();
    elseif class == "Paladin" then
        vr.pal.Stimulus()
    elseif class == "Priest" then
        vr.pri.Stimulus()
    elseif class == "Rogue" then
        vr.rog.Stimulus();
    elseif class == "Shaman" then
        vr.shm.Stimulus();
    elseif class == "Warlock" then
        vr.wlk.Stimulus();
    elseif class == "Warrior" then
        vr.war.Stimulus();
    end
end

---[ vr.api.SyncClassData ]----------------------------------------------------
vr.api.SyncClassData = function()
    vr.trinkets.ScanTrinkets()
    local class = UnitClass('player');
    if class == "Druid" then
        vr.dru.SyncClassData();
    elseif class == "Hunter" then
        vr.hun.SyncClassData();
    elseif class == "Mage" then
        vr.mag.SyncClassData();
    elseif class == "Paladin" then
        vr.pal.SyncClassData()
    elseif class == "Priest" then
        vr.pri.SyncClassData()
    elseif class == "Rogue" then
        vr.rog.SyncClassData();
    elseif class == "Shaman" then
        vr.shm.SyncClassData();
    elseif class == "Warlock" then
        vr.wlk.SyncClassData();
    elseif class == "Warrior" then
        vr.war.SyncClassData();
    end
end

-------------------------------------------------------------------------------
---[ vr.api.SyncClassDataWorld ]--------------------------------- GLOBAL INIT -
vr.api.SyncClassDataWorld = function()

    -- Initialize All Modules HERE
    vr.trinkets.ScanTrinkets()


    local class = UnitClass('player');
    if class == "Druid" then
        vr.dru.SyncClassData();
        vr.dru.Init();
        vr.dru.InitRole();
    elseif class == "Hunter" then
        vr.hun.SyncClassData();
        vr.hun.InitRole();
    elseif class == "Mage" then
        vr.mag.SyncClassData();
        vr.mag.InitRole();
    elseif class == "Paladin" then
        vr.pal.SyncClassData()
        vr.pal.InitRole();
    elseif class == "Priest" then
        vr.pri.SyncClassData()
        vr.pri.InitRole();
    elseif class == "Rogue" then
        vr.rog.SyncClassData();
        vr.rog.InitRole();
    elseif class == "Shaman" then
        vr.shm.SyncClassData();
        vr.shm.InitRole();
    elseif class == "Warlock" then
        vr.wlk.SyncClassData();
        vr.wlk.InitRole();
    elseif class == "Warrior" then
        vr.war.SyncClassData();
        vr.war.Init();
        vr.war.InitRole();
    end
end

---[ vr.api.TreatDebuffPlayer ]------------------------------------------------
-- Returns integer number of elements in a given table 
function vr.api.Tablelength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end

---[ vr.api.TreatDebuffPlayer ]------------------------------------------------
-- Treat debuff on player
function vr.api.TreatDebuffPlayer()
    local allowCombatCooldown = true
    if UnitName("target") == BOSS_NAX_LOATHEB_FURY
      or UnitName("target") == BOSS_NAX_SAPPHIRON_FURY then
        allowCombatCooldown = false -- Save for Shadow/frost Protection Potion
    end
    -- add Restorative Potion (magic, poison curse or disease)
    if vr.api.HasDebuffType("player", ITEM_DEBUFF_TYPE_POISON) then
        if UnitName("target") == BOSS_NAX_GROBBULUS_FURY then
            return false
        end
        if vr.api.IsTrinketEquipped(ITEM_TRINKET_HEART_OF_NOXXION) then
            local slot = vr.api.IsTrinketEquipped(ITEM_TRINKET_HEART_OF_NOXXION)
            UseInventoryItem(slot)

        elseif UnitRace("player") == RACE_DWARF
          and Cg(RACIAL_STONEFORM_FURY)
          and vr.api.IsSpellReady(RACIAL_STONEFORM_FURY) then
            CastSpellByName(RACIAL_STONEFORM_FURY)

        elseif allowCombatCooldown
          and vr.api.IsItemReady(ITEM_CONS_JUNGLE_REMEDY) then
            vr.log.Log(ITEM_CONS_JUNGLE_REMEDY)
            vr.api.UseContainerItemByNameOnPlayer(ITEM_CONS_JUNGLE_REMEDY)

        elseif vr.api.IsItemReady(ITEM_CONS_POWERFUL_ANTIVENOM) then
            vr.log.Log(ITEM_CONS_POWERFUL_ANTIVENOM)
            vr.api.UseContainerItemByNameOnPlayer(ITEM_CONS_POWERFUL_ANTIVENOM)

        elseif vr.api.IsItemReady(ITEM_CONS_ELIXIR_OF_POISION_RESISTANCE) then
            vr.log.Log(ITEM_CONS_ELIXIR_OF_POISION_RESISTANCE)
            vr.api.UseContainerItemByNameOnPlayer(ITEM_CONS_ELIXIR_OF_POISION_RESISTANCE)

        elseif allowCombatCooldown
          and vr.api.IsItemReady(ITEM_CONS_PURIFICATION_POTION) then
            vr.log.Log(ITEM_CONS_PURIFICATION_POTION)
            vr.api.UseContainerItemByNameOnPlayer(ITEM_CONS_PURIFICATION_POTION)

        elseif allowCombatCooldown
          and vr.api.IsItemReady(ITEM_CONS_RESTORATIVE_POTION) then
            vr.log.Log(ITEM_CONS_RESTORATIVE_POTION_POTION)
            vr.api.UseContainerItemByNameOnPlayer(ITEM_CONS_RESTORATIVE_POTION_POTION)

        else
            return false

        end
        vr.log.Log(ITEM_DEBUFF_TYPE_POISON)
    elseif vr.api.HasDebuffType("player", ITEM_DEBUFF_TYPE_DISEASE) then
        if UnitRace("player") == RACE_DWARF
          and vr.api.IsSpellReady(ABILITY_STONEFORM_FURY) then
            CastSpellByName(ABILITY_STONEFORM_FURY)

        elseif allowCombatCooldown
          and vr.api.IsItemReady(ITEM_CONS_JUNGLE_REMEDY) then
            vr.log.Log(ITEM_CONS_JUNGLE_REMEDY)
            vr.api.UseContainerItemByNameOnPlayer(ITEM_CONS_JUNGLE_REMEDY)

        elseif allowCombatCooldown
          and vr.api.IsItemReady(ITEM_CONS_RESTORATIVE_POTION) then
            vr.log.Log(ITEM_CONS_RESTORATIVE_POTION_POTION)
            vr.api.UseContainerItemByNameOnPlayer(ITEM_CONS_RESTORATIVE_POTION_POTION)

            else
            return false
        end
        vr.log.Log(ITEM_DEBUFF_TYPE_DISEASE)
    elseif vr.api.HasDebuffType("player", ITEM_DEBUFF_TYPE_CURSE) then
        if allowCombatCooldown
          and vr.api.IsItemReady(ITEM_CONS_PURIFICATION_POTION) then
            vr.log.Log(ITEM_CONS_PURIFICATION_POTION)
            vr.api.UseContainerItemByNameOnPlayer(ITEM_CONS_PURIFICATION_POTION)

        elseif allowCombatCooldown
          and vr.api.IsItemReady(ITEM_CONS_RESTORATIVE_POTION) then
            vr.log.Log(ITEM_CONS_RESTORATIVE_POTION_POTION)
            vr.api.UseContainerItemByNameOnPlayer(ITEM_CONS_RESTORATIVE_POTION_POTION)

            else
            return false
        end
        vr.log.Log(ITEM_DEBUFF_TYPE_CURSE)
    elseif vr.api.HasDebuffType("player", ITEM_DEBUFF_TYPE_MAGIC) then
        
        if allowCombatCooldown
          and vr.api.IsItemReady(ITEM_CONS_RESTORATIVE_POTION) then
            vr.log.Log(ITEM_CONS_RESTORATIVE_POTION_POTION)
            vr.api.UseContainerItemByNameOnPlayer(ITEM_CONS_RESTORATIVE_POTION_POTION)

        else
            return false
        end
        vr.log.Log(ITEM_DEBUFF_TYPE_MAGIC)
    else
        return false

    end
    return true
end

---[ vr.api.WoWVersionCheck ]--------------------------------------------------
function vr.api.WoWVersionCheck(version)
    if version == VR_WOWVERSION then
        return true;
    end
    return false;
end

--endregion ---- UTILITIES

--region    ----    EVENTS

---[ vr.api.CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE ]---------------------------
function vr.api.CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE()
    local class = UnitClass('player');
    if class == "Druid" then
        vr.dru.CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE(event, arg1)
    elseif class == "Hunter" then
        --vr.hun.CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE(event, arg1)
    elseif class == "Mage" then
        --vr.mag.CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE(event, arg1)
    elseif class == "Paladin" then
        --vr.pal.CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE(event, arg1)
    elseif class == "Priest" then
        --vr.pri.CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE(event, arg1)
    elseif class == "Rogue" then
        --vr.rog.CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE(event, arg1)
    elseif class == "Shaman" then
        --vr.shm.CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE(event, arg1)
    elseif class == "Warlock" then
        --vr.wlk.CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE(event, arg1)
    elseif class == "Warrior" then
        vr.war.CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE(event, arg1)
    end
end

---[ vr.api.CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE ]--------------------------
function vr.api.CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE()
    local class = UnitClass('player');
    if class == "Druid" then
        vr.dru.CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE(event, arg1)
    elseif class == "Hunter" then
        --vr.hun.CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE(event, arg1)
    elseif class == "Mage" then
        --vr.mag.CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE(event, arg1)
    elseif class == "Paladin" then
        --vr.pal.CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE(event, arg1)
    elseif class == "Priest" then
        --vr.pri.CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE(event, arg1)
    elseif class == "Rogue" then
        --vr.rog.CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE(event, arg1)
    elseif class == "Shaman" then
        --vr.shm.CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE(event, arg1)
    elseif class == "Warlock" then
        --vr.wlk.CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE(event, arg1)
    elseif class == "Warrior" then
        vr.war.CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE(event, arg1)
    end
end

---[ vr.api.CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS ]-------------------------------
function vr.api.CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS()
    local class = UnitClass('player');
    if class == "Druid" then
        vr.dru.CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS(event, arg1)
    elseif class == "Hunter" then
        --vr.hun.CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE(event, arg1)
    elseif class == "Mage" then
        --vr.mag.CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE(event, arg1)
    elseif class == "Paladin" then
        --vr.pal.CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE(event, arg1)
    elseif class == "Priest" then
        --vr.pri.CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE(event, arg1)
    elseif class == "Rogue" then
        --vr.rog.CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE(event, arg1)
    elseif class == "Shaman" then
        --vr.shm.CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE(event, arg1)
    elseif class == "Warlock" then
        --vr.wlk.CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE(event, arg1)
    elseif class == "Warrior" then
        vr.war.CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS(event, arg1)
    end
end

---[ vr.api.CHAT_MSG_SPELL_SELF_DAMAGE ]---------------------------------------
function vr.api.CHAT_MSG_SPELL_SELF_BUFF()
    local class = UnitClass('player');
    if class == "Druid" then
        vr.dru.CHAT_MSG_SPELL_SELF_BUFF(event, arg1)
    elseif class == "Hunter" then
        --vr.hun.InitPaladinData();
    elseif class == "Mage" then
        --vr.mag.InitPaladinData();
    elseif class == "Paladin" then
        vr.pal.CHAT_MSG_SPELL_SELF_BUFF(event, arg1)
    elseif class == "Priest" then
        --vr.pri.InitPaladinData();
    elseif class == "Rogue" then
        --vr.rog.InitPaladinData();
    elseif class == "Shaman" then
        --vr.shm.InitPaladinData();
    elseif class == "Warlock" then
        --vr.wlk.InitPaladinData();
    elseif class == "Warrior" then
        vr.war.CHAT_MSG_SPELL_SELF_BUFF(event, arg1)
    end
end

---[ vr.api.CHAT_MSG_SPELL_SELF_DAMAGE ]---------------------------------------
function vr.api.CHAT_MSG_SPELL_SELF_DAMAGE()
    local class = UnitClass('player');
    if class == "Druid" then
        vr.dru.CHAT_MSG_SPELL_SELF_DAMAGE(event, arg1)
    elseif class == "Hunter" then
        vr.hun.CHAT_MSG_SPELL_SELF_DAMAGE(event, arg1)
    elseif class == "Mage" then
        --vr.mag.InitPaladinData();
    elseif class == "Paladin" then
        vr.pal.CHAT_MSG_SPELL_SELF_DAMAGE(event, arg1)
    elseif class == "Priest" then
        --vr.pri.InitPaladinData();
    elseif class == "Rogue" then
        --vr.rog.InitPaladinData();
    elseif class == "Shaman" then
        --vr.shm.InitPaladinData();
    elseif class == "Warlock" then
        --vr.wlk.InitPaladinData();
    elseif class == "Warrior" then
        vr.war.CHAT_MSG_SPELL_SELF_DAMAGE(event, arg1)
    end
end

---[ vr.api.SPELLCAST_FAILED ]---------------------------------------
function vr.api.SPELLCAST_FAILED()
    local class = UnitClass('player');
    if class == "Druid" then
        vr.dru.SPELLCAST_FAILED(event, arg1)
    elseif class == "Hunter" then
        --vr.hun.SPELLCAST_FAILED(event, arg1)
    elseif class == "Mage" then
        --vr.mag.InitPaladinData();
    elseif class == "Paladin" then
        --vr.pal.SPELLCAST_FAILED(event, arg1)
    elseif class == "Priest" then
        --vr.pri.InitPaladinData();
    elseif class == "Rogue" then
        --vr.rog.InitPaladinData();
    elseif class == "Shaman" then
        --vr.shm.InitPaladinData();
    elseif class == "Warlock" then
        --vr.wlk.InitPaladinData();
    elseif class == "Warrior" then
        vr.war.SPELLCAST_FAILED(event, arg1)
    end
end

---[ vr.api.COMBAT_LOG_EVENT_UNFILTERED ]---------------------------------------
function vr.api.COMBAT_LOG_EVENT_UNFILTERED()
    local class = UnitClass('player');
    if class == "Druid" then
        vr.dru.COMBAT_LOG_EVENT_UNFILTERED(event, arg1)
    elseif class == "Hunter" then
        --vr.hun.COMBAT_LOG_EVENT_UNFILTERED(event, arg1)
    elseif class == "Mage" then
        --vr.mag.InitPaladinData();
    elseif class == "Paladin" then
        --vr.pal.COMBAT_LOG_EVENT_UNFILTERED(event, arg1)
    elseif class == "Priest" then
        --vr.pri.InitPaladinData();
    elseif class == "Rogue" then
        --vr.rog.InitPaladinData();
    elseif class == "Shaman" then
        --vr.shm.InitPaladinData();
    elseif class == "Warlock" then
        --vr.wlk.InitPaladinData();
    elseif class == "Warrior" then
        --vr.war.COMBAT_LOG_EVENT_UNFILTERED(event, arg1)
    end
end

---[ vr.api.CHAT_MSG_SPELL_FAILED_LOCALPLAYER ]---------------------------------------
function vr.api.CHAT_MSG_SPELL_FAILED_LOCALPLAYER()
    local class = UnitClass('player');
    if class == "Druid" then
        vr.dru.CHAT_MSG_SPELL_FAILED_LOCALPLAYER(event, arg1)
    elseif class == "Hunter" then
        --vr.hun.CHAT_MSG_SPELL_FAILED_LOCALPLAYER(event, arg1)
    elseif class == "Mage" then
        --vr.mag.InitPaladinData();
    elseif class == "Paladin" then
        --vr.pal.CHAT_MSG_SPELL_FAILED_LOCALPLAYER(event, arg1)
    elseif class == "Priest" then
        --vr.pri.InitPaladinData();
    elseif class == "Rogue" then
        --vr.rog.InitPaladinData();
    elseif class == "Shaman" then
        --vr.shm.InitPaladinData();
    elseif class == "Warlock" then
        --vr.wlk.InitPaladinData();
    elseif class == "Warrior" then
        --vr.war.CHAT_MSG_SPELL_FAILED_LOCALPLAYER(event, arg1)
    end
end

--endregion ----    EVENTS

--region    ----    WOWPLAYER

---[ vr.api.AmHealer ]---------------------------------------------------------
function vr.api.AmHealer()
    local class = UnitClass('player')
    if class == "Druid" or class == "Paladin" or class == "Priest" or class == "Shaman" then
        return true;
    end
    return false;
end

---[ vr.api.GetActiveStance ]--------------------------------------------------
-- Return active stance
function vr.api.GetActiveStance(caller)
    --Detect the active stance
    for i = 1, 3 do
        local _, _, active = GetShapeshiftFormInfo(i)
        if active then
            if caller then
                vr.log.Debug('vr.api.GetActiveStance called from ' .. caller)
            end
            return i
        end
    end
    return nil
end

---[ vr.api.HavePet ]----------------------------------------------------------
function vr.api.HavePet()
    if (UnitCreatureFamily("pet") ~= nil) then
        --print('have pet');
        return true;
    else
        --print('no pet');
        return false;
    end
end

---[ vr.api.Loot ]-------------------------------------------------------------
-- sends command to wr to initiate loot all objects within range
function vr.api.Loot()
    --print('hopefully looting!')
    vrcmd_loot = true
end

---[ vr.api.PlayerManaPercent ]------------------------------------------------
-- Return player mana percentage
function vr.api.PlayerManaPercent()
    local mana = UnitMana("player");
    local maxmana = UnitManaMax("player");
    return math.floor(mana * 100 / maxmana);
end

--endregion ----    WOWPLAYER

--region    ----    PULSE

function vr.api.Pulse100ms()
    --vr.log.Debug('100ms Pulse!')
    local class = UnitClass('player');
    if class == "Druid" then
        vr.dru.Pulse100ms();
    elseif class == "Hunter" then
        --vr.hun.Pulse100ms();
    elseif class == "Mage" then
        --vr.mag.Pulse100ms();
    elseif class == "Paladin" then
        --vr.pal.Pulse100ms();
    elseif class == "Priest" then
        --vr.pri.Pulse100ms();
    elseif class == "Rogue" then
        --vr.rog.Pulse100ms();
    elseif class == "Shaman" then
        --vr.shm.Pulse100ms();
    elseif class == "Warlock" then
        --vr.wlk.Pulse100ms();
    elseif class == "Warrior" then
        --vr.war.Pulse100ms();
    end
end

function vr.api.Pulse250ms()
    --vr.log.Debug('250ms Pulse!')
    local class = UnitClass('player');
    if class == "Druid" then
        vr.dru.Pulse250ms();
    elseif class == "Hunter" then
        --vr.hun.Pulse250ms();
    elseif class == "Mage" then
        --vr.mag.Pulse250ms();
    elseif class == "Paladin" then
        --vr.pal.Pulse250ms();
    elseif class == "Priest" then
        --vr.pri.Pulse250ms();
    elseif class == "Rogue" then
        --vr.rog.Pulse250ms();
    elseif class == "Shaman" then
        --vr.shm.Pulse250ms();
    elseif class == "Warlock" then
        --vr.wlk.Pulse250ms();
    elseif class == "Warrior" then
        --vr.war.Pulse250ms();
    end
end

--endregion ----    PULSE



-- vr.war.buttonsWRadar = {
--     { name = 'Enable' },
-- }

--endregion ----    WRadarFrameElements




--region    ----    MOVEMENT

function vr.api.MoveForwardStart()
    vr.log.Log('vr.api.MoveForwardStart() invoked.  assmonkeys.')
    MoveForwardStart();
end

function vr.api.MoveForwardStop()
    vr.log.Log('vr.api.MoveForwardStop() invoked')
    MoveForwardStop();
end

--endregion ----    MOVEMENT



--region    ---- ROGUETEMP

function vr.api.Test()
    print('vr.api.Test() invoked')
    MoveForwardStart();
end

--------------------------------------------------
function vr.api.AmbushReady()
    BlessItRogueAmbush = nil;
    for i = 1, 120 do
        local t = GetActionTexture(i)
        if t then
            --print(tostring(t));
            --if not Yard20 then --Holy Shock
                --if string.find(t, "Ability_Warrior_Charge") -- Charge
                --        or string.find(t, "Ability_Rogue_Sprint") then -- Intercept
                if string.find(t, "Ability_Rogue_Ambush") then -- Intercept

                    --vr.log.Debug("found holy shock")

                    BlessItRogueAmbush = i
                    vr.log.Debug("Found Ambush: "..t)
                    --found = found + 1
                end
            --end
        end
    end

    if BlessItRogueAmbush and IsActionInRange(BlessItRogueAmbush) == 1 then
        print('Ambush READY')
        return true;
    else
        print('Ambush NOT ready')
        return false;
    end
end

function vr.api.BackstabReady()
    BlessItRogueBackstab = nil;
    for i = 1, 120 do
        local t = GetActionTexture(i)
        if t then
            --print(tostring(t));
            --if not Yard20 then --Holy Shock
                --if string.find(t, "Ability_Warrior_Charge") -- Charge
                --        or string.find(t, "Ability_Rogue_Sprint") then -- Intercept
                if string.find(t, "Ability_BackStab") then -- Intercept

                    --vr.log.Debug("found holy shock")

                    BlessItRogueBackstab = i
                    vr.log.Debug("Found Backstab: "..t)
                    --found = found + 1
                end
            --end
        end
    end

    --local isUsable, notEnoughMana = IsUsableAction(BlessItRogueAmbush)

    if BlessItRogueBackstab and IsActionInRange(BlessItRogueBackstab) == 1 then
        print('Backstab READY')
        return true;
    else
        print('Backstab NOT ready')
        return false;
    end
end


function vr.api.SinisterStrikeReady()
    BlessItRogueSinisterStrike = nil;
    for i = 1, 120 do
        local t = GetActionTexture(i)
        if t then
            --print(tostring(t));
            --if not Yard20 then --Holy Shock
                --if string.find(t, "Ability_Warrior_Charge") -- Charge
                --        or string.find(t, "Ability_Rogue_Sprint") then -- Intercept
                if string.find(t, "Spell_Shadow_RitualOfSacrifice") then -- Intercept

                    --vr.log.Debug("found holy shock")

                    BlessItRogueSinisterStrike = i
                    vr.log.Debug("Found Sinister Strike: "..t)
                    --found = found + 1
                end
            --end
        end
    end

    --local isUsable, notEnoughMana = IsUsableAction(BlessItRogueAmbush)

    if BlessItRogueSinisterStrike and IsActionInRange(BlessItRogueSinisterStrike) == 1 then
        print('Sinister Strike READY')
        return true;
    else
        print('Sinister Strike NOT ready')
        return false;
    end
end
--endregion ---- ROGUETEMP

--region    ---- FISHING
local GiveTheseItems = {
	{"Zesty Clam Meat", 10},
	{"Raw Bristle Whisker Catfish", 10},
	{"Raw Nightfin Snapper", 10},
	{"Raw Sagefish", 10},
	{"Raw Whitescale Salmon", 10},
	{"Raw Greater Sagefish", 10},
	{"Raw Sunscale Salmon", 10},
	{"Raw Mithril Head Trout", 10},
	{"Raw Summer Bass", 10},
	{"Raw Longjaw Mud Snapper", 10},
	{"Raw Rainbow Fin Albacore", 10},
	{"Raw Spotted Yellowtail", 10},
	{"Raw Brilliant Smallfish", 10},
	{"Raw Rockscale Cod", 10},
	{"Darkclaw Lobster", 10},
	{"Raw Redgill", 10},
	{"Raw Glossy Mightfish", 10},
	{"Raw Slitherskin Mackerel", 10},
	{"Raw Loch Frenzy", 10}
}

function GiveFish()
    for i, k in ipairs(GiveTheseItems) do
        --print(k[1] .. " " .. k[2])
        GenerateItem(k[1], k[2])
    end
end

-- including itemIDs, because they cannot be resolved it they do not exist in inventory :P
local UnwantedFish = {
	{"Zesty Clam Meat", 7974, 0},
	{"Raw Bristle Whisker Catfish", 6308, 0},
	{"Raw Nightfin Snapper", 13759, 9999},  -- that last number means 'Keep 9999 Raw Nightfin Snappers'
	{"Raw Sagefish", 21071, 0},
	{"Raw Whitescale Salmon", 13889, 0},
	{"Raw Greater Sagefish", 21153, 0},
	{"Raw Sunscale Salmon", 13760, 0},
	{"Raw Mithril Head Trout", 8365, 0},
	{"Raw Summer Bass", 13756, 0},
	{"Raw Longjaw Mud Snapper", 6289, 0},
	{"Raw Rainbow Fin Albacore", 6361, 0},
	{"Raw Spotted Yellowtail", 4603, 0},
	{"Raw Brilliant Smallfish", 6291, 0},
	{"Raw Rockscale Cod", 6362, 0},
	{"Darkclaw Lobster", 13888, 0},
	{"Raw Redgill", 13758, 0},
	{"Raw Glossy Mightfish", 13754, 0},
	{"Raw Slitherskin Mackerel", 6303, 0},
	{"Raw Loch Frenzy", 6317, 0}
}

function DeleteUnwantedFish()
    for _, k in pairs(UnwantedFish) do
        --print("Destroying " .. k[1] .. " /" .. k[2] .. " /" .. k[3] )
        DeleteItems(k[1], k[2], k[3])
        --GetLocalInventoryTotalFromItemName(k[1])
    end
end

function GetLocalInventoryTotalFromItemName(DeleteItemName)
    --print("Processing " .. DeleteItemName)
    local itemCount = 100000;
    local deleted = 0;
    local totalCount = 0;
    for b=0,4 do
        if GetBagName(b) then
            for s=1, GetContainerNumSlots(b) do
                local itemLink = GetContainerItemLink(b, s)
                if itemLink then
                    local _,_, itemId = string.find(itemLink, 'item:(%d+):');
                    local _, stackCount = GetContainerItemInfo(b, s);
                    local leftItems = itemCount - deleted;
                    if ((GetItemInfo(itemId) == DeleteItemName) and leftItems > 0) then
                        totalCount = totalCount + stackCount
                    end
                end
            end
        end
    end
    return totalCount
end

function IterateInventory()
    --local itemCount = LeaveAmount;
    local deleted = 0;
    for b=0,4 do
        if GetBagName(b) then
            for s=1, GetContainerNumSlots(b) do
                local itemLink = GetContainerItemLink(b, s)
                if itemLink then

                    local _,_, itemId = string.find(itemLink, 'item:(%d+):');
                    --local _, stackCount = GetContainerItemInfo(b, s);
                    --local leftItems = itemCount - deleted;
                    print((GetItemInfo(itemId)))
                    -- if ((GetItemInfo(itemId) == DeleteItemName) and leftItems > 0) then 
                    --     if stackCount <= 1 then
                    --         PickupContainerItem(b, s);
                    --         DeleteCursorItem();
                    --         deleted = deleted + 1;
                    --     else
                    --         if (leftItems > stackCount) then
                    --             SplitContainerItem(b, s, stackCount);
                    --             DeleteCursorItem();
                    --             deleted = deleted + stackCount;
                    --         else
                    --             SplitContainerItem(b, s, leftItems);
                    --             DeleteCursorItem();
                    --             deleted = deleted + leftItems;
                    --         end
                    --     end
                    -- end
                end
            end
        end
    end
end

function DeleteItems(DeleteItemName, DeleteItemID, LeaveAmount)
    local itemCount = GetLocalInventoryTotalFromItemName(DeleteItemName) - LeaveAmount;
    local deleted = 0;
    for b=0,4 do
        if GetBagName(b) then
            for s=1, GetContainerNumSlots(b) do
                local itemLink = GetContainerItemLink(b, s)
                if itemLink then
                    local _,_, itemId = string.find(itemLink, 'item:(%d+):');
                    local _, stackCount = GetContainerItemInfo(b, s);
                    local leftItems = itemCount - deleted;
                    if ((GetItemInfo(itemId) == DeleteItemName) and leftItems > 0) then
                        if stackCount <= 1 then
                            PickupContainerItem(b, s);
                            DeleteCursorItem();
                            deleted = deleted + 1;
                        else
                            if (leftItems > stackCount) then
                                SplitContainerItem(b, s, stackCount);
                                DeleteCursorItem();
                                deleted = deleted + stackCount;
                            else
                                SplitContainerItem(b, s, leftItems);
                                DeleteCursorItem();
                                deleted = deleted + leftItems;
                            end
                        end
                    end
                end
            end
        end
    end
end

function GenerateItem(itemName, itemAmount)
    --print("adding " .. "'" .. itemName .. "'" .. " " .. itemAmount)
    DEFAULT_CHAT_FRAME.editBox:SetText(".additem " .. "'" .. itemName .. "'" .. " " .. itemAmount)
    ChatEdit_SendText(DEFAULT_CHAT_FRAME.editBox, 0)
end
--endregion ---- FISHING