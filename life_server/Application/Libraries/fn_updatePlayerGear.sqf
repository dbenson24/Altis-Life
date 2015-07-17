#include "\life_server\script_macros.hpp"
/*
    File: fn_saveGear.sqf
    Author: Bryan "Tonic" Boardwine
    Full Gear/Y-Menu Save by Vampire
    Edited: Itsyuka

    Description:
    Saves the _units gear for syncing to the database for persistence..
*/
private["_unit","_uid","_side","_return","_uItems","_bItems","_vItems","_pItems","_hItems","_yItems","_uMags","_vMags","_bMags","_pMag","_hMag","_uni","_ves","_bag","_handled"];
_unit = param [0,objNull,[objNull]];
_uid = param [1,"",[""]];
_side = param [2,sideUnknown,[civilian]];

_return = [];

uiSleep 1;

_return pushBack uniform _unit;
_return pushBack vest _unit;
_return pushBack backpack _unit;
_return pushBack goggles _unit;
_return pushBack headgear _unit;
_return pushBack assignedITems _unit;
if(_side == west || _side == civilian && {EQUAL(LIFE_SETTINGS(getNumber,"save_civ_weapons"),1)}) then {
    _return pushBack primaryWeapon _unit;
    _return pushBack handgunWeapon _unit;
} else {
    _return pushBack [];
    _return pushBack [];
};

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
    {
        if (_x in (magazines _unit)) then {
			ADD(_uMags,[_x]);
        } else {
            ADD(_uItems,[_x]);
        };
    } forEach (uniformItems _unit);
};

if(!(EQUAL(backpack _unit,""))) then {
    {
        if (_x in (magazines _unit)) then {
			ADD(_bMags,[_x]);
        } else {
			ADD(_bItems,[_x]);
        };
    } forEach (backpackItems _unit);
};

if(!(EQUAL(vest _unit,""))) then {
    {
        if (_x in (magazines _unit)) then {
			ADD(_vMags,[_x]);
        } else {
			ADD(_vItems,[_x]);
        };
    } forEach (vestItems _unit);
};

if(count (primaryWeaponMagazine _unit) > 0 && alive _unit) then {
    _pMag = SEL((primaryWeaponMagazine _unit),0);

    if(!(EQUAL(_pMag,""))) then {
        _uni = _unit canAddItemToUniform _pMag;
        _ves = _unit canAddItemToVest _pMag;
        _bag = _unit canAddItemToBackpack _pMag;
        _handled = false;

        if(_ves) then {
			ADD(_vMags,[_pMag]);
            _handled = true;
        };

        if(_uni && !_handled) then {
			ADD(_uMags,[_pMag]);
            _handled = true;
        };

        if(_bag && !_handled) then {
			ADD(_bMags,[_pMag]);
            _handled = true;
        };
    };
};

if(count (handgunMagazine _unit) > 0 && alive _unit) then {
    _hMag = ((handgunMagazine _unit) select 0);

    if(!(EQUAL(_hMag,""))) then {
        _uni = _unit canAddItemToUniform _hMag;
        _ves = _unit canAddItemToVest _hMag;
        _bag = _unit canAddItemToBackpack _hMag;
        _handled = false;

        if(_ves) then {
			ADD(_vMags,[_hMag]);
            _handled = true;
        };

        if(_uni && !_handled) then {
			ADD(_uMags,[_hMag]);
            _handled = true;
        };

        if(_bag && !_handled) then {
            ADD(_uMags,[_hMag]);
            _handled = true;
        };
    };
};

if(count (primaryWeaponItems _unit) > 0) then {
    {
		ADD(_pItems,[_x]);
    } forEach (primaryWeaponItems _unit);
};

if(count (handgunItems _unit) > 0) then {
    {
		ADD(_hItems,[_x]);
    } forEach (handGunItems _unit);
};

_return pushBack _uItems;
_return pushBack _uMags;
_return pushBack _bItems;
_return pushBack _bMags;
_return pushBack _vItems;
_return pushBack _vMags;
_return pushBack _pItems;
_return pushBack _hItems;

[_uid,_side,3,_return] spawn APP_fnc_playerSessionUpdate;