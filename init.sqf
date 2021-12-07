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