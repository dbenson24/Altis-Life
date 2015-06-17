#include "\life_server\script_macros.hpp"
/*
	 Author: Dillon "Itsyuka" Modine-Thuen
	 File: fn_playerSessionUpdate.sqf
	 Description: Updates the player's data on the memory
*/
private["_uid","_playerArray"];
_uid = [_this,0,"",[""]] call BIS_fnc_param;
_side = [_this,1,sideUnknown,[civilian]] call BIS_fnc_param;
_mode = [_this,2,0,[0]] call BIS_fnc_param;

if(isNull _uid) exitWith {};

_data = GVAR_MNS [format["%1_%2",_uid,_side],""];
if(EQUAL(_data,"")) exitWith {}; //Wait, how did he get in without a session?

switch(_mode)do {
	case 0: { //Cash
		_value = [_this,3,0,[0]] call BIS_fnc_param;
		_value = [_value] call SYS_fnc_numberSafe;
		_data set[2,_value];
		[_uid,_side,0,_value] call APP_fnc_updatePartial;
	};
	case 1: { //Bank
		_value = [_this,3,0,[0]] call BIS_fnc_param;
		_value = [_value] call SYS_fnc_numberSafe;
		_data set[3,_value];
		[_uid,_side,0,_value] call APP_fnc_updatePartial;
	};
	case 2: { //Licenses
		_value = [_this,3,[],[[]]] call BIS_fnc_param;
		_data set[5,_value];
		[_uid,_side,0,_value] call APP_fnc_updatePartial;
	};
	case 3: { //Gear
		_value = [_this,3,[],[[]]] call BIS_fnc_param;
		_data set[7,_value];
		[_uid,_side,0,_value] call APP_fnc_updatePartial;
	};
	case 4: { //Arrested
		if(EQUAL(_side,civilian)) then {
			_value = [_this,3,0,[0]] call BIS_fnc_param;
			_value = [_value] call SYS_fnc_numberSafe;
			_data set[6,_value];
			[_uid,_side,0,_value] call APP_fnc_updatePartial;
		};
	};
	case 5: { //Cash and Bank
		_value1 = [_this,3,0,[0]] call BIS_fnc_param;
		_value2 = [_this,4,0,[0]] call BIS_fnc_param;
		_value1 = [_value1] call SYS_fnc_numberSafe;
		_value2 = [_value2] call SYS_fnc_numberSafe;
		_data set[2,_value1];
		_data set[3,_value2];
		[_uid,_side,0,_value1,_value2] call APP_fnc_updatePartial;
	};
	case 6: {};
	case 7: {};
};


SVAR_MNS [format["%1_%2",_uid,_side],_data];