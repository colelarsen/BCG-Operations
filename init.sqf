call compileFinal  preprocessFileLineNumbers "Scripts\BCG-Common\BCG-Utility.sqf";

//Only set to true when you are developing features in singleplayer
IS_DEVELOPING = true;


SHOULD_KEEP_SPAWNING = true;

if (isDedicated || IS_DEVELOPING) then {
	hint "Ran on isDedicated";

	["StartWaves", "Start Waves", {execVM "Scripts\Attrition\aihandler.sqf";}, {true}] call addActionGameMasterAce;
	["StopWaves", "Stop Waves", {SHOULD_KEEP_SPAWNING = false;}, {SHOULD_KEEP_SPAWNING}] call addActionGameMasterAce;
	["ResumeWaves", "Resume Waves", {SHOULD_KEEP_SPAWNING = true;}, {not SHOULD_KEEP_SPAWNING}] call addActionGameMasterAce;
	
};

