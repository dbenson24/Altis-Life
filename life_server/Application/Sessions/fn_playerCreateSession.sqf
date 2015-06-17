#include "\life_server\script_macros.hpp"
/*
    File: fn_playerCreateSession.sqf
    Author: Dillon "Itsyuka" Modine-Thuen
    Created: Jun 17, 2015
    
    Description:
    N/A
*/
private[""];
_uid = [_this,0,"",[""]] call BIS_fnc_param;
_side = [_this,1,sideUnknown,[civilian]] call BIS_fnc_param;
_query = [_this,2,[],[[]]] call BIS_fnc_param;

/* Take the query and setup the session */
