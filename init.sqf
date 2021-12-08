call compileFinal  preprocessFileLineNumbers "Scripts\BCG-Common\BCG-Utility.sqf";
call compileFinal  preprocessFileLineNumbers "Scripts\BCG-Common\BCG-Starting-Hints.sqf";
call compileFinal preprocessFileLineNumbers "f\safeStart\safety.sqf";

//Only set to true when you are developing features in singleplayer
IS_DEVELOPING = false;





if (isDedicated || IS_DEVELOPING) then {
	SAFETY_ON_SERVER = true;
	//On player connect set up their safety
	onPlayerConnected {
	_owner publicVariableClient "SAFETY_ON_SERVER";
	};



	//Fixes ace bad kill counter
	addMissionEventHandler ["EntityKilled",{
		params ["_killed", "_killer", "_instigator"];
		if (isPlayer _instigator) then {
			if (not (side group _killed isEqualTo side _instigator)) then {
				if((vehicle _killed) isKindOf "Tank") then 
				{
					_instigator addPlayerScores [0, 0, 1, 0,0];
					// hint "Player Killed Tank";
				} else 
				{
					if((vehicle _killed) isKindOf "Car") then 
					{
						_instigator addPlayerScores [0, 1, 0, 0,0];
						// hint "Player Killed Car";
					}
					else 
					{
						if((vehicle _killed) isKindOf "Helicopter" || (vehicle _killed) isKindOf "Plane") then 
						{
							_instigator addPlayerScores [0, 0, 0, 1,0];
							// hint "Player Killed Helicopter";
						}
						else 
						{
							_instigator addPlayerScores [1, 0, 0, 0,0];
							// hint "Player Killed Man";
						};
					};
				};
				format ["%1",_instigator_kills] remoteExec ["hint",_instigator];
				// to add one more point than the standard score against infantry
			
		};
	};
	}];
}
else {
	sleep 2;
	[SAFETY_ON_SERVER] call safety;
};


//Uncomment if using attrition
//call compileFinal preprocessFileLineNumbers "Scripts\Attrition\onStart.sqf";


["General", "General", {}, {true}] call addActionGameMasterAce;
["SafetyOn", "Safety On", {[true] remoteExec ["safety", 0]; publicVariable "SAFETY_ON_SERVER";}, {true}, "General"] call addSubActionGameMasterAce;
["SafetyOff", "Safety Off", {[false] remoteExec ["safety", 0]; publicVariable "SAFETY_ON_SERVER";}, {true}, "General"] call addSubActionGameMasterAce;