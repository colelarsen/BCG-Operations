["Attrition", "Attrition", {}, {true}] call addActionGameMasterAce;

["StartWaves", "Start Waves", {execVM "Scripts\Attrition\aihandler.sqf";}, {true}, "Attrition"] call addSubActionGameMasterAce;
["PauseWaves", "Pause Waves", {SHOULD_KEEP_SPAWNING = false;}, {SHOULD_KEEP_SPAWNING}, "Attrition"] call addSubActionGameMasterAce;
["ResumeWaves", "Resume Waves", {SHOULD_KEEP_SPAWNING = true;}, {not SHOULD_KEEP_SPAWNING}, "Attrition"] call addSubActionGameMasterAce;



SHOULD_KEEP_SPAWNING = true;
MAXIMUM_SPAWNED_GROUPS = 100;
MAXIMUM_ACTIVE_GROUPS = 20;