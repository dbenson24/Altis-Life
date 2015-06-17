#include "\life_server\script_macros.hpp"
/*
    File: fn_updatePartial.sqf
    Author: Bryan "Tonic" Boardwine
    Revised: Dillon "Itsyuka" Modine-Thuen
    
    Description:
    Takes partial data of a player and updates it, this is meant to be
    less network intensive towards data flowing through it for updates.
*/
private["_uid","_side","_mode","_query"];
_uid = [_this,0,"",[""]] call BIS_fnc_param;
_side = [_this,1,sideUnknown,[civilian]] call BIS_fnc_param;
_mode = [_this,2,0,[0]] call BIS_fnc_param;

_query = "";

switch(_mode)do {
    case 0: { //Cash
        _value = [_this,3,0,[0]] call BIS_fnc_param;
        _query = format["updatePlayerCash:%1:%2",_value,_uid];
    };
    case 1: { //Bank
        _value = [_this,3,0,[0]] call BIS_fnc_param;
        _query = format["updatePlayerBank:%1:%2",_value,_uid];
    };
    case 2: { //Licenses
        _value = [_this,3,[],[[]]] call BIS_fnc_param;
        //Does something license related but I can't remember I only know it's important?
        for "_i" from 0 to count(_value)-1 do {
        	_bool = [(_value select _i) select 1] call DB_fnc_bool;
        	_value set[_i,[(_value select _i) select 0,_bool]];
        };
        _value = [_value] call SYS_fnc_mresArray;
        switch(_side) do {
        	case west: {_query = format["updatePlayerWestLicenses:%1:%2",_value,_uid];};
        	case civilian: {_query = format["updatePlayerCivilianLicenses:%1:%2",_value,_uid];};
        	case independent: {_query = format["updatePlayerIndependentLicenses:%1:%2",_value,_uid];};
        };
    };
    case 3: { //Gear
        _value = [_this,3,[],[[]]] call BIS_fnc_param;
        _value = [_value] call SYS_fnc_mresArray;
        switch(_side) do {
          	case west: {_query = format["updatePlayerWestGear:%1:%2",_value,_uid];};
           	case civilian: {_query = format["updatePlayerCivilianGear:%1:%2",_value,_uid];};
           	case independent: {_query = format["updatePlayerIndependentGear:%1:%2",_value,_uid];};
        };
    };
    case 4: { //Arrested
        if(EQUAL(_side,civilian)) then {
             _value = [_this,3,0,[0]] call BIS_fnc_param;
             _query = format["updatePlayerArrested:%1:%2",_value,_uid];
        };
    };
    case 5: { //Cash and Bank
        _value1 = [_this,3,0,[0]] call BIS_fnc_param;
        _value2 = [_this,4,0,[0]] call BIS_fnc_param;
        _query = format["updatePlayerCashBank:%1:%2:%3",_value1,_value2,_uid];
    };
    case 6: {};
    case 7: {};
};

waitUntil{sleep (random 0.3); !SYS_Async_Active};
_tickTime = diag_tickTime;
_queryResult = [_query,2] call SYS_fnc_asyncCall;