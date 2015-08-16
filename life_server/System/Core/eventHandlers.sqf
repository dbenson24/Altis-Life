/*
	File: eventHandlers.sqf
	Author: Dillon "Itsyuka" Modine-Thuen
	Created: Jun 17, 2015

	Description:
	Handles the events
*/
"SYS_fnc_MP_packet" addPublicVariableEventHandler {[_this select 0,_this select 1] call SYS_fnc_MPexec;};
if(isServer) then {
	addMissionEventHandler ["HandleDisconnect",{_this spawn APP_fnc_playerSessionEnd; false;}];
};