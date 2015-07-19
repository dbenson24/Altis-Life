#include "\life_server\script_macros.hpp"
/*
	 Author: Dillon "Itsyuka" Modine-Thuen
	 File: fn_playerSessionUpdate.sqf
	 Description: Updates the player's data on the memory
*/
private["_uid","_playerArray"];
_uid = param [0,"",[""]];
_side = param [1,sideUnknown,[civilian]];
_mode = param [2,0,[0]];

if(_uid isEqualTo "") exitWith {};

_data = GVAR_MNS [format["%1_%2",_uid,_side],""];
if(EQUAL(_data,"")) exitWith {}; /* Wait, how did he get in without a session? */

switch(_mode)do {
	case 0: { /* Cash */
		_value = param [3,0,[0]];
		_value = [_value] call SYS_fnc_numberSafe;
		_data set[2,_value];
		[_uid,_side,0,_value] spawn APP_fnc_updatePartial;
	};
	case 1: { /* Bank */
		_value = param [3,0,[0]];
		_value = [_value] call SYS_fnc_numberSafe;
		_data set[3,_value];
		[_uid,_side,1,_value] spawn APP_fnc_updatePartial;
	};
	case 2: { /* Licenses */
		_value = param [3,[],[[]]];
		_data set[5,_value];
		[_uid,_side,2,_value] spawn APP_fnc_updatePartial;
	};
	case 3: { /* Gear */
		_value = param [3,[],[[]]];
		_data set[7,_value];
		[_uid,_side,3,_value] spawn APP_fnc_updatePartial;
	};
	case 4: { /* Arrested */
		if(EQUAL(_side,civilian)) then {
			_value = param [3,0,[0]];
			_bool = param [4,false,[false]];
			_value = [_value] call SYS_fnc_numberSafe;
			_data set[6,_value];
			if(_bool) { /* Only save if I say so */
				[_uid,_side,4,_value] spawn APP_fnc_updatePartial;
			};
		};
	};
	case 5: { /* Cash and Bank */
		_value1 = param [3,0,[0]];
		_value2 = param [4,0,[0]];
		_value1 = [_value1] call SYS_fnc_numberSafe;
		_value2 = [_value2] call SYS_fnc_numberSafe;
		_data set[2,_value1];
		_data set[3,_value2];
		[_uid,_side,5,_value1,_value2] spawn APP_fnc_updatePartial;
	};
	case 6: {};
	case 7: {};
};

SVAR_MNS [format["%1_%2",_uid,_side],_data];