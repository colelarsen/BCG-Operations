/**
 * Author - Cole Larsen
 * Used with Attrition
 * Called when Start Waves is used by Zeus
 *
 * Example for how to use Attrition gamemode
*/

call compile preprocessFileLineNumbers "Scripts\BCG-Common\BCG-Spawn-Rand-Group.sqf";

if (isDedicated || IS_DEVELOPING) then {
    _spawn1 = getMarkerPos "infantrySpawn_1";
    _spawn2 = getMarkerPos "infantrySpawn_2";
    _spawn3 = getMarkerPos "infantrySpawn_3";
    
    _Deletedistance = 2000;
    _Spawngroups = [
    (configfile >> "CfgGroups" >> "East" >> "rhs_faction_vdv" >> "rhs_group_rus_vdv_infantry_flora" >> "rhs_group_rus_vdv_infantry_flora_squad"),
    (configfile >> "CfgGroups" >> "East" >> "rhs_faction_vdv" >> "rhs_group_rus_vdv_infantry_flora" >> "rhs_group_rus_vdv_infantry_flora_section_mg"),
    (configfile >> "CfgGroups" >> "East" >> "rhs_faction_vdv" >> "rhs_group_rus_vdv_infantry_flora" >> "rhs_group_rus_vdv_infantry_flora_section_AT"),
    (configfile >> "CfgGroups" >> "East" >> "rhs_faction_vdv" >> "rhs_group_rus_vdv_infantry_flora" >> "rhs_group_rus_vdv_infantry_flora_fireteam")
    ];

    _SpawnArray = [_spawn1,_spawn2,_spawn3];

    _Spawnmaxdelay = 5;
    _Spawnavgdelay = 5;
    _Spawnmindelay = 5;

    _SpawnAvgDegrade = 0;

    _Spawnside = OPFOR;
    _enemySide = BLUFOR;

    _AISkills = [
    ["aimingShake", 0.2],
    ["aimingSpeed", 0.2],
    ["endurance", 0.5],
    ["spotDistance", 0.5],
    ["spotTime", 0.5],
    ["courage", 1],
    ["reloadSpeed", 0.5],
    ["commanding", 1],
    ["general", 0.5]
    ];

    

	h = [[_spawn1,_spawn2,_spawn3],_Spawngroups,_AISkills,_Spawnside,_enemySide,_Spawnmindelay,_Spawnavgdelay,_Spawnmaxdelay,_SpawnAvgDegrade] spawn spawnWaves;

}