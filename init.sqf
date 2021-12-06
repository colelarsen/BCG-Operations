call compileFinal  preprocessFileLineNumbers "Scripts\BCG-Common\BCG-Utility.sqf";

//Only set to true when you are developing features in singleplayer
IS_DEVELOPING = true;




if (isDedicated || IS_DEVELOPING) then {

	call compileFinal preprocessFileLineNumbers "Scripts\Attrition\onStart.sqf";
};

