#include "\life_server\script_macros.hpp"
/*
    File: eventHandlers.sqf
    Author: Dillon "Itsyuka" Modine-Thuen
    Created: Jun 17, 2015
    
    Description:
    Handles the events
*/
"SYS_fnc_MP_packet" addPublicVariableEventHandler {[_this select 0,_this select 1] call SYS_fnc_MPexec;};
addMissionEventHandler ["HandleDisconnect",{_this call SYS_fnc_clientDisconnect; false;}];
addMissionEventHandler ["HandleDisconnect",{[_this,serverKey] call APP_fnc_playerS  essionEnd; false;}];