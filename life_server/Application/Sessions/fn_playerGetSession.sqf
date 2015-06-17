#include "\life_server\script_macros.hpp"
/*
    File: fn_playerGetSession.sqf
    Author: Dillon "Itsyuka" Modine-Thuen
    Created: Jun 17, 2015
    
    Description:
    Gets information from session data
*/
private["_uid","_side","_selection","_data","_return"];
_uid = [_this,0,"",[""]] call BIS_fnc_param;
_side = [_this,1,sideUnknown,[civilian]] call BIS_fnc_param;
_selection = [_this,2,0,[0]] call BIS_fnc_param;

_data = GVAR_MNS [format["%1_%2",_uid,_side], ""];
if(EQUAL(_data,"")) exitWith {false}; //No session created

_return = (SEL(_data,_selection));
_return;