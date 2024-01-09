# BlessIt : All-In-One Macros & Class Rotations for WoW 1.12.1 & Turtle WoW 1.17.1

## MobDB Module
Bestiary that provides critical information about the engaged NPC and its environment.

- names (TODO)
- enrage parameters (TODO)
- aoe-ability info (TODO)
- cues to encourage defense or burst damage (TODO)
- spell interruption priority flat database (IMPLEMENTED)

## Supported Classes & Specs

### Druid

Focuses on Cat DPS spec.<br>

`/vr buff`<br>
Buff self with Thorns & Mark of the Wild<br>

`/vr dps`<br>
Single target DPS rotation<br>

`/vr dps powershift`<br>
Single target DPS rotation, powershift enabled<br>

### Hunter
Basic anti-autoshoot clipping rotation implemented.

### Mage
Undefined.  Placeholder code is implemented.

### Paladin
Holy/Ret spec rotations implemented with MobDB spellcast interrupt database.

`/vr hoj`<br>
Hand of Justice macro.  Reports CD time left if it is on Cooldown.

`/vr loh`<br>
Mouseover Lay on Hands.

`/vr bop`<br>
Mouseover Blessing of Protection.

`/vr holyshock`<br>
Divine Favor + Holy Shock / Holy Shock on current target.

`/vr dps`<br>
Boilerplate paladin DPS rotation.<br>
Holy: Can select judgement, judge light / wisdom in UI.<br>
Ret: Can select Crusader, Command, Righteousness in UI.<br>

### Priest
Holy/Shadow spec rotations in development.

`/vr dps long`      DPS rotation.

Holy<br>
Shadow<br>

### Rogue
Undefined.  Placeholder code is implemented.

### Shaman
Undefined.  Placeholder code is implemented.

### Warrior
Focuses on **FuryProt Dual Wield** spec.<br>
Spell interruption MobDB integration.<br>

Warrior Macros:<br>

`/vr buffed`    Toggles whether or not you are raid buffed.  If this is toggled ON, macro will be more aggressive on Heroic Strike/Cleave/Hamstring usage.  Only affects DPS macros.<br>

`/vr dpsst`     Single target DPS rotation with AOE abilities enabled.<br>

`/vr dpsstnaoe` Single target DPS rotation with AOE abilities disabled.<br>

`/vr dpsaoe`    Multi target DPS rotation.<br>

`/vr tankopen`  Fury prot opener macro.<br>

`/vr block`     Mitigation tanking macro.<br>

`/vr threat`    Threat tanking macro.<br>

`/vr shoot`<br>
Shoots whatever ranged weapon you have equipped.

#### WeaponQuickSwap weaponset configuration (warrior weapons only):

**IMPORTANT:** *user must edit `vr.war.WeaponSets` inside `Warrior.lua` with their own loadout prior to use.*

`/vr weapon 1`<br>
dual wield weapons, AOE properties allowed

`/vr weapon 2`<br>
dual wield weapons, AOE properties prohibited

`/vr weapon 3`<br>
sword & board, AOE properties allowed

`/vr weapon 4`<br>
sword & board, AOE properties prohibited

`/vr weapon 5`<br>
threat tanking weapons, AOE properties allowed

`/vr weapon 6`<br>
threat tanking weapons, AOE properties prohibited

`/vr weapon 7`<br>
equip frost damage weapons (for Viscidus encounter)


### Warlock
Undefined.  Placeholder code is implemented.

## Global Slash Commands

`/vr radar`<br>

Toggle Radar UI Visibility.
