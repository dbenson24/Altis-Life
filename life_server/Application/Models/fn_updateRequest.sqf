#include "\life_server\script_macros.hpp"
/*
    File: fn_updateRequest.sqf
    Author: Bryan "Tonic" Boardwine
    Revised: Dillon "Itsyuka" Modine-Thuen
    Created: Jun 17, 2015
    
    Description:
    Updates the player's information to the database.
*/
private["_uid","_side","_cash","_bank","_licenses","_gear","_name","_query","_thread"];
_uid = [_this,0,"",[""]] call BIS_fnc_param;
_name = [_this,1,"",[""]] call BIS_fnc_param;
_side = [_this,2,sideUnknown,[civilian]] call BIS_fnc_param;
_cash = [_this,3,0,[0]] call BIS_fnc_param;
_bank = [_this,4,5000,[0]] call BIS_fnc_param;
_licenses = [_this,5,[],[[]]] call BIS_fnc_param;
_gear = [_this,6,[],[[]]] call BIS_fnc_param;

//Get to those error checks.
if((_uid == "") OR (_name == "")) exitWith {};

//Parse and setup some data.
_name = [_name] call SYS_fnc_mresString;
_gear = [_gear] call SYS_fnc_mresArray;
_cash = [_cash] call SYS_fnc_numberSafe;
_bank = [_bank] call SYS_fnc_numberSafe;

//Does something license related but I can't remember I only know it's important?
for "_i" from 0 to count(_licenses)-1 do {
	_bool = [(_licenses select _i) select 1] call SYS_fnc_bool;
	_licenses set[_i,[(_licenses select _i) select 0,_bool]];
};

_licenses = [_licenses] call SYS_fnc_mresArray;

switch (_side) do {
	case west: {_query = format["updatePlayerWest:%1:%2:%3:%4:%5:%6",_name,_cash,_bank,_gear,_licenses,_uid];};
	case civilian: {_query = format["updatePlayerCivilian:%1:%2:%3:%4:%5:%6:7",_name,_cash,_bank,_gear,_licenses,_uid,[_this select 7] call SYS_fnc_bool];};
	case independent: {_query = format["updatePlayerIndependent:%1:%2:%3:%4:%5:%6",_name,_cash,_bank,_gear,_licenses,_uid];};
};

waitUntil {sleep (random 0.3); !SYS_Async_Active};
_queryResult = [_query,1] call SYS_fnc_asyncCall;