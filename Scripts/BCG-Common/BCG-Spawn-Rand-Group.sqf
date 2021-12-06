
call compileFinal preprocessFileLineNumbers "Scripts\BCG-Common\BCG-Utility.sqf";

BCG_Spawn_Rand_Group = {

    
    private _spawnPosistion = _this select 0;
    private _side = _this select 1;
    private _spawnGroup = _this select 2;
    private _AISkills = _this select 3;
    private _Spawnside = _this select 4;
    private _enemySide = _this select 5;


    _NewGroup = [_SpawnPosistion, east, _spawnGroup,[],[],[],[],[],[], false] call BIS_fnc_spawnGroup;
    _NewGroup setVariable ["spawned",true];
    _NewGroup deleteGroupWhenEmpty true;

    {
        _EditUnit = _x;
        {
            _EditUnit setSkill _x;
        } forEach _AISkills;

        _EditUnit disableAI "SUPPRESSION";
        _EditUnit disableAI "AUTOCOMBAT";
        
    } forEach units _NewGroup;


    _moveHere = selectRandom allPlayers;


    _NewGroup enableGunLights "forceOn";
    _NewGroup setBehaviour "AWARE";
    _NewGroup setSpeedMode "FULL";
    _NewGroup allowFleeing 0;
    _GroupWayPoint = _NewGroup addWaypoint [position _moveHere, 0];
    _GroupWayPoint setWaypointType "MOVE";

    _NewGroup;

    };


spawnWaves = {
    




    params ["_Spawntargets", "_side", "_spawnGroups", "_AISkills", "_Spawnside", "_enemySide", "_Spawnmindelay", "_Spawnavgdelay", "_Spawnmaxdelay", "_midDegrade"];
    while {true} do { 
        if(SHOULD_KEEP_SPAWNING && MAXIMUM_SPAWNED_GROUPS > 0)  then 
        {
            _SpawnPosistion = selectRandom _Spawntargets;

            if([_Spawnside] call getSideGroupNums < MAXIMUM_ACTIVE_GROUPS) then {
                _NewGroup = [_SpawnPosistion, east, _Spawngroups select (floor (random (count _Spawngroups))), _AISkills, _Spawnside, _enemySide] call BCG_Spawn_Rand_Group;
                MAXIMUM_SPAWNED_GROUPS = MAXIMUM_SPAWNED_GROUPS - 1;
            };


            _moveHere = selectRandom allPlayers;
            {
                _EditGroup = _x;
                for "_i" from count waypoints _EditGroup - 1 to 0 step -1 do  { 
                    deleteWaypoint [_EditGroup, _i];
                };

                _NewGroupWayPoint = _EditGroup addWaypoint [position _moveHere, 0];
                _NewGroupWayPoint setWaypointType "MOVE";


                if({alive _x} count units _EditGroup == 0) then 
                {
                    _EditGroup setVariable ["spawned",false];
                };


            } foreach (allGroups select {side _x == _Spawnside && (_x getVariable ["spawned",true])});

            
            
            
            hint format ["Times: %1, %2, %3", _Spawnmindelay, _Spawnavgdelay, _Spawnmaxdelay];
            
            sleep (random [_Spawnmindelay,_Spawnavgdelay,_Spawnmaxdelay]);

            //Degrade the average until
            _Spawnavgdelay = _Spawnavgdelay - _midDegrade;
            if(_Spawnavgdelay < _Spawnmindelay) then { 
                _Spawnavgdelay = _Spawnmindelay;
            };

        }
    };
};
