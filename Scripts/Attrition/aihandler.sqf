/**
 * Author - Cole Larsen
 * Used with Attrition
 * Called when Zeus uses "Start Waves"
 *
 * Default code is for spawning infantry and cars and armor but using this format you can spawn anything anywhere
*/

execVM "Scripts\Attrition\infantry.sqf";

//Time until cars start spawning
// sleep 300;
sleep 60;
execVM "Scripts\Attrition\car.sqf";


execVM "Scripts\Attrition\helicopter-dropoff.sqf";


//Time until armor starts spawning
// sleep 600;

sleep 60;
execVM "Scripts\Attrition\armor.sqf";

sleep 120;
execVM "Scripts\Attrition\helicopter.sqf";