#include "\life_server\script_macros.hpp"
/*
	File: fn_insertRequest.sqf
	Author: Bryan "Tonic" Boardwine
	
	Description:
	Does something with inserting... Don't have time for
	descriptions... Need to write it...
*/
private["_uid","_name","_side","_money","_bank","_licenses","_handler","_thread","_queryResult","_query","_alias"];
_uid = [_this,0,"",[""]] call BIS_fnc_param;
_side = [_this,1,sideUnknown,[civilian]] call BIS_fnc_param;
_name = [_this,2,"",[""]] call BIS_fnc_param;
_money = LIFE_SETTINGS(getNumber,"starting_cash");
_bank = LIFE_SETTINGS(getNumber,"starting_atmcash");
_queryResult = "";

//Error checks
if((_uid == "") OR (_name == "")) exitWith {diag_log "Bad UID or name";}; //Let the client be 'lost' in 'transaction'

_query = format["playerInfo:%1",_uid];

waitUntil{sleep (random 0.3); !SYS_Async_Active};
_tickTime = diag_tickTime;
_queryResult = [_query,2] call SYS_fnc_asyncCall;

diag_log "------------- Insert Query Request -------------";
diag_log format["QUERY: %1",_query];
diag_log format["Time to complete: %1 (in seconds)",(diag_tickTime - _tickTime)];
diag_log format["Result: %1",_queryResult];
diag_log "------------------------------------------------";

//Double check to make sure the client isn't in the database...
if(EQUAL(_queryResult,true)) exitWith {false}; //There was an entry!

//Clense and prepare some information.
_name = [_name] call SYS_fnc_mresString; //Clense the name of bad chars.
_alias = [[_name]] call SYS_fnc_mresArray;

//Prepare the query statement..
_query = format["playerInsert:%1:%2:%3:%4:%5",_uid,_name,_money,_bank,_alias];

waitUntil {!SYS_Async_Active};
[_query,1] call SYS_fnc_asyncCall;