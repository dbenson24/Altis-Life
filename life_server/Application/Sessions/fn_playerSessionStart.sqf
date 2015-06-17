#include "\life_server\script_macros.hpp"
/*
    Author: Dillon "Itsyuka" Modine-Thuen
    File: fn_playerSessionStart.sqf

    Description: Starts the session and saves the data to the memory (missionNamespace)
*/
private["_uid","_side","_ownerID","_existingProfile","_queryRequest","_name"];
_uid = [_this,0,"",[""]] call BIS_fnc_param;
_name = [_this,3,"",[""]] call BIS_fnc_param;

_side = [_this,1,sideUnknown,[civilian]] call BIS_fnc_param;
_ownerID = [_this,2,ObjNull,[ObjNull]] call BIS_fnc_param;

if(isNull _uid) exitWith {};
if(isNull _ownerID) exitWith {};
if(isNull _name) exitWith {};
_ownerID = owner _ownerID;

_existingProfile = GVAR_MNS [format["%1_%2",_uid,_side], ""];
if(!(_existingProfile == "")) exitWith {
    [_existingProfile,"SOCK_fnc_requestReceived",_ownerID,false] call life_fnc_MP;
};

_queryRequest = [_uid,_side,_name,serverKey] call APP_fnc_queryRequest;
_session = [_uid,_side,_queryRequest] call APP_fnc_playerCreateSession;
SVAR_MNS [format["%1_%2",_uid,_side], _session];

[_queryRequest,"SOCK_fnc_requestReceived",_ownerID,false] call life_fnc_MP;