/**
 * Author - Cole Larsen
 * Helper functions for various BCG scripts
 * 
 *
 * Core mechanics of Attrition
*/


//Get number of groups on a side that BCG spawned
getSideGroupNums = {

    private _Spawnside = _this select 0;

    count (allGroups select {side _x == _Spawnside && (_x getVariable ["spawned",true])});
};

//Add actions to Zeus ACE interact
addActionGameMasterAce = {

    _name = _this select 0;
    _description = _this select 1;
    _statement = _this select 2;
    _condition = _this select 3;

    _action = [_name,_description,"",_statement,_condition] call ace_interact_menu_fnc_createAction;
    [["ACE_ZeusActions"], _action] call ace_interact_menu_fnc_addActionToZeus;
};

//Add actions to Zeus ACE interact in a sub directory
addSubActionGameMasterAce = {

    _name = _this select 0;
    _description = _this select 1;
    _statement = _this select 2;
    _condition = _this select 3;
    _path = _this select 4;

    _action = [_name,_description,"",_statement,_condition] call ace_interact_menu_fnc_createAction;
    [["ACE_ZeusActions", _path], _action] call ace_interact_menu_fnc_addActionToZeus;
};