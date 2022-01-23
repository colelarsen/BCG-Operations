
aiUpdater = {
	while {true} do {
		//Update the move orders of spawned groups to a current player position
		{
			_moveHere = call getRandomPlayerLocation;
			_EditGroup = _x;
			if(count waypoints _EditGroup >= 3) then {
				deleteWaypoint [_EditGroup, 0];
			};

			
			_NewGroupWayPoint = _EditGroup addWaypoint [position _moveHere, count waypoints _EditGroup];
			_NewGroupWayPoint setWaypointType "SAD";
			if({alive _x} count units _EditGroup == 0) then 
			{

				_EditGroup setVariable ["spawned",false];
			};
		} foreach (allGroups select {(_x getVariable ["spawned",false]) && (_x getVariable ["attack-players",false])});





		{
			_moveHere = call getRandomPlayerLocation;
			_EditGroup = _x;
			if(count waypoints _EditGroup >= 3) then {
				deleteWaypoint [_EditGroup, 0];
			};

			
			_NewGroupWayPoint = _EditGroup addWaypoint [position _moveHere, count waypoints _EditGroup];
			_NewGroupWayPoint setWaypointType "Hold";
			if({alive _x} count units _EditGroup == 0) then 
			{
				_EditGroup setVariable ["spawned",false];
			};
		} foreach (allGroups select {(_x getVariable ["spawned",false]) && (_x getVariable ["cas",false])});


		sleep 30;
	}

}
