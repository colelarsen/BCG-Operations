/**
 * Author - Cole Larsen
 * Used with Attrition
 * Called when server is starting and Attrition is enabled
 *
 * Sets up Zeus handlers and sets some server side global vars
*/

SHOULD_KEEP_SPAWNING = true;
MAXIMUM_SPAWNED_GROUPS = 100;
MAXIMUM_ACTIVE_GROUPS = 20;

["Attrition", "Attrition", {}, {true}] call addActionGameMasterAce;

["StartWaves", "Start Waves", {["Scripts\Attrition\aihandler.sqf"] remoteExec ["execVM", 2];}, {true}, "Attrition"] call addSubActionGameMasterAce;
["PauseWaves", "Pause Waves", {SHOULD_KEEP_SPAWNING = false; publicVariable "SHOULD_KEEP_SPAWNING"}, {SHOULD_KEEP_SPAWNING}, "Attrition"] call addSubActionGameMasterAce;
["ResumeWaves", "Resume Waves", {SHOULD_KEEP_SPAWNING = true; publicVariable "SHOULD_KEEP_SPAWNING"}, {not SHOULD_KEEP_SPAWNING}, "Attrition"] call addSubActionGameMasterAce;



