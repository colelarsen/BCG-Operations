call compileFinal  preprocessFileLineNumbers "Scripts\BCG-Common\BCG-Utility.sqf";
call compileFinal  preprocessFileLineNumbers "Scripts\BCG-Common\BCG-Starting-Hints.sqf";
call compileFinal preprocessFileLineNumbers "f\safeStart\safety.sqf";

//Only set to true when you are developing features in singleplayer
IS_DEVELOPING = true;





if (isDedicated || IS_DEVELOPING) then {
	SAFETY_ON_SERVER = true;
	//Start up the attrition game modes
	call compileFinal preprocessFileLineNumbers "Scripts\Attrition\onStart.sqf";
}
else {
	[SAFETY_ON_SERVER] call safety;

	
};




["General", "General", {}, {true}] call addActionGameMasterAce;

["SafetyOn", "Safety On", {[true] remoteExec ["safety", 0];}, {true}, "General"] call addSubActionGameMasterAce;
["SafetyOff", "Safety Off", {[false] remoteExec ["safety", 0];}, {true}, "General"] call addSubActionGameMasterAce;