/**
 * Author - Cole Larsen
 * Used with Attrition
 * Called when Start Waves is used by Zeus
 *
 * Example for how to use Attrition gamemode
*/

call compile preprocessFileLineNumbers "Scripts\BCG-Common\BCG-Spawn-Rand-Group.sqf";

if (isDedicated || IS_DEVELOPING) then {
    _spawn1 = getMarkerPos "helicopterSpawn_1";
    
    _Deletedistance = 2000;
    _Spawngroups = [
    ["CUP_O_Ka50_DL_RU"]
    ];

    _SpawnArray = [_spawn1];

    _Spawnmaxdelay = 800;
    _Spawnavgdelay = 600;
    _Spawnmindelay = 400;
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

    

	h = [[_spawn1],_Spawngroups,_AISkills,_Spawnside,_enemySide,_Spawnmindelay,_Spawnavgdelay,_Spawnmaxdelay,_SpawnAvgDegrade, "cas"] spawn spawnWaves;

}