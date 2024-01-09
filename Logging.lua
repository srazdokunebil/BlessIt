vr.log = { }

-- https://opensource.com/article/22/11/iterate-over-tables-lua

local colors = {
    -- classes
    Druid = "|cAAFF7D0A",
    Hunter = "|cAAABD473",
    Mage = "|cAA69CCF0",
    Paladin = "|caaf58cba",
    Priest = "|cAAFFFFFF",
    Rogue = "|cAAFFF569",
    Shaman = "|cAA0070DE",
    Warlock = "|cAA9482C9",
    Warrior = "|cAAC79C6E",

    -- item quality
    Poor = "|cAA889D9D",
    Common = "|cAAFFFFFF",
    Uncommon = "|cAA1EFF0C",
    Rare = "|cAA0070FF",
    Superior = "|cAAA335EE",
    Legendary = "|cAAFF8000",
    Heirloom = "|cAAE6CC80",

    -- palette
    Blue = "|cff0F52BA",
    LightGreen = "|cff80FF77",
    LightOrange = "|cffFEB781",
    LightRed = "|cffFF7777",
    LightYellow = "|cffffff70",
    Gray = "|cff808080",
    Green = "|cff00ff00",
    DarkGreen = "|cff009900",
    SickGreen = "|cffafd437",
    LightGray = "|cffBBBBBB",
    Magenta = "|cffff00ff",
    Orange = "|cFFFF6F00",
    Purple = "|cAABD45ED",
    Red = "|cffff0000",
    White = "|cffffffff",
    Yellow = "|cffffff00",

    Clear = "|r",
}

function vr.log.Format3Var(title, var1, val1, var2, val2, var3, val3)
    local o =
        vr.log.C("LightGray") .. title .. vr.log.C("Clear") ..
        vr.log.C("Orange") .. var1 .. vr.log.C("Clear") ..
        vr.log.C("LightGreen") .. val1 .. vr.log.C("Clear") ..
        vr.log.C("Orange") .. var2 .. vr.log.C("Clear") ..
        vr.log.C("LightGreen") .. val2 .. vr.log.C("Clear") ..
        vr.log.C("Orange") .. var3 .. vr.log.C("Clear") ..
        vr.log.C("LightGreen") .. val3 .. vr.log.C("Clear")
    return o;
end

function vr.log.Format2Var(title, var1, val1, var2, val2)
    local o =
        vr.log.C("LightGray") .. title .. vr.log.C("Clear") ..
        vr.log.C("Orange") .. var1 .. vr.log.C("Clear") ..
        vr.log.C("LightGreen") .. val1 .. vr.log.C("Clear") ..
        vr.log.C("Orange") .. var2 .. vr.log.C("Clear") ..
        vr.log.C("LightGreen") .. val2 .. vr.log.C("Clear")
    return o;
end

function vr.log.Format1Var(title, var1, val1)
    local o =
        vr.log.C("LightGray") .. title .. vr.log.C("Clear") ..
        vr.log.C("Orange") .. var1 .. vr.log.C("Clear") ..
        vr.log.C("LightGreen") .. val1 .. vr.log.C("Clear")
    return o;
end

function vr.log.Damage(event, arg1)
    if (event ~= nil and arg1 ~= nil) then
        local o =
            vr.log.C("LightYellow") .. arg1 .. vr.log.C("Clear")
        return o;
    end
end

function vr.log.DamageToSelf(event, arg1)
    if (event ~= nil and arg1 ~= nil) then
        local o =
            vr.log.C("LightRed") .. arg1 .. vr.log.C("Clear")
        return o;
    end
end

function vr.log.Healing()
    if (event ~= nil and arg1 ~= nil) then
        local o =
            vr.log.C("LightGreen") .. arg1 .. vr.log.C("Clear")
        return o;
    end
end

function vr.log.UnpackEvent(event, arg1)
    if     (event ~= nil and arg1 == nil) then
        vr.log.Log("0a: " .. event)
    elseif (event ~= nil and arg1 ~= nil) then
        vr.log.Log("1a: " .. event .. " // " .. arg1)
    end
end

function vr.log.Log(a)
    --DEFAULT_CHAT_FRAME:AddMessage("|cff69ccf0[DEBUG] |cffffffff" .. a)
    --print('console == ' .. VRGO.console)
    --print('playerclass == ' .. VRGO.playerclass)

    --if VRGO.Console == 1 then
    --    ChatFrame1:AddMessage("|cff69ccf0[VR] |cffffffff" .. a)
    --    return;
    --elseif VRGO.Console == 2 then
    --    ChatFrame2:AddMessage("|cff69ccf0[VR] |cffffffff" .. a)
    --    return;
    --elseif VRGO.Console == 3 then
    --    ChatFrame3:AddMessage("|cff69ccf0[VR] |cffffffff" .. a)
    --    return;
    --elseif VRGO.Console == 4 then
    --    --ChatFrame4:AddMessage(vr.log.C(BlessIt_playerclass) .. "[VR] |cffffffff" .. a)
    --    ChatFrame4:AddMessage(vr.log.C(BlessIt_PlayerClass) .. "[VR] |cffffffff" .. a)
    --    return;
    --end

    ChatFrame4:AddMessage(vr.log.C(UnitClass('Player')) .. "[VR] |cffffffff" .. a)
end

function vr.log.Ability(ability, notification, delta)

    local timestamp = tonumber(getglobal("Ability" .. ability))
    --local dtime = 1000

    -- local arse = 3406438.001
    -- local dtime = 3404438.001

    if getglobal("Ability" .. ability) then
        --ChatFrame4:AddMessage(vr.log.C(UnitClass('Player')) .. "[VR] |cffffffff" .. "Ability" .. ability .. " has timestamp " .. getglobal("Ability" .. ability))

        --ChatFrame4:AddMessage(vr.log.C(UnitClass('Player')) .. "[VR] |cffffffff" .. "arse = ".. arse)

        if vr.api.MilliSecondsSince(timestamp) > delta then
            ChatFrame4:AddMessage(vr.log.C(UnitClass('Player')) .. "[VR] |cffffffff" .. notification)
            setglobal("Ability" .. ability, GetTime())
        end
    else
        --ChatFrame4:AddMessage(vr.log.C(UnitClass('Player')) .. "[VR] |cffffffff" .. "no have mr fawlty")
        setglobal("Ability" .. ability, GetTime())      -- creates global var and assigns timestamp to it
    end

    --setglobal(aaa, 1)

end

function vr.log.Action(a)
    --DEFAULT_CHAT_FRAME:AddMessage("|cff69ccf0[DEBUG] |cffffffff" .. a)
    --print('console == ' .. VRGO.console)
    --print('playerclass == ' .. VRGO.playerclass)

    if not GOg("WLAction") or (vr.wr.isRunning and GOg("SuppressBlessItLogging")) then
        return;
    end

    --if VRGO.Console == 1 then
    --    ChatFrame1:AddMessage("|cff69ccf0[VR] |cffffffff" .. a)
    --    return;
    --elseif VRGO.Console == 2 then
    --    ChatFrame2:AddMessage("|cff69ccf0[VR] |cffffffff" .. a)
    --    return;
    --elseif VRGO.Console == 3 then
    --    ChatFrame3:AddMessage("|cff69ccf0[VR] |cffffffff" .. a)
    --    return;
    --elseif VRGO.Console == 4 then
    --    --ChatFrame4:AddMessage(vr.log.C(BlessIt_playerclass) .. "[VR] |cffffffff" .. a)
    --    ChatFrame4:AddMessage(vr.log.C(BlessIt_PlayerClass) .. "[VR] |cffffffff" .. a)
    --    return;
    --end

    ChatFrame4:AddMessage(vr.log.C(UnitClass('Player')) .. "[VR] |cffffffff" .. a)
end

function vr.log.Debug(a)
    --DEFAULT_CHAT_FRAME:AddMessage("|cff69ccf0[DEBUG] |cffffffff" .. a)
    --print('console == ' .. VRGO.console)
    --print('playerclass == ' .. VRGO.playerclass)

    if not GOg("WLDebug") then
        return;
    end

    --if VRGO.Console == 1 then
    --    ChatFrame1:AddMessage("|cff69ccf0[VR] |cffffffff" .. a)
    --    return;
    --elseif VRGO.Console == 2 then
    --    ChatFrame2:AddMessage("|cff69ccf0[VR] |cffffffff" .. a)
    --    return;
    --elseif VRGO.Console == 3 then
    --    ChatFrame3:AddMessage("|cff69ccf0[VR] |cffffffff" .. a)
    --    return;
    --elseif VRGO.Console == 4 then
    --    --ChatFrame4:AddMessage(vr.log.C(BlessIt_playerclass) .. "[VR] |cffffffff" .. a)
    --    ChatFrame4:AddMessage(vr.log.C(BlessIt_PlayerClass) .. "[VR] |cffffffff" .. a)
    --    return;
    --end

    ChatFrame4:AddMessage(vr.log.C("LightGray") .. "[VR] " .. vr.log.C("LightGray") .. a)
end

function vr.log.Report(ability, notification, delta)
    if not getglobal("AbilityReport" .. ability) then
        setglobal("AbilityReport" .. ability, GetTime() - delta)
    end

    local timestamp = tonumber(getglobal("AbilityReport" .. ability))

    if vr.api.MilliSecondsSince(timestamp) > delta then
        --ChatFrame4:AddMessage(vr.log.C(UnitClass('Player')) .. "[VR] |cffffffff" .. notification)
        vr.log.Say(notification)
        setglobal("AbilityReport" .. ability, GetTime())
    end
end

function vr.log.LogThrottle(ability, notification, delta)
    if not getglobal("AbilityReport" .. ability) then
        setglobal("AbilityReport" .. ability, GetTime() - delta)
    end

    local timestamp = tonumber(getglobal("AbilityReport" .. ability))

    if vr.api.MilliSecondsSince(timestamp) > delta then
        --ChatFrame4:AddMessage(vr.log.C(UnitClass('Player')) .. "[VR] |cffffffff" .. notification)
        vr.log.Warn(notification)
        setglobal("AbilityReport" .. ability, GetTime())
    end
end

function vr.log.Say(a)
    SendChatMessage(a, "SAY");
end

function vr.log.Emote(a)
    SendChatMessage(a, "EMOTE");
end

function vr.log.TargetChangeAnnounce()
    if not GOg("VerboseTargeting") or (vr.wr.isRunning and GOg("SuppressBlessItLogging")) then
        return false;
    end
    if UnitExists('target') then
        if vr.mobdb.Match() then
            if (UnitIsEnemy("player","target")) then
                ChatFrame4:AddMessage(vr.log.C(UnitClass('Player')) .. "[VR] " .. vr.log.C("Legendary") .. "Target acquired: " .. vr.log.C("Red") .. "[" .. vr.log.C("LightRed") .. vr.api.TargetName .. vr.log.C("Red") .."]")
                ----vr.api.XMLSetText("GeneralOptionsFrame", "_Target", vr.log.C("Red") .. "[" .. vr.log.C("LightRed") .. vr.api.TargetName .. vr.log.C("Red") .."]")
            elseif (UnitCanAttack("player", "target")) then
                ChatFrame4:AddMessage(vr.log.C(UnitClass('Player')) .. "[VR] " .. vr.log.C("Legendary") .. "Target acquired: " .. vr.log.C("Yellow") .. "[" .. vr.log.C("LightYellow") .. vr.api.TargetName .. vr.log.C("Yellow") .."]")
                ----vr.api.XMLSetText("GeneralOptionsFrame", "_Target", vr.log.C("Yellow") .. "[" .. vr.log.C("LightYellow") .. vr.api.TargetName .. vr.log.C("Yellow") .."]")
            else
                ChatFrame4:AddMessage(vr.log.C(UnitClass('Player')) .. "[VR] " .. vr.log.C("Legendary") .. "Target acquired: " .. vr.log.C("Green") .. "[" .. vr.log.C("LightGreen") .. vr.api.TargetName .. vr.log.C("Green") .."]")
                ----vr.api.XMLSetText("GeneralOptionsFrame", "_Target", vr.log.C("Green") .. "[" .. vr.log.C("LightGreen") .. vr.api.TargetName .. vr.log.C("Green") .."]")
            end
        else
            if (UnitIsEnemy("player","target")) then
                ChatFrame4:AddMessage(vr.log.C(UnitClass('Player')) .. "[VR] " .. vr.log.C("Legendary") .. "Target acquired: " .. vr.log.C("LightRed") .. vr.api.TargetName)
                ----vr.api.XMLSetText("GeneralOptionsFrame", "_Target", vr.log.C("LightRed") .. vr.api.TargetName)
            elseif (UnitCanAttack("player", "target")) then
                ChatFrame4:AddMessage(vr.log.C(UnitClass('Player')) .. "[VR] " .. vr.log.C("Legendary") .. "Target acquired: " .. vr.log.C("LightYellow") .. vr.api.TargetName)
                ----vr.api.XMLSetText("GeneralOptionsFrame", "_Target", vr.log.C("LightYellow") .. vr.api.TargetName)
            else
                ChatFrame4:AddMessage(vr.log.C(UnitClass('Player')) .. "[VR] " .. vr.log.C("Legendary") .. "Target acquired: " .. vr.log.C("LightGreen") .. vr.api.TargetName)
                ----vr.api.XMLSetText("GeneralOptionsFrame", "_Target", vr.log.C("LightGreen") .. vr.api.TargetName)
            end
        end
    else
        ChatFrame4:AddMessage(vr.log.C(UnitClass('Player')) .. "[VR] " .. vr.log.C("Legendary") .. "Target cleared.")
    end
end

function vr.log.Warn(a)
    --DEFAULT_CHAT_FRAME:AddMessage("|cff69ccf0[DEBUG] |cffffffff" .. a)
    --print('console == ' .. VRGO.console)
    --print('playerclass == ' .. VRGO.playerclass)

    -- if not VRGO["WLDebug"] then
    --     return;
    -- end

    --if VRGO.Console == 1 then
    --    ChatFrame1:AddMessage("|cff69ccf0[VR] |cffffffff" .. a)
    --    return;
    --elseif VRGO.Console == 2 then
    --    ChatFrame2:AddMessage("|cff69ccf0[VR] |cffffffff" .. a)
    --    return;
    --elseif VRGO.Console == 3 then
    --    ChatFrame3:AddMessage("|cff69ccf0[VR] |cffffffff" .. a)
    --    return;
    --elseif VRGO.Console == 4 then
    --    --ChatFrame4:AddMessage(vr.log.C(BlessIt_playerclass) .. "[VR] |cffffffff" .. a)
    --    ChatFrame4:AddMessage(vr.log.C(BlessIt_PlayerClass) .. "[VR] |cffffffff" .. a)
    --    return;
    --end

    ChatFrame4:AddMessage(vr.log.C("LightOrange") .. "[VR] " .. vr.log.C("LightOrange") .. a)
end

---[ vr.log.LogEvent ]---------------------------------------------------------
function vr.log.LogEvent(a)
    if not GOg("WLEvent") then
        return;
    end
    ChatFrame4:AddMessage(vr.log.C(UnitClass('Player')) .. "[VR] |cffffffff" .. a)
end

---[ vr.log.LogBoolVarToggle ]-------------------------------------------------
function vr.log.LogBoolVarToggle(var, state)
    if state then
        ChatFrame4:AddMessage(vr.log.C(UnitClass('Player')) .. "[VR] " .. vr.log.C('LightGray') .. var .. ":" .. vr.log.C("LightGreen") .. tostring(state))
    else
        ChatFrame4:AddMessage(vr.log.C(UnitClass('Player')) .. "[VR] " .. vr.log.C('LightGray') .. var .. ":" .. vr.log.C("LightRed") .. tostring(state))
    end
end

---[ vr.log.LogStateVarChange ]------------------------------------------------
function vr.log.LogStateVarChange()

end

---[ vr.log.LogStateVarChange ]------------------------------------------------
function vr.log.LogIntVarChange(var, val)
    ChatFrame4:AddMessage(vr.log.C(UnitClass('Player')) .. "[VR] " .. vr.log.C('LightGray') .. var .. ":" .. vr.log.C("LightGreen") .. tostring(val))
end

---[ vr.log.C ]----------------------------------------------------------------
function vr.log.C(color)
    --print('colors')
    for k, v in pairs(colors) do
        --print(k .. " " .. v)
        if color == k then
            return(v)
        end
    end
end

function BlessIt_WLPrint(a)
    ChatFrame4:AddMessage("|cff69ccf0[VR] |cffffffff" .. a)
end