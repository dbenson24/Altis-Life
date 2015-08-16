#include <macro.h>
/*
	Author: Karel Moricky

	Description:
	Send function or scripting command for remote execution (and executes locally if conditions are met)

	Parameter(s):
		0: ANY - function params
		1: STRING - function or scripting command name
		2 (Optional):
			BOOL - true to execute on each machine (including the one where the function was called from), false to execute it on server only [default: true]
			STRING - the function will be executed only where unit defined by the variable is local
			OBJECT - the function will be executed only where unit is local
			GROUP - the function will be executed only on client who is member of the group
			SIDE - the function will be executed on all players of the given side
			NUMBER - the function will be executed only on client with the given ID
			ARRAY - array of previous data types
		3 (Optional): BOOL - true for persistent call (will be called now and for every JIP client) [default: false]

	Returns:
	ARRAY - sent packet
*/

with missionNamespace do {
	private ["_params","_functionName","_target","_isPersistent","_isCall","_ownerID"];
	_params = 	param [0,[[]]];
    _functionName =	param [1,"",[""]];
    _target =	param [2,true,[objnull,true,0,[],sideUnknown,grpnull,""]];
    _isPersistent =	param [3,false,[false]];
    _isCall =	param [4,false,[false]];

	//--- Send to server
	if(isServer && isDedicated) then {
    	SYS_fnc_MP_packet = [0,_params,_functionName,_target,_isPersistent,_isCall,"__SERVER__","__SERVER__",(FETCH_CONST(serverKey))];
    } else {
    	SYS_fnc_MP_packet = [0,_params,_functionName,_target,_isPersistent,_isCall,profileName,getPlayerUID player];
    };
	publicVariableServer "SYS_fnc_MP_packet";

	//--- Local execution
	if !(isMultiplayer) then {
		["SYS_fnc_MP_packet",SYS_fnc_MP_packet] spawn SYS_fnc_MPexec;
	};

	SYS_fnc_MPexec
};