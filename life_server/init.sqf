#define SYSPATH(FILE) format["\life_server\System\%1",##FILE##]
/*
	Author: Bryan "Tonic" Boardwine

	Description:
	Initialize the server and required systems.
*/
"BIS_fnc_MP_packet" addPublicVariableEventHandler {_this call life_fnc_MPexec};
SYS_Async_Active = false;
SYS_Async_ExtraLock = false;
life_server_isReady = false;
serverKey = round(random(9999));


/* Event Handlers */
addMissionEventHandler ["HandleDisconnect",{_this call TON_fnc_clientDisconnect; false;}];
addMissionEventHandler ["HandleDisconnect",{[_this,serverKey] call APP_fnc_playerSessionEnd; false;}];
[] call compile PreProcessFileLineNumbers "\life_server\functions.sqf";
[] call compile PreProcessFileLineNumbers "\life_server\eventhandlers.sqf";

[8,true,12] execFSM SYSPATH("FSM\timeModule.fsm");
[] execFSM SYSPATH("FSM\cleanup.fsm");