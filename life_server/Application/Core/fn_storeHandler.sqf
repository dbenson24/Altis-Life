#include "\life_server\script_macros.hpp"
/*
    File: fn_storeHandler.sqf
    Author: Dillon "Itsyuka" Modine-Thuen
    Created: Jun 17, 2015
    
    Description:
    N/A
*/
private[""];
_uid = [_this,0,"",[""]] call BIS_fnc_param;
_side = [_this,1,sideUnknown,[civilian]] call BIS_fnc_param;
_mode = [_this,2,0,[0]] call BIS_fnc_param
_item = [_this,3,"",[""]] call BIS_fnc_param;
_amount = [_this,4,0,[0]] call BIS_fnc_param;

if((EQUAL(_uid,"") || (EQUAL(_item,""))) exitWith {};

switch(_mode) do {
    case 5: { //Sell
        _playerCash = [_uid,_side,1] call SYS_fnc_playerGetSession;
        _itemPrice = M_CONFIG(getNumber,"VirtualItems",_item,"sellPrice");
        if(EQUAL(_itemPrice,-1)) exitWith {};
        _itemPrice = (_itemPrice * _amount);
        if(_playerCash < _itemPrice) exitWith {};
        SUB(_playerCash,_itemPrice);
        _gear = [_uid,_side,3] call SYS_fnc_playerGetSession;
        _gear = [false,_item,_amount] call APP_fnc_invHandler;
        [_uid,_side,0,_playerCash] call APP_fnc_playerSessionUpdate;
        [_uid,_side,3,_gear] call APP_fnc_playerSessionUpdate
    };
    case 10: { //Buy

    };
    default {};
};