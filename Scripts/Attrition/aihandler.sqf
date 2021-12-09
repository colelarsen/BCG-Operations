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
execVM "Scripts\Attrition\car.sqf";

//Time until armor starts spawning
// sleep 600;
// execVM "Scripts\Attrition\armor.sqf";