call compileFinal preprocessFileLineNumbers "Scripts\BCG-Common\BCG-Spawn-Rand-Group.sqf";
if (isDedicated || IS_DEVELOPING) then {

	_spawn1 = getMarkerPos "carSpawn_1";
	_spawn2 = getMarkerPos "carSpawn_2";
	_Deletedistance = 2000;
	_Spawngroups = [
	(configfile >> "CfgGroups" >> "East" >> "rhs_faction_vdv" >> "rhs_group_rus_vdv_Ural" >> "rhs_group_rus_vdv_Ural_squad"),
	(configfile >> "CfgGroups" >> "East" >> "rhs_faction_vdv" >> "rhs_group_rus_vdv_Ural" >> "rhs_group_rus_vdv_Ural_squad_mg_sniper"),
	(configfile >> "CfgGroups" >> "East" >> "rhs_faction_vdv" >> "rhs_group_rus_vdv_gaz66" >> "rhs_group_rus_vdv_gaz66_squad")
	];

	_Spawnmaxdelay =300;
	_Spawnavgdelay =480;
	_Spawnmindelay =300;
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

	h = [[_spawn1,_spawn2],east,_Spawngroups,_AISkills,_Spawnside,_enemySide,_Spawnmindelay,_Spawnavgdelay,_Spawnmaxdelay,0] spawn spawnWaves;


}