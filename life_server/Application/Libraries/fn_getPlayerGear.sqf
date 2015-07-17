#include "\life_server\script_macros.hpp"
/*
    File: fn_getPlayerGear.sqf
    Author: Bryan "Tonic" Boardwine
    Revised by: Dillon "Itsyuka" Modine-Thuen
    Created: Jul 16, 2015
    
    Description:
    	Fetches gear from array.
*/
private["_itemArray","_uniform","_vest","_backpack","_goggles","_headgear","_items","_prim","_seco","_uItems","_bItems","_vItems","_pItems","_hItems","_yItems","_uMags","_bMags","_vMags","_handle"];
_unit = param [0,objNull,[objNull]];
_uid = param [1,"",[""]];
_side = param [2,sideUnknown,[civilian]];

_getCachedData = GVAR_MNS [format["%1_%2",_uid,_side], ""];
if(EQUAL(_getCachedData,"")) exitWith {};
_itemArray = SEL(_getCachedData,7);

_handle = [_unit] spawn APP_fnc_stripDownPlayer;
waitUntil {scriptDone _handle};

if(EQUAL(count _itemArray,0)) exitWith {
    [_unit,_uid,_side] call APP_fnc_loadoutHandler;
};

_uniform = [_itemArray,0,"",[""]] call BIS_fnc_param;
_vest = [_itemArray,1,"",[""]] call BIS_fnc_param;
_backpack = [_itemArray,2,"",[""]] call BIS_fnc_param;
_goggles = [_itemArray,3,"",[""]] call BIS_fnc_param;
_headgear = [_itemArray,4,"",[""]] call BIS_fnc_param;
_items = [_itemArray,5,[],[[]]] call BIS_fnc_param;
_prim = [_itemArray,6,"",[""]] call BIS_fnc_param;
_seco = [_itemArray,7,"",[""]] call BIS_fnc_param;
_uItems = [_itemArray,8,[],[[]]] call BIS_fnc_param;
_uMags = [_itemArray,9,[],[[]]] call BIS_fnc_param;
_bItems = [_itemArray,10,[],[[]]] call BIS_fnc_param;
_bMags = [_itemArray,11,[],[[]]] call BIS_fnc_param;
_vItems = [_itemArray,12,[],[[]]] call BIS_fnc_param;
_vMags = [_itemArray,13,[],[[]]] call BIS_fnc_param;
_pItems = [_itemArray,14,[],[[]]] call BIS_fnc_param;
_hItems = [_itemArray,15,[],[[]]] call BIS_fnc_param;

if(!(EQUAL(_goggles,""))) then {_handle = [_unit,_goggles,true,false,false,false] spawn SYS_fnc_itemHandler; waitUntil {scriptDone _handle};};
if(!(EQUAL(_headgear,""))) then {_handle = [_unit,_headgear,true,false,false,false] spawn SYS_fnc_itemHandler; waitUntil {scriptDone _handle};};
if(!(EQUAL(_uniform,""))) then {_handle = [_unit,_uniform,true,false,false,false] spawn SYS_fnc_itemHandler; waitUntil {scriptDone _handle};};
if(!(EQUAL(_vest,""))) then {_handle = [_unit,_vest,true,false,false,false] spawn SYS_fnc_itemHandler; waitUntil {scriptDone _handle};};
if(!(EQUAL(_backpack,""))) then {_handle = [_unit,_backpack,true,false,false,false] spawn SYS_fnc_itemHandler; waitUntil {scriptDone _handle};};

{_handle = [_unit,_x,true,false,false,false] spawn SYS_fnc_itemHandler; waitUntil {scriptDone _handle};} foreach _items;

{_unit addItemToUniform _x;} foreach (_uItems);
{(uniformContainer _unit) addItemCargoGlobal [_x,1];} foreach (_uMags);
{_unit addItemToVest _x;} foreach (_vItems);
{(vestContainer _unit) addItemCargoGlobal [_x,1];} foreach (_vMags);
{_unit addItemToBackpack _x;} foreach (_bItems);
{(backpackContainer _unit) addItemCargoGlobal [_x,1];} foreach (_bMags);

//Primary & Secondary (Handgun) should be added last as magazines do not automatically load into the gun.
if(!(EQUAL(_prim,""))) then {_handle = [_unit,_prim,true,false,false,false] spawn SYS_fnc_itemHandler; waitUntil {scriptDone _handle};};
if(!(EQUAL(_seco,""))) then {_handle = [_unit,_seco,true,false,false,false] spawn SYS_fnc_itemHandler; waitUntil {scriptDone _handle};};

{
    if (!(EQUAL(_x,""))) then {
        _unit addPrimaryWeaponItem _x;
    };
} foreach (_pItems);
{
    if (!(EQUAL(_x,""))) then {
        _unit addHandgunItem _x;
    };
} foreach (_hItems);

if(side _unit == independent && {EQUAL(uniform _unit,"U_Rangemaster")}) then {
	[[_unit,0,"textures\medic_uniform.jpg"],"SYS_fnc_setTexture",true,false] call SYS_fnc_MP;
};