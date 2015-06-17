#define SYSPATH(FILE) format["\life_server\System\%1",##FILE##]
/*
	Author: Bryan "Tonic" Boardwine

	Description:
	Initialize the server and required systems.
*/
"BIS_fnc_MP_packet" addPublicVariableEventHandler {_this call SYS_fnc_MPexec};
SYS_Async_Active = false;
SYS_Async_ExtraLock = false;
life_server_isReady = false;

[] call compile preprocessFileLineNumbers "\life_server\System\Core\eventhandlers.sqf";
[] call compile preprocessFileLineNumbers "\life_server\functions.sqf";

[8,true,12] execFSM SYSPATH("FSM\timeModule.fsm");
[] execFSM SYSPATH("FSM\cleanup.fsm");