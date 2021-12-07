call compileFinal  preprocessFileLineNumbers "Scripts\BCG-Common\BCG-Utility.sqf";
call compileFinal preprocessFileLineNumbers "f\safeStart\safety.sqf";

//Only set to true when you are developing features in singleplayer
IS_DEVELOPING = true;
SAFETY_ON_SERVER = true;




if (isDedicated || IS_DEVELOPING) then {

	//Start up the attrition game modes
	call compileFinal preprocessFileLineNumbers "Scripts\Attrition\onStart.sqf";
};





[SAFETY_ON_SERVER] call safety;


["SafetyOn", "Safety On", {[true] remoteExec ["safety", 0];}, {true}] call addActionGameMasterAce;
["SafetyOff", "Safety Off", {[false] remoteExec ["safety", 0];}, {true}] call addActionGameMasterAce;