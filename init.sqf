/**
 * Author - Cole Larsen
 * 
 * Called Mission starts or when Player joins
 *
 * 
*/

//Compile commonly used / helper functions
call compileFinal  preprocessFileLineNumbers "Scripts\BCG-Common\BCG-Utility.sqf";
call compileFinal  preprocessFileLineNumbers "Scripts\BCG-Common\BCG-Global-Vars.sqf";
call compileFinal preprocessFileLineNumbers "f\safeStart\safety.sqf";
call compileFinal  preprocessFileLineNumbers "Scripts\BCG-Common\BCG-AI-Waypoints.sqf";





//Called ONLY on the server when server starts mission
if (isDedicated || IS_DEVELOPING) then {
	//On player connect send them the current value of SAFETY_ON_SERVER
	onPlayerConnected {
	_owner publicVariableClient "SAFETY_ON_SERVER";
	};
}
//When a player joins execute the below code
else {

	//Sleep for a short while so values from server can be populated
	sleep 2;

	//Configure player safety for whatever value was got from server
	[SAFETY_ON_SERVER] call safety;

	//Turn on less grenade bouncing
	if(LESS_GL_SMOKE_BOUNCE_ENABLED) then 
	{
		//When player fires
		player addEventHandler["Fired", {
		if(["smoke", typeOf (_this select 6)] call BIS_fnc_inString) then 
		{
			[_this select 6] spawn projectileTrackHit;
		}
		}];
	};



	// player addEventHandler ["Fired", {
	// 	_null = _this spawn {
	// 		if(["smoke", typeOf (_this select 6)] call BIS_fnc_inString) then {
	// 			_missile = _this select 6;

	// 			[_this select 6] call projectileTrackHit;

	// 			_cam = "camera" camCreate (position (_this select 6)); 
	// 			_cam cameraEffect ["Internal", "Back"];
	// 			// _cam camCommand "MANUAL ON";
	// 			_cam camCommand "speedMax 1";
	// 			_cam camCommand "speedDefault 0.1";
	// 			_cam camCommand "atl on";
	// 			_cam camCommand "surfaceSpeed on";
	// 			_cam camCommand "maxPitch 30";
	// 			_cam camCommand "minPitch -30";

	// 			_cam camCommitPrepared 0;

	// 			deleteVehicle _missile;

	// 			waitUntil {camCommitted _cam};

	// 			CAM_ON = true;

	// 			_action = ["ReturntoBody","Return to Body","",{params ["_cam"]; _cam cameraEffect ["Terminate", "Back"];camDestroy _cam; CAM_ON = false; [player,1,["ACE_SelfActions","ReturntoBody"]] call ace_interact_menu_fnc_removeActionFromObject;},{CAM_ON},{},[_cam]] call ace_interact_menu_fnc_createAction;
	// 			[player, 1, ["ACE_SelfActions"], _action] call ace_interact_menu_fnc_addActionToObject;
				
	// 		} else {
	// 			systemChat "NOT SMOKE GONE";
	// 		};

			
	// 	};
	// }];


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


//Always initialize this, but only 
call compile preprocessFileLineNumbers "Scripts\Attrition\onStart.sqf";


//General BCG Zeus ACE interact handlers
["General", "General", {}, {true}] call addActionGameMasterAce;
["SafetyOn", "Safety On", {[true] remoteExec ["safety", 0]; publicVariable "SAFETY_ON_SERVER";}, {true}, "General"] call addSubActionGameMasterAce;
["SafetyOff", "Safety Off", {[false] remoteExec ["safety", 0]; publicVariable "SAFETY_ON_SERVER";}, {true}, "General"] call addSubActionGameMasterAce;


_handle = [] spawn {
    call aiUpdater;
};
