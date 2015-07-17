#include "\life_server\script_macros.hpp"
/*
	File: fn_queryRequest.sqf
	Author: Bryan "Tonic" Boardwine
	
	Description:
	Handles the incoming request and sends an asynchronous query 
	request to the database.
	
	Return:
	ARRAY - If array has 0 elements it should be handled as an error in client-side files.
	STRING - The request had invalid handles or an unknown error and is logged to the RPT.
*/
private["_uid","_side","_query","_queryResult","_qResult","_handler","_thread","_tickTime","_loops","_returnCount"];
_uid = param [0,"",[""]];
_side = param [1,sideUnknown,[civilian]];
_name = param [2,"",[""]];

_handle = [_uid,_side,_name] spawn APP_fnc_insertRequest;
waitUntil{scriptDone _handle;};

_query = switch(_side) do {
	case west: {format["playerWestFetch:%1",_uid];};
	case civilian: {format["playerCivilianFetch:%1",_uid];};
	case independent: {format["playerIndependentFetch:%1",_uid];};
};

waitUntil{sleep (random 0.3); !SYS_Async_Active};
_tickTime = diag_tickTime;
_queryResult = [_query,2] call SYS_fnc_asyncCall;

diag_log "------------- Client Query Request -------------";
diag_log format["QUERY: %1",_query];
diag_log format["Time to complete: %1 (in seconds)",(diag_tickTime - _tickTime)];
diag_log format["Result: %1",_queryResult];
diag_log "------------------------------------------------";

if(typeName _queryResult == "STRING") exitWith {};
if(count _queryResult == 0) exitWith {};

//Blah conversion thing from a2net->extdb
private["_tmp"];
_tmp = _queryResult select 2;
_queryResult set[2,[_tmp] call SYS_fnc_numberSafe];
_tmp = _queryResult select 3;
_queryResult set[3,[_tmp] call SYS_fnc_numberSafe];

//Parse licenses (Always index 5)
_new = [(_queryResult select 5)] call SYS_fnc_mresToArray;
if(typeName _new == "STRING") then {_new = call compile format["%1", _new];};
_queryResult set[5,_new];

//Convert tinyint to boolean
_old = _queryResult select 5;
for "_i" from 0 to (count _old)-1 do
{
	_data = _old select _i;
	_old set[_i,[_data select 0, ([_data select 1,1] call SYS_fnc_bool)]];
};

_queryResult set[5,_old];

_new = [(_queryResult select 7)] call SYS_fnc_mresToArray;
if(typeName _new == "STRING") then {_new = call compile format["%1", _new];};
_queryResult set[7,_new];
//Parse data for specific side.
switch (_side) do {
	case west: {
		_queryResult set[8,([_queryResult select 8,1] call SYS_fnc_bool)];
	};

	case civilian: {
		_queryResult set[6,([_queryResult select 6,1] call SYS_fnc_bool)];
	};
};

_keyArr = missionNamespace getVariable [format["%1_KEYS_%2",_uid,_side],[]];
_queryResult set[12,_keyArr];
_queryResult;