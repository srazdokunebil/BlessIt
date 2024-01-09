--[[
	BlessIt
--]]
vr = CreateFrame("Frame", "vr", UIParent)

vr.class = { }
vr.group = { }


-- WR data array
vr.wr = { }

ClassSpec = "";

local timer = CreateFrame("FRAME");
--"duration" is in seconds and "func" is the function that will be executed in the end
local function setTimer(duration, func)
	local endTime = GetTime() + duration;

	timer:SetScript("OnUpdate", function()
		if(endTime < GetTime()) then
			--time is up
			func();
			timer:SetScript("OnUpdate", nil);
		end
	end);
end

local BlessIt_Initialized = false;
local BlessIt_InitGeneralOptionsTab = false;
local BlessIt_ShowGeneralOptionsFrameStart = false;
local _initGeneralOptionsTab = GetTime();


function print(a)
    ChatFrame4:AddMessage(a)
end

function BlessIt_SetConfiguration(defaults)
    --vr.log.Debug("BlessIt_SetConfguration() invoked!")

    local Default_GeneralOptions = {

        { name="AutoAttack", type="bool", val=true, ldesc="Set to false to disable auto-attack" },
        { name="Console", type="int", val=4, ldesc="Set WL console window number" },
        --{"Debug", false},                                         -- Toggles debug feedback
        { name="Enabled", type="bool", val=true, ldesc="Toggle BlessIt addon" },
        -- { name="PlayerClass", type="bool", UnitClass('player')}, -- Stores player class

        -- Logging Options
        { name="WLAction", type="bool", val=true, ldesc="Echo Actions to WL console", sdesc="Echo Actions" },
        { name="WLDebug", type="bool", val=true, ldesc="Echo Debug events to WL console", sdesc="Echo Debug" },
        { name="WLEvent", type="bool", val=true, ldesc="Echo Damage, Healing events to WL console", sdesc="Echo Events" },
        { name="WLAllEvents", type="bool", val=false, ldesc="Echo ALL events to the WL console", sdesc="Echo All Events" },
        { name="AnnounceActions", type="bool", val=false, ldesc="AnnounceActions (e.g. interrupts, lay on hands, taunt, etc)", sdesc="Announce Actions Publicly" },
        { name="VerboseTargeting", type="bool", val=false, ldesc="Verbose Targeting", sdesc="Verbose Targeting" },
        { name="SuppressBlessItLogging", type="bool", val=false, ldesc="Suppress double logging from Wrobot", sdesc="Suppress BlessIt Logging" },

        { name="InterruptSpells", type="bool", val=true, ldesc="Interrupt Enemy Spellcasts", sdesc="" },
        { name="MobDBFilter", type="bool", val=true, ldesc="MobDB Interrupt Prioritization", sdesc="" },
        { name="IntSpellCatchAll", type="bool", val=true, ldesc="Interrupt Unblacklisted Enemy Spellcasts", sdesc="" },

    }

    local Default_HUDOptions = {
        { name="Radar", type="bool", val=false, ldesc="Toggle Radar UI", sdesc="Radar" },
        { name="Debug", type="bool", val=false, ldesc="Toggle Debug Frame", sdesc="Debug" },
        { name="Three", type="bool", val=false, ldesc="placeholder", sdesc="Debug" },
        { name="Four",  type="bool", val=false, ldesc="placeholder", sdesc="Debug" },
    }

    local Default_WRadarOptions = {
        { name="hideincombat", type="bool", val=false, ldesc="Hide Radar in combat", sdesc="Hide Radar" },
        { name="enableradar", type="bool", val=false, ldesc="Enable Radar", sdesc="Enable Radar" },

        { name="playersdrawui", type="bool", val=false, ldesc="Draw Players", sdesc="Draw Players" },
        { name="playerssound", type="bool", val=false, ldesc="Players Sound", sdesc="Players Sound" },
        { name="playerscorpses", type="bool", val=false, ldesc="Players Corpses", sdesc="Players Corpses" },

        { name="npcsdrawui", type="bool", val=false, ldesc="Draw NPCs", sdesc="Draw NPCs" },
        { name="npcssound", type="bool", val=false, ldesc="NPCs Sound", sdesc="NPCs Sound" },

        { name="objectssdrawui", type="bool", val=false, ldesc="Draw Objects", sdesc="Draw Objects" },
        { name="objectssound", type="bool", val=false, ldesc="Objects Sound", sdesc="Objects Sound" },

        { name="map3dme", type="bool", val=false, ldesc="Show Me", sdesc="Show Me" },
        { name="map3dtarget", type="bool", val=false, ldesc="Show Target", sdesc="Show Target" },
        { name="map3dtargetline", type="bool", val=false, ldesc="Display TargetLine", sdesc="Display TargetLine" },
        { name="map3dnpcs", type="bool", val=false, ldesc="Show NPCs", sdesc="Show NPCs" },
        { name="map3dplayers", type="bool", val=false, ldesc="Show Players", sdesc="Show Players" },
        { name="map3dobjects", type="bool", val=false, ldesc="Show Objects", sdesc="Show Objects" },

        { name="pvpdrawui", type="bool", val=false, ldesc="pvpdrawui", sdesc="pvpdrawui" },
        { name="pvpsound", type="bool", val=false, ldesc="pvpsound", sdesc="pvpsound" },
        { name="map3dpath", type="bool", val=false, ldesc="map3dpath", sdesc="map3dpath" },
    }

    local Default_DRU = {
        { name="InterruptSpells", type="bool", val=true, ldesc="Interrupt Enemy Spellcasts", sdesc="Interrupt" },
        { name="MobDBFilter", type="bool", val=true, ldesc="Prioritize MobDB Spellcast Interruption", sdesc="MobDB" },
        { name="IntSpellCatchAll", type="bool", val=true, ldesc="Interrupt Catch-All", sdesc="Interrupt Catch-All" },
        { name="AutoAttack", type="bool", val=true, ldesc="AutoAttack", sdesc="AutoAttack" },
        { name="AllowAOE", type="bool", val=true, ldesc="Allow AOE Abilities", sdesc="Allow AOE" },
        { name="Mode", type="quadstate", val="mdps", states={'heal', 'mdps', 'rdps', 'tank'}, ldesc="Druid State", sdesc="Druid State" },
    }

    local Default_HUNBM = {
        { name="AutoAttack", type="bool", val=true },
        { name="Stings", type="bool", val=false },
        { name="Scorpid", type="bool", val=false },
        { name="Serpent", type="bool", val=false },
        { name="Viper", type="bool", val=false },
    }

    local Default_HUNMM = {
        { name="AutoAttack", type="bool", val=true },
        { name="Stings", type="bool", val=false },
        { name="Scorpid", type="bool", val=false },
        { name="Serpent", type="bool", val=false },
        { name="Viper", type="bool", val=false },
    }

    local Default_MAGFIRE = {
        --Mage Options
    }

    local Default_MAGFROST = {
        --Mage Options
    }

    local Default_PALHOLY = {
        -- Paladin Options
        { name="AutoAttack", type="bool", val=true},
        { name="JudgeLight", type="bool", val=false},
        { name="JudgeWisdom", type="bool", val=true},
        { name="Use_HammerOfWrath", type="bool", val=true},

        { name="AutoAura", type="bool", val=false},
        { name="QuickHeal", type="bool", val=false},
    }

    local Default_PALPROT = {
        -- Paladin Options
        { name="Use_Exorcism", type="bool", val=true},
        { name="Use_HammerOfWrath", type="bool", val=true},
    }

    local Default_PALRET = {
        -- Paladin Options
        { name="AutoAttack", type="bool", val=true},
        { name="JudgeLight", type="bool", val=false},
        { name="JudgeWisdom", type="bool", val=true},
        { name="Use_HammerOfWrath", type="bool", val=true},

        { name="AutoAura", type="bool", val=true},
        { name="Command", type="bool", val=true},
        { name="Crusader", type="bool", val=false},
        { name="Righteousness", type="bool", val=false},
    }

    local Default_PRIHOLY = {
        -- Priest Options
        { name="Use_InnerFocus", type="bool", val=true},
    }

    local Default_PRISHADOW = {
        -- Priest Options
        { name="Use_InnerFocus", type="bool", val=true},
        { name="AutoAttack", type="bool", val=true},
        { name="StackSWP", type="bool", val=false},
        { name="AutoPWS", type="bool", val=true},
        { name="PainSpike", type="bool", val=true},
    }

    local Default_ROGCOMBAT = {
        -- Rogue Options
        { name="AutoAttack", type="bool", val=true},
    }

    local Default_ROGSUB = {
        -- Rogue Options
        --{"Use_InnerFocus", true},
    }

    local Default_SHMHEAL = {
        -- Rogue Options
        --{"Use_InnerFocus", true},
    }

    local Default_SHMRDPS = {
        -- Rogue Options
        --{"Use_InnerFocus", true},
    }

    local Default_SHMTANK = {
        -- Rogue Options
        --{"Use_InnerFocus", true},
    }

    local Default_WLKDSR = {
        -- Warlock Options
        --{"Use_InnerFocus", true},
    }

    local Default_WLKSMR = {
        -- Warlock Options
        --{"Use_InnerFocus", true},
    }

    Default_WAR = {
        { name="RaidBuffed", type="bool", val=true, ldesc="Toggle Aggressive Use of Cleave/Heroic Strike/Hamstring", sdesc="RaidBuffed" },
        { name="InterruptSpells", type="bool", val=true, ldesc="Interrupt Enemy Spellcasts", sdesc="Interrupt" },
        { name="MobDBFilter", type="bool", val=true, ldesc="Prioritize MobDB Spellcast Interruption", sdesc="MobDB" },
        { name="IntSpellCatchAll", type="bool", val=true, ldesc="Interrupt Catch-All", sdesc="Interrupt Catch-All" },
        { name="BerserkHealth", type="int", val=40, min=20, max=100, delta=10, ldesc="minimum % health to have when using Berserk", sdesc="Berserk Rage MinHealth" },
        { name="BloodrageHealth", type="int", val=20, min=20, max=100, delta=10, ldesc="minimum % health to have when using Bloodrage", sdesc="Bloodrage MinHealth" },
        { name="DeathWishHealth", type="int", val=60, min=20, max=100, delta=10, ldesc="minimum % health to have when using Death Wish", sdesc="Death Wish MinHealth" },
        { name="DemoDiff", type="int", val=1, min=1, max=7, delta=1, ldesc="Use Demoralizaing Shout on Mobs < currentlevel", sdesc="Demo Level Difference" },
        { name="FlurryTriggerRage", type="int", val=50, min=20, max=100, delta=10, ldesc="minimum rage to use Hamstring to trigger Flurry", sdesc="Hamstring MinRage" },
        { name="HamstringHealth", type="int", val=40, min=20, max=100, delta=10, ldesc="maximum % allowed when using Hamstring on NPCs", sdesc="Hamstring MaxHealth" },
        { name="InstantBuildTime", type="int", val=2, min=1, max=2, delta=1, ldesc="Set the time to spend building rage for upcoming 31 point instant attacks", sdesc="InstantBuildTime" },
        { name="MaximumRage", type="int", val=30, min=20, max=100, delta=10, ldesc="maximum amount of rage allowed when using abilities to increase rage", sdesc="MaxRage for Boost" },
        { name="StanceChangeRage", type="int", val=40, min=20, max=100, delta=10, ldesc="amount of rage allowed to be wasted when switching stances", sdesc="MaxRage Waste" },
        { name="NextAttackRage", type="int", val=60, min=20, max=100, delta=10, ldesc="minimum rage to have to use next attack abilities (Cleave and Heroic Strike)", sdesc="MinRage HS Cleave" },
        { name="Enabled", type="bool", val=true, ldesc="Enable BlessIt", sdesc="BlessIt Enabled" },
        { name="ExecuteSwap", type="bool", val=true, ldesc="Swap Weapons for Execute Phase", sdesc="Execute Swap" },
        --{ name="ExecuteSwapped", type="bool", val=true, ldesc="placeholder", sdesc="placeholder" },
        { name="PrimaryStance", type="int", val=2, min=1, max=2, delta=1, ldesc="stance to fall back to after performing an attack requiring another stance", sdesc="Primary Stance" },
        { name="ShieldBashSwap", type="bool", val=true, ldesc="Swap Shield to Interrupt in Prot+Threat Mode", sdesc="Shield Bash Swap" },
        --{ name="Overpower", type="bool", val=true, ldesc="placeholder", sdesc="placeholder" },
        { name="OverpowerSwap", type="bool", val=true, ldesc="Swap to 2H Weapon for Overpower", sdesc="Overpower Swap" },
        { name=MODE_HEADER_PROT, type="bool", val=false, state1="Prot", state2="MDPS", ldesc="Tank/MDPS", sdesc="Tank/MDPS" },
        { name=MODE_HEADER_MITITHREAT, type="bool", val=false, state1="Miti", state2="Threat", ldesc="Miti/Threat", sdesc="Miti/Threat" },
        { name=MODE_HEADER_AOE, type="bool", val=false, state1="AoE", state2="NO AoE", ldesc="Toggle Allow AoE", sdesc="AoE" },
        { name=MODE_HEADER_DEBUFF, type="bool", val=false, ldesc="placeholder", sdesc="placeholder" },
        { name=MODE_HEADER_AOE_TANK, type="bool", val=false, ldesc="placeholder", sdesc="placeholder" },
        -----------------------------------------------------------------------
        --{ name=ENV_WLACTION, type="bool", val=false, ldesc="placeholder", sdesc="placeholder" },
        --{ name=ENV_WLEVENT, type="bool", val=false, ldesc="placeholder", sdesc="placeholder" },
        -----------------------------------------------------------------------
        { name=ABILITY_SHIELD_BLOCK_FURY, type="bool", val=true, ldesc="Use Shield Block", sdesc="Shield Block" },
        { name=ABILITY_SUNDER_ARMOR_FURY, type="bool", val=true, ldesc="Use Sunder Armor", sdesc="Sunder Armor" },
        { name=ABILITY_BATTLE_SHOUT_FURY, type="bool", val=true, ldesc="Use Battle Shout", sdesc="Battle Shout" },
        { name=ABILITY_BERSERKER_RAGE_FURY, type="bool", val=true, ldesc="Use Berserker Rage", sdesc="Berserker Rage" },
        { name=ABILITY_BLOODRAGE_FURY, type="bool", val=true, ldesc="Use Bloodrage", sdesc="Bloodrage" },
        { name=ABILITY_BLOODTHIRST_FURY, type="bool", val=true, ldesc="Use Bloodthirst", sdesc="Bloodthirst" },
        { name=ABILITY_CHARGE_FURY, type="bool", val=true, ldesc="Use Charge", sdesc="Charge" },
        { name=ABILITY_CLEAVE_FURY, type="bool", val=true, ldesc="Use Cleave", sdesc="Cleave" },
        { name=ABILITY_DEMORALIZING_SHOUT_FURY, type="bool", val=true, ldesc="Use Demoralizing Shout", sdesc="Demoralizing Shout" },
        { name=ABILITY_DISARM_FURY, type="bool", val=false, ldesc="Use Disarm", sdesc="Disarm" },
        { name=ABILITY_EXECUTE_FURY, type="bool", val=true, ldesc="Use Execute", sdesc="Execute" }, 
        { name=ABILITY_HAMSTRING_FURY, type="bool", val=true, ldesc="Use Hamstring", sdesc="Hamstring" },
        { name=ABILITY_PIERCING_HOWL_FURY, type="bool", val=true, ldesc="Use Piercing Howl", sdesc="Piercing Howl" },
        { name=ABILITY_HEROIC_STRIKE_FURY, type="bool", val=true, ldesc="Use Heroic Strike", sdesc="Heroic Strike" },
        { name=ABILITY_INTERCEPT_FURY, type="bool", val=true, ldesc="Use Intercept", sdesc="Intercept" },
        { name=ABILITY_MORTAL_STRIKE_FURY, type="bool", val=false, ldesc="Use Mortal Strike", sdesc="Mortal Strike" },
        { name=ABILITY_SWEEPING_STRIKES_FURY, type="bool", val=false, ldesc="Use Sweeping Strikes", sdesc="Sweeping Strikes" },
        { name=ABILITY_OVERPOWER_FURY, type="bool", val=false, ldesc="Use Overpower", sdesc="Overpower" },
        { name=ABILITY_PUMMEL_FURY, type="bool", val=true, ldesc="Use Pummel", sdesc="Pummel" },
        { name=ABILITY_REND_FURY, type="bool", val=true, ldesc="Use Rend", sdesc="Rend" },
        { name=ABILITY_SHIELD_BASH_FURY, type="bool", val=true, ldesc="Use Shield Bash", sdesc="Shield Bash" },
        { name=ABILITY_SHIELD_SLAM_FURY, type="bool", val=false, ldesc="Use Shield Slam", sdesc="Shield Slam" },
        { name=ABILITY_DEATH_WISH_FURY, type="bool", val=true, ldesc="Use Death Wish", sdesc="Death Wish" },
        { name=ABILITY_THUNDER_CLAP_FURY, type="bool", val=true, ldesc="Use Thunder Clap", sdesc="Thunder Clap" },
        { name=ABILITY_WHIRLWIND_FURY, type="bool", val=true, ldesc="Use Whirlwind", sdesc="Whirlwind" },
        { name=ABILITY_REVENGE_FURY, type="bool", val=true, ldesc="Use Revenge", sdesc="Revenge" },
        { name=ITEM_CONS_JUJU_CHILL, type="bool", val=false, ldesc="Use Juju Chill", sdesc="Juju Chill" },
        { name=ITEM_CONS_JUJU_EMBER, type="bool", val=false, ldesc="Use Juju Ember", sdesc="Juju Ember" },
        { name=ITEM_CONS_JUJU_FLURRY, type="bool", val=false, ldesc="Use Juju Flurry", sdesc="Juju Flurry" },
        { name=ITEM_CONS_JUJU_MIGHT, type="bool", val=false, ldesc="Use Juju Might", sdesc="Juju Might" },
        { name=ITEM_CONS_JUJU_POWER, type="bool", val=true, ldesc="Use Juju Power", sdesc="Juju Power" },
        { name=ITEM_CONS_OIL_OF_IMMOLATION, type="bool", val=false, ldesc="Use Oil of Immolation", sdesc="Oil of Immolation" },
        { name=ITEM_TRINKET_EARTHSTRIKE, type="bool", val=true, ldesc="Use Earthstrike", sdesc="Earthstrike" },
        { name=ITEM_TRINKET_KOTS, type="bool", val=true, ldesc="Use Kiss of the Spider", sdesc="Kiss of the Spider" },
        { name=ITEM_TRINKET_SLAYERS_CREST, type="bool", val=true, ldesc="Use Slayers Crest", sdesc="Slayers Crest" },
        { name=RACIAL_BERSERKING_FURY, type="bool", val=true, ldesc="Use Berserking", sdesc="Berserking" },
        { name=RACIAL_BLOOD_FURY, type="bool", val=true, ldesc="Use Blood Fury", sdesc="Blood Fury" },
        { name=RACIAL_STONEFORM_FURY, type="bool", val=true, ldesc="Use Stoneform", sdesc="Stoneform" },
        { name="AutoWeapon", type="bool", val=true, ldesc="Swap Weapons Automatically", sdesc="AutoSwap" }
    }

    -- General Options
    if defaults or VRGO[1] == nil then
        VRGO = {}
        for _, v in next, Default_GeneralOptions do
            table.insert(VRGO,v)
        end
    end

    -- HUD Options
    if defaults or VRHUD[1] == nil then
        VRHUD = {}
        for _, v in next, Default_HUDOptions do
            table.insert(VRHUD,v)
        end
    end

    -- Radar Options
    if defaults or VRRAD[1] == nil then
        VRRAD = {}
        for _, v in next, Default_WRadarOptions do
            table.insert(VRRAD,v)
        end
    end

    -- Druid
    if defaults or VRDRU[1] == nil then
        VRDRU = {}
        for _, v in next, Default_DRU do
            table.insert(VRDRU,v)
        end
    end

    -- Hunter
    if defaults or VRHUNBM[1] == nil then
        VRHUNBM = {}
        for _, v in next, Default_HUNBM do
            table.insert(VRHUNBM,v)
        end
    end
    if defaults or VRHUNMM[1] == nil then
        VRHUNMM = {}
        for _, v in next, Default_HUNMM do
            table.insert(VRHUNMM,v)
        end
    end

    -- Mage
    if defaults or VRMAGFIRE[1] == nil then
        VRMAGFIRE = {}
        for _, v in next, Default_MAGFIRE do
            table.insert(VRMAGFIRE,v)
        end
    end
    if defaults or VRMAGFROST[1] == nil then
        VRMAGFROST = {}
        for _, v in next, Default_MAGFROST do
            table.insert(VRMAGFROST,v)
        end
    end

    -- Paladin
    if defaults or VRPALHOLY[1] == nil then
        VRPALHOLY = {}
        for _, v in next, Default_PALHOLY do
            table.insert(VRPALHOLY,v)
        end
    end
    if defaults or VRPALPROT[1] == nil then
        VRPALPROT = {}
        for _, v in next, Default_PALPROT do
            table.insert(VRPALPROT,v)
        end
    end
    if defaults or VRPALRET[1] == nil then
        VRPALRET = {}
        for _, v in next, Default_PALRET do
            table.insert(VRPALRET,v)
        end
    end

    -- Priest
    if defaults or VRPRIHOLY[1] == nil then
        VRPRIHOLY = {}
        for _, v in next, Default_PRIHOLY do
            table.insert(VRPRIHOLY,v)
        end
    end
    if defaults or VRPRISHADOW[1] == nil then
        VRPRISHADOW = {}
        for _, v in next, Default_PRISHADOW do
            table.insert(VRPRISHADOW,v)
        end
    end

    -- Rogue
    if defaults or VRROGCOMBAT[1] == nil then
        VRROGCOMBAT = {}
        for _, v in next, Default_ROGCOMBAT do
            table.insert(VRROGCOMBAT,v)
        end
    end
    if defaults or VRROGSUB[1] == nil then
        VRROGSUB = {}
        for _, v in next, Default_ROGSUB do
            table.insert(VRROGSUB,v)
        end
    end

    -- Shaman
    if defaults or VRSHMHEAL[1] == nil then
        VRSHMHEAL = {}
        for _, v in next, Default_SHMHEAL do
            table.insert(VRSHMHEAL,v)
        end
    end
    if defaults or VRSHMRDPS[1] == nil then
        VRSHMRDPS = {}
        for _, v in next, Default_SHMRDPS do
            table.insert(VRSHMRDPS,v)
        end
    end
    if defaults or VRSHMTANK[1] == nil then
        VRSHMTANK = {}
        for _, v in next, Default_SHMTANK do
            table.insert(VRSHMTANK,v)
        end
    end

    -- Warlock
    if defaults or VRWLKDSR[1] == nil then
        VRWLKDSR = {}
        for _, v in next, Default_WLKDSR do
            table.insert(VRWLKDSR,v)
        end
    end
    if defaults or VRWLKSMR[1] == nil then
        VRWLKSMR = {}
        for _, v in next, Default_WLKSMR do
            table.insert(VRWLKSMR,v)
        end
    end

    -- Warrior
    if defaults or VRWAR[1] == nil then
        VRWAR = {}
        for _, v in next, Default_WAR do
            table.insert(VRWAR,v)
        end
    end

    
end



Rotations, Player, Target, VRLib = {}, nil, nil, {};

vr.pal={};


--[ Initialization ]--
function BlessIt_Initialize()

    --BlessIt_SetConfiguration(false);

    -- BlessIt_VERSION = "1.0.6a"
    -- BlessItConfig_Text_Version:SetText("BlessIt v" .. BlessIt_VERSION)
    -- VR_WOWVERSION = vr.api.GetWoWVersion();

    SlashCmdList["BLESSIT"] = vr.pal.SlashCommands

    vr.log.Log('Slash commands loaded.')
    vr.api.Target = "";

    vr.api.GroupSync();

    vr.pal.lastCastHoJ = GetTime()
    vr.pal.lastCastBoP = GetTime()
    vr.pal.lastBoPTarget = ''
    vr.pal.lastCastLoH = GetTime()
    vr.pal.lastLoHTarget = ''
    vr.pal.lastCastBoF = GetTime()
    vr.pal.lastBoFTarget = ''
    vr.api.LastSpellCast = 0

    BlessIt_Initialized = true;
end

--[ OnLoad ]--
function BlessIt_OnLoad()

    BlessIt_RegisterEvents()
    BlessIt_UnpauseEvents()

end

--[ OnUpdate ]--
function BlessIt_OnUpdate(arg1)

end

--[ OnEvent ]--
function BlessIt_OnEvent(event, arg1)

    if BlessIt_Initialized then

        -- Unpack and echo every event if WLAllEvents is checked
        -- if GOg("WLAllEvents") then
        --     vr.log.UnpackEvent(event, arg1);
        -- end

        vr.pal.OnEvent(event, arg1);
    end

    if false then
        --
    elseif (event == "CHARACTER_POINTS_CHANGED") then
        --vr.api.SyncClassData()

    elseif event == "CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE"
        or event == "CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF"
        or event == "CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF"
        or event == "CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE"  then
            -- Check to see if enemy casts spell
            for mob, spell in string.gfind(arg1, CHAT_CAST) do
                vr.api.EnemySpellcast = spell
                if mob == UnitName("target")
                    and UnitCanAttack("player", "target")
                    and mob ~= spell then
                        vr.api.InterruptSpell = GetTime()
                        vr.log.Debug(UnitName("target") .. " has begun casting " .. spell)
                        return
                end
            end

    elseif (event == "ADDON_LOADED") then
        BlessIt_Initialize();

    elseif event == "PARTY_MEMBERS_CHANGED" then
        --vr.api.GroupSync();

    elseif (event == "PLAYER_TARGET_CHANGED") then

    elseif event == "PLAYER_AURAS_CHANGED" then
        -- Check to see if mounted
        if UnitIsMounted("player") then
            vr.api.Mount = true
        else
            vr.api.Mount = false
        end

    -- elseif event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" then
    --     if arg1 == CHAT_GAINED_FLURRY_FURY then
    --         vr.war.FlurryStart = GetTime()
    --     end

    elseif event == "CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE" and not (vr.wr.isRunning and GOg("SuppressBlessItLogging")) then --echo damage to self event back to WLconsole
        vr.api.CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE()

    elseif event == "CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE" and not (vr.wr.isRunning and GOg("SuppressBlessItLogging")) then --echo damage event back to WLconsole
        vr.api.CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE()

    elseif event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" and not (vr.wr.isRunning and GOg("SuppressBlessItLogging")) then --echo damage event back to WLconsole
        vr.api.CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS()

    elseif event == "CHAT_MSG_SPELL_SELF_BUFF" and not (vr.wr.isRunning and GOg("SuppressBlessItLogging")) then --echo heals event to WLconsole
        vr.api.CHAT_MSG_SPELL_SELF_BUFF()

    elseif event == "CHAT_MSG_SPELL_SELF_DAMAGE" and not (vr.wr.isRunning and GOg("SuppressBlessItLogging")) then --echo damage event back to WLconsole
        vr.api.CHAT_MSG_SPELL_SELF_DAMAGE()

    elseif event == "SPELLCAST_FAILED" then
        vr.api.SPELLCAST_FAILED()

    elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
        vr.api.COMBAT_LOG_EVENT_UNFILTERED()

    elseif event == "CHAT_MSG_SPELL_FAILED_LOCALPLAYER" then
        vr.api.CHAT_MSG_SPELL_FAILED_LOCALPLAYER()

    elseif event == "PLAYER_REGEN_DISABLED" then
        vr.api.Combat = true
        vr.api.CombatStart = GetTime()
        vr.api.CombatTotal = 0
        if not vr.api.AttackStart then
            vr.api.AttackEnd = nil
            vr.api.AttackStart = vr.api.CombatStart
        end

    elseif event == "PLAYER_REGEN_ENABLED" then
        vr.api.CombatEnd = GetTime()
        vr.api.Combat = nil
        vr.api.BackstabBugged = false
        -- for slot = 1, 18 do
        --    local name = CheckCooldown(slot)
        --    if name then
        --        Print(name.." "..CHAT_IS_ON_CD_FURY)
        --    end
        -- end

    elseif event == "PLAYER_ENTER_COMBAT" then
        vr.api.Attack = true
        vr.api.AttackEnd = nil
        vr.api.AttackStart = GetTime()
        vr.war.HaveNotSunderedYet = true
        --vr.war.tankopen(true)
        if vr.api.HasBuff("player", 'Flurry') then
            vr.war.FlurryStart = GetTime()
        end

    elseif event == "PLAYER_LEAVE_COMBAT" then
        vr.api.Attack = nil
        if vr.api.AttackStart then
            vr.api.AttackEnd = GetTime()
            vr.api.CombatTotal = vr.api.CombatTotal + (vr.api.AttackEnd - vr.api.AttackStart)
            if vr.war.FlurryStart then
                vr.war.FlurryCombatTotal = vr.war.FlurryCombatTotal + (vr.api.AttackEnd - vr.war.FlurryStart)
                vr.war.FlurryStart = nil
            end
        end

    elseif event == "PLAYER_ENTERING_WORLD" then
        --setTimer(0.5, vr.api.SyncClassDataWorld)

    elseif event == "RAID_ROSTER_UPDATE" then
        --vr.api.GroupSync();

    elseif (event == "VARIABLES_LOADED") then
        if not BlessIt_Initialized then
            BlessIt_Initialize();
        end
    end

end




---[ vr.pal.bof ]--------------------------------------------------------------
function vr.pal.bof()
    --vr.log.Log("invoking vr.pal.bof()")
    if vr.api.CheckWoWVersion("vanilla") then
        if true
            and vr.pal.isBoFReady() then
                SpellStopCasting()
                vr.pal.castBlessingOfFreedom()
                vr.pal.lastCastBoF = GetTime()
                vr.pal.lastBoFTarget = UnitName('target')
            end

    elseif vr.api.CheckWoWVersion("twow") then
        if true
            and vr.pal.isBoFReady() then
                SpellStopCasting()
                vr.pal.castBlessingOfFreedom()
                vr.pal.lastCastBoF = GetTime()
                vr.pal.lastBoFTarget = UnitName('target')
            end
    end
end

---[ vr.pal.bop ]---------------------------------------------------------
function vr.pal.bop()
    --vr.log.Log("invoking vr.pal.bop()")
    if vr.api.CheckWoWVersion("vanilla") then
        if true
            and vr.pal.isBoPReady()
            and not vr.pal.isBlessingOfProtectionActive() then
                if vr.api.HasDebuff("target", "Spell_Holy_RemoveCurse") then
                    vr.log.Ability('Forbearance', 'Cannot cast BOP on ' .. UnitName('target') .. '!  Has Forbearance.', 2000)
                else
                    SpellStopCasting()
                    vr.pal.castBlessingOfProtection()
                    vr.pal.lastCastBoP = GetTime()
                    vr.pal.lastBoPTarget = UnitName('target')
                    return
                end
            end

    elseif vr.api.CheckWoWVersion("twow") then
        if true
            and vr.pal.isBoPReady()
            and not vr.pal.isBlessingOfProtectionActive() then
                if vr.api.HasDebuff("target", "Spell_Holy_RemoveCurse") then
                    vr.log.Ability('Forbearance', 'Cannot cast BOP on ' .. UnitName('target') .. '!  Has Forbearance.', 2000)
                else
                    SpellStopCasting()
                    vr.pal.castBlessingOfProtection()
                    vr.pal.lastCastBoP = GetTime()
                    vr.pal.lastBoPTarget = UnitName('target')
                    return
                end
            end
    end
end

---[ vr.pal.hoj ]--------------------------------------------------------------
function vr.pal.hoj()
    --vr.log.Debug('Invoking vr.pal.hoj()')
    if vr.api.CheckWoWVersion('vanilla') then

        if not UnitExists('target') or not UnitCanAttack('player', 'target') then
            -- if no viable target, report time until ready
            --print('one')
            vr.api.ReportCD(ABILITY_HAMMER_OF_JUSTICE, 2000)
            return false;
        elseif UnitOnTaxi('player') then
            vr.log.Debug('You are on a taxi.')
            return false;
        elseif UnitIsCivilian('target') then
            vr.log.Debug('Unit is a civilian.')
            return false;
        end

        --SpellStopCasting()

        if vr.pal.isHammerOfJusticeUsable() and vr.pal.isHammerOfJusticeReady() then
            SpellStopCasting()
            vr.pal.castHammerOfJustice()
            vr.log.Say('HoJ on ' .. UnitName('target') .. '!')
            vr.pal.lastCastHoJ = GetTime()
        else
            -- if not ready, report time until ready
            --print('hello')
            --print('two')
            if vr.api.MilliSecondsSince(vr.pal.lastCastHoJ) > 2000 then
                vr.api.ReportCD(ABILITY_HAMMER_OF_JUSTICE, 2000)
            end

        end

    elseif vr.api.CheckWoWVersion('twow') then

        if not UnitExists('target') or not UnitCanAttack('player', 'target') then
            -- if no viable target, report time until ready
            --print('one')
            vr.api.ReportCD(ABILITY_HAMMER_OF_JUSTICE, 2000)
            return false;
        elseif UnitOnTaxi('player') then
            vr.log.Debug('You are on a taxi.')
            return false;
        elseif UnitIsCivilian('target') then
            vr.log.Debug('Unit is a civilian.')
            return false;
        end

        --SpellStopCasting()

        if vr.pal.isHammerOfJusticeUsable() and vr.pal.isHammerOfJusticeReady() then
            SpellStopCasting()
            vr.pal.castHammerOfJustice()
            vr.log.Say('HoJ on ' .. UnitName('target') .. '!')
            vr.pal.lastCastHoJ = GetTime()
        else
            -- if not ready, report time until ready
            --print('hello')
            --print('two')
            if vr.api.MilliSecondsSince(vr.pal.lastCastHoJ) > 2000 then
                vr.api.ReportCD(ABILITY_HAMMER_OF_JUSTICE, 2000)
            end

        end

    end
end

---[ vr.pal.loh ]--------------------------------------------------------------
function vr.pal.loh()
    --vr.log.Log("invoking vr.pal.loh()")
    if vr.api.CheckWoWVersion("vanilla") then
        if true
            and vr.pal.isLoHReady() then
                SpellStopCasting()
                vr.pal.castLayOnHands()
                vr.pal.lastCastLoH = GetTime()
                vr.pal.lastLoHTarget = UnitName('target')
            end

    elseif vr.api.CheckWoWVersion("twow") then
        if true
            and vr.pal.isLoHReady() then
                SpellStopCasting()
                vr.pal.castLayOnHands()
                vr.pal.lastCastLoH = GetTime()
                vr.pal.lastLoHTarget = UnitName('target')
            end
    end
end


function vr.pal.SlashCommands(msg)

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

        -- set console output
        if arg1 == "console" and arg2 == '4' then
            print('BlessIt: Console output set to chat 4');
        end

        return;
    end

    -- MATCH 1 ARGUMENT
    arg1 = nil;
    local arg1 = string.lower(msg)

    if arg1 ~= nil then
        if arg1 == "bof" then
            --vr.log.Log(vr.log.Format1Var("[1 args]"," /arg1:", arg1))
            --vr.log.Log("executing bof script")
            vr.pal.bof();
            return;
        end
        if arg1 == "bop" then
            --vr.log.Log(vr.log.Format1Var("[1 args]"," /arg1:", arg1))
            --vr.log.Log("executing bop script")
            vr.pal.bop();
            return;
        end
        if arg1 == "hoj" then
            --vr.log.Log(vr.log.Format1Var("[1 args]"," /arg1:", arg1))
            --vr.log.Log("executing hoj script")
            vr.pal.hoj();
            return;
        end
        if arg1 == "holyshock" then
            --vr.log.Log(vr.log.Format1Var("[1 args]"," /arg1:", arg1))
            vr.log.Log("executing holyshock script")
            vr.pal.holyshock();
            return;
        end
        if arg1 == "loh" then
            --vr.log.Log(vr.log.Format1Var("[1 args]"," /arg1:", arg1))
            --vr.log.Log("executing loh script")
            vr.pal.loh();
            return;
        end

    end
    vr.api.SlashCommands(msg)
end
SLASH_BLESSIT1 = "/blessit";
SLASH_BLESSIT2 = "/vr";