#include <macro.h>
#define exitScope(BOOL) _exitScope = BOOL
/*
	Author: Karel Moricky

	Description:
	Execute received remote execution

	Parameter(s):
	_this select 0: STRING - Packet variable name (always "BIS_fnc_MP_packet")
	_this select 1: ARRAY - Packet value (sent by BIS_fnc_MP function; see it's description for more details)

	Returns:
	BOOL - true if function was executed successfuly
*/
private ["_params","_functionName","_target","_isPersistent","_isCall","_varName","_varValue","_function","_callerName","_callerUID","_exitScope"];
exitScope(false);
_varName = _this select 0;
_varValue = _this select 1;

_mode = 	[_varValue,0,[0]] call bis_fnc_param;
_params = 	[_varValue,1,[]] call bis_fnc_param;
_functionName =	[_varValue,2,"",[""]] call bis_fnc_param;
_target =	[_varValue,3,true,[objNull,true,0,[],sideUnknown,grpNull,""]] call bis_fnc_param;
_isPersistent =	[_varValue,4,false,[false]] call bis_fnc_param;
_isCall =	[_varValue,5,false,[false]] call bis_fnc_param;
_callerName = [_varValue,6,"",[""]] call bis_fnc_param;
_callerUID = [_varValue,7,"",[""]] call bis_fnc_param;

if(!(["APP_fnc_",_functionName] call BIS_fnc_inString) && {(toLower(_functionName) in ["app_fnc_insertrequest","app_fnc_queryrequest","app_fnc_playersessionend","app_fnc_playercreatesession","app_fnc_playergetsession","app_fnc_playergetsession","app_fnc_invhandler"])} && {!(toLower(_functionName) in ["bis_fnc_execvm","bis_fnc_effectkilledairdestruction","bis_fnc_effectkilledairdestructionstage2","life_fnc_stripDownPlayer"])}) exitWith {false};

if(_functionName == "bis_fnc_execvm") then {
	_param2 = _params select 1;
	if(isNil "_param2") exitWith {exitScope(true);};
	if(_param2 != "initPlayerServer.sqf") exitWith {exitScope(true);};
};

if(_callerName == "" OR _callerUID == "") exitWith {}; //NO.
if(toLower(_functionName) == "bis_fnc_endmission") exitWith {false};
if(_exitScope) exitWith {false};

if (isMultiplayer && _mode == 0) then {
	if(isServer) then {
		if (typeName _target == typeName []) then {
			//--- Multi execution
			{
				[_varName,[_mode,_params,_functionName,_x,_isPersistent,_isCall,_callerName,_callerUID]] call SYS_fnc_MPexec;
			} forEach _target;
		} else {
			//--- Single execution
			private ["_ownerID","_serverID"];
			_serverID = owner (missionNamespace getVariable ["bis_functions_mainscope",objNull]);
			switch (typeName _target) do {
				case (typeName ""): {
					_ownerID = owner (missionNamespace getVariable [_target,objNull]);
				};
				case (typeName objNull): {
					private ["_targetCuratorUnit"];
					_targetCuratorUnit = getAssignedCuratorUnit _target;
					if !(isNull _targetCuratorUnit) then {
						_target = _targetCuratorUnit;
					};
					_ownerID = owner _target;
				};
				case (typeName true): {_ownerID = [_serverID,-1] select _target;};
				case (typeName 0): {_ownerID = _target;};
				case (typeName grpNull);
				case (typeName sideUnknown): {_ownerID = -1;};
			};
			SYS_fnc_MP_packet = [1,_params,_functionName,_target,_isPersistent,_isCall,"__SERVER__","__SERVER__"];
			//--- Send to clients
			if (_ownerID < 0) then {
				//--- Everyone
				publicVariable "SYS_fnc_MP_packet";
			} else {
				if (_ownerID != _serverID) then {
					//--- Client
					_ownerID publicVariableClient "SYS_fnc_MP_packet";
				};
			};
			//--- Server execution(for all or server only)
			if (_ownerID == -1 || _ownerID == _serverID) then {
				["SYS_fnc_MP_packet",SYS_fnc_MP_packet] spawn SYS_fnc_MPexec;
			};
			//--- Persistent call (for all or clients)
			if (_isPersistent) then {
				if (typeName _target != typeName 0) then {
					private ["_logic","_queue"];
					_logic = missionNamespace getVariable ["bis_functions_mainscope",objNull];
					_queue = _logic getVariable ["SYS_fnc_MP_queue",[]];
					_queue set [ count _queue, +SYS_fnc_MP_packet ];
					_logic setVariable ["SYS_fnc_MP_queue",_queue,true];
				} else {
					["Persistent execution is not allowed when target is %1. Use %2 or %3 instead.",typeName 0,typeName objNull,typeName false] call bis_fnc_error;
				};
			};
		};
	};
} else {
	//--- Local execution
    private ["_canExecute"];
    _canExecute = switch (typename _target) do {
    	case (typename grpnull): {player in units _target};
    	case (typename sideUnknown): {(player call bis_fnc_objectside) == _target};
    	default {true};
    };

    if (_canExecute) then {
    	_function = missionnamespace getvariable _functionName;
    	if (!isnil "_function") then {
    		//--- Function
    		if (_isCall) then {
    			_params call _function;
    		} else {
    			_params spawn _function;
    		};
    		true
    	} else {
    		_supportInfo = supportInfo format ["*:%1*",_functionName];
    		if (count _supportInfo > 0) then {
    			//--- Scripting command
    			_cfgRemoteExecCommands = [["CfgRemoteExecCommands"],configfile] call bis_fnc_loadClass;
    			if (isclass (_cfgRemoteExecCommands >> _functionName)) then {
    				_paramCount = if (typename _params == typename []) then {count _params} else {1};
    				switch (_paramCount) do {
    					case 0: {_params call compile format ["%1",_functionName]; true};
    					case 1: {_params call compile format ["%1 (_this)",_functionName]; true};
    					case 2: {_params call compile format ["(_this select 0) %1 (_this select 1)",_functionName]; true};
    					default {
    						//--- Error
    						["Error when remotely executing '%1' - wrong number of arguments (%2) passed, must be 0, 1 or 2",_functionName,count _params] call bis_fnc_error;
    						false
    					};
    				};
    			} else {
    				//--- Banned commands
    				["Scripting command '%1' is not allowed to be remotely executed",_functionName] call bis_fnc_error;
    				false
    			};
    		} else {
    			//--- Error
    			["Function or scripting command '%1' does not exist",_functionName] call bis_fnc_error;
    			false
    		};
    	};
    };
};