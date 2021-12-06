["StartWaves", "Start Waves", {execVM "Scripts\Attrition\aihandler.sqf";}, {true}] call addActionGameMasterAce;
["PauseWaves", "Pause Waves", {SHOULD_KEEP_SPAWNING = false;}, {SHOULD_KEEP_SPAWNING}] call addActionGameMasterAce;
["ResumeWaves", "Resume Waves", {SHOULD_KEEP_SPAWNING = true;}, {not SHOULD_KEEP_SPAWNING}] call addActionGameMasterAce;

SHOULD_KEEP_SPAWNING = true;
MAXIMUM_SPAWNED_GROUPS = 100;
MAXIMUM_ACTIVE_GROUPS = 20;