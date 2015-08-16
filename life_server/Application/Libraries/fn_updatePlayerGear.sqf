#include "\life_server\script_macros.hpp"
/*
    File: fn_saveGear.sqf
    Edited: Itsyuka

    Description:
    Saves the _units gear for syncing to the database for persistence..
*/
private["_unit","_uid","_side","_return","_pWeapon","_hWeapon","_uItems","_bItems","_vItems","_pItems","_hItems","_yItems","_uMags","_vMags","_bMags","_pMag","_hMag","_uni","_ves","_bag","_handled"];
_unit = param [0,objNull,[objNull]];
_uid = param [1,"",[""]];
_side = param [2,sideUnknown,[civilian]];
_bool = param [3,false,[false]];

_return = [];

uiSleep 1; /* Why is this needed? Blah */

_return pushBack uniform _unit;
_return pushBack vest _unit;
_return pushBack backpack _unit;
_return pushBack goggles _unit;
_return pushBack headgear _unit;
_return pushBack assignedITems _unit;

_pWeapon = [];
_hWeapon = [];
_uItems = [];
_uMags  = [];
_bItems = [];
_bMags  = [];
_vItems = [];
_vMags  = [];
_pItems = [];
_hItems = [];
_yItems = [];
_uni = [];
_ves = [];
_bag = [];

if(!(EQUAL(uniform _unit,""))) then {
    _uMagList = getMagazineCargo uniformContainer _unit;
    {
        _AmntList = _uMagList select 1;
        _tmp = [];
        _tmp pushback _x;
        _tmp pushback (_AmntList select _forEachIndex);
        _uMags pushback _tmp;
    }forEach (_uMagList select 0);
    _uItemList = getItemCargo uniformContainer _unit;
    {
        _AmntList = _uItemList select 1;
        _tmp = [];
        _tmp pushback _x;
        _tmp pushback (_AmntList select _forEachIndex);
        _uItem pushback _tmp;
    }forEach (_uItemList select 0);
};

if(!(EQUAL(backpack _unit,""))) then {
    _bMagList = getMagazineCargo backpackContainer _unit;
    {
        _AmntList = _bMagList select 1;
        _tmp = [];
        _tmp pushback _x;
        _tmp pushback (_AmntList select _forEachIndex);
        _bMags pushback _tmp;
    }forEach (_bMagList select 0);
    _bItemList = getItemCargo backpackContainer _unit;
    {
        _AmntList = _bItemList select 1;
        _tmp = [];
        _tmp pushback _x;
        _tmp pushback (_AmntList select _forEachIndex);
        _bItems pushback _tmp;
    }forEach (_bItemList select 0);
};

if(!(EQUAL(vest _unit,""))) then {
    _vMagList = getMagazineCargo vestContainer _unit;
    {
        _AmntList = _vMagList select 1;
        _tmp = [];
        _tmp pushback _x;
        _tmp pushback (_AmntList select _forEachIndex);
        _vMags pushback _tmp;
    }forEach (_vMagList select 0);
    _vItemList = getItemCargo vestContainer _unit;
    {
        _AmntList = _vItemList select 1;
        _tmp = [];
        _tmp pushback _x;
        _tmp pushback (_AmntList select _forEachIndex);
        _vItems pushback _tmp;
    }forEach (_vItemList select 0);
};

if(!((primaryWeapon _unit) isEqualTo "")) then {
	_pWeapon pushBack primaryWeapon _unit;
	_pWeapon pushBack primaryWeaponItems _unit;
	if(count(primaryWeaponMagazine _unit) > 0) then {
		_pWeapon pushBack ((primaryWeaponMagazine _unit) select 0);
	} else {
		_pWeapon pushBack "";
	};
};

if(!((handgunWeapon _unit) isEqualTo "")) then {
	_hWeapon pushBack handgunWeapon _unit;
	_hWeapon pushBack handgunItems _unit;
	if(count(handgunMagazine _unit) > 0) then {
		_hWeapon pushBack ((handgunMagazine _unit) select 0);
	} else {
     	_pWeapon pushBack "";
    };
};

_return pushBack _pWeapon;
_return pushBack _hWeapon;
_return pushBack _uItems;
_return pushBack _uMags;
_return pushBack _bItems;
_return pushBack _bMags;
_return pushBack _vItems;
_return pushBack _vMags;

[_uid,_side,3,_return,_bool] spawn APP_fnc_playerSessionUpdate;