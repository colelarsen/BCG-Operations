/**
 * Author - Cole Larsen
 * Helper functions for various BCG scripts
 * 
 *
 * Core mechanics of Attrition
*/


//Get number of groups on a side that BCG spawned
getSideGroupNums = {

    private _Spawnside = _this select 0;

    count (allGroups select {side _x == _Spawnside && (_x getVariable ["spawned",false])});
};

//Add actions to Zeus ACE interact
addActionGameMasterAce = {

    _name = _this select 0;
    _description = _this select 1;
    _statement = _this select 2;
    _condition = _this select 3;

    _action = [_name,_description,"",_statement,_condition] call ace_interact_menu_fnc_createAction;
    [["ACE_ZeusActions"], _action] call ace_interact_menu_fnc_addActionToZeus;
};

//Add actions to Zeus ACE interact in a sub directory
addSubActionGameMasterAce = {

    _name = _this select 0;
    _description = _this select 1;
    _statement = _this select 2;
    _condition = _this select 3;
    _path = _this select 4;

    _action = [_name,_description,"",_statement,_condition] call ace_interact_menu_fnc_createAction;
    [["ACE_ZeusActions", _path], _action] call ace_interact_menu_fnc_addActionToZeus;
};







getXYVelocity = {
	params ["_projectile"];
	abs((velocity _projectile) select 0) + abs((velocity _projectile) select 1);
};

getTotalVelocity = {
	params ["_projectile"];
	abs((velocity _projectile) select 0) + abs((velocity _projectile) select 1) + abs((velocity _projectile) select 2);
};

getZVelocity = {
	params ["_projectile"];
	abs((velocity _projectile) select 2);
};
projectileTrackHit = {
	params ["_projectile"];
	sleep 0.15;
	_lastXYVel = [_projectile] call getXYVelocity;
	while {true} do
	{
		sleep 0.15;
		//Change in XY Velocity is less than 0.1
		if(abs (([_projectile] call getXYVelocity) - _lastXYVel) > 0.1) exitWith {true};
		_lastXYVel = [_projectile] call getXYVelocity;
	}; 
	_projectile setVelocity ((velocity _projectile) vectorMultiply 0.1);
	if(true) exitWith {true};
};

helicopterFlyable = {
	params ["_helicopter"];
	_MainRotorDamage = _helicopter getHitPointDamage "HitHRotor";
    _TailRotorDamage = _helicopter getHitPointDamage "HitVRotor";
	_EngineDamage = _helicopter getHitPointDamage "HitEngine";


	// systemChat format ["_MainRotorDamage: %1", _MainRotorDamage];
	// systemChat format ["_TailRotorDamage: %1", _TailRotorDamage];
	// systemChat format ["_EngineDamage: %1", _EngineDamage];

	_MainRotorDamage < 0.5 && _TailRotorDamage < 0.5 && _EngineDamage < 0.5;
};



getRandomPositionNearObject = {
	params [
	["_centre", objNull, [objNull, []]],
	["_radius", 50, [0]],
	["_dir", random 360, [0]],
	["_height", 0, [0]]
	];

	if (typename _centre == "OBJECT") then {
		_centre = getpos _centre;
	};

	[(_centre select 0) + (sin _dir *_radius), (_centre select 1) + (cos _dir *_radius), _height];
};