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
_uid = param [0,"",[""]];
_name = param [1,"",[""]];
_side = param [2,sideUnknown,[civilian]];
_cash = param [3,0,[0]];
_bank = param [4,5000,[0]];
_licenses = param [5,[],[[]]];
_gear = param [6,[],[[]]];
_arrested = param [7,false,[false]];

//Get to those error checks.
if((_uid == "") OR (_name == "")) exitWith {};

//Parse and setup some data.
_name = [_name] call SYS_fnc_mresString;
_gear = [_gear] call SYS_fnc_mresArray;
_cash = [_cash] call SYS_fnc_numberSafe;
_bank = [_bank] call SYS_fnc_numberSafe;

if(EQUAL(_side,civilian)) then {
	_arrested = [_arrested] call SYS_fnc_bool;
};

//Does something license related but I can't remember I only know it's important?
for "_i" from 0 to count(_licenses)-1 do {
	_bool = [(_licenses select _i) select 1] call SYS_fnc_bool;
	_licenses set[_i,[(_licenses select _i) select 0,_bool]];
};

_licenses = [_licenses] call SYS_fnc_mresArray;

switch (_side) do {
	case west: {_query = format["updatePlayerWest:%1:%2:%3:%4:%5:%6",_name,_cash,_bank,_gear,_licenses,_uid];};
	case civilian: {_query = format["updatePlayerCivilian:%1:%2:%3:%4:%5:%6:%7",_name,_cash,_bank,_gear,_licenses,_arrested,_uid];};
	case independent: {_query = format["updatePlayerIndependent:%1:%2:%3:%4:%5:%6",_name,_cash,_bank,_gear,_licenses,_uid];};
};

diag_log "------------- Player Update Query Request -------------";
diag_log format["QUERY: %1",_query];
diag_log "------------------------------------------------";

[_query,1] call SYS_fnc_asyncCall;