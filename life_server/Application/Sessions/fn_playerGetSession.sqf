#include "\life_server\script_macros.hpp"
/*
	File: fn_playerGetSession.sqf
	Author: Dillon "Itsyuka" Modine-Thuen
	Created: Jun 17, 2015

	Description:
	Gets information from session data
*/
private["_uid","_side","_selection","_data","_return"];
_uid = param [0,"",[""]];
_side = param [1,sideUnknown,[civilian]];
_selection = param [2,0,[0]];

_data = GVAR_MNS [format["%1_%2",_uid,_side], ""];
if(EQUAL(_data,"")) exitWith {false}; //No session created

_return = (SEL(_data,_selection));
_return;