/**
 * Author - Cole Larsen
 * Used with Attrition gamemode but possibly more in the future
 * 
 *
 * Core mechanics of Attrition
*/

call compileFinal preprocessFileLineNumbers "Scripts\BCG-Common\BCG-Utility.sqf";


/**
 * Spawn a _spawnGroup at  _spawnPosistion with skills _AISkills
*/
BCG_Spawn_Rand_Group = {

     params ["_spawnPosistion", "_spawnGroup", "_AISkills", "_Spawnside"];

    
    _NewGroup = [_spawnPosistion, _Spawnside, _spawnGroup, [],[],[],[],[],[], false] call BIS_fnc_spawnGroup;


    _NewGroup setVariable ["spawned",true];
    //_NewGroup deleteGroupWhenEmpty true;

    {
        _EditUnit = _x;
        {
            _EditUnit setSkill _x;
        } forEach _AISkills;

        _EditUnit disableAI "SUPPRESSION";
        _EditUnit disableAI "AUTOCOMBAT";
        
    } forEach units _NewGroup;

    _NewGroup addVehicle (vehicle ((units _NewGroup) select 0));
    _NewGroup addVehicle (vehicle ((units _NewGroup) select 1));
    
    _moveHere = selectRandom allPlayers; 

    NewGroupWayPoint = _NewGroup addWaypoint [position ((units _NewGroup) select 0), 0];
    NewGroupWayPoint setWaypointType "GETIN";

    NewGroupWayPoint = _NewGroup addWaypoint [position _moveHere, 1];
    NewGroupWayPoint setWaypointType "MOVE";
    NewGroupWayPoint setWaypointTimeout [20, 20, 20];






    _NewGroup enableGunLights "forceOn";
    _NewGroup setBehaviour "AWARE";
    _NewGroup setSpeedMode "FULL";
    _NewGroup allowFleeing 0;


    _NewGroup;

    };



/**
 * _Spawntargets - array of locations to spawn in
 * _spawnGroups - array of groups to possibly spawn in
 * _AISkills - skills they have
 * _Spawnside - Side of group
 * _enemySide - Side of enemies of group
 * _Spawnmindelay - Minimum time between waves
 * _Spawnavgdelay - Average (bell cureve) time between waves
 * _Spawnmaxdelay - Maximum time between waves
 * _midDegrade - Every time a wave comes in, subtract the _Spawnavgdelay by _midDegrade. Effectively shift the bell curve by _midDegrade. Reduces average time between wave spawns
*/
spawnWaves = {
    
    params ["_Spawntargets", "_spawnGroups", "_AISkills", "_Spawnside", "_enemySide", "_Spawnmindelay", "_Spawnavgdelay", "_Spawnmaxdelay", "_midDegrade"];
    while {true} do { 
        if(SHOULD_KEEP_SPAWNING && MAXIMUM_SPAWNED_GROUPS > 0)  then 
        {

            //Update the move orders of spawned groups to a current player position
            {
                _moveHere = selectRandom allPlayers;
                _EditGroup = _x;
                if(count waypoints _EditGroup >= 3) then {
                    deleteWaypoint [_EditGroup, 0];
                };

                
                _NewGroupWayPoint = _EditGroup addWaypoint [position _moveHere, count waypoints _EditGroup];
                _NewGroupWayPoint setWaypointType "MOVE";
                if({alive _x} count units _EditGroup == 0) then 
                {
                    _EditGroup setVariable ["spawned",false];
                };
            } foreach (allGroups select {side _x == _Spawnside && (_x getVariable ["spawned",false])});



            _SpawnPosistion = selectRandom _Spawntargets;

            //If less than the max active groups are around then spawn in more groups
            if([_Spawnside] call getSideGroupNums < MAXIMUM_ACTIVE_GROUPS) then {
                _NewGroup = [_SpawnPosistion, (selectRandom _Spawngroups), _AISkills, _Spawnside] call BCG_Spawn_Rand_Group;
                MAXIMUM_SPAWNED_GROUPS = MAXIMUM_SPAWNED_GROUPS - 1;

                (units _NewGroup) orderGetIn true;
            };

            
        

            
            
            
            //Sleep a random amount of time - time between wave spawns            
            sleep (random [_Spawnmindelay,_Spawnavgdelay,_Spawnmaxdelay]);

            //Degrade the average time between waves
            _Spawnavgdelay = _Spawnavgdelay - _midDegrade;
            if(_Spawnavgdelay < _Spawnmindelay) then { 
                _Spawnavgdelay = _Spawnmindelay;
            };

        }
    };
};
