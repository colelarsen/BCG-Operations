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
    
    params ["_Spawntargets", "_spawnGroups", "_AISkills", "_Spawnside", "_enemySide", "_Spawnmindelay", "_Spawnavgdelay", "_Spawnmaxdelay", "_midDegrade", "_type"];
    while {true} do { 
        if(SHOULD_KEEP_SPAWNING && MAXIMUM_SPAWNED_GROUPS > 0)  then 
        {

             _SpawnPosistion = selectRandom _Spawntargets;

             _NewGroup = nil;

            


            switch (_type) do
            {
                case "move": {
                    //If less than the max active groups are around then spawn in more groups
                    if([_Spawnside] call getSideGroupNums < MAXIMUM_ACTIVE_GROUPS) then {
                        _NewGroup = [_SpawnPosistion, (selectRandom _Spawngroups), _AISkills, _Spawnside] call BCG_Spawn_Rand_Group;
                        _NewGroup setVariable [_type,true];
                        MAXIMUM_SPAWNED_GROUPS = MAXIMUM_SPAWNED_GROUPS - 1;
                    };
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
                    } foreach (allGroups select {side _x == _Spawnside && (_x getVariable ["spawned",false]) && (_x getVariable [_type,false])});

                    if(!isNil _NewGroup) then {
                        //Groups should get in vehicle then move out
                        _NewGroup addVehicle (vehicle ((units _NewGroup) select 0));
                        
                        _moveHere = selectRandom allPlayers; 

                        NewGroupWayPoint = _NewGroup addWaypoint [position ((units _NewGroup) select 0), 0];
                        NewGroupWayPoint setWaypointType "GETIN";

                        NewGroupWayPoint = _NewGroup addWaypoint [position _moveHere, 1];
                        NewGroupWayPoint setWaypointType "MOVE";
                        NewGroupWayPoint setWaypointTimeout [20, 20, 20];
                    }
                };
                case "drop-off": {
                    if([_Spawnside] call getSideGroupNums < MAXIMUM_ACTIVE_GROUPS) then {

                        //Spawn groups and put them in helicopter
                        _troops = [_SpawnPosistion, _Spawngroups select 0, _AISkills, _Spawnside] call BCG_Spawn_Rand_Group;
                        _pilots = [_SpawnPosistion, _Spawngroups select 1, _AISkills, _Spawnside] call BCG_Spawn_Rand_Group;
                        MAXIMUM_SPAWNED_GROUPS = MAXIMUM_SPAWNED_GROUPS - 1;
                        _helicopter = (_Spawngroups select 2) select 0 createVehicle _SpawnPosistion;
                        _troops setVariable [_type,true];
                        _pilots setVariable [_type,true];
                        _pilots addVehicle _helicopter;

                        _moveHere = selectRandom allPlayers;
                        //Land somewhere 200-300m away from a random player
                        _helicopterLanding = [_rand_player, (random [200, 250, 300])] call getRandomPositionNearObject;
                        

                        {_x moveincargo _helicopter} foreach units _troops;
                        units _pilots select 0 moveInDriver _helicopter;
                        units _pilots select 1 moveInGunner _helicopter;

                        //Helicopter Move Order
                        _helicopter move _helicopterLanding;
                        sleep 3;



                        //Wait for helicopter to move or become unflyable
                        while { (alive _helicopter) && !unitReady _helicopter && [_helicopter] call helicopterFlyable} do
                        {
                            sleep 1;
                        };

                        //If helicopter too damaged to land go home
                        if (alive _helicopter && [_helicopter] call helicopterFlyable) then
                        {
                            _helicopter land "GET OUT";
                        }
                        else {
                            [_helicopter, _pilots, _troops, _SpawnPosistion] call helicopterGoHome;
                        };

                        //Wait for helicopter to land or become unflyable
                        while { (alive _helicopter) && ((getPos _helicopter) select 2) > 10 && [_helicopter] call helicopterFlyable} do
                        {
                            sleep 1;
                        };

                        

                        //If crash landed
                        if(!([_helicopter] call helicopterFlyable) && ((getPos _helicopter) select 2) < 10) then 
                        {
                            _pilots leaveVehicle _helicopter;
                            _NewGroupWayPoint = _pilots addWaypoint [position _helicopter, 0];
                            _NewGroupWayPoint setWaypointType "GETOUT";
                            _NewGroupWayPoint setWaypointCompletionRadius 50;
                            _NewGroupWayPoint2 = _pilots addWaypoint [_SpawnPosistion, 1];
                            _NewGroupWayPoint2 setWaypointType "MOVE";

                            systemChat "Helicopter damaged on landing, pilots evac";
                            while { (alive _helicopter) && ((getPos _helicopter) select 2) > 10} do
                            {
                                sleep 1;
                            };
                        };

                        //If the helicopter is on ground troops get out
                        if(((getPos _helicopter) select 2) < 10) then 
                        {
                            _troops leaveVehicle _helicopter;
                            _NewGroupWayPoint = _troops addWaypoint [position _helicopter, 0];
                            _NewGroupWayPoint setWaypointType "Unload";
                            _NewGroupWayPoint setWaypointCompletionRadius 50;
                            _NewGroupWayPoint2 = _troops addWaypoint [position _moveHere, 1];
                            _NewGroupWayPoint2 setWaypointType "MOVE";

                            _troops setVariable [_type,false];
                            _troops setVariable ["move",true];
                            //Wait troops unload
                            sleep (count units _troops) * 4.25;
                        };
                        
                        


                        //If helicopter is damaged
                        if(!([_helicopter] call helicopterFlyable)) then 
                        {
                            _pilots leaveVehicle _helicopter;
                            NewGroupWayPoint = _pilots addWaypoint [position _helicopter, 0];
                            NewGroupWayPoint setWaypointType "GETOUT";
                            NewGroupWayPoint = _pilots addWaypoint [_SpawnPosistion, 1];
                            NewGroupWayPoint setWaypointType "MOVE";

                            systemChat "Helicopter damaged on takeoff, pilots evac";

                            _troops leaveVehicle _helicopter;
                            NewGroupWayPoint = _troops addWaypoint [position _helicopter, 0];
                            NewGroupWayPoint setWaypointType "Unload";
                            NewGroupWayPoint = _troops addWaypoint [position _moveHere, 1];
                            NewGroupWayPoint setWaypointType "MOVE";
                        }
                        //If helicopter flyable head home and 
                        else
                        {
                           [_helicopter, _pilots, nil, _SpawnPosistion] call helicopterGoHome;
                        };
                    };
                };
                default {};
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



helicopterGoHome = {
    params ["_helicopter", "_pilots", "_troops", "_destination"];

    _helicopter move _destination;
    while { (alive _helicopter) && !unitReady _helicopter } do
    {
        sleep 1;
    };


    if (alive _helicopter) then
    {
        _helicopter land "LAND";
    };
    while { (alive _helicopter) && ((getPos _helicopter) select 2) > 10 } do
    {
        sleep 1;
    };

    if((alive _helicopter)) then 
    {
        { deleteVehicle _x;} foreach units _troops;
        { deleteVehicle _x;} foreach units _pilots;
        deleteVehicle _helicopter;
    };
    

}


