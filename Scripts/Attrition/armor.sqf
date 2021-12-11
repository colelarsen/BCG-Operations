/**
 * Author - Cole Larsen
 * Used with Attrition
 * Called when Start Waves is used by Zeus
 *
 * Example for how to use Attrition gamemode
*/

call compile preprocessFileLineNumbers "Scripts\BCG-Common\BCG-Spawn-Rand-Group.sqf";


_spawnArmor = {
	if (isDedicated || IS_DEVELOPING) then {

		_spawn1 = getMarkerPos "armorSpawn_1";
		_spawn2 = getMarkerPos "armorSpawn_2";
		_Spawntarget = selectRandom [_spawn1,_spawn2];
		_Deletedistance = 2000;
		_Spawngroups = [
		(configfile >> "CfgGroups" >> "East" >> "rhs_faction_vdv" >> "rhs_group_rus_vdv_bmd1" >> "rhs_group_rus_vdv_bmd1_squad"),
		(configfile >> "CfgGroups" >> "East" >> "rhs_faction_vdv" >> "rhs_group_rus_vdv_bmd2" >> "rhs_group_rus_vdv_bmd2_squad"),
		(configfile >> "CfgGroups" >> "East" >> "rhs_faction_vdv" >> "rhs_group_rus_vdv_bmp1" >> "rhs_group_rus_vdv_bmp1_squad"),
		(configfile >> "CfgGroups" >> "East" >> "rhs_faction_vdv" >> "rhs_group_rus_vdv_bmp2" >> "rhs_group_rus_vdv_bmp2_squad"),
		(configfile >> "CfgGroups" >> "East" >> "rhs_faction_vdv" >> "rhs_group_rus_vdv_btr60" >> "rhs_group_rus_vdv_btr60_squad"),
		(configfile >> "CfgGroups" >> "East" >> "rhs_faction_tv" >> "rhs_group_rus_tv_72" >> "RHS_T72BASection")
		];

		_Spawnmaxdelay =600;
		_Spawnavgdelay =300;
		_Spawnmindelay =240;
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

		h = [[_spawn1,_spawn2],_Spawngroups,_AISkills,_Spawnside,_enemySide,_Spawnmindelay,_Spawnavgdelay,_Spawnmaxdelay,0, "attack-players"] spawn spawnWaves;
	};
};

call _spawnArmor;