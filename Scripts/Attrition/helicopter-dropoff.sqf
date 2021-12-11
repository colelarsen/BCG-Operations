/**
 * Author - Cole Larsen
 * Used with Attrition
 * Called when Start Waves is used by Zeus
 *
 * Example for how to use Attrition gamemode
*/

call compile preprocessFileLineNumbers "Scripts\BCG-Common\BCG-Spawn-Rand-Group.sqf";

if (isDedicated || IS_DEVELOPING) then {
    _spawn1 = getMarkerPos "helicopter_transport1";
    
    _Deletedistance = 2000;
    _Spawngroups = [
    ["O_Soldier_SL_F","O_Soldier_AR_F","O_HeavyGunner_F","O_Soldier_AAR_F","O_soldier_M_F","O_Sharpshooter_F","O_Soldier_LAT_F","O_medic_F","O_Soldier_SL_F","O_Soldier_AR_F","O_HeavyGunner_F","O_Soldier_AAR_F","O_soldier_M_F","O_Sharpshooter_F","O_Soldier_LAT_F"],
    ["O_Soldier_SL_F", "O_Soldier_SL_F"],
    ["B_Heli_Transport_03_F"]
    ];

    _SpawnArray = [_spawn1];

    _Spawnmaxdelay = 400;
    _Spawnavgdelay = 400;
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

    

	h = [[_spawn1],_Spawngroups,_AISkills,_Spawnside,_enemySide,_Spawnmindelay,_Spawnavgdelay,_Spawnmaxdelay,_SpawnAvgDegrade, "drop-off"] spawn spawnWaves;

}