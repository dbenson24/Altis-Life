#include "\life_server\script_macros.hpp"
/*
	File: fn_playerSessionStart.sqf
	Author: Dillon "Itsyuka" Modine-Thuen
	Created: Jun 14, 2015

	Description:
	Starts the session and saves the data to the memory for reading
*/
private["_uid","_side","_ownerID","_existingProfile","_queryRequest","_name"];
_uid = param [0,"",[""]];
_data = param [1,[],[[]]];
_side = param [1,sideUnknown,[civilian]];
_name = param [2,"",[""]];
_owner = param [3,objNull,[objNull]];

if(EQUAL(_uid,"")) exitWith {};
if(isNull _owner) exitWith {};
if(EQUAL(_name,"")) exitWith {};
_ownerID = owner _owner;

_existingProfile = GVAR_MNS [format["%1_%2",_uid,_side], ""];
if(!(EQUAL(_existingProfile,""))) exitWith {
	[_owner,_uid,_side] spawn APP_fnc_getPlayerGear;
	[_existingProfile,"APP_fnc_requestReceived",_ownerID,false] call SYS_fnc_MP;
};

_queryRequest = [_uid,_side,_name] call APP_fnc_queryRequest;
SVAR_MNS [format["%1_%2",_uid,_side], _queryRequest];

[_owner,_uid,_side] spawn APP_fnc_getPlayerGear;
[_queryRequest,"APP_fnc_requestReceived",_ownerID,false] call SYS_fnc_MP;