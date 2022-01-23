/**
 * Author - Cole Larsen
 * Used with Attrition
 * Called when Zeus uses "Start Waves"
 *
 * Default code is for spawning infantry and cars and armor but using this format you can spawn anything anywhere
*/



/** 
execVM "Scripts\Attrition\infantry.sqf";
// Time until cars start spawning
_handle = [] spawn {
    sleep 300;
    execVM "Scripts\Attrition\car.sqf";
};

// Time until armor starts spawning
_handle = [] spawn {
    sleep 900;
    execVM "Scripts\Attrition\armor.sqf";
};



// Time until heli-cas starts spawning
_handle = [] spawn {
    sleep 800;
    execVM "Scripts\Attrition\helicopter.sqf";
};
*/

//Time until heli-transport starts spawning
_handle = [] spawn {
    sleep 0;
    execVM "Scripts\Attrition\helicopter-dropoff.sqf";
};