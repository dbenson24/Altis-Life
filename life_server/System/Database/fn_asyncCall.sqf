#include "\life_server\script_macros.hpp"
/*
	File: fn_asyncCall.sqf
	Author: Bryan "Tonic" Boardwine
	Description:
	Commits an asynchronous call to ExtDB
	Parameters:
		0: STRING (Query to be ran).
		1: INTEGER (1 = ASYNC + not return for update/insert, 2 = ASYNC + return for query's).
		3: BOOL (True to return a single array, false to return multiple entries mainly for garage).
*/
waitUntil {!SYS_Async_Active};
private["_queryStmt","_queryResult","_key","_mode","_return","_loop"];

_tickTime = diag_tickTime;

_queryStmt = param [0,"",[""]];
_mode = param [1,1,[0]];

_key = EXTDB_TAG callExtension format["%1:%2:%3",_mode,(call SYS_sql_id),_queryStmt];

if(_mode isEqualTo 1) exitWith {SYS_Async_Active = false; true};

_key = call compile format["%1",_key];
_key = _key select 1;

SYS_Async_Active = true;
// Get Result via 4:x (single message return)  v19 and later
_queryResult = "";
_loop = true;

waitUntil{uisleep (random .03); !SYS_Async_ExtraLock};
SYS_Async_ExtraLock = true;

while{_loop} do
{
	_queryResult = EXTDB_TAG callExtension format["4:%1", _key];
	if (_queryResult isEqualTo "[5]") then {
		// extDB2 returned that result is Multi-Part Message
		_queryResult = "";
		while{true} do {
			_pipe = EXTDB_TAG callExtension format["5:%1", _key];
			if(_pipe isEqualTo "") exitWith {_loop = false};
			_queryResult = _queryResult + _pipe;
		};
	}
	else
	{
		if (_queryResult isEqualTo "[3]") then
		{
			diag_log format ["extDB2: uisleep [4]: %1", diag_tickTime];
			uisleep 0.1;
		} else {
			_loop = false;
		};
	};
};

SYS_Async_ExtraLock = false;
SYS_Async_Active = false;

_queryResult = call compile _queryResult;

// Not needed, its SQF Code incase extDB2 ever returns error message i.e Database Connection Died
if ((_queryResult select 0) isEqualTo 0) exitWith {diag_log format ["extDB2: Protocol Error: %1", _queryResult]; []};
_return = ((_queryResult select 1) select 0);
if(!(_return isEqualTo [])) then {
	_return;
};