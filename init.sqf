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
	_owner publicVariableClient "PARADROP_TOOL_ENABLED";
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

	if(PARADROP_TOOL_ENABLED) then 
	{
		//!isTouchingGround player && leader player == player(? check that the player is the leader)
		["Paradrop", "Paradrop", {}, {
		((getPos player) select 2) > 50 &&
		((vehicle player) isKindOf "plane" || (vehicle player) isKindOf "helicopter") //Player is in plane or helicopter
		}] call addActionSelfInteract;



		["Paradrop Group", "Paradrop Group", {
			[player] spawn performParadrop;
		}, {
		leader player == player && //Player is the leader of the group
		((getPos player) select 2) > 50 &&
		((vehicle player) isKindOf "plane" || (vehicle player) isKindOf "helicopter") //Player is in plane or helicopter
		
		}, "Paradrop"] call addSubActionSelfInteract;


		["Paradrop Cargo", "Paradrop Cargo", {
			[player] spawn performParadropCargo;
		}, {
		leader player == player && //Player is the leader of the group
		((getPos player) select 2) > 50 &&
		((vehicle player) isKindOf "plane" || (vehicle player) isKindOf "helicopter") //Player is in plane or helicopter
		
		}, "Paradrop"] call addSubActionSelfInteract;



		["Parachute Eject", "Parachute Eject", {
			[player, vehicle player, true] spawn paradropTroop;
		}, {((getPos player) select 2) > 50 &&
			((vehicle player) isKindOf "plane" || (vehicle player) isKindOf "helicopter")}, "Paradrop"] call addSubActionSelfInteract;
			
	};
};




//Always initialize this
call compile preprocessFileLineNumbers "Scripts\Attrition\onStart.sqf";


//General BCG Zeus ACE interact handlers
["General", "General", {}, {true}] call addActionGameMasterAce;
["SafetyOn", "Safety On", {[true] remoteExec ["safety", 0]; publicVariable "SAFETY_ON_SERVER";}, {true}, "General"] call addSubActionGameMasterAce;
["SafetyOff", "Safety Off", {[false] remoteExec ["safety", 0]; publicVariable "SAFETY_ON_SERVER";}, {true}, "General"] call addSubActionGameMasterAce;


_handle = [] spawn {
    call aiUpdater;
};
