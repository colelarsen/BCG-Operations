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




	
};

if(PARADROP_TOOL_ENABLED) then 
{
	//!isTouchingGround player && leader player == player(? check that the player is the leader)
	["Paradrop Group", "Paradrop Squad", {

		
		[player] spawn performParadrop;


	}, {!isTouchingGround player && //Player is off of the ground
	leader player == player && //Player is the leader of the group
	((vehicle player) isKindOf "plane" || (vehicle player) isKindOf "helicopter") //Player is in plane or helicopter
	
	}] call addActionSelfInteract;



	["Parachute Eject", "Parachute Eject", {
		[player] spawn paradropTroop;
	}, {!isTouchingGround player && //Player is off of the ground
	((vehicle player) isKindOf "plane" || (vehicle player) isKindOf "helicopter") //Player is in plane or helicopter
	}] call addActionSelfInteract;
		
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
