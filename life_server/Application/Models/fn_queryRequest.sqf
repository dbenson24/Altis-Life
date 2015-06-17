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
_uid = [_this,0,"",[""]] call BIS_fnc_param;
_side = [_this,1,sideUnknown,[civilian]] call BIS_fnc_param;
_name = [_this,2,"",[""]] call BIS_fnc_param;
_key = [_this,3,0,[0]] call BIS_fnc_param;
_noPlayer = false;

if(!(EQUAL(_key,serverKey))) exitWith {}; //Doesn't match, probably a bad request

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

if((typeName _queryResult == "STRING") || (count _queryResult == 0)) then {
	[_uid,_side,_name,serverKey] call APP_fnc_insertRequest;
};

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
		_houseData = _uid spawn TON_fnc_fetchPlayerHouses;
		waitUntil {scriptDone _houseData};
		_queryResult pushBack (missionNamespace getVariable[format["houses_%1",_uid],[]]);
		_gangData = _uid spawn TON_fnc_queryPlayerGang;
		waitUntil{scriptDone _gangData};
		_queryResult pushBack (missionNamespace getVariable[format["gang_%1",_uid],[]]);
	};
};

_keyArr = missionNamespace getVariable [format["%1_KEYS_%2",_uid,_side],[]];
_queryResult set[12,_keyArr];
_queryResult;