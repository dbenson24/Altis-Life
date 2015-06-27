#include "\life_server\script_macros.hpp"
/*
	File: fn_playerSessionStart.sqf
	Author: Dillon "Itsyuka" Modine-Thuen
	Created: Jun 14, 2015

	Description:
	Starts the session and saves the data to the memory for reading
*/
private["_uid","_side","_ownerID","_existingProfile","_queryRequest","_name"];
_uid = [_this,0,"",[""]] call BIS_fnc_param;
_data = [_this,1,[],[[]]] call BIS_fnc_param;
_side = [_this,1,sideUnknown,[civilian]] call BIS_fnc_param;
_name = [_this,2,"",[""]] call BIS_fnc_param;
_owner = [_this,3,ObjNull,[ObjNull]] call BIS_fnc_param;

if(EQUAL(_uid,"")) exitWith {};
if(isNull _owner) exitWith {};
if(EQUAL(_name,"")) exitWith {};
_ownerID = owner _owner;

_existingProfile = GVAR_MNS [format["%1_%2",_uid,_side], ""];
if(!(EQUAL(_existingProfile,""))) exitWith {
	[_existingProfile,"APP_fnc_requestReceived",_ownerID,false] call SYS_fnc_MP;
};

_queryRequest = [_uid,_side,_name] call APP_fnc_queryRequest;
SVAR_MNS [format["%1_%2",_uid,_side], _queryRequest];

diag_log format["Data: %1",_queryRequest];

[_queryRequest,"APP_fnc_requestReceived",_ownerID,false] call SYS_fnc_MP;