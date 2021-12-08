/**
 * Author - Cole Larsen
 * 
 * Called Mission starts or when Player joins
 *
 * 
*/

//Compile commonly used / helper functions
call compileFinal  preprocessFileLineNumbers "Scripts\BCG-Common\BCG-Utility.sqf";
call compileFinal preprocessFileLineNumbers "f\safeStart\safety.sqf";




/**
	***************************
	Configurable Variables
	***************************
*/

IS_DEVELOPING = false; //Only set to true when you are developing features in singleplayer


SAFETY_ON_SERVER = true; //Should the safety be on when server starts
ATTRITION_ENABLED = false; //Should the attrition gamemode / controlls be available




if (isDedicated || IS_DEVELOPING) then {
	//On player connect send them the current value of SAFETY_ON_SERVER
	onPlayerConnected {
	_owner publicVariableClient "SAFETY_ON_SERVER";
	};



	//Fixes ace bad kill counter
	addMissionEventHandler ["EntityKilled",{
		params ["_killed", "_killer", "_instigator"];
		if (isPlayer _instigator) then {
			if (not (side group _killed isEqualTo side _instigator)) then {
				if(_killed isKindOf "Man") then 
				{
					instigator addPlayerScores [1, 0, 0, 0,0];
				};			
		};
	};
	}];
}
//When a player joins execute the below code
else {

	//Sleep for a short while so values from server can be populated
	sleep 2;
	//Configure their safety for whatever value was got from server
	[SAFETY_ON_SERVER] call safety;
};


//Enable attrition gamemode
if(ATTRTION_ENABLED) then {
	call compileFinal preprocessFileLineNumbers "Scripts\Attrition\onStart.sqf";
};


//General BCG Zeus ACE interact handlers
["General", "General", {}, {true}] call addActionGameMasterAce;
["SafetyOn", "Safety On", {[true] remoteExec ["safety", 0]; publicVariable "SAFETY_ON_SERVER";}, {true}, "General"] call addSubActionGameMasterAce;
["SafetyOff", "Safety Off", {[false] remoteExec ["safety", 0]; publicVariable "SAFETY_ON_SERVER";}, {true}, "General"] call addSubActionGameMasterAce;