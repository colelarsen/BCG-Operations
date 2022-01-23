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

//Get number of groups on a side that BCG spawned
getRandomPlayerLocation = {
    selectRandom (allPlayers - entities "HeadlessClient_F");
};

//Add actions to Zeus ACE interact
addActionSelfInteract = {
    _name = _this select 0;
    _description = _this select 1;
    _statement = _this select 2;
    _condition = _this select 3;

	myaction = [_description, _name,'',_statement,_condition] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions"], myaction] call ace_interact_menu_fnc_addActionToObject;
};

addSubActionSelfInteract = {
    _name = _this select 0;
    _description = _this select 1;
    _statement = _this select 2;
    _condition = _this select 3;
	_path = _this select 4;

	myaction = [_description, _name,'',_statement,_condition] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions", _path], myaction] call ace_interact_menu_fnc_addActionToObject;
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



paradropTroop = {
	params ["_x", "_vehicle", "_isPlayer"];
	if(_isPlayer) then {
		_x = player;
	};

	if((vehicle _x) == _vehicle && (vehicle _x) != _x) then {
		_x allowDamage false;
		[_x] call zade_boc_fnc_actionOnChest;
		//Type of Parachute to use
		_x addBackpack PARADROP_PARACHUTE_TO_USE;
		_x action ["getOut", vehicle _x];
		sleep 2;
		_x action ["OpenParachute", _x];
		sleep 5;
		_x allowDamage false;
		unassignVehicle _x;
	};
	

};


performParadropCargo = {
	params ["_player"];
	{
		if(_x != _player) then {
			//Eject players in group
			if(isPlayer _x && (vehicle _player) getCargoIndex _x > 0) then {
				[_x, vehicle _player, true] remoteExec ["paradropTroop",_x];
			}
			//Eject AI in group
			else {
				if((vehicle _player) getCargoIndex _x > 0) then {
					[_x, vehicle _player, false] spawn paradropTroop;
				};
				
			};
			sleep 1;
		};
	} foreach crew (vehicle _player);

	if((vehicle _player) getCargoIndex _player > 0) then {
		[_player, vehicle _player, true] spawn paradropTroop;
	};
};

performParadrop = {
	params ["_player"];
	{
		if(_x != _player) then {
			//Eject other Players in group
			if(isPlayer _x) then {
				[_x, vehicle _player, true] remoteExec ["paradropTroop",_x];
			}
			//Eject AI in group
			else {
				[_x, vehicle _player, false] spawn paradropTroop;
			};
			//Delay between ejects
			sleep 1;
		};
	} foreach units (group _player);
	[_player, vehicle _player, true] spawn paradropTroop;

	
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
	_Fuel = fuel _helicopter;

	_MainRotorDamage < 0.5 && _TailRotorDamage < 0.5 && _EngineDamage < 0.5 && _Fuel > 0.1;
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

getClosePositionNearObject = {
	params [
	["_C", objNull, [objNull, []]],
	["_R", 50, [0]],
	["_A", objNull, [objNull, []]],
	["_dir", random 360, [0]],
	["_height", 0, [0]]
	];


	if (typename _C == "OBJECT") then {
		_C = getpos _C;
	};


	_Cx = _C select 0;
	_Cy = _C select 1;

	_Ax = _A select 0;
	_Ay = _A select 1;

	_Bx = (_C select 0) + (sin _dir *_R);
	_By = (_C select 1) + (cos _dir *_R);
	






	// compute the euclidean distance between A and B
	_LAB = sqrt ( (_Bx-_Ax)*(_Bx-_Ax)+(_By-_Ay)*(_By-_Ay) );

	// compute the direction vector D from A to B
	_Dx = (_Bx-_Ax)/_LAB;
	_Dy = (_By-_Ay)/_LAB;

	// the equation of the line AB is x = Dx*t + Ax, y = Dy*t + Ay with 0 <= t <= LAB.

	// compute the distance between the points A and E, where
	// E is the point of AB closest the circle center (Cx, Cy)
	_t = _Dx*(_Cx-_Ax) + _Dy*(_Cy-_Ay);

	// compute the coordinates of the point E
	_Ex = _t*_Dx+_Ax;
	_Ey = _t*_Dy+_Ay;

	// compute the euclidean distance between E and C
	_LEC = sqrt((_Ex-_Cx)*(_Ex-_Cx)+(_Ey-_Cy)*(_Ey-_Cy));

	// test if the line intersects the circle
	// compute distance from t to circle intersection point
	_dt = sqrt(_R*_R - _LEC*_LEC);

	// compute first intersection point
	_Fx = (_t-_dt)*_Dx + _Ax;
	_Fy = (_t-_dt)*_Dy + _Ay;

	// compute second intersection point
	_Gx = (_t+_dt)*_Dx + _Ax;
	_Gy = (_t+_dt)*_Dy + _Ay;

	systemChat format ["%1 : %2", _Fx, _Fy];

	[_Fx, _Fy, _height];

	
};